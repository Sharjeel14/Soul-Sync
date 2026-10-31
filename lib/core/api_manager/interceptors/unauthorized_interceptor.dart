import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../constants/app_constants.dart';
import '../../../features/auth/services/auth_storage_service.dart';

class UnauthorizedInterceptor extends Interceptor {
  final Dio dio;
  final AuthStorageService _authStorageService = AuthStorageService();

  final Dio _tokenRefreshDio = Dio(
    BaseOptions(
      baseUrl: NetworkConfig.baseUrl,
      connectTimeout: NetworkConfig.connectTimeout,
      receiveTimeout: NetworkConfig.receiveTimeout,
      sendTimeout: NetworkConfig.sendTimeout,
      headers: {
        'Content-Type': NetworkConfig.contentType,
        'Accept': NetworkConfig.accept,
      },
    ),
  );

  UnauthorizedInterceptor({required this.dio});

  bool _isRefreshing = false;
  final List<MapEntry<RequestOptions, ErrorInterceptorHandler>> _requestQueue =
      [];

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await _authStorageService.getRefreshToken();

      // log('refresh token is $refreshToken');
      if (refreshToken != null && refreshToken.isNotEmpty) {
        if (_isRefreshing) {
          _requestQueue.add(MapEntry(err.requestOptions, handler));
          return;
        }

        _isRefreshing = true;
        _requestQueue.add(MapEntry(err.requestOptions, handler));

        try {
          debugPrint('--- UnauthorizedInterceptor: Refreshing Token ---');
          final response = await _tokenRefreshDio.post(
            ApiEndpoints.getRefreshToken,
            data: {'refresh_token': refreshToken},
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            final data = response.data;
            final responseData = data['data'];
            final newAccessToken = responseData['access_token'];
            final newRefreshToken = responseData['refresh_token'];

            if (newAccessToken != null && newRefreshToken != null) {
              debugPrint(
                '--- UnauthorizedInterceptor: Token Refreshed Successfully ---',
              );
              await _authStorageService.saveAccessRefereshToken(
                newAccessToken,
                newRefreshToken,
              );

              // Retry all queued requests
              for (final entry in _requestQueue) {
                final options = entry.key;
                options.headers['Authorization'] = 'Bearer $newAccessToken';

                try {
                  final retryResponse = await dio.fetch(options);
                  entry.value.resolve(retryResponse);
                } on DioException catch (retryErr) {
                  entry.value.next(retryErr);
                }
              }
              _requestQueue.clear();
              return;
            }
          }
        } catch (e) {
          debugPrint(
            '--- UnauthorizedInterceptor: Token Refresh Failed: $e ---',
          );
          // If refresh fails, forward the original error to all queued requests
          for (final entry in _requestQueue) {
            entry.value.next(err);
          }
          _requestQueue.clear();
          return;
        } finally {
          _isRefreshing = false;
        }
      }
    }
    super.onError(err, handler);
  }
}

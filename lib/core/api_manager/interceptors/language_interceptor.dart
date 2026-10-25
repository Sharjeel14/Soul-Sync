import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:date_app/core/constants/app_constants.dart';
import 'package:date_app/core/di/injection_container.dart';
import '../../storage/storage_manager.dart';

class LanguageInterceptor extends Interceptor {
  final _storage = getIt<StorageManager>();

  static const List<String> _languageEnabledRoutes = [
    '/mobile/customer/profile/create/s1',
    '/mobile/customer/profile/create/s3',
    '/auth/login',
    '/auth/login/customer/resendotp',
    '/mobile/customer/profile/mobile/update/s1',
    '/mobile/customer/profile/delete/s1',
    '/mobile/food/category/s1',
    '/mobile/food/category/s2',
  ];

  bool _isLanguageEnabledRoute(String path) {
    return _languageEnabledRoutes.any(
      (route) => path == '${ApiEndpoints.apiV1}$route',
    );
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_isLanguageEnabledRoute(options.path)) {
      final language = await _storage.read(StorageKeys.appLanguage) ?? 'en';

      if (options.data == null) {
        options.data = {'Language': language};
      } else if (options.data is Map) {
        final data = Map<String, dynamic>.from(options.data as Map);
        data['Language'] = language;
        options.data = data;
      } else if (options.data is FormData) {
        (options.data as FormData).fields.add(MapEntry('Language', language));
      } else if (options.data is String) {
        try {
          final data = Map<String, dynamic>.from(
            jsonDecode(options.data as String),
          );
          data['Language'] = language;
          options.data = jsonEncode(data);
        } catch (_) {
          // Handle non-JSON string if needed
        }
      }
    }

    super.onRequest(options, handler);
  }
}

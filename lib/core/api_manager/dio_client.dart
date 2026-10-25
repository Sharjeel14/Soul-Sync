import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/foundation.dart';

import '../constants/app_constants.dart';
import 'base_api_client.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/language_interceptor.dart';
import 'interceptors/logger_interceptor.dart';
import 'interceptors/unauthorized_interceptor.dart';

@LazySingleton(as: BaseApiClient)
class DioClient implements BaseApiClient {
  late final Dio _dio;
  late final Dio _externalDio; // For completely new/external URLs

  DioClient() {
    _dio = Dio(
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

    // External Dio — no baseUrl, no auth by default
    _externalDio = Dio(
      BaseOptions(
        connectTimeout: NetworkConfig.connectTimeout,
        receiveTimeout: NetworkConfig.receiveTimeout,
        sendTimeout: NetworkConfig.sendTimeout,
        headers: {
          'Content-Type': NetworkConfig.contentType,
          'Accept': NetworkConfig.acceptAll,
        },
      ),
    );

    _applyInterceptors(_dio);
    _applyInterceptors(_externalDio, skipAuth: true);
  }

  void _applyInterceptors(Dio dio, {bool skipAuth = false}) {
    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        logPrint: (message) => debugPrint('--- Retry: $message'),
        retries: NetworkConfig.maxRetries,
        retryDelays: List.generate(
          NetworkConfig.maxRetries,
          (index) => NetworkConfig.retryInterval,
        ),
      ),
    );

    final cacheOptions = CacheOptions(
      store: MemCacheStore(),
      policy: CachePolicy.refreshForceCache,
      maxStale: NetworkConfig.cacheMaxAge,
      priority: CachePriority.normal,
    );
    dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));

    if (!skipAuth) {
      dio.interceptors.add(LanguageInterceptor());
      dio.interceptors.add(AuthInterceptor());
      dio.interceptors.add(UnauthorizedInterceptor(dio: dio));
    }
    dio.interceptors.add(LoggerInterceptor());
  }

  /// Resolves which Dio instance to use and merges API key header if needed.
  ///
  /// [externalUrl] — pass a full URL (e.g. "https://other-api.com/v1/data")
  ///                 to bypass baseUrl entirely.
  /// [requiresApiKey] — when true, injects the API key header into this request.
  (Dio dio, Options resolvedOptions) _resolve({
    String? externalUrl,
    bool requiresApiKey = false,
    Options? options,
  }) {
    final dio = externalUrl != null ? _externalDio : _dio;

    Options resolved = options ?? Options();
    if (requiresApiKey) {
      resolved = resolved.copyWith(headers: {...?resolved.headers});
    }

    return (dio, resolved);
  }

  @override
  Future<Response> get(
    String url, {
    String? externalUrl,
    bool requiresApiKey = false,
    dynamic data,

    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    final (dio, resolvedOptions) = _resolve(
      externalUrl: externalUrl,
      requiresApiKey: requiresApiKey,
      options: options,
    );

    return await dio.get(
      externalUrl ?? url,
      data: data,
      queryParameters: queryParameters,
      options: resolvedOptions,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }

  @override
  Future<Response> post(
    String url, {
    String? externalUrl,
    bool requiresApiKey = false,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final (dio, resolvedOptions) = _resolve(
      externalUrl: externalUrl,
      requiresApiKey: requiresApiKey,
      options: options,
    );

    return await dio.post(
      externalUrl ?? url,
      data: data,
      queryParameters: queryParameters,
      options: resolvedOptions,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  @override
  Future<Response> put(
    String url, {
    String? externalUrl,
    bool requiresApiKey = false,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final (dio, resolvedOptions) = _resolve(
      externalUrl: externalUrl,
      requiresApiKey: requiresApiKey,
      options: options,
    );

    return await dio.put(
      externalUrl ?? url,
      data: data,
      queryParameters: queryParameters,
      options: resolvedOptions,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  @override
  Future<Response> patch(
    String url, {
    String? externalUrl,
    bool requiresApiKey = false,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final (dio, resolvedOptions) = _resolve(
      externalUrl: externalUrl,
      requiresApiKey: requiresApiKey,
      options: options,
    );

    return await dio.patch(
      externalUrl ?? url,
      data: data,
      queryParameters: queryParameters,
      options: resolvedOptions,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  @override
  Future<Response> delete(
    String url, {
    String? externalUrl,
    bool requiresApiKey = false,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final (dio, resolvedOptions) = _resolve(
      externalUrl: externalUrl,
      requiresApiKey: requiresApiKey,
      options: options,
    );

    return await dio.delete(
      externalUrl ?? url,
      data: data,
      queryParameters: queryParameters,
      options: resolvedOptions,
      cancelToken: cancelToken,
    );
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('--- API Request ---');
      debugPrint('Method: ${options.method}');
      debugPrint('URL: ${options.baseUrl}${options.path}');
      debugPrint('Headers: ${options.headers}');
      debugPrint('Query Params: ${options.queryParameters}');
      debugPrint('Data: ${options.data}');
      debugPrint('-------------------');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('--- API Response ---');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Data: ${response.data}');
      debugPrint('--------------------');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('--- API Error ---');
      debugPrint('Status Code: ${err.response?.statusCode}');
      debugPrint('Message: ${err.message}');
      debugPrint('Error Data: ${err.response?.data}');
      debugPrint('-----------------');
    }
    super.onError(err, handler);
  }
}

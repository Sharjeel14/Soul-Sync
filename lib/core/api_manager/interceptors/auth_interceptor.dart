import 'package:dio/dio.dart';
import '../../constants/app_constants.dart';
import '../../storage/storage_manager.dart';

class AuthInterceptor extends Interceptor {
  final _storage = StorageManager();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    String? token = await _storage.read(StorageKeys.userToken);
    if (token != null && token.toString().isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}

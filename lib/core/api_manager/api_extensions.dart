import 'package:dio/dio.dart';
import 'api_exceptions.dart';

extension DioExceptionExtension on DioException {
  ApiException toApiException() {
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException();
      case DioExceptionType.badResponse:
        final statusCode = response?.statusCode;
        final data = response?.data;

        final extractedMessage = _extractMessage(data);

        // Handle specific status codes
        if (statusCode == 401) {
          return UnauthorizedException(message: extractedMessage, data: data);
        } else if (statusCode == 422) {
          return ValidationException(message: extractedMessage, data: data);
        } else if (statusCode == 400) {
          return BadRequestException(
            message: extractedMessage,
            statusCode: statusCode,
            data: data,
          );
        } else if (statusCode != null && statusCode >= 500) {
          return ServerException(
            message: extractedMessage ?? 'Internal Server Error',
            statusCode: statusCode,
            data: data,
          );
        } else {
          return ServerException(
            message: extractedMessage ?? 'Something went wrong',
            statusCode: statusCode,
            data: data,
          );
        }
      case DioExceptionType.cancel:
        return UnknownException(message: 'Request cancelled');
      case DioExceptionType.connectionError:
        return NetworkException();
      default:
        return UnknownException(message: message);
    }
  }

  String? _extractMessage(dynamic data) {
    if (data is Map) {
      final message = data['message'] ?? data['msg'] ?? data['error'];
      if (message != null) return message.toString();
    }
    return null;
  }
}

extension ResponseExtension on Response {
  bool get isSuccess =>
      statusCode != null && statusCode! >= 200 && statusCode! < 300;
}

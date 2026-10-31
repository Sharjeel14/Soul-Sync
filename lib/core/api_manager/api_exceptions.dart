abstract class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({required this.message, this.statusCode, this.data});

  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  NetworkException({String? message})
    : super(message: message ?? 'No Internet Connection');
}

class ServerException extends ApiException {
  ServerException({String? message, super.statusCode, super.data})
    : super(message: message ?? 'Internal Server Error');
}

class UnauthorizedException extends ApiException {
  UnauthorizedException({String? message, super.data})
    : super(message: message ?? 'Unauthorized Access', statusCode: 401);
}

class ValidationException extends ApiException {
  ValidationException({String? message, super.data})
    : super(message: message ?? 'Validation Failed', statusCode: 422);
}

class TimeoutException extends ApiException {
  TimeoutException({String? message})
    : super(message: message ?? 'Connection Timeout');
}

class BadRequestException extends ApiException {
  BadRequestException({String? message, int? statusCode, super.data})
    : super(message: message ?? 'Bad Request', statusCode: statusCode ?? 400);
}

class UnknownException extends ApiException {
  UnknownException({String? message})
    : super(message: message ?? 'An unknown error occurred');
}

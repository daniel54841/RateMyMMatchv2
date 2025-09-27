// Excepción base para la API
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic responseData;

  ApiException(this.message, {this.statusCode, this.responseData});

  @override
  String toString() {
    return 'ApiException: $message (Status Code: $statusCode)';
  }
}

class NetworkException extends ApiException {
  NetworkException(super.message) : super(statusCode: null);
}

class NotFoundException extends ApiException {
  NotFoundException(super.message, {super.responseData}) : super(statusCode: 404);
}

class BadRequestException extends ApiException {
  BadRequestException(super.message, {super.responseData}) : super(statusCode: 400);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(super.message) : super(statusCode: 401);
}


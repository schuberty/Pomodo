part of 'errors.dart';

class ServerError extends ClientError {
  const ServerError({required super.message, this.statusCode, this.description = ''});

  factory ServerError.fromDioError(DioException error) {
    ServerError? instance;

    // Not being able to connect to the endpoint.
    if (error.error is SocketException) {
      instance = ServerError(
        message: '...',
        statusCode: error.response?.statusCode,
        description: '...',
      );
    }

    // Not having internet connection.
    if (error.response == null) {
      instance = ServerError(
        message: '...',
        statusCode: error.response?.statusCode,
        description: '...',
      );
    }

    // API 500 Errors
    if (error.response?.statusCode == 500) {
      instance = ServerError(
        message: '...',
        statusCode: error.response?.statusCode,
        description: '...',
      );
    }

    // API 400 Errors
    instance ??= ServerError(
      message: '...',
      statusCode: error.response?.statusCode,
      description: '...',
    );

    return instance;
  }

  final int? statusCode;
  final String description;
}

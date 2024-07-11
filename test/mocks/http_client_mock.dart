part of 'mocks.dart';

class HttpClientMock implements HttpClient {
  void whenSuccess(Response Function() onSuccess) {
    _onSuccess = onSuccess;
  }

  void whenFailure(ServerError Function() onFailure) {
    _onFailure = onFailure;
  }

  Response Function()? _onSuccess;
  ServerError Function()? _onFailure;

  @override
  FutureOr<Either<ServerError, Response>> request(
    Endpoint endpoint, {
    data,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
  }) {
    final onSuccess = _onSuccess;
    final onFailure = _onFailure;

    if (onSuccess != null) {
      return Success(onSuccess());
    }

    if (onFailure != null) {
      return Failure(onFailure());
    }

    throw Exception('HttpClientMock not setup for success or failure.');
  }
}

part of 'client.dart';

abstract class HttpClient {
  FutureOr<Either<ServerError, ClientResponse>> request(
    Endpoint endpoint, {
    dynamic data,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
  });
}

class DioClient implements HttpClient {
  DioClient._({required this.dioClient}) {
    dioClient.options = dioClient.options.copyWith(
      sendTimeout: const Duration(seconds: 90),
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 180),
    );
  }

  factory DioClient.baseUrl(String baseUrl, {List<Interceptor> interceptors = const []}) {
    final dioClient = Dio(BaseOptions(baseUrl: baseUrl));

    dioClient.interceptors.addAll(interceptors);

    return DioClient._(dioClient: dioClient);
  }

  late final Dio dioClient;

  @override
  Future<Either<ServerError, ClientResponse>> request(
    Endpoint endpoint, {
    dynamic data,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
  }) async {
    final options = Options(
      method: endpoint.method.name,
      headers: headers,
    );

    AppLogger.debug('${endpoint.method.name} ${endpoint.path}', 'api');

    try {
      final response = await dioClient.request(
        data: data,
        endpoint.path,
        options: options,
        cancelToken: cancelToken,
        queryParameters: endpoint.queries,
      );

      return Success(ClientResponse.fromDioResponse(response));
    } on DioException catch (error) {
      return Failure(ServerError.fromDioError(error));
    }
  }
}

part of '../client.dart';

class ApiTokenInterceptor extends Interceptor {
  ApiTokenInterceptor({required this.apiToken});

  final String apiToken;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!options.headers.containsKey('Authorization')) {
      options.headers['Authorization'] = 'Bearer $apiToken';
    }

    super.onRequest(options, handler);
  }
}

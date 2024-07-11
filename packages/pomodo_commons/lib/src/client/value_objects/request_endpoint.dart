part of '../client.dart';

class Endpoint {
  Endpoint(
    this.path, {
    this.queries,
    required this.method,
  });

  String path;
  Method method;
  Map<String, dynamic>? queries;
}

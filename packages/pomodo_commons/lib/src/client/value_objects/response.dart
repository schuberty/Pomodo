part of '../client.dart';

class ClientResponse {
  ClientResponse({
    required this.data,
    this.statusCode,
  });

  factory ClientResponse.fromDioResponse(Response response) {
    return ClientResponse(
      data: response.data,
      statusCode: response.statusCode,
    );
  }

  final dynamic data;
  final int? statusCode;
}

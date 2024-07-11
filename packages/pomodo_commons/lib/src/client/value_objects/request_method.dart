// ignore_for_file: constant_identifier_names

part of '../client.dart';

enum Method {
  GET('GET'),
  PUT('PUT'),
  POST('POST'),
  DELETE('DELETE');

  const Method(this.name);

  final String name;
}

import 'dart:io';

import 'package:dio/dio.dart';

part 'server_error.dart';

abstract class ClientError implements Exception {
  const ClientError({this.message = ''});

  final String message;
}

class ParsingError implements ClientError {
  @override
  final message = 'Error parsing data';
}

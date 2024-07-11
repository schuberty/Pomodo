import 'dart:io' as io;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

abstract class AppLogger {
  const AppLogger._();

  static final _logger = Logger(
    printer: PrefixPrinter(
      PrettyPrinter(
        methodCount: 0,
        noBoxingByDefault: true,
        colors: io.stdout.supportsAnsiEscapes,
      ),
    ),
    output: ConsoleOutput(),
    level: kDebugMode ? Level.debug : Level.error,
  );

  static void error(String message, {Object? error, String scope = ''}) {
    var parsedMessage = message;

    if (error != null) {
      parsedMessage += '\nError: ${error.toString()}';
    }

    _log(Level.error, parsedMessage);
  }

  static void debug(String message, [String scope = '']) {
    _log(Level.debug, message, scope);
  }

  static void info(String message, [String scope = '']) {
    _log(Level.info, message, scope);
  }

  static void trace(String message, [String scope = '']) {
    _log(Level.trace, message, scope);
  }

  static void warning(String message, [String scope = '']) {
    _log(Level.warning, message, scope);
  }

  static void _log(Level level, dynamic message, [String scope = '']) {
    if (kDebugMode && !Platform.environment.containsKey('FLUTTER_TEST')) {
      final timestamp = DateTime.now();

      final hour = timestamp.hour.toString().padLeft(2, '0');
      final minute = timestamp.minute.toString().padLeft(2, '0');
      final second = timestamp.second.toString().padLeft(2, '0');

      final timeLabel = '$hour:$minute:$second';

      if (scope.isEmpty) {
        scope = 'app';
      }

      final loggedMessage = '[${scope.toUpperCase()}] $timeLabel $message';

      _logger.log(level, loggedMessage);
    }
  }
}

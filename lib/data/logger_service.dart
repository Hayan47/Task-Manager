import 'package:logging/logging.dart';
import 'package:flutter/foundation.dart';

class LoggerService {
  static final LoggerService _instance = LoggerService._internal();

  factory LoggerService() {
    return _instance;
  }

  LoggerService._internal() {
    _initializeLogging();
  }

  void _initializeLogging() {
    Logger.root.level =
        Level.ALL; // Adjust this to set the overall logging level
    Logger.root.onRecord.listen((record) {
      if (kDebugMode) {
        print(_getFormattedLog(record));
      }
    });
  }

  String _getFormattedLog(LogRecord record) {
    String color = _getColorCode(record.level);
    String resetColor = '\x1B[0m';
    String emoji = _getLevelEmoji(record.level);

    return '$color[$emoji ${record.time}] ${record.loggerName}: ${record.level.name}: ${record.message}${record.error != null ? '\nError: ${record.error}' : ''}${record.stackTrace != null ? '\nStack Trace:\n${record.stackTrace}' : ''}$resetColor';
  }

  String _getColorCode(Level level) {
    if (level == Level.SEVERE) return '\x1B[31m'; // Red
    if (level == Level.WARNING) return '\x1B[33m'; // Yellow
    if (level == Level.INFO) return '\x1B[36m'; // Cyan
    if (level == Level.FINE) return '\x1B[32m'; // Green
    return '\x1B[37m'; // White (default)
  }

  String _getLevelEmoji(Level level) {
    if (level == Level.SEVERE) return '🚨'; // Red alarm
    if (level == Level.WARNING) return '⚠️'; // Warning sign
    if (level == Level.INFO) return 'ℹ️'; // Information
    if (level == Level.FINE) return '✅'; // Check mark
    return '📝'; // Memo (default)
  }

  Logger getLogger(String name) {
    return Logger(name);
  }

  void info(String message, [Object? error, StackTrace? stackTrace]) {
    Logger.root.info(message, error, stackTrace);
  }

  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    Logger.root.warning(message, error, stackTrace);
  }

  void severe(String message, [Object? error, StackTrace? stackTrace]) {
    Logger.root.severe(message, error, stackTrace);
  }

  void fine(String message, [Object? error, StackTrace? stackTrace]) {
    Logger.root.fine(message, error, stackTrace);
  }
}

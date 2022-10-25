import 'package:logging/logging.dart';

class ChaseAppCallException implements Exception {
  ChaseAppCallException({
    required this.message,
    this.logger,
    this.error,
  });

  /// Supportive message for more details
  final String message;
  final Logger? logger;
  final Object? error;

  @override
  String toString() =>
      'ApiCallException(message: $message, error: ${error.toString()}, logger: ${logger?.name}-${logger?.level})';
}

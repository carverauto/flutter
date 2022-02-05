class ChaseAppCallException implements Exception {
  final String message;
  final Object error;
  final StackTrace stackTrace;
  ChaseAppCallException({
    required this.message,
    required this.error,
    required this.stackTrace,
  });

  @override
  String toString() =>
      'ApiCallException(message: $message, error: $error, stackTrace: $stackTrace)';
}

class AppException implements Exception {
  //Message shown to the USER in a dialog
  final String userMessage;

  //Message shown in DEVELOPER LOGS only
  final String devMessage;

  /// The original raw error for logging.
  final dynamic originalError;

  const AppException({
    required this.userMessage,
    required this.devMessage,
    this.originalError,
  });

  @override
  String toString() => 'AppException: $devMessage';
}

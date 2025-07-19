/// Custom exceptions for TrueNAS API operations
class TrueNasException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const TrueNasException(
    this.message, {
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'TrueNasException($code): $message';
}

/// Connection-related exceptions
class TrueNasConnectionException extends TrueNasException {
  const TrueNasConnectionException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Authentication-related exceptions
class TrueNasAuthenticationException extends TrueNasException {
  const TrueNasAuthenticationException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Authorization-related exceptions
class TrueNasAuthorizationException extends TrueNasException {
  const TrueNasAuthorizationException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// API rate limiting exceptions
class TrueNasRateLimitException extends TrueNasException {
  final Duration retryAfter;

  const TrueNasRateLimitException(
    super.message, {
    required this.retryAfter,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Version compatibility exceptions
class TrueNasVersionException extends TrueNasException {
  final String requiredVersion;
  final String actualVersion;

  const TrueNasVersionException(
    super.message, {
    required this.requiredVersion,
    required this.actualVersion,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Resource not found exceptions
class TrueNasNotFoundException extends TrueNasException {
  final String resourceType;
  final String resourceId;

  const TrueNasNotFoundException(
    super.message, {
    required this.resourceType,
    required this.resourceId,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Validation exceptions
class TrueNasValidationException extends TrueNasException {
  final Map<String, List<String>> validationErrors;

  const TrueNasValidationException(
    super.message, {
    required this.validationErrors,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Server error exceptions
class TrueNasServerException extends TrueNasException {
  final int? statusCode;

  const TrueNasServerException(
    super.message, {
    this.statusCode,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Timeout exceptions
class TrueNasTimeoutException extends TrueNasException {
  final Duration timeout;

  const TrueNasTimeoutException(
    super.message, {
    required this.timeout,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Network exceptions
class TrueNasNetworkException extends TrueNasException {
  const TrueNasNetworkException(
    super.message, {
    super.code,
    super.originalError,
    super.stackTrace,
  });
}
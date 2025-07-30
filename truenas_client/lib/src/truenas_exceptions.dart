/// Base exception for all TrueNAS client errors
class TrueNasException implements Exception {
  final String message;

  const TrueNasException(this.message);

  @override
  String toString() => 'TrueNasException: $message';
}

/// Authentication-related errors
class TrueNasAuthException extends TrueNasException {
  const TrueNasAuthException(super.message);

  @override
  String toString() => 'TrueNasAuthException: $message';
}

/// JSON-RPC errors from TrueNAS
class TrueNasRpcException extends TrueNasException {
  final int code;
  final dynamic data;

  const TrueNasRpcException(this.code, String message, this.data)
    : super(message);

  @override
  String toString() => 'TrueNasRpcException($code): $message';
}

/// Resource not found errors
class TrueNasNotFoundException extends TrueNasException {
  const TrueNasNotFoundException(super.message);

  @override
  String toString() => 'TrueNasNotFoundException: $message';
}

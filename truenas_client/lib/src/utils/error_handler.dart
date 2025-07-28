import 'dart:async';
import 'dart:io';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:logging/logging.dart';
import '../exceptions/truenas_exceptions.dart';

/// Centralized error handling utility for TrueNAS operations
class TrueNasErrorHandler {
  static final _logger = Logger('TrueNasErrorHandler');

  /// Wraps an async operation with comprehensive error handling
  static Future<T> handleOperation<T>(
    Future<T> Function() operation, {
    required String operationName,
    Map<String, dynamic>? context,
    Duration? timeout,
  }) async {
    try {
      _logger.fine('Starting operation: $operationName');

      Future<T> future = operation();

      // Apply timeout if specified
      if (timeout != null) {
        future = future.timeout(
          timeout,
          onTimeout: () => throw TrueNasTimeoutException(
            'Operation $operationName timed out after ${timeout.inSeconds}s',
            timeout: timeout,
          ),
        );
      }

      final result = await future;
      _logger.fine('Operation completed successfully: $operationName');
      return result;
    } catch (error, stackTrace) {
      final exception = _mapErrorToException(
        error,
        operationName: operationName,
        context: context,
        stackTrace: stackTrace,
      );

      _logger.severe('Operation failed: $operationName', exception, stackTrace);

      throw exception;
    }
  }

  /// Maps generic errors to specific TrueNAS exceptions
  static TrueNasException _mapErrorToException(
    dynamic error, {
    required String operationName,
    Map<String, dynamic>? context,
    StackTrace? stackTrace,
  }) {
    // If it's already a TrueNAS exception, return as-is
    if (error is TrueNasException) {
      return error;
    }

    // Handle WebSocket errors
    if (error is WebSocketChannelException) {
      return TrueNasConnectionException(
        'WebSocket connection failed during $operationName: ${error.message}',
        code: 'WEBSOCKET_ERROR',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    // Handle socket errors
    if (error is SocketException) {
      return TrueNasNetworkException(
        'Network error during $operationName: ${error.message}',
        code: 'NETWORK_ERROR',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    // Handle timeout errors
    if (error is TimeoutException) {
      return TrueNasTimeoutException(
        'Timeout during $operationName: ${error.message}',
        timeout: error.duration ?? const Duration(seconds: 30),
        code: 'TIMEOUT_ERROR',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    // Handle format exceptions (JSON parsing, etc.)
    if (error is FormatException) {
      return TrueNasServerException(
        'Invalid response format during $operationName: ${error.message}',
        code: 'FORMAT_ERROR',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    // Handle argument errors (validation)
    if (error is ArgumentError) {
      return TrueNasValidationException(
        'Invalid arguments for $operationName: ${error.message}',
        validationErrors: {
          'general': [error.message.toString()],
        },
        code: 'VALIDATION_ERROR',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    // Handle state errors
    if (error is StateError) {
      return TrueNasException(
        'Invalid state during $operationName: ${error.message}',
        code: 'STATE_ERROR',
        originalError: error,
        stackTrace: stackTrace,
      );
    }

    // Default to generic exception for unknown errors
    return TrueNasException(
      'Unexpected error during $operationName: ${error.toString()}',
      code: 'UNKNOWN_ERROR',
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  /// Handles JSON-RPC specific errors
  static TrueNasException handleJsonRpcError(
    Map<String, dynamic> errorData, {
    required String method,
    Map<String, dynamic>? params,
  }) {
    final code = errorData['code'] as int?;
    final message = errorData['message'] as String?;

    switch (code) {
      case -32700:
        return TrueNasServerException(
          'Parse error in JSON-RPC call to $method',
          code: 'PARSE_ERROR',
          statusCode: code,
        );
      case -32600:
        return TrueNasValidationException(
          'Invalid JSON-RPC request for $method',
          validationErrors: {
            'request': ['Invalid request format'],
          },
          code: 'INVALID_REQUEST',
        );
      case -32601:
        return TrueNasNotFoundException(
          'Method $method not found',
          resourceType: 'method',
          resourceId: method,
          code: 'METHOD_NOT_FOUND',
        );
      case -32602:
        return TrueNasValidationException(
          'Invalid parameters for $method',
          validationErrors: {
            'parameters': ['Invalid parameter format'],
          },
          code: 'INVALID_PARAMS',
        );
      case -32603:
        return TrueNasServerException(
          'Internal error during $method: ${message ?? 'Unknown error'}',
          code: 'INTERNAL_ERROR',
          statusCode: code,
        );
      case 401:
        return TrueNasAuthenticationException(
          'Authentication required for $method',
          code: 'AUTHENTICATION_REQUIRED',
        );
      case 403:
        return TrueNasAuthorizationException(
          'Insufficient permissions for $method',
          code: 'INSUFFICIENT_PERMISSIONS',
        );
      case 404:
        return TrueNasNotFoundException(
          'Resource not found for $method',
          resourceType: 'unknown',
          resourceId: 'unknown',
          code: 'RESOURCE_NOT_FOUND',
        );
      case 429:
        return TrueNasRateLimitException(
          'Rate limit exceeded for $method',
          retryAfter: const Duration(seconds: 60),
          code: 'RATE_LIMIT_EXCEEDED',
        );
      default:
        return TrueNasServerException(
          'Server error during $method: ${message ?? 'Unknown error'}',
          code: 'SERVER_ERROR',
          statusCode: code,
        );
    }
  }

  /// Validates required parameters
  static void validateRequired(
    Map<String, dynamic> params,
    List<String> requiredFields, {
    String? operationName,
  }) {
    final missing = <String>[];

    for (final field in requiredFields) {
      if (!params.containsKey(field) || params[field] == null) {
        missing.add(field);
      }
    }

    if (missing.isNotEmpty) {
      throw TrueNasValidationException(
        'Missing required parameters${operationName != null ? ' for $operationName' : ''}: ${missing.join(', ')}',
        validationErrors: {
          for (final field in missing) field: ['This field is required'],
        },
        code: 'MISSING_REQUIRED_PARAMS',
      );
    }
  }

  /// Validates parameter types
  static void validateTypes(
    Map<String, dynamic> params,
    Map<String, Type> expectedTypes, {
    String? operationName,
  }) {
    final errors = <String, List<String>>{};

    for (final entry in expectedTypes.entries) {
      final field = entry.key;
      final expectedType = entry.value;
      final value = params[field];

      if (value != null && value.runtimeType != expectedType) {
        errors[field] = ['Expected $expectedType, got ${value.runtimeType}'];
      }
    }

    if (errors.isNotEmpty) {
      throw TrueNasValidationException(
        'Invalid parameter types${operationName != null ? ' for $operationName' : ''}',
        validationErrors: errors,
        code: 'INVALID_PARAM_TYPES',
      );
    }
  }
}

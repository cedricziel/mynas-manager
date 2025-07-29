import 'dart:async';
import 'dart:math';
import 'package:logging/logging.dart';
import '../exceptions/truenas_exceptions.dart';

/// Configuration for retry behavior
class RetryConfig {
  final int maxAttempts;
  final Duration initialDelay;
  final Duration maxDelay;
  final double backoffMultiplier;
  final bool retryOnTimeout;
  final bool retryOnNetwork;
  final bool retryOnServer;
  final List<Type> retryOnExceptions;

  const RetryConfig({
    this.maxAttempts = 3,
    this.initialDelay = const Duration(seconds: 1),
    this.maxDelay = const Duration(seconds: 30),
    this.backoffMultiplier = 2.0,
    this.retryOnTimeout = true,
    this.retryOnNetwork = true,
    this.retryOnServer = false,
    this.retryOnExceptions = const [],
  });

  /// Default retry configuration for TrueNAS API calls
  static const apiCalls = RetryConfig(
    maxAttempts: 3,
    initialDelay: Duration(seconds: 1),
    maxDelay: Duration(seconds: 10),
    backoffMultiplier: 2.0,
    retryOnTimeout: true,
    retryOnNetwork: true,
    retryOnServer: false,
  );

  /// Retry configuration for critical operations
  static const critical = RetryConfig(
    maxAttempts: 5,
    initialDelay: Duration(milliseconds: 500),
    maxDelay: Duration(seconds: 30),
    backoffMultiplier: 1.5,
    retryOnTimeout: true,
    retryOnNetwork: true,
    retryOnServer: true,
  );

  /// No retry configuration
  static const none = RetryConfig(
    maxAttempts: 1,
    initialDelay: Duration.zero,
    maxDelay: Duration.zero,
    backoffMultiplier: 1.0,
    retryOnTimeout: false,
    retryOnNetwork: false,
    retryOnServer: false,
  );
}

/// Handles retry logic with exponential backoff
class RetryHandler {
  static final _logger = Logger('RetryHandler');
  static final _random = Random();

  /// Executes an operation with retry logic
  static Future<T> execute<T>(
    Future<T> Function() operation, {
    RetryConfig config = RetryConfig.apiCalls,
    String? operationName,
    bool Function(Exception)? shouldRetry,
  }) async {
    final opName = operationName ?? 'operation';
    Exception? lastException;

    for (int attempt = 1; attempt <= config.maxAttempts; attempt++) {
      try {
        _logger.fine(
          'Executing $opName (attempt $attempt/${config.maxAttempts})',
        );
        final result = await operation();

        if (attempt > 1) {
          _logger.info('$opName succeeded on attempt $attempt');
        }

        return result;
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());

        if (attempt == config.maxAttempts) {
          _logger.severe('$opName failed after $attempt attempts: $e');
          break;
        }

        if (!_shouldRetryException(lastException, config, shouldRetry)) {
          _logger.info('$opName failed with non-retryable error: $e');
          break;
        }

        final delay = _calculateDelay(attempt - 1, config);
        _logger.warning(
          '$opName failed on attempt $attempt, retrying in ${delay.inMilliseconds}ms: $e',
        );

        await Future<void>.delayed(delay);
      }
    }

    throw lastException!;
  }

  /// Determines if an exception should trigger a retry
  static bool _shouldRetryException(
    Exception exception,
    RetryConfig config,
    bool Function(Exception)? customShouldRetry,
  ) {
    // Check custom retry logic first
    if (customShouldRetry != null) {
      return customShouldRetry(exception);
    }

    // Check specific exception types in config
    if (config.retryOnExceptions.isNotEmpty) {
      return config.retryOnExceptions.any(
        (type) => exception.runtimeType == type,
      );
    }

    // Check TrueNAS specific exceptions
    if (exception is TrueNasTimeoutException && config.retryOnTimeout) {
      return true;
    }

    if (exception is TrueNasNetworkException && config.retryOnNetwork) {
      return true;
    }

    if (exception is TrueNasConnectionException && config.retryOnNetwork) {
      return true;
    }

    if (exception is TrueNasServerException && config.retryOnServer) {
      // Don't retry client errors (4xx)
      if (exception.statusCode != null &&
          exception.statusCode! >= 400 &&
          exception.statusCode! < 500) {
        return false;
      }
      return true;
    }

    if (exception is TrueNasRateLimitException) {
      // Always retry rate limits, but respect the retry-after header
      return true;
    }

    // Don't retry authentication/authorization errors
    if (exception is TrueNasAuthenticationException ||
        exception is TrueNasAuthorizationException) {
      return false;
    }

    // Don't retry validation errors
    if (exception is TrueNasValidationException) {
      return false;
    }

    // Don't retry not found errors
    if (exception is TrueNasNotFoundException) {
      return false;
    }

    return false;
  }

  /// Calculates the delay for the next retry using exponential backoff with jitter
  static Duration _calculateDelay(int attemptNumber, RetryConfig config) {
    if (config.initialDelay == Duration.zero) {
      return Duration.zero;
    }

    // Calculate exponential backoff
    final exponentialDelay =
        config.initialDelay.inMilliseconds *
        pow(config.backoffMultiplier, attemptNumber);

    // Apply max delay constraint
    final constrainedDelay = min(
      exponentialDelay,
      config.maxDelay.inMilliseconds.toDouble(),
    );

    // Add jitter (±25% of the delay)
    final jitterRange = constrainedDelay * 0.25;
    final jitter = (_random.nextDouble() - 0.5) * 2 * jitterRange;
    final finalDelay = constrainedDelay + jitter;

    return Duration(milliseconds: max(0, finalDelay.round()));
  }

  /// Creates a retry configuration for rate-limited operations
  static RetryConfig forRateLimit({Duration? retryAfter, int maxAttempts = 3}) {
    final delay = retryAfter ?? const Duration(seconds: 60);

    return RetryConfig(
      maxAttempts: maxAttempts,
      initialDelay: delay,
      maxDelay: delay,
      backoffMultiplier: 1.0, // No exponential backoff for rate limits
      retryOnTimeout: false,
      retryOnNetwork: false,
      retryOnServer: false,
      retryOnExceptions: [TrueNasRateLimitException],
    );
  }
}

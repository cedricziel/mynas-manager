import 'dart:async';

/// Rate limiting configuration
class RateLimitConfig {
  final int maxRequests;
  final Duration window;
  final Duration cooldownPeriod;

  const RateLimitConfig({
    required this.maxRequests,
    required this.window,
    this.cooldownPeriod = const Duration(minutes: 10),
  });

  /// TrueNAS recommended rate limits (20 requests per 60 seconds)
  factory RateLimitConfig.truenas() => const RateLimitConfig(
    maxRequests: 20,
    window: Duration(seconds: 60),
    cooldownPeriod: Duration(minutes: 10),
  );
}

/// Rate limiting state
enum RateLimitState { normal, approaching, limited, cooldown }

/// Rate limiter interface for controlling API request frequency
abstract class IRateLimiter {
  /// Current rate limiting state
  RateLimitState get state;

  /// Stream of rate limit state changes
  Stream<RateLimitState> get stateStream;

  /// Current number of requests in the window
  int get currentRequests;

  /// Maximum requests allowed in the window
  int get maxRequests;

  /// Time until the rate limit window resets
  Duration get timeUntilReset;

  /// Wait for permission to make a request
  /// Throws [RateLimitExceededException] if in cooldown
  Future<void> waitForPermission();

  /// Check if a request can be made immediately
  bool canMakeRequest();

  /// Record that a request was made
  void recordRequest();

  /// Record that a rate limit violation occurred
  void recordViolation();

  /// Reset the rate limiter
  void reset();
}

/// Exception thrown when rate limit is exceeded
class RateLimitExceededException implements Exception {
  final String message;
  final Duration retryAfter;

  const RateLimitExceededException({
    required this.message,
    required this.retryAfter,
  });

  @override
  String toString() =>
      'RateLimitExceededException: $message (retry after $retryAfter)';
}

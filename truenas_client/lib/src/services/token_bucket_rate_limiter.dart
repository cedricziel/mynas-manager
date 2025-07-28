import 'dart:async';
import 'package:logging/logging.dart';
import '../interfaces/rate_limiter.dart';

/// Token bucket rate limiter implementation
class TokenBucketRateLimiter implements IRateLimiter {
  final _logger = Logger('TokenBucketRateLimiter');
  final StreamController<RateLimitState> _stateController =
      StreamController<RateLimitState>.broadcast();

  final RateLimitConfig _config;
  final List<DateTime> _requestTimes = [];
  Timer? _resetTimer;
  Timer? _cooldownTimer;

  RateLimitState _state = RateLimitState.normal;
  bool _inCooldown = false;
  DateTime? _cooldownStart;

  TokenBucketRateLimiter({required RateLimitConfig config}) : _config = config {
    _startResetTimer();
  }

  /// Create with TrueNAS default settings
  factory TokenBucketRateLimiter.truenas() =>
      TokenBucketRateLimiter(config: RateLimitConfig.truenas());

  @override
  RateLimitState get state => _state;

  @override
  Stream<RateLimitState> get stateStream => _stateController.stream;

  @override
  int get currentRequests => _getValidRequestCount();

  @override
  int get maxRequests => _config.maxRequests;

  @override
  Duration get timeUntilReset {
    if (_requestTimes.isEmpty) return Duration.zero;

    final oldestRequest = _requestTimes.first;
    final resetTime = oldestRequest.add(_config.window);
    final now = DateTime.now();

    if (resetTime.isAfter(now)) {
      return resetTime.difference(now);
    }

    return Duration.zero;
  }

  @override
  bool canMakeRequest() {
    if (_inCooldown) return false;
    return _getValidRequestCount() < _config.maxRequests;
  }

  @override
  Future<void> waitForPermission() async {
    if (_inCooldown) {
      final remaining = _cooldownStart!
          .add(_config.cooldownPeriod)
          .difference(DateTime.now());
      throw RateLimitExceededException(
        message: 'Rate limit exceeded, in cooldown period',
        retryAfter: remaining,
      );
    }

    while (!canMakeRequest()) {
      final waitTime = timeUntilReset;
      if (waitTime > Duration.zero) {
        _logger.fine(
          'Waiting ${waitTime.inMilliseconds}ms for rate limit reset',
        );
        await Future.delayed(
          Duration(milliseconds: waitTime.inMilliseconds.clamp(0, 1000)),
        );
      } else {
        // Clean up old requests
        _cleanupOldRequests();
        break;
      }
    }
  }

  @override
  void recordRequest() {
    if (_inCooldown) {
      _logger.warning('Request recorded during cooldown period');
      return;
    }

    final now = DateTime.now();
    _requestTimes.add(now);
    _cleanupOldRequests();

    final count = _getValidRequestCount();
    _logger.fine('Request recorded, current count: $count/$maxRequests');

    _updateState();
  }

  @override
  void recordViolation() {
    _logger.warning('Rate limit violation recorded, entering cooldown');
    _enterCooldown();
  }

  @override
  void reset() {
    _logger.info('Rate limiter reset');
    _requestTimes.clear();
    _inCooldown = false;
    _cooldownStart = null;
    _cooldownTimer?.cancel();
    _updateState();
  }

  int _getValidRequestCount() {
    _cleanupOldRequests();
    return _requestTimes.length;
  }

  void _cleanupOldRequests() {
    final now = DateTime.now();
    final cutoff = now.subtract(_config.window);

    _requestTimes.removeWhere((time) => time.isBefore(cutoff));
  }

  void _updateState() {
    final count = _getValidRequestCount();
    final maxRequests = _config.maxRequests;

    RateLimitState newState;
    if (_inCooldown) {
      newState = RateLimitState.cooldown;
    } else if (count >= maxRequests) {
      newState = RateLimitState.limited;
    } else if (count >= (maxRequests * 0.8)) {
      newState = RateLimitState.approaching;
    } else {
      newState = RateLimitState.normal;
    }

    if (_state != newState) {
      _logger.fine('Rate limit state changed: $_state -> $newState');
      _state = newState;
      _stateController.add(newState);
    }
  }

  void _enterCooldown() {
    _inCooldown = true;
    _cooldownStart = DateTime.now();
    _requestTimes.clear();

    _cooldownTimer?.cancel();
    _cooldownTimer = Timer(_config.cooldownPeriod, () {
      _logger.info('Cooldown period ended');
      _inCooldown = false;
      _cooldownStart = null;
      _updateState();
    });

    _updateState();
  }

  void _startResetTimer() {
    // Periodically clean up old requests
    _resetTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      _cleanupOldRequests();
      _updateState();
    });
  }

  void dispose() {
    _resetTimer?.cancel();
    _cooldownTimer?.cancel();
    _stateController.close();
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mynas_frontend/providers/auth_provider.dart';

class SessionTimer extends ConsumerStatefulWidget {
  const SessionTimer({super.key});

  @override
  ConsumerState<SessionTimer> createState() => _SessionTimerState();
}

class _SessionTimerState extends ConsumerState<SessionTimer> {
  Timer? _timer;
  Duration _timeRemaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          // Update time remaining
          final authState = ref.read(authProvider);
          if (authState.sessionExpiringIn != null) {
            _timeRemaining =
                authState.sessionExpiringIn! - const Duration(seconds: 1);
            if (_timeRemaining.isNegative) {
              _timeRemaining = Duration.zero;
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    if (duration == Duration.zero) return '';

    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 10) {
      return '${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);

    if (!authState.isAuthenticated) {
      return const SizedBox.shrink();
    }

    // Only show timer when session is expiring soon (< 5 minutes)
    final showTimer =
        authState.sessionExpiringIn != null &&
        authState.sessionExpiringIn!.inMinutes < 5;

    if (!showTimer) {
      return const SizedBox.shrink();
    }

    final isUrgent = _timeRemaining.inMinutes < 2;
    final color = isUrgent ? theme.colorScheme.error : Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer_outlined, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            _formatDuration(_timeRemaining),
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

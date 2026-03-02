import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mynas_frontend/providers/auth_provider.dart';

class SessionExpiryDialog extends ConsumerStatefulWidget {
  final Duration timeRemaining;

  const SessionExpiryDialog({super.key, required this.timeRemaining});

  @override
  ConsumerState<SessionExpiryDialog> createState() =>
      _SessionExpiryDialogState();
}

class _SessionExpiryDialogState extends ConsumerState<SessionExpiryDialog> {
  late Timer _timer;
  late Duration _timeRemaining;

  @override
  void initState() {
    super.initState();
    _timeRemaining = widget.timeRemaining;

    // Update countdown every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeRemaining = _timeRemaining - const Duration(seconds: 1);
        if (_timeRemaining.isNegative) {
          _timer.cancel();
          Navigator.of(context).pop();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _extendSession() async {
    // Any activity will extend the session
    await ref.read(authProvider.notifier).refreshSession();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      icon: Icon(
        Icons.timer_outlined,
        size: 48,
        color: theme.colorScheme.warning,
      ),
      title: const Text('Session Expiring Soon'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Your session will expire in:',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.warningContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _formatDuration(_timeRemaining),
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onWarningContainer,
                fontWeight: FontWeight.bold,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Would you like to extend your session?',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Log Out'),
        ),
        FilledButton(
          onPressed: _extendSession,
          child: const Text('Extend Session'),
        ),
      ],
    );
  }
}

// Helper extension to add warning color
extension ColorSchemeExtension on ColorScheme {
  Color get warning => Colors.orange;
  Color get onWarning => Colors.white;
  Color get warningContainer => Colors.orange.shade100;
  Color get onWarningContainer => Colors.orange.shade900;
}

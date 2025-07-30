import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mynas_frontend/providers/auth_provider.dart';
import 'package:mynas_frontend/widgets/session_expiry_dialog.dart';

class SessionMonitor extends ConsumerStatefulWidget {
  final Widget child;

  const SessionMonitor({super.key, required this.child});

  @override
  ConsumerState<SessionMonitor> createState() => _SessionMonitorState();
}

class _SessionMonitorState extends ConsumerState<SessionMonitor> {
  bool _dialogShown = false;

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes
    ref.listen<AuthState>(authProvider, (previous, next) {
      // Handle session expiry
      if (previous?.isAuthenticated == true && !next.isAuthenticated) {
        // Session expired - redirect to login
        context.go('/login');
      }

      // Handle session expiring soon
      if (next.sessionExpiringIn != null && !_dialogShown) {
        _dialogShown = true;
        _showExpiryDialog(next.sessionExpiringIn!);
      }

      // Reset dialog flag when session is extended
      if (next.sessionExpiringIn == null && _dialogShown) {
        _dialogShown = false;
      }
    });

    return widget.child;
  }

  void _showExpiryDialog(Duration timeRemaining) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SessionExpiryDialog(timeRemaining: timeRemaining),
    ).then((_) {
      // Dialog was closed
      _dialogShown = false;

      // Check if user chose to log out
      final authState = ref.read(authProvider);
      if (!authState.isAuthenticated && mounted) {
        context.go('/login');
      }
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mynas_frontend/providers/auth_provider.dart';
import 'package:mynas_frontend/widgets/session_timer.dart';

class StatusBar extends ConsumerStatefulWidget {
  const StatusBar({super.key});

  @override
  ConsumerState<StatusBar> createState() => _StatusBarState();
}

class _StatusBarState extends ConsumerState<StatusBar> {
  late Stream<DateTime> _timeStream;

  @override
  void initState() {
    super.initState();
    // Update time every minute
    _timeStream = Stream.periodic(
      const Duration(minutes: 1),
      (_) => DateTime.now(),
    ).asBroadcastStream();
  }

  Future<void> _showLogoutConfirmation(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(authProvider.notifier).logout();
      if (context.mounted) {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);

    return Container(
      height: 28,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            // User info
            if (authState.isAuthenticated) ...[
              Icon(
                Icons.person_outline,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Text(
                authState.username ?? 'User',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 16),
            ],

            // Session timer
            const SessionTimer(),

            const Spacer(),

            // Logout button
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _showLogoutConfirmation(context, ref),
                borderRadius: BorderRadius.circular(4),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.logout,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Log Out',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Current time
            StreamBuilder<DateTime>(
              stream: _timeStream,
              initialData: DateTime.now(),
              builder: (context, snapshot) {
                final time = snapshot.data ?? DateTime.now();
                final hour = time.hour.toString().padLeft(2, '0');
                final minute = time.minute.toString().padLeft(2, '0');
                final formattedTime = '$hour:$minute';

                final weekdays = [
                  'Mon',
                  'Tue',
                  'Wed',
                  'Thu',
                  'Fri',
                  'Sat',
                  'Sun',
                ];
                final months = [
                  'Jan',
                  'Feb',
                  'Mar',
                  'Apr',
                  'May',
                  'Jun',
                  'Jul',
                  'Aug',
                  'Sep',
                  'Oct',
                  'Nov',
                  'Dec',
                ];
                final weekday = weekdays[time.weekday - 1];
                final month = months[time.month - 1];
                final formattedDate = '$weekday, $month ${time.day}';

                return Row(
                  children: [
                    Text(
                      formattedDate,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      formattedTime,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

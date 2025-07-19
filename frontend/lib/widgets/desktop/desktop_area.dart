import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mynas_frontend/providers/window_manager_provider.dart';
import 'package:mynas_frontend/screens/dashboard_screen.dart';
import 'package:mynas_frontend/screens/storage_screen.dart';
import 'package:mynas_frontend/screens/shares_screen.dart';
import 'package:mynas_frontend/screens/settings_screen.dart';

class DesktopArea extends ConsumerWidget {
  const DesktopArea({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Wrap(
        spacing: 24,
        runSpacing: 24,
        children: [
          _DesktopIcon(
            icon: Icons.dashboard,
            label: 'Dashboard',
            onTap: () => _openApp(
              ref,
              'dashboard',
              'Dashboard',
              Icons.dashboard,
              const DashboardScreen(),
            ),
          ),
          _DesktopIcon(
            icon: Icons.storage,
            label: 'Storage',
            onTap: () => _openApp(
              ref,
              'storage',
              'Storage Manager',
              Icons.storage,
              const StorageScreen(),
            ),
          ),
          _DesktopIcon(
            icon: Icons.folder_shared,
            label: 'Shares',
            onTap: () => _openApp(
              ref,
              'shares',
              'Share Manager',
              Icons.folder_shared,
              const SharesScreen(),
            ),
          ),
          _DesktopIcon(
            icon: Icons.settings,
            label: 'Settings',
            onTap: () => _openApp(
              ref,
              'settings',
              'Settings',
              Icons.settings,
              const SettingsScreen(),
            ),
          ),
        ],
      ),
    );
  }

  void _openApp(
    WidgetRef ref,
    String id,
    String title,
    IconData icon,
    Widget content,
  ) {
    ref
        .read(windowManagerProvider.notifier)
        .openWindowWithParams(
          id: id,
          title: title,
          icon: icon,
          content: content,
        );
  }
}

class _DesktopIcon extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DesktopIcon({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_DesktopIcon> createState() => _DesktopIconState();
}

class _DesktopIconState extends State<_DesktopIcon> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onDoubleTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 80,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _isHovered
                ? theme.colorScheme.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  widget.icon,
                  size: 28,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: _isHovered ? FontWeight.w600 : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

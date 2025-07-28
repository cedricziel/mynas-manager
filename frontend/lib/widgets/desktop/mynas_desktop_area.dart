import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mynas_desktop/mynas_desktop.dart';
import 'package:mynas_frontend/screens/dashboard_screen.dart';
import 'package:mynas_frontend/screens/storage_screen.dart';
import 'package:mynas_frontend/screens/shares_screen.dart';
import 'package:mynas_frontend/screens/settings_screen.dart';

class MyNASDesktopArea extends ConsumerWidget {
  const MyNASDesktopArea({super.key});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DesktopArea(
      icons: [
        DesktopIcon(
          id: 'dashboard',
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
        DesktopIcon(
          id: 'storage',
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
        DesktopIcon(
          id: 'shares',
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
        DesktopIcon(
          id: 'settings',
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
    );
  }
}

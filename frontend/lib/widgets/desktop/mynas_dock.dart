import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mynas_desktop/mynas_desktop.dart';
import 'package:mynas_frontend/widgets/apps/storage_app.dart';

class MyNASDock extends ConsumerWidget {
  const MyNASDock({super.key});

  void _openStorageApp(WidgetRef ref) {
    final windowManager = ref.read(windowManagerProvider.notifier);

    // Check if storage window is already open
    final existingWindows = ref
        .read(windowManagerProvider)
        .windows
        .where((w) => w.id == 'storage-app');
    final existingWindow = existingWindows.isNotEmpty
        ? existingWindows.first
        : null;

    if (existingWindow != null) {
      // Focus existing window
      windowManager.focusWindow('storage-app');
      if (existingWindow.isMinimized) {
        windowManager.restoreWindow('storage-app');
      }
      return;
    }

    // Create new storage window
    final window = WindowState(
      id: 'storage-app',
      title: 'Storage Manager',
      icon: Icons.storage,
      content: const StorageApp(),
      position: const Offset(100, 100),
      size: const Size(1200, 800),
      minSize: const Size(800, 600),
      canResize: true,
      canClose: true,
      isFocused: true,
    );

    windowManager.openWindow(window);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dock(
      launchers: [
        DockLauncher(
          id: 'storage',
          icon: Icons.storage,
          label: 'Storage',
          onTap: () => _openStorageApp(ref),
        ),
        DockLauncher(
          id: 'apps',
          icon: Icons.apps,
          label: 'Apps',
          onTap: () {
            // TODO: Show app launcher
          },
        ),
      ],
    );
  }
}

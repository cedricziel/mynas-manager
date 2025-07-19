import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mynas_shared/mynas_shared.dart';
import '../../providers/pool_provider.dart';
import '../../providers/window_manager_provider.dart';
import 'package:mynas_frontend/models/window_state.dart';
import '../storage/pool_health_cards.dart';
import '../storage/pool_list_view.dart';
import '../storage/pool_detail_panel.dart';

class StorageApp extends ConsumerStatefulWidget {
  const StorageApp({super.key});

  @override
  ConsumerState<StorageApp> createState() => _StorageAppState();
}

class _StorageAppState extends ConsumerState<StorageApp> {
  Pool? _selectedPool;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Storage Manager'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => ref.read(poolProvider.notifier).refresh(),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create Pool',
            onPressed: () {
              // TODO: Implement create pool wizard
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Pool creation wizard coming soon'),
                ),
              );
            },
          ),
        ],
      ),
      body: _selectedPool != null ? _buildDetailView() : _buildOverviewLayout(),
    );
  }

  Widget _buildOverviewLayout() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Health cards section
          const PoolHealthCards(),

          const SizedBox(height: 32),

          // Pool list section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Storage Pools',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: PoolListView(
                    onPoolSelected: (pool) {
                      setState(() {
                        _selectedPool = pool;
                      });
                    },
                    onPoolAction: (pool) {
                      // Handle pool actions from context menu
                      setState(() {
                        _selectedPool = pool;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailView() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: PoolDetailPanel(
        pool: _selectedPool!,
        onClose: () {
          setState(() {
            _selectedPool = null;
          });
        },
      ),
    );
  }

  // Static method to open the storage app as a window
  // ignore: unused_element
  static void openAsWindow(WidgetRef ref) {
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
}

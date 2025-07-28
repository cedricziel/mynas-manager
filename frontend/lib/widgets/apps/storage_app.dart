import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mynas_shared/mynas_shared.dart';
import '../../providers/pool_provider.dart';
import '../../providers/disk_provider.dart';
import 'package:mynas_desktop/mynas_desktop.dart';
import '../storage/pool_health_cards.dart';
import '../storage/pool_list_view.dart';
import '../storage/pool_detail_panel.dart';
import '../storage/disk_list_view.dart';
import '../storage/disk_detail_panel.dart';

class StorageApp extends ConsumerStatefulWidget {
  const StorageApp({super.key});

  @override
  ConsumerState<StorageApp> createState() => _StorageAppState();
}

class _StorageAppState extends ConsumerState<StorageApp>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Pool? _selectedPool;
  Disk? _selectedDisk;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
            onPressed: () {
              ref.read(poolProvider.notifier).refresh();
              ref.read(diskProvider.notifier).refresh();
            },
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
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.storage), text: 'Pools'),
            Tab(icon: Icon(Icons.album), text: 'Disks'),
            Tab(icon: Icon(Icons.folder), text: 'Datasets'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Pools tab
          _selectedPool != null
              ? _buildPoolDetailView()
              : _buildPoolsOverview(),
          // Disks tab
          _selectedDisk != null
              ? _buildDiskDetailView()
              : _buildDisksOverview(),
          // Datasets tab
          _buildDatasetsView(),
        ],
      ),
    );
  }

  Widget _buildPoolsOverview() {
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

  Widget _buildPoolDetailView() {
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

  Widget _buildDisksOverview() {
    final diskState = ref.watch(diskProvider);

    if (diskState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (diskState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading disks',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(diskState.error!),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => ref.read(diskProvider.notifier).refresh(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Disk health summary
          _buildDiskHealthSummary(ref),

          const SizedBox(height: 24),

          // Disk list
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All Disks',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: DiskListView(
                    onDiskSelected: (disk) {
                      setState(() {
                        _selectedDisk = disk;
                      });
                    },
                    onDiskAction: (disk) {
                      setState(() {
                        _selectedDisk = disk;
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

  Widget _buildDiskDetailView() {
    if (_selectedDisk == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: DiskDetailPanel(
        disk: _selectedDisk!,
        onClose: () {
          setState(() {
            _selectedDisk = null;
          });
        },
      ),
    );
  }

  Widget _buildDatasetsView() {
    return const Center(child: Text('Datasets view coming soon'));
  }

  Widget _buildDiskHealthSummary(WidgetRef ref) {
    final diskStats = ref.watch(diskHealthStatsProvider);

    return Row(
      children: [
        _buildHealthCard(
          context: context,
          title: 'Total Disks',
          value: diskStats['total'].toString(),
          icon: Icons.album,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 16),
        _buildHealthCard(
          context: context,
          title: 'Healthy',
          value: diskStats['healthy'].toString(),
          icon: Icons.check_circle,
          color: Colors.green,
        ),
        const SizedBox(width: 16),
        _buildHealthCard(
          context: context,
          title: 'Warning',
          value: diskStats['warning'].toString(),
          icon: Icons.warning,
          color: Colors.orange,
        ),
        const SizedBox(width: 16),
        _buildHealthCard(
          context: context,
          title: 'Critical',
          value: diskStats['critical'].toString(),
          icon: Icons.error,
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildHealthCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20, color: color),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
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

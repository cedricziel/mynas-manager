import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mynas_shared/mynas_shared.dart';
import '../../providers/pool_provider.dart';
import '../../providers/disk_provider.dart';
import '../../utils/storage_utils.dart';
import 'pool_topology_view.dart';
import 'disk_list_view.dart';

class PoolDetailPanel extends ConsumerStatefulWidget {
  final Pool pool;
  final VoidCallback? onClose;

  const PoolDetailPanel({super.key, required this.pool, this.onClose});

  @override
  ConsumerState<PoolDetailPanel> createState() => _PoolDetailPanelState();
}

class _PoolDetailPanelState extends ConsumerState<PoolDetailPanel>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final datasets = ref.watch(datasetsByPoolProvider(widget.pool.id));
    final scrubTasks = ref.watch(scrubTasksByPoolProvider(widget.pool.id));
    final resilver = ref.watch(resilverByPoolProvider(widget.pool.id));
    final scrubHistory = ref.watch(scrubHistoryByPoolProvider(widget.pool.id));

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(theme),

          // Tab bar
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Overview', icon: Icon(Icons.dashboard_outlined)),
                Tab(text: 'Disks', icon: Icon(Icons.album)),
                Tab(text: 'Datasets', icon: Icon(Icons.folder_outlined)),
                Tab(text: 'Maintenance', icon: Icon(Icons.build_outlined)),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(theme, resilver, scrubHistory),
                _buildDisksTab(theme),
                _buildDatasetsTab(theme, datasets),
                _buildMaintenanceTab(theme, scrubTasks, resilver),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final usagePercentage = StorageUtils.calculatePercentage(
      widget.pool.allocated,
      widget.pool.size,
    );

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.storage,
                size: 32,
                color: theme.colorScheme.onPrimaryContainer,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.pool.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (widget.pool.path != null)
                      Text(
                        widget.pool.path!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer
                              .withValues(alpha: 0.8),
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                onPressed: widget.onClose,
                icon: Icon(
                  Icons.close,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Pool stats row
          Row(
            children: [
              _buildStatCard(
                'Status',
                widget.pool.status.toUpperCase(),
                widget.pool.isHealthy ? Colors.green : theme.colorScheme.error,
                theme,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                'Capacity',
                StorageUtils.formatBytes(widget.pool.size),
                theme.colorScheme.onPrimaryContainer,
                theme,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                'Used',
                '${StorageUtils.formatBytes(widget.pool.allocated)} (${usagePercentage.toStringAsFixed(1)}%)',
                _getUsageColor(usagePercentage, theme),
                theme,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    Color valueColor,
    ThemeData theme,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer.withValues(
                  alpha: 0.8,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                color: valueColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(
    ThemeData theme,
    PoolResilver? resilver,
    List<PoolScrub> scrubHistory,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Performance metrics
          Text(
            'Performance',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Read IOPS',
                  '12.5K',
                  Icons.download_outlined,
                  Colors.blue,
                  theme,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard(
                  'Write IOPS',
                  '8.2K',
                  Icons.upload_outlined,
                  Colors.orange,
                  theme,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard(
                  'Throughput',
                  '450 MB/s',
                  Icons.speed,
                  Colors.green,
                  theme,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Recent activity
          Text(
            'Recent Activity',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          if (resilver != null) ...[
            _buildActivityCard(
              'Resilver in Progress',
              'VDev replacement ongoing',
              resilver.percentComplete != null
                  ? '${resilver.percentComplete!.toStringAsFixed(1)}% complete'
                  : 'In progress...',
              Icons.autorenew,
              Colors.blue,
              theme,
            ),
            const SizedBox(height: 12),
          ],

          if (scrubHistory.isNotEmpty) ...[
            ...scrubHistory
                .take(3)
                .map(
                  (scrub) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildActivityCard(
                      'Scrub ${scrub.status.name}',
                      scrub.startTime != null
                          ? 'Started ${StorageUtils.formatRelativeTime(scrub.startTime!)}'
                          : 'Scheduled',
                      scrub.endTime != null && scrub.startTime != null
                          ? 'Completed in ${StorageUtils.formatDuration(scrub.endTime!.difference(scrub.startTime!))}'
                          : 'In progress...',
                      Icons.cleaning_services,
                      _getScrubColor(scrub.status.name),
                      theme,
                    ),
                  ),
                ),
          ],

          if (resilver == null && scrubHistory.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.timeline,
                        size: 48,
                        color: theme.colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No recent activity',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pool is running normally',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDisksTab(ThemeData theme) {
    final poolDisks = ref.watch(disksByPoolProvider(widget.pool.id));

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          // Disk health summary for this pool
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                _buildDiskHealthCard(
                  'Total Disks',
                  poolDisks.length.toString(),
                  Icons.album,
                  theme.colorScheme.primary,
                  theme,
                ),
                const SizedBox(width: 16),
                _buildDiskHealthCard(
                  'Healthy',
                  poolDisks
                      .where((d) => d.health == DiskHealth.healthy)
                      .length
                      .toString(),
                  Icons.check_circle,
                  Colors.green,
                  theme,
                ),
                const SizedBox(width: 16),
                _buildDiskHealthCard(
                  'Warning',
                  poolDisks
                      .where((d) => d.health == DiskHealth.warning)
                      .length
                      .toString(),
                  Icons.warning,
                  Colors.orange,
                  theme,
                ),
                const SizedBox(width: 16),
                _buildDiskHealthCard(
                  'Critical',
                  poolDisks
                      .where((d) => d.health == DiskHealth.critical)
                      .length
                      .toString(),
                  Icons.error,
                  Colors.red,
                  theme,
                ),
              ],
            ),
          ),

          // Sub tabs for topology and disk list
          Container(
            color: theme.colorScheme.surfaceContainerHighest,
            child: const TabBar(
              tabs: [
                Tab(text: 'Topology', icon: Icon(Icons.device_hub)),
                Tab(text: 'Disk List', icon: Icon(Icons.list)),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              children: [
                // Topology view
                PoolTopologyView(
                  poolId: widget.pool.id,
                  onDiskSelected: (disk) {
                    // TODO: Open disk detail panel
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Selected disk: ${disk.name}')),
                    );
                  },
                ),

                // Disk list view
                DiskListView(
                  onDiskSelected: (disk) {
                    // TODO: Open disk detail panel
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Selected disk: ${disk.name}')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatasetsTab(ThemeData theme, List<Dataset> datasets) {
    return Column(
      children: [
        // Datasets header
        Container(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Text(
                'Datasets',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Show create dataset dialog
                },
                icon: const Icon(Icons.add),
                label: const Text('Create Dataset'),
              ),
            ],
          ),
        ),

        // Datasets list
        Expanded(
          child: datasets.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.folder_outlined,
                        size: 64,
                        color: theme.colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No datasets found',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Create your first dataset to organize your data',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: datasets.length,
                  itemBuilder: (context, index) {
                    final dataset = datasets[index];
                    return _buildDatasetCard(dataset, theme);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildMaintenanceTab(
    ThemeData theme,
    List<PoolScrubTask> scrubTasks,
    PoolResilver? resilver,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Scrub section
          Row(
            children: [
              Text(
                'Scrub Tasks',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Show create scrub task dialog
                },
                icon: const Icon(Icons.add),
                label: const Text('Schedule Scrub'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (scrubTasks.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.cleaning_services_outlined,
                        size: 48,
                        color: theme.colorScheme.outline,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No scheduled scrub tasks',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Schedule regular scrubs to maintain pool health',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            ...scrubTasks.map(
              (task) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildScrubTaskCard(task, theme),
              ),
            ),

          const SizedBox(height: 32),

          // Resilver section
          Text(
            'Resilver Status',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          if (resilver != null)
            _buildResilverCard(resilver, theme)
          else
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 48,
                        color: Colors.green,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No resilver in progress',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'All VDevs are healthy',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
    ThemeData theme,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiskHealthCard(
    String title,
    String value,
    IconData icon,
    Color color,
    ThemeData theme,
  ) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20, color: color),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: theme.textTheme.headlineMedium?.copyWith(
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

  Widget _buildActivityCard(
    String title,
    String subtitle,
    String detail,
    IconData icon,
    Color color,
    ThemeData theme,
  ) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text(
          detail,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildDatasetCard(Dataset dataset, ThemeData theme) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.folder),
        title: Text(dataset.name),
        subtitle: Text(dataset.mountpoint),
        trailing: PopupMenuButton<String>(
          onSelected: (action) => _handleDatasetAction(dataset, action),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'properties',
              child: Row(
                children: [
                  Icon(Icons.settings, size: 16),
                  SizedBox(width: 8),
                  Text('Properties'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'snapshot',
              child: Row(
                children: [
                  Icon(Icons.camera_alt, size: 16),
                  SizedBox(width: 8),
                  Text('Create Snapshot'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 16),
                  SizedBox(width: 8),
                  Text('Delete'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrubTaskCard(PoolScrubTask task, ThemeData theme) {
    return Card(
      child: ListTile(
        leading: Icon(
          task.enabled ? Icons.schedule : Icons.schedule_outlined,
          color: task.enabled ? Colors.green : theme.colorScheme.outline,
        ),
        title: Text(task.description),
        subtitle: Text(StorageUtils.formatCronExpression(task.schedule)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Switch(
              value: task.enabled,
              onChanged: (enabled) {
                // TODO: Update task enabled state
              },
            ),
            PopupMenuButton<String>(
              onSelected: (action) => _handleScrubTaskAction(task, action),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 16),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'run',
                  child: Row(
                    children: [
                      Icon(Icons.play_arrow, size: 16),
                      SizedBox(width: 8),
                      Text('Run Now'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 16),
                      SizedBox(width: 8),
                      Text('Delete'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResilverCard(PoolResilver resilver, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.autorenew, color: Colors.blue),
                const SizedBox(width: 12),
                Text(
                  'Resilver in Progress',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: resilver.percentComplete != null
                  ? resilver.percentComplete! / 100
                  : null,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  resilver.percentComplete != null
                      ? '${resilver.percentComplete!.toStringAsFixed(1)}% complete'
                      : 'Processing...',
                  style: theme.textTheme.bodyMedium,
                ),
                if (resilver.estimatedEndTime != null)
                  Text(
                    'ETA: ${StorageUtils.formatRelativeTime(resilver.estimatedEndTime!)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getUsageColor(double percentage, ThemeData theme) {
    if (percentage >= 90) {
      return theme.colorScheme.error;
    } else if (percentage >= 75) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  Color _getScrubColor(String state) {
    switch (state.toLowerCase()) {
      case 'running':
      case 'scanning':
        return Colors.blue;
      case 'finished':
      case 'completed':
        return Colors.green;
      case 'canceled':
      case 'cancelled':
        return Colors.orange;
      case 'error':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _handleDatasetAction(Dataset dataset, String action) {
    switch (action) {
      case 'properties':
        // TODO: Show dataset properties dialog
        break;
      case 'snapshot':
        // TODO: Show create snapshot dialog
        break;
      case 'delete':
        // TODO: Show delete confirmation dialog
        break;
    }
  }

  void _handleScrubTaskAction(PoolScrubTask task, String action) {
    switch (action) {
      case 'edit':
        // TODO: Show edit scrub task dialog
        break;
      case 'run':
        // TODO: Run scrub task immediately
        break;
      case 'delete':
        // TODO: Show delete confirmation dialog
        break;
    }
  }
}

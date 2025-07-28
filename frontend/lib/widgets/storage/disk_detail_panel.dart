import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mynas_shared/mynas_shared.dart';
import '../../providers/disk_provider.dart';
import '../../utils/format_utils.dart';
import 'smart_data_dialog.dart';

class DiskDetailPanel extends ConsumerStatefulWidget {
  final Disk disk;
  final VoidCallback? onClose;

  const DiskDetailPanel({super.key, required this.disk, this.onClose});

  @override
  ConsumerState<DiskDetailPanel> createState() => _DiskDetailPanelState();
}

class _DiskDetailPanelState extends ConsumerState<DiskDetailPanel>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Load SMART data for this disk
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(diskProvider.notifier).loadSmartData(widget.disk.name);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final temperature = ref.watch(diskTemperatureProvider(widget.disk.name));
    final smartData = ref.watch(diskSmartDataProvider(widget.disk.name));

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(theme, temperature),

          // Tab bar
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
            ),
            child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Overview', icon: Icon(Icons.info_outline)),
                Tab(text: 'Performance', icon: Icon(Icons.speed)),
                Tab(text: 'SMART Data', icon: Icon(Icons.health_and_safety)),
              ],
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(theme, temperature),
                _buildPerformanceTab(theme),
                _buildSmartTab(theme, smartData),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, DiskTemperature? temperature) {
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
              _buildDiskIcon(theme),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.disk.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.disk.model,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer.withOpacity(
                          0.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.onClose != null)
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

          // Disk stats row
          Row(
            children: [
              _buildStatCard(
                'Health',
                widget.disk.health.name.toUpperCase(),
                _getHealthColor(widget.disk.health),
                theme,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                'Capacity',
                FormatUtils.formatBytes(widget.disk.size),
                theme.colorScheme.onPrimaryContainer,
                theme,
              ),
              const SizedBox(width: 16),
              if (temperature != null && temperature.temperature != null)
                _buildStatCard(
                  'Temperature',
                  '${temperature.temperature}°C',
                  _getTemperatureColor(temperature.temperature!),
                  theme,
                )
              else
                _buildStatCard(
                  'Temperature',
                  'N/A',
                  theme.colorScheme.onPrimaryContainer.withOpacity(0.5),
                  theme,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDiskIcon(ThemeData theme) {
    final IconData icon;
    final Color color;

    switch (widget.disk.type) {
      case DiskType.ssd:
        icon = Icons.memory;
        color = theme.colorScheme.primary;
        break;
      case DiskType.hdd:
        icon = Icons.album;
        color = theme.colorScheme.secondary;
        break;
      case DiskType.unknown:
        icon = Icons.device_unknown;
        color = theme.colorScheme.onSurface.withOpacity(0.6);
        break;
    }

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 32),
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
          color: theme.colorScheme.surface.withOpacity(0.3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
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

  Widget _buildOverviewTab(ThemeData theme, DiskTemperature? temperature) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Disk Information
          Text(
            'Disk Information',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoCard(theme),

          const SizedBox(height: 32),

          // Physical Properties
          Text(
            'Physical Properties',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildPhysicalPropertiesCard(theme),

          const SizedBox(height: 32),

          // Configuration
          Text(
            'Configuration',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildConfigurationCard(theme),
        ],
      ),
    );
  }

  Widget _buildInfoCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow('Identifier', widget.disk.identifier, theme),
            _buildInfoRow('Device Name', widget.disk.devname, theme),
            if (widget.disk.serial != null)
              _buildInfoRow('Serial Number', widget.disk.serial!, theme),
            if (widget.disk.pool != null)
              _buildInfoRow('Pool', widget.disk.pool!, theme),
            _buildInfoRow('Bus Type', widget.disk.bus, theme),
            _buildInfoRow('Subsystem', widget.disk.subsystem, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildPhysicalPropertiesCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow('Type', widget.disk.type.name.toUpperCase(), theme),
            _buildInfoRow(
              'Capacity',
              FormatUtils.formatBytes(widget.disk.size),
              theme,
            ),
            if (widget.disk.rotationrate != null &&
                widget.disk.type == DiskType.hdd)
              _buildInfoRow(
                'Rotation Speed',
                '${widget.disk.rotationrate} RPM',
                theme,
              ),
            if (widget.disk.enclosure != null)
              _buildInfoRow('Enclosure', widget.disk.enclosure!, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigurationCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow('Transfer Mode', widget.disk.transfermode, theme),
            _buildInfoRow('HDD Standby', widget.disk.hddstandby, theme),
            _buildInfoRow(
              'Advanced Power Management',
              widget.disk.advpowermgmt,
              theme,
            ),
            _buildInfoRow(
              'SMART Enabled',
              widget.disk.togglesmart ? 'Yes' : 'No',
              theme,
            ),
            if (widget.disk.smartoptions.isNotEmpty)
              _buildInfoRow('SMART Options', widget.disk.smartoptions, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Performance Metrics',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Performance metric cards
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Read Speed',
                  '550 MB/s',
                  Icons.download_outlined,
                  Colors.blue,
                  theme,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard(
                  'Write Speed',
                  '520 MB/s',
                  Icons.upload_outlined,
                  Colors.orange,
                  theme,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Read IOPS',
                  '95K',
                  Icons.storage,
                  Colors.green,
                  theme,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricCard(
                  'Write IOPS',
                  '88K',
                  Icons.edit,
                  Colors.purple,
                  theme,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Temperature history placeholder
          Text(
            'Temperature History',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  'Temperature chart coming soon',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartTab(ThemeData theme, Map<String, dynamic>? smartData) {
    if (smartData == null || smartData.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.health_and_safety_outlined,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text('No SMART data available', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(diskProvider.notifier).loadSmartData(widget.disk.name);
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Load SMART Data'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // SMART actions bar
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _runSmartTest('short'),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Short Test'),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => _runSmartTest('long'),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Long Test'),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _showSmartDataDialog(smartData),
                icon: const Icon(Icons.open_in_new),
                tooltip: 'View Full SMART Data',
              ),
            ],
          ),
        ),

        // SMART attributes summary
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SMART Attributes',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'SMART data display coming soon',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
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

  Color _getHealthColor(DiskHealth health) {
    switch (health) {
      case DiskHealth.healthy:
        return Colors.green;
      case DiskHealth.warning:
        return Colors.orange;
      case DiskHealth.critical:
        return Colors.red;
      case DiskHealth.unknown:
        return Colors.grey;
    }
  }

  Color _getTemperatureColor(int temperature) {
    if (temperature > 50) {
      return Colors.red;
    } else if (temperature > 45) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  void _runSmartTest(String testType) {
    ref
        .read(diskProvider.notifier)
        .runSmartTest(diskName: widget.disk.name, testType: testType);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting $testType SMART test on ${widget.disk.name}'),
      ),
    );
  }

  void _showSmartDataDialog(Map<String, dynamic> smartData) {
    showDialog(
      context: context,
      builder: (context) =>
          SmartDataDialog(diskName: widget.disk.name, smartData: smartData),
    );
  }
}

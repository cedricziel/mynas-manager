import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mynas_shared/mynas_shared.dart';
import '../../providers/disk_provider.dart';
import '../../utils/format_utils.dart';
import '../../utils/storage_utils.dart';

class PoolTopologyView extends ConsumerStatefulWidget {
  final String poolId;
  final Function(Disk)? onDiskSelected;

  const PoolTopologyView({
    super.key,
    required this.poolId,
    this.onDiskSelected,
  });

  @override
  ConsumerState<PoolTopologyView> createState() => _PoolTopologyViewState();
}

class _PoolTopologyViewState extends ConsumerState<PoolTopologyView> {
  @override
  void initState() {
    super.initState();
    // Load pool topology
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(diskProvider.notifier).loadPoolTopology(widget.poolId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topology = ref.watch(poolTopologyProvider(widget.poolId));

    if (topology == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text('Loading pool topology...', style: theme.textTheme.bodyLarge),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pool Topology - ${topology.poolName}',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // Data VDevs
          if (topology.vdevGroups.isNotEmpty) ...[
            _buildSectionHeader('Data VDevs', Icons.storage, theme),
            const SizedBox(height: 16),
            ...topology.vdevGroups.map(
              (vdev) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildVdevCard(vdev, theme),
              ),
            ),
          ],

          // Cache Devices
          if (topology.cache.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSectionHeader('Cache Devices (L2ARC)', Icons.speed, theme),
            const SizedBox(height: 16),
            _buildDiskGrid(topology.cache, theme),
          ],

          // Log Devices
          if (topology.log.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSectionHeader('Log Devices (ZIL)', Icons.edit_note, theme),
            const SizedBox(height: 16),
            _buildDiskGrid(topology.log, theme),
          ],

          // Spare Devices
          if (topology.spares.isNotEmpty) ...[
            const SizedBox(height: 24),
            _buildSectionHeader('Hot Spares', Icons.backup, theme),
            const SizedBox(height: 16),
            _buildDiskGrid(topology.spares, theme),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildVdevCard(VdevGroup vdev, ThemeData theme) {
    final isHealthy = vdev.status.toLowerCase() == 'online';

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // VDev header
            Row(
              children: [
                Icon(
                  isHealthy ? Icons.check_circle : Icons.warning,
                  color: isHealthy ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    vdev.name ?? StorageUtils.formatVdevType(vdev.type),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: Text(vdev.type.toUpperCase()),
                  backgroundColor: theme.colorScheme.secondaryContainer,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Disk count and status
            Row(
              children: [
                Text(
                  'Disks: ${vdev.disks.length}',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(width: 16),
                Text(
                  'Status: ${vdev.status}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isHealthy ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Disks in VDev
            _buildDiskGrid(vdev.disks, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildDiskGrid(List<Disk> disks, ThemeData theme) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: disks.map((disk) => _buildDiskChip(disk, theme)).toList(),
    );
  }

  Widget _buildDiskChip(Disk disk, ThemeData theme) {
    final temperature = ref.watch(diskTemperatureProvider(disk.name));

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: widget.onDiskSelected != null
            ? () => widget.onDiskSelected!(disk)
            : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _getDiskBorderColor(disk.health),
              width: 2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                disk.type == DiskType.ssd ? Icons.memory : Icons.album,
                size: 16,
                color: _getDiskIconColor(disk.health),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    disk.name,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        FormatUtils.formatBytes(disk.size),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (temperature != null &&
                          temperature.temperature != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          '${temperature.temperature}°C',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: _getTemperatureColor(
                              temperature.temperature!,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Icon(
                _getDiskHealthIcon(disk.health),
                size: 16,
                color: _getDiskIconColor(disk.health),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDiskBorderColor(DiskHealth health) {
    switch (health) {
      case DiskHealth.healthy:
        return Colors.green.withValues(alpha: 0.5);
      case DiskHealth.warning:
        return Colors.orange.withValues(alpha: 0.5);
      case DiskHealth.critical:
        return Colors.red.withValues(alpha: 0.5);
      case DiskHealth.unknown:
        return Colors.grey.withValues(alpha: 0.5);
    }
  }

  Color _getDiskIconColor(DiskHealth health) {
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

  IconData _getDiskHealthIcon(DiskHealth health) {
    switch (health) {
      case DiskHealth.healthy:
        return Icons.check_circle_outline;
      case DiskHealth.warning:
        return Icons.warning_outlined;
      case DiskHealth.critical:
        return Icons.error_outline;
      case DiskHealth.unknown:
        return Icons.help_outline;
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
}

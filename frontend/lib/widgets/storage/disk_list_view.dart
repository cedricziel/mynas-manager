import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mynas_shared/mynas_shared.dart';
import '../../providers/disk_provider.dart';
import '../../utils/format_utils.dart';

class DiskListView extends ConsumerWidget {
  final Function(Disk disk)? onDiskSelected;
  final Function(Disk disk)? onDiskAction;

  const DiskListView({super.key, this.onDiskSelected, this.onDiskAction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final disks = ref.watch(allDisksProvider);
    final diskState = ref.watch(diskProvider);

    if (diskState.isLoading && disks.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (disks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.album_outlined,
              size: 64,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'No disks found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: disks.length,
      itemBuilder: (context, index) {
        final disk = disks[index];
        final temperature = ref.watch(diskTemperatureProvider(disk.name));

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: _buildDiskIcon(context, disk),
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    disk.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (disk.pool != null) ...[
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(
                      'Pool: ${disk.pool}',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      disk.model,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const Text(' • '),
                    Text(
                      FormatUtils.formatBytes(disk.size),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const Text(' • '),
                    Text(
                      disk.type.name.toUpperCase(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (disk.rotationrate != null &&
                        disk.type == DiskType.hdd) ...[
                      const Text(' • '),
                      Text(
                        '${disk.rotationrate} RPM',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (disk.serial != null) ...[
                      Text(
                        'S/N: ${disk.serial}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                    Text(
                      'Bus: ${disk.bus}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    if (temperature != null &&
                        temperature.temperature != null) ...[
                      const SizedBox(width: 16),
                      _buildTemperatureChip(context, temperature.temperature!),
                    ],
                  ],
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHealthIndicator(context, disk.health),
                if (onDiskAction != null) ...[
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'smart',
                        child: Text('View SMART Data'),
                      ),
                      const PopupMenuItem(
                        value: 'test_short',
                        child: Text('Run Short Test'),
                      ),
                      const PopupMenuItem(
                        value: 'test_long',
                        child: Text('Run Long Test'),
                      ),
                    ],
                    onSelected: (value) {
                      switch (value) {
                        case 'smart':
                          ref
                              .read(diskProvider.notifier)
                              .loadSmartData(disk.name);
                          onDiskAction?.call(disk);
                          break;
                        case 'test_short':
                          ref
                              .read(diskProvider.notifier)
                              .runSmartTest(
                                diskName: disk.name,
                                testType: 'short',
                              );
                          break;
                        case 'test_long':
                          ref
                              .read(diskProvider.notifier)
                              .runSmartTest(
                                diskName: disk.name,
                                testType: 'long',
                              );
                          break;
                      }
                    },
                  ),
                ],
              ],
            ),
            onTap: onDiskSelected != null ? () => onDiskSelected!(disk) : null,
          ),
        );
      },
    );
  }

  Widget _buildDiskIcon(BuildContext context, Disk disk) {
    final IconData icon;
    final Color color;

    switch (disk.type) {
      case DiskType.ssd:
        icon = Icons.memory;
        color = Theme.of(context).colorScheme.primary;
        break;
      case DiskType.hdd:
        icon = Icons.album;
        color = Theme.of(context).colorScheme.secondary;
        break;
      case DiskType.unknown:
        icon = Icons.device_unknown;
        color = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6);
        break;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color),
    );
  }

  Widget _buildHealthIndicator(BuildContext context, DiskHealth health) {
    final Color color;
    final IconData icon;
    final String tooltip;

    switch (health) {
      case DiskHealth.healthy:
        color = Colors.green;
        icon = Icons.check_circle;
        tooltip = 'Healthy';
        break;
      case DiskHealth.warning:
        color = Colors.orange;
        icon = Icons.warning;
        tooltip = 'Warning';
        break;
      case DiskHealth.critical:
        color = Colors.red;
        icon = Icons.error;
        tooltip = 'Critical';
        break;
      case DiskHealth.unknown:
        color = Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3);
        icon = Icons.help_outline;
        tooltip = 'Unknown';
        break;
    }

    return Tooltip(
      message: tooltip,
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _buildTemperatureChip(BuildContext context, int temperature) {
    final Color color;
    if (temperature > 50) {
      color = Colors.red;
    } else if (temperature > 45) {
      color = Colors.orange;
    } else {
      color = Colors.green;
    }

    return Chip(
      label: Text(
        '$temperature°C',
        style: TextStyle(color: color, fontSize: 12),
      ),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide(color: color.withValues(alpha: 0.3)),
      visualDensity: VisualDensity.compact,
    );
  }
}

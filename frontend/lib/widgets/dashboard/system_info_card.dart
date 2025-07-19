import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mynas_frontend/providers/system_provider.dart';

class SystemInfoCard extends ConsumerWidget {
  const SystemInfoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final systemInfoAsync = ref.watch(systemInfoNotifierProvider);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.computer,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'System Information',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                if (systemInfoAsync.isLoading)
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            systemInfoAsync.when(
              data: (systemInfo) {
                if (systemInfo == null) {
                  return const Center(
                    child: Text('Unable to connect to server'),
                  );
                }
                
                final memoryUsedGB = (systemInfo.memory.used / 1073741824).toStringAsFixed(1);
                final memoryTotalGB = (systemInfo.memory.total / 1073741824).toStringAsFixed(1);
                
                return Column(
                  children: [
                    _InfoRow(label: 'Hostname', value: systemInfo.hostname),
                    const SizedBox(height: 8),
                    _InfoRow(label: 'Version', value: systemInfo.version),
                    const SizedBox(height: 8),
                    _InfoRow(label: 'Uptime', value: systemInfo.uptime),
                    const SizedBox(height: 8),
                    _InfoRow(label: 'CPU Usage', value: '${systemInfo.cpuUsage.toStringAsFixed(1)}%'),
                    const SizedBox(height: 8),
                    _InfoRow(label: 'Memory', value: '$memoryUsedGB GB / $memoryTotalGB GB'),
                    const SizedBox(height: 8),
                    _InfoRow(label: 'Temperature', value: '${systemInfo.cpuTemperature.toStringAsFixed(1)}°C'),
                  ],
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Text('Error: ${error.toString()}'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
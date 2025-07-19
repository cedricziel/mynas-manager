import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SystemInfoCard extends ConsumerWidget {
  const SystemInfoCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              ],
            ),
            const SizedBox(height: 16),
            _InfoRow(label: 'Hostname', value: 'truenas.local'),
            const SizedBox(height: 8),
            _InfoRow(label: 'Version', value: 'TrueNAS-SCALE-24.04'),
            const SizedBox(height: 8),
            _InfoRow(label: 'Uptime', value: '5 days, 12:34:56'),
            const SizedBox(height: 8),
            _InfoRow(label: 'CPU Usage', value: '15%'),
            const SizedBox(height: 8),
            _InfoRow(label: 'Memory', value: '8 GB / 16 GB'),
            const SizedBox(height: 8),
            _InfoRow(label: 'Temperature', value: '45°C'),
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
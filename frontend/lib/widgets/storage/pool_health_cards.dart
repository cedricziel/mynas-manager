import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/pool_provider.dart';
import '../../utils/storage_utils.dart';

class PoolHealthCards extends ConsumerWidget {
  const PoolHealthCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final poolState = ref.watch(poolProvider);
    final totalCapacity = ref.watch(totalCapacityProvider);
    final totalAllocated = ref.watch(totalAllocatedProvider);
    final overallUsage = ref.watch(overallUsagePercentageProvider);
    final hasUnhealthyPools = ref.watch(hasUnhealthyPoolsProvider);

    if (poolState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (poolState.error != null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 8),
              Text(
                'Failed to load storage data',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                poolState.error!,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => ref.read(poolProvider.notifier).refresh(),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        // Pool Count Card
        Expanded(
          child: _HealthCard(
            title: 'Storage Pools',
            value: poolState.totalPools.toString(),
            subtitle: '${poolState.healthyPools} healthy',
            icon: Icons.storage,
            color: hasUnhealthyPools
                ? Theme.of(context).colorScheme.error
                : Theme.of(context).colorScheme.primary,
            onTap: () {
              // TODO: Navigate to pools list
            },
          ),
        ),
        const SizedBox(width: 16),

        // Capacity Card
        Expanded(
          child: _CapacityCard(
            totalCapacity: totalCapacity,
            allocatedCapacity: totalAllocated,
            usagePercentage: overallUsage,
          ),
        ),
        const SizedBox(width: 16),

        // Health Status Card
        Expanded(child: _HealthStatusCard(poolState: poolState)),
      ],
    );
  }
}

class _HealthCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _HealthCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CapacityCard extends StatelessWidget {
  final int totalCapacity;
  final int allocatedCapacity;
  final double usagePercentage;

  const _CapacityCard({
    required this.totalCapacity,
    required this.allocatedCapacity,
    required this.usagePercentage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final freeCapacity = totalCapacity - allocatedCapacity;

    // Determine color based on usage
    Color usageColor;
    if (usagePercentage >= 90) {
      usageColor = theme.colorScheme.error;
    } else if (usagePercentage >= 75) {
      usageColor = Colors.orange;
    } else {
      usageColor = theme.colorScheme.primary;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.pie_chart, color: usageColor, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Storage Capacity',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Circular progress indicator
            Center(
              child: SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  children: [
                    CircularProgressIndicator(
                      value: usagePercentage / 100,
                      strokeWidth: 8,
                      backgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(usageColor),
                    ),
                    Center(
                      child: Text(
                        '${usagePercentage.toStringAsFixed(1)}%',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: usageColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Capacity details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Used',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      StorageUtils.formatBytes(allocatedCapacity),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Free',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      StorageUtils.formatBytes(freeCapacity),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              'Total: ${StorageUtils.formatBytes(totalCapacity)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HealthStatusCard extends StatelessWidget {
  final PoolState poolState;

  const _HealthStatusCard({required this.poolState});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unhealthyPools = poolState.unhealthyPools;
    final isHealthy = unhealthyPools.isEmpty;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isHealthy ? Icons.check_circle : Icons.warning,
                  color: isHealthy ? Colors.green : theme.colorScheme.error,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Pool Health',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (isHealthy) ...[
              Text(
                'All Good',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'All pools are healthy',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ] else ...[
              Text(
                '${unhealthyPools.length}',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                unhealthyPools.length == 1
                    ? 'Pool needs attention'
                    : 'Pools need attention',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),

              // List unhealthy pools
              ...unhealthyPools
                  .take(3)
                  .map(
                    (pool) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 16,
                            color: theme.colorScheme.error,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              pool.name,
                              style: theme.textTheme.bodySmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

              if (unhealthyPools.length > 3)
                Text(
                  '... and ${unhealthyPools.length - 3} more',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],

            const SizedBox(height: 16),

            // Last updated
            if (poolState.lastUpdated != null)
              Text(
                'Updated ${StorageUtils.formatRelativeTime(poolState.lastUpdated!)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

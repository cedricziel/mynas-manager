import 'package:flutter/material.dart';

class SmartDataDialog extends StatelessWidget {
  final String diskName;
  final Map<String, dynamic> smartData;

  const SmartDataDialog({
    super.key,
    required this.diskName,
    required this.smartData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: Container(
        width: 800,
        height: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.health_and_safety, color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Text(
                  'SMART Data - $diskName',
                  style: theme.textTheme.headlineSmall,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(height: 32),

            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSmartOverview(theme),
                    const SizedBox(height: 24),
                    _buildSmartAttributes(theme),
                    const SizedBox(height: 24),
                    _buildTestHistory(theme),
                  ],
                ),
              ),
            ),

            // Actions
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartOverview(ThemeData theme) {
    final overallStatus = smartData['overall_status'] ?? 'Unknown';
    final isHealthy =
        overallStatus.toLowerCase() == 'passed' ||
        overallStatus.toLowerCase() == 'pass';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overall Status',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  isHealthy ? Icons.check_circle : Icons.warning,
                  color: isHealthy ? Colors.green : Colors.orange,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Text(
                  overallStatus,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: isHealthy ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            if (smartData['power_on_hours'] != null) ...[
              const SizedBox(height: 16),
              Text(
                'Power On Hours: ${smartData['power_on_hours']}',
                style: theme.textTheme.bodyMedium,
              ),
            ],
            if (smartData['temperature'] != null) ...[
              const SizedBox(height: 8),
              Text(
                'Current Temperature: ${smartData['temperature']}°C',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSmartAttributes(ThemeData theme) {
    final attributes = smartData['attributes'] as List<dynamic>? ?? [];

    if (attributes.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'No SMART attributes available',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return Card(
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Attribute')),
                  DataColumn(label: Text('Value')),
                  DataColumn(label: Text('Worst')),
                  DataColumn(label: Text('Threshold')),
                  DataColumn(label: Text('Raw Value')),
                  DataColumn(label: Text('Status')),
                ],
                rows: attributes.map((attr) {
                  final id = attr['id']?.toString() ?? '';
                  final name = attr['name'] ?? 'Unknown';
                  final value = attr['value']?.toString() ?? '-';
                  final worst = attr['worst']?.toString() ?? '-';
                  final threshold = attr['threshold']?.toString() ?? '-';
                  final rawValue = attr['raw_value']?.toString() ?? '-';
                  final failed = attr['failed'] ?? false;

                  return DataRow(
                    cells: [
                      DataCell(Text(id)),
                      DataCell(Text(name)),
                      DataCell(Text(value)),
                      DataCell(Text(worst)),
                      DataCell(Text(threshold)),
                      DataCell(Text(rawValue)),
                      DataCell(
                        Icon(
                          failed ? Icons.warning : Icons.check,
                          color: failed ? Colors.red : Colors.green,
                          size: 16,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestHistory(ThemeData theme) {
    final testHistory = smartData['test_history'] as List<dynamic>? ?? [];

    if (testHistory.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Test History',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'No test history available',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Test History',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...testHistory.take(5).map((test) {
              final testType = test['type'] ?? 'Unknown';
              final status = test['status'] ?? 'Unknown';
              final timestamp = test['timestamp'] ?? '';
              final duration = test['duration'] ?? '';

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      _getTestStatusIcon(status),
                      color: _getTestStatusColor(status),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$testType - $status',
                            style: theme.textTheme.bodyMedium,
                          ),
                          Text(
                            '$timestamp (Duration: $duration)',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  IconData _getTestStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'passed':
        return Icons.check_circle;
      case 'failed':
        return Icons.error;
      case 'aborted':
      case 'cancelled':
        return Icons.cancel;
      case 'running':
      case 'in_progress':
        return Icons.play_circle;
      default:
        return Icons.help_outline;
    }
  }

  Color _getTestStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'passed':
        return Colors.green;
      case 'failed':
        return Colors.red;
      case 'aborted':
      case 'cancelled':
        return Colors.orange;
      case 'running':
      case 'in_progress':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

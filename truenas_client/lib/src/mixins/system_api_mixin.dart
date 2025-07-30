import '../models.dart';
import '../interfaces/connection_api.dart';
import '../interfaces/system_api.dart';

/// System API mixin
mixin SystemApiMixin on IConnectionApi implements ISystemApi {
  @override
  Future<SystemInfo> getSystemInfo() async {
    final data = await call<Map<String, dynamic>>('system.info');

    // Map TrueNAS response to our model
    return SystemInfo(
      hostname: (data['hostname'] as String?) ?? 'unknown',
      version: (data['version'] as String?) ?? 'unknown',
      uptime: (data['uptime'] as String?) ?? '',
      cpuUsage: 0.0, // TODO: Get from appropriate endpoint
      cpuTemperature: 0.0, // TODO: Get from appropriate endpoint
      memory: MemoryInfo(
        total: (data['physmem'] as int?) ?? 0,
        used:
            ((data['physmem'] as int?) ?? 0) -
            ((data['physmem_free'] as int?) ?? 0),
        free: (data['physmem_free'] as int?) ?? 0,
        cached: 0, // TODO: Get from appropriate endpoint
      ),
    );
  }

  @override
  Future<List<Alert>> getAlerts() async {
    final data = await call<List<dynamic>>('alert.list');

    return data.map((alert) {
      final alertMap = alert as Map<String, dynamic>;

      // Map alert level
      AlertLevel level = AlertLevel.info;
      final levelStr = alertMap['level']?.toString().toLowerCase();
      if (levelStr == 'warning') level = AlertLevel.warning;
      if (levelStr == 'error') level = AlertLevel.error;
      if (levelStr == 'critical') level = AlertLevel.critical;

      return Alert(
        id: alertMap['id']?.toString() ?? '',
        level: level,
        message:
            (alertMap['formatted'] as String?) ??
            (alertMap['text'] as String?) ??
            '',
        timestamp:
            DateTime.tryParse((alertMap['datetime'] as String?) ?? '') ??
            DateTime.now(),
        dismissed: (alertMap['dismissed'] as bool?) ?? false,
      );
    }).toList();
  }
}

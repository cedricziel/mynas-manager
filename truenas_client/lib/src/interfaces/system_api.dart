import '../models.dart';

/// System API interface
abstract class ISystemApi {
  /// Get system information
  Future<SystemInfo> getSystemInfo();

  /// Get system alerts
  Future<List<Alert>> getAlerts();
}

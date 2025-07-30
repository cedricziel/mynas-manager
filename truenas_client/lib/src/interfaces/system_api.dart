import 'package:mynas_shared/mynas_shared.dart';

/// System API interface
abstract class ISystemApi {
  /// Get system information
  Future<SystemInfo> getSystemInfo();

  /// Get system alerts
  Future<List<Alert>> getAlerts();
}

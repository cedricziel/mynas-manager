import '../models.dart';

/// Disk API interface
abstract class IDiskApi {
  /// List all disks
  Future<List<Disk>> listDisks();

  /// Get a specific disk by identifier
  Future<Disk> getDisk(String identifier);
}

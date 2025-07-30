import '../models.dart';

/// Pool API interface
abstract class IPoolApi {
  /// List all pools
  Future<List<Pool>> listPools();

  /// Get a specific pool by ID
  Future<Pool> getPool(String id);
}

import '../models.dart';
import '../truenas_exceptions.dart';
import '../interfaces/connection_api.dart';
import '../interfaces/pool_api.dart';

/// Pool API mixin
mixin PoolApiMixin on IConnectionApi implements IPoolApi {
  @override
  Future<List<Pool>> listPools() async {
    final data = await call<List<dynamic>>('pool.query', []);

    return data.map((pool) {
      final poolMap = pool as Map<String, dynamic>;

      return Pool(
        id: poolMap['id']?.toString() ?? '',
        name: (poolMap['name'] as String?) ?? '',
        status: (poolMap['status'] as String?) ?? 'UNKNOWN',
        size: _parseIntOrString(poolMap['size']),
        allocated: _parseIntOrString(poolMap['allocated']),
        free: _parseIntOrString(poolMap['free']),
        fragmentation: _parseDoubleOrString(poolMap['fragmentation']),
        path: poolMap['path'] as String?,
        isHealthy: (poolMap['healthy'] as bool?) ?? false,
        vdevs: [], // TODO: Parse topology if needed
      );
    }).toList();
  }

  @override
  Future<Pool> getPool(String id) async {
    final pools = await call<List<dynamic>>('pool.query', [
      [
        ['id', '=', int.tryParse(id) ?? id],
      ],
    ]);

    if (pools.isEmpty) {
      throw TrueNasNotFoundException('Pool not found: $id');
    }

    final poolMap = pools.first as Map<String, dynamic>;

    return Pool(
      id: poolMap['id']?.toString() ?? '',
      name: (poolMap['name'] as String?) ?? '',
      status: (poolMap['status'] as String?) ?? 'UNKNOWN',
      size: _parseIntOrString(poolMap['size']),
      allocated: _parseIntOrString(poolMap['allocated']),
      free: _parseIntOrString(poolMap['free']),
      fragmentation: _parseDoubleOrString(poolMap['fragmentation']),
      path: poolMap['path'] as String?,
      isHealthy: (poolMap['healthy'] as bool?) ?? false,
      vdevs: [],
    );
  }

  // Helper method to parse int from either int or string
  int _parseIntOrString(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  // Helper method to parse double from either num or string
  double _parseDoubleOrString(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}

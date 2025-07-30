import '../models.dart';
import '../truenas_exceptions.dart';
import '../interfaces/connection_api.dart';
import '../interfaces/pool_api.dart';

/// Pool API mixin
mixin PoolApiMixin on IConnectionApi implements IPoolApi {
  @override
  Future<List<Pool>> listPools() async {
    final data = await call<List<dynamic>>('pool.query');

    return data.map((pool) {
      final poolMap = pool as Map<String, dynamic>;

      return Pool(
        id: poolMap['id']?.toString() ?? '',
        name: (poolMap['name'] as String?) ?? '',
        status: (poolMap['status'] as String?) ?? 'UNKNOWN',
        size: (poolMap['size'] as int?) ?? 0,
        allocated: (poolMap['allocated'] as int?) ?? 0,
        free: (poolMap['free'] as int?) ?? 0,
        fragmentation: (poolMap['fragmentation'] as num?)?.toDouble() ?? 0.0,
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
      size: (poolMap['size'] as int?) ?? 0,
      allocated: (poolMap['allocated'] as int?) ?? 0,
      free: (poolMap['free'] as int?) ?? 0,
      fragmentation: (poolMap['fragmentation'] as num?)?.toDouble() ?? 0.0,
      path: poolMap['path'] as String?,
      isHealthy: (poolMap['healthy'] as bool?) ?? false,
      vdevs: [],
    );
  }
}

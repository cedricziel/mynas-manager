import '../models.dart';
import '../truenas_exceptions.dart';
import '../interfaces/connection_api.dart';
import '../interfaces/dataset_api.dart';

/// Dataset API mixin
mixin DatasetApiMixin on IConnectionApi implements IDatasetApi {
  @override
  Future<List<Dataset>> listDatasets({String? poolId}) async {
    final data = await call<List<dynamic>>('pool.dataset.query');

    return data
        .where((dataset) {
          if (poolId == null) return true;
          final name = dataset['name'] as String?;
          return name?.startsWith('$poolId/') ?? false;
        })
        .map((dataset) {
          final datasetMap = dataset as Map<String, dynamic>;

          return Dataset(
            id: (datasetMap['id'] as String?) ?? '',
            name: (datasetMap['name'] as String?) ?? '',
            pool: (datasetMap['pool'] as String?) ?? '',
            type: (datasetMap['type'] as String?) ?? 'FILESYSTEM',
            mountpoint: (datasetMap['mountpoint'] as String?) ?? '',
            used: (datasetMap['used']?['parsed'] as int?) ?? 0,
            available: (datasetMap['available']?['parsed'] as int?) ?? 0,
            referenced: (datasetMap['referenced']?['parsed'] as int?) ?? 0,
            encrypted: (datasetMap['encrypted'] as bool?) ?? false,
          );
        })
        .toList();
  }

  @override
  Future<Dataset> getDataset(String id) async {
    final datasets = await call<List<dynamic>>('pool.dataset.query', [
      [
        ['id', '=', id],
      ],
    ]);

    if (datasets.isEmpty) {
      throw TrueNasNotFoundException('Dataset not found: $id');
    }

    final datasetMap = datasets.first as Map<String, dynamic>;

    return Dataset(
      id: (datasetMap['id'] as String?) ?? '',
      name: (datasetMap['name'] as String?) ?? '',
      pool: (datasetMap['pool'] as String?) ?? '',
      type: (datasetMap['type'] as String?) ?? 'FILESYSTEM',
      mountpoint: (datasetMap['mountpoint'] as String?) ?? '',
      used: (datasetMap['used']?['parsed'] as int?) ?? 0,
      available: (datasetMap['available']?['parsed'] as int?) ?? 0,
      referenced: (datasetMap['referenced']?['parsed'] as int?) ?? 0,
      encrypted: (datasetMap['encrypted'] as bool?) ?? false,
    );
  }

  @override
  Future<Dataset> createDataset({
    required String pool,
    required String name,
    Map<String, dynamic>? properties,
  }) async {
    final data = await call<Map<String, dynamic>>('pool.dataset.create', {
      'name': '$pool/$name',
      ...?properties,
    });

    return Dataset(
      id: (data['id'] as String?) ?? '',
      name: (data['name'] as String?) ?? '',
      pool: pool,
      type: (data['type'] as String?) ?? 'FILESYSTEM',
      mountpoint: (data['mountpoint'] as String?) ?? '',
      used: 0,
      available: (data['available']?['parsed'] as int?) ?? 0,
      referenced: 0,
      encrypted: (data['encrypted'] as bool?) ?? false,
    );
  }

  @override
  Future<Dataset> updateDataset(
    String id,
    Map<String, dynamic> properties,
  ) async {
    await call<dynamic>('pool.dataset.update', [id, properties]);
    return getDataset(id);
  }

  @override
  Future<bool> deleteDataset(String id, {bool recursive = false}) async {
    await call<dynamic>('pool.dataset.delete', [
      id,
      {'recursive': recursive},
    ]);
    return true;
  }
}

import '../models.dart';

/// Dataset API interface
abstract class IDatasetApi {
  /// List datasets, optionally filtered by pool
  Future<List<Dataset>> listDatasets({String? poolId});

  /// Get a specific dataset by ID
  Future<Dataset> getDataset(String id);

  /// Create a new dataset
  Future<Dataset> createDataset({
    required String pool,
    required String name,
    Map<String, dynamic>? properties,
  });

  /// Update dataset properties
  Future<Dataset> updateDataset(String id, Map<String, dynamic> properties);

  /// Delete a dataset
  Future<bool> deleteDataset(String id, {bool recursive = false});
}

import 'package:mynas_shared/mynas_shared.dart';

/// Share API interface
abstract class IShareApi {
  /// List shares, optionally filtered by type
  Future<List<Share>> listShares({ShareType? type});

  /// Get a specific share by ID
  Future<Share> getShare(String id);

  /// Create a new share
  Future<Share> createShare(Share share);

  /// Update an existing share
  Future<Share> updateShare(Share share);

  /// Delete a share
  Future<bool> deleteShare(String id);
}

import 'truenas_client_base.dart';
import 'truenas_client_interface.dart';
import 'mixins/system_api_mixin.dart';
import 'mixins/pool_api_mixin.dart';
import 'mixins/dataset_api_mixin.dart';
import 'mixins/share_api_mixin.dart';
import 'mixins/disk_api_mixin.dart';

/// TrueNAS API client implementation
class TrueNasClient extends TrueNasClientBase
    with
        SystemApiMixin,
        PoolApiMixin,
        DatasetApiMixin,
        ShareApiMixin,
        DiskApiMixin
    implements ITrueNasClient {
  TrueNasClient._({
    required super.uri,
    super.apiKey,
    super.username,
    super.password,
  });

  /// Create client with API key authentication
  factory TrueNasClient.withApiKey({
    required String uri,
    required String apiKey,
  }) {
    return TrueNasClient._(uri: uri, apiKey: apiKey);
  }

  /// Create client with username/password authentication
  factory TrueNasClient.withCredentials({
    required String uri,
    required String username,
    required String password,
  }) {
    return TrueNasClient._(uri: uri, username: username, password: password);
  }
}

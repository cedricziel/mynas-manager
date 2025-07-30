import 'interfaces/connection_api.dart';
import 'interfaces/system_api.dart';
import 'interfaces/pool_api.dart';
import 'interfaces/dataset_api.dart';
import 'interfaces/share_api.dart';
import 'interfaces/disk_api.dart';

/// Complete TrueNAS client interface
abstract class ITrueNasClient
    implements
        IConnectionApi,
        ISystemApi,
        IPoolApi,
        IDatasetApi,
        IShareApi,
        IDiskApi {
  // This interface combines all the individual API interfaces
  // Each interface can be mocked independently for testing
}

import 'dart:async';
import 'package:mynas_shared/mynas_shared.dart';
import 'auth_manager.dart';
import 'version_manager.dart';
import 'event_manager.dart';

/// Main TrueNAS API client interface
abstract class ITrueNasApiClient {
  /// Authentication manager
  IAuthManager get auth;

  /// Version manager
  IVersionManager get version;

  /// Event manager
  IEventManager get events;

  /// Whether the client is connected and authenticated
  bool get isReady;

  /// Connect to TrueNAS server
  Future<void> connect(String uri);

  /// Disconnect from TrueNAS server
  Future<void> disconnect();

  /// Dispose resources
  Future<void> dispose();

  // System Information
  /// Get system information
  Future<SystemInfo> getSystemInfo();

  /// Get system alerts
  Future<List<Alert>> getAlerts();

  /// Get system uptime
  Future<String> getUptime();

  // Pool Management
  /// List all storage pools
  Future<List<Pool>> listPools();

  /// Get a specific pool by ID
  Future<Pool> getPool(String id);

  /// Import a pool
  Future<Pool> importPool(String poolName, {Map<String, dynamic>? options});

  /// Export a pool
  Future<bool> exportPool(String poolId, {bool destroy = false});

  // Pool Health & Monitoring
  /// Get detailed pool status and health information
  Future<Map<String, dynamic>> getPoolStatus(String poolId);

  /// Get pool usage statistics
  Future<Map<String, dynamic>> getPoolUsage(String poolId);

  // Pool Scrub Management
  /// List all scrub tasks for pools
  Future<List<PoolScrubTask>> listScrubTasks({String? poolId});

  /// Get specific scrub task details
  Future<PoolScrubTask> getScrubTask(String taskId);

  /// Create a new scrub task
  Future<PoolScrubTask> createScrubTask({
    required String poolId,
    required String schedule,
    String? description,
    bool enabled = true,
  });

  /// Update an existing scrub task
  Future<PoolScrubTask> updateScrubTask(
    String taskId,
    Map<String, dynamic> updates,
  );

  /// Delete a scrub task
  Future<bool> deleteScrubTask(String taskId);

  /// Run a scrub task manually
  Future<PoolScrub> runScrub(String poolId);

  /// Get current/recent scrub status for a pool
  Future<List<PoolScrub>> getScrubHistory(String poolId, {int? limit});

  // Pool Resilver Management
  /// Get resilver status for a pool
  Future<PoolResilver?> getResilverStatus(String poolId);

  /// Update resilver configuration
  Future<bool> updateResilverConfig(String poolId, Map<String, dynamic> config);

  // Dataset Management
  /// List datasets, optionally filtered by pool
  Future<List<Dataset>> listDatasets({String? poolId});

  /// Get a specific dataset by ID
  Future<Dataset> getDataset(String id);

  /// Get detailed dataset information including space usage
  Future<Map<String, dynamic>> getDatasetDetails(String id);

  /// Create a new dataset
  Future<Dataset> createDataset({
    required String pool,
    required String name,
    String? type,
    Map<String, dynamic>? properties,
  });

  /// Update dataset properties
  Future<Dataset> updateDataset(String id, Map<String, dynamic> properties);

  /// Delete a dataset
  Future<bool> deleteDataset(String id, {bool recursive = false});

  // Dataset Snapshot Management
  /// Get snapshot count for a dataset
  Future<SnapshotCount> getDatasetSnapshotCount(String datasetId);

  /// List snapshots for a dataset
  Future<List<Snapshot>> listDatasetSnapshots(String datasetId);

  // Snapshot Task Management
  /// List all snapshot tasks
  Future<List<SnapshotTask>> listSnapshotTasks({String? datasetId});

  /// Get specific snapshot task details
  Future<SnapshotTask> getSnapshotTask(String taskId);

  /// Create a new snapshot task
  Future<SnapshotTask> createSnapshotTask({
    required String dataset,
    required String schedule,
    required String namingSchema,
    required int lifetimeValue,
    required String lifetimeUnit,
    bool enabled = true,
    bool recursive = false,
    bool excludeEmpty = false,
  });

  /// Update an existing snapshot task
  Future<SnapshotTask> updateSnapshotTask(
    String taskId,
    Map<String, dynamic> updates,
  );

  /// Delete a snapshot task
  Future<bool> deleteSnapshotTask(String taskId);

  /// Run a snapshot task manually
  Future<Snapshot> runSnapshotTask(String taskId);

  /// Create a manual snapshot
  Future<Snapshot> createSnapshot({
    required String dataset,
    required String name,
    bool recursive = false,
  });

  /// Delete specific snapshots
  Future<bool> deleteSnapshots(String dataset, List<String> snapshotNames);

  // Share Management
  /// List shares, optionally filtered by type
  Future<List<Share>> listShares({ShareType? type});

  /// Get a specific share by ID
  Future<Share> getShare(String id);

  /// Create a new share
  Future<Share> createShare(Share shareData);

  /// Update an existing share
  Future<Share> updateShare(Share shareData);

  /// Delete a share
  Future<bool> deleteShare(String id);

  // User Management
  /// List users
  Future<List<Map<String, dynamic>>> listUsers();

  /// Get a specific user
  Future<Map<String, dynamic>> getUser(String username);

  /// Create a new user
  Future<Map<String, dynamic>> createUser(Map<String, dynamic> userData);

  /// Update an existing user
  Future<Map<String, dynamic>> updateUser(
    String username,
    Map<String, dynamic> userData,
  );

  /// Delete a user
  Future<bool> deleteUser(String username);

  // Group Management
  /// List groups
  Future<List<Map<String, dynamic>>> listGroups();

  /// Get a specific group
  Future<Map<String, dynamic>> getGroup(String groupname);

  /// Create a new group
  Future<Map<String, dynamic>> createGroup(Map<String, dynamic> groupData);

  /// Update an existing group
  Future<Map<String, dynamic>> updateGroup(
    String groupname,
    Map<String, dynamic> groupData,
  );

  /// Delete a group
  Future<bool> deleteGroup(String groupname);

  // Network Management
  /// Get network configuration
  Future<Map<String, dynamic>> getNetworkConfig();

  /// Update network configuration
  Future<Map<String, dynamic>> updateNetworkConfig(Map<String, dynamic> config);

  /// List network interfaces
  Future<List<Map<String, dynamic>>> listNetworkInterfaces();

  // Service Management
  /// List all services
  Future<List<Map<String, dynamic>>> listServices();

  /// Get service status
  Future<Map<String, dynamic>> getService(String serviceName);

  /// Start a service
  Future<bool> startService(String serviceName);

  /// Stop a service
  Future<bool> stopService(String serviceName);

  /// Restart a service
  Future<bool> restartService(String serviceName);

  /// Update service configuration
  Future<Map<String, dynamic>> updateService(
    String serviceName,
    Map<String, dynamic> config,
  );

  // VM Management (if supported)
  /// List virtual machines
  Future<List<Map<String, dynamic>>> listVMs();

  /// Get VM details
  Future<Map<String, dynamic>> getVM(String vmId);

  /// Start a VM
  Future<bool> startVM(String vmId);

  /// Stop a VM
  Future<bool> stopVM(String vmId);

  // Apps/Containers Management (if supported)
  /// List applications/containers
  Future<List<Map<String, dynamic>>> listApps();

  /// Get app details
  Future<Map<String, dynamic>> getApp(String appId);

  /// Install an app
  Future<Map<String, dynamic>> installApp(
    String appName,
    Map<String, dynamic> config,
  );

  /// Update an app
  Future<Map<String, dynamic>> updateApp(
    String appId,
    Map<String, dynamic> config,
  );

  /// Delete an app
  Future<bool> deleteApp(String appId);

  // System Control
  /// Reboot the system
  Future<bool> reboot({int delay = 0});

  /// Shutdown the system
  Future<bool> shutdown({int delay = 0});

  /// Get system logs
  Future<List<Map<String, dynamic>>> getSystemLogs({
    int? limit,
    String? level,
    DateTime? since,
  });
}

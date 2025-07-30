// Re-export models from truenas_client for backwards compatibility
export 'package:truenas_client/truenas_client.dart'
    show
        Pool,
        PoolVdev,
        Dataset,
        Share,
        ShareType,
        SystemInfo,
        MemoryInfo,
        Alert,
        AlertLevel,
        PoolScrub,
        PoolScrubTask,
        ScrubStatus,
        Snapshot,
        SnapshotTask,
        SnapshotCount,
        PoolResilver,
        ResilverStatus,
        Disk,
        DiskHealth,
        DiskType,
        DiskTemperature,
        PoolTopology,
        VdevGroup;

// Base
export 'src/mynas_shared_base.dart';

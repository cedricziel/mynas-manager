import 'package:mynas_shared/mynas_shared.dart';
import '../truenas_exceptions.dart';
import '../interfaces/connection_api.dart';
import '../interfaces/disk_api.dart';

/// Disk API mixin
mixin DiskApiMixin on IConnectionApi implements IDiskApi {
  @override
  Future<List<Disk>> listDisks() async {
    final data = await call<List<dynamic>>('disk.query');

    return data.map((disk) {
      final diskMap = disk as Map<String, dynamic>;

      // Map disk type
      DiskType type = DiskType.unknown;
      final typeStr = diskMap['type']?.toString().toUpperCase();
      if (typeStr == 'SSD') type = DiskType.ssd;
      if (typeStr == 'HDD') type = DiskType.hdd;

      return Disk(
        identifier: (diskMap['identifier'] as String?) ?? '',
        name: (diskMap['name'] as String?) ?? '',
        serial: diskMap['serial'] as String?,
        lunid: diskMap['lunid'] as String?,
        size: (diskMap['size'] as int?) ?? 0,
        description: diskMap['description'] as String?,
        model: (diskMap['model'] as String?) ?? '',
        type: type,
        bus: (diskMap['bus'] as String?) ?? '',
        devname: (diskMap['devname'] as String?) ?? '',
        rotationrate: diskMap['rotationrate'] as int?,
        zfsGuid: diskMap['zfs_guid'] as String?,
        pool: diskMap['pool'] as String?,
        number: (diskMap['number'] as int?) ?? 0,
        subsystem: (diskMap['subsystem'] as String?) ?? '',
        transfermode: (diskMap['transfermode'] as String?) ?? '',
        hddstandby: (diskMap['hddstandby'] as String?) ?? 'ALWAYS_ON',
        advpowermgmt: (diskMap['advpowermgmt'] as String?) ?? 'DISABLED',
        togglesmart: (diskMap['togglesmart'] as bool?) ?? true,
        smartoptions: (diskMap['smartoptions'] as String?) ?? '',
        temperature: diskMap['temperature'] as int?,
        supportsSmart: diskMap['supports_smart'] as bool?,
        enclosure: diskMap['enclosure'] as String?,
      );
    }).toList();
  }

  @override
  Future<Disk> getDisk(String identifier) async {
    final disks = await call<List<dynamic>>('disk.query', [
      [
        ['identifier', '=', identifier],
      ],
    ]);

    if (disks.isEmpty) {
      throw TrueNasNotFoundException('Disk not found: $identifier');
    }

    final diskMap = disks.first as Map<String, dynamic>;

    // Map disk type
    DiskType type = DiskType.unknown;
    final typeStr = diskMap['type']?.toString().toUpperCase();
    if (typeStr == 'SSD') type = DiskType.ssd;
    if (typeStr == 'HDD') type = DiskType.hdd;

    return Disk(
      identifier: (diskMap['identifier'] as String?) ?? '',
      name: (diskMap['name'] as String?) ?? '',
      serial: diskMap['serial'] as String?,
      lunid: diskMap['lunid'] as String?,
      size: (diskMap['size'] as int?) ?? 0,
      description: diskMap['description'] as String?,
      model: (diskMap['model'] as String?) ?? '',
      type: type,
      bus: (diskMap['bus'] as String?) ?? '',
      devname: (diskMap['devname'] as String?) ?? '',
      rotationrate: diskMap['rotationrate'] as int?,
      zfsGuid: diskMap['zfs_guid'] as String?,
      pool: diskMap['pool'] as String?,
      number: (diskMap['number'] as int?) ?? 0,
      subsystem: (diskMap['subsystem'] as String?) ?? '',
      transfermode: (diskMap['transfermode'] as String?) ?? '',
      hddstandby: (diskMap['hddstandby'] as String?) ?? 'ALWAYS_ON',
      advpowermgmt: (diskMap['advpowermgmt'] as String?) ?? 'DISABLED',
      togglesmart: (diskMap['togglesmart'] as bool?) ?? true,
      smartoptions: (diskMap['smartoptions'] as String?) ?? '',
      temperature: diskMap['temperature'] as int?,
      supportsSmart: diskMap['supports_smart'] as bool?,
      enclosure: diskMap['enclosure'] as String?,
    );
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'disk.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Disk _$DiskFromJson(Map<String, dynamic> json) => _Disk(
  identifier: json['identifier'] as String,
  name: json['name'] as String,
  serial: json['serial'] as String?,
  lunid: json['lunid'] as String?,
  size: (json['size'] as num).toInt(),
  description: json['description'] as String?,
  model: json['model'] as String,
  type: $enumDecode(_$DiskTypeEnumMap, json['type']),
  bus: json['bus'] as String,
  devname: json['devname'] as String,
  rotationrate: (json['rotationrate'] as num?)?.toInt(),
  zfsGuid: json['zfsGuid'] as String?,
  pool: json['pool'] as String?,
  number: (json['number'] as num).toInt(),
  subsystem: json['subsystem'] as String,
  transfermode: json['transfermode'] as String,
  hddstandby: json['hddstandby'] as String,
  advpowermgmt: json['advpowermgmt'] as String,
  togglesmart: json['togglesmart'] as bool,
  smartoptions: json['smartoptions'] as String,
  temperature: (json['temperature'] as num?)?.toInt(),
  supportsSmart: json['supportsSmart'] as bool?,
  enclosure: json['enclosure'] as String?,
  health:
      $enumDecodeNullable(_$DiskHealthEnumMap, json['health']) ??
      DiskHealth.unknown,
);

Map<String, dynamic> _$DiskToJson(_Disk instance) => <String, dynamic>{
  'identifier': instance.identifier,
  'name': instance.name,
  'serial': instance.serial,
  'lunid': instance.lunid,
  'size': instance.size,
  'description': instance.description,
  'model': instance.model,
  'type': _$DiskTypeEnumMap[instance.type]!,
  'bus': instance.bus,
  'devname': instance.devname,
  'rotationrate': instance.rotationrate,
  'zfsGuid': instance.zfsGuid,
  'pool': instance.pool,
  'number': instance.number,
  'subsystem': instance.subsystem,
  'transfermode': instance.transfermode,
  'hddstandby': instance.hddstandby,
  'advpowermgmt': instance.advpowermgmt,
  'togglesmart': instance.togglesmart,
  'smartoptions': instance.smartoptions,
  'temperature': instance.temperature,
  'supportsSmart': instance.supportsSmart,
  'enclosure': instance.enclosure,
  'health': _$DiskHealthEnumMap[instance.health]!,
};

const _$DiskTypeEnumMap = {
  DiskType.ssd: 'SSD',
  DiskType.hdd: 'HDD',
  DiskType.unknown: 'UNKNOWN',
};

const _$DiskHealthEnumMap = {
  DiskHealth.healthy: 'HEALTHY',
  DiskHealth.warning: 'WARNING',
  DiskHealth.critical: 'CRITICAL',
  DiskHealth.unknown: 'UNKNOWN',
};

_DiskTemperature _$DiskTemperatureFromJson(Map<String, dynamic> json) =>
    _DiskTemperature(
      diskName: json['diskName'] as String,
      temperature: (json['temperature'] as num?)?.toInt(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$DiskTemperatureToJson(_DiskTemperature instance) =>
    <String, dynamic>{
      'diskName': instance.diskName,
      'temperature': instance.temperature,
      'timestamp': instance.timestamp.toIso8601String(),
    };

_PoolTopology _$PoolTopologyFromJson(Map<String, dynamic> json) =>
    _PoolTopology(
      poolId: json['poolId'] as String,
      poolName: json['poolName'] as String,
      vdevGroups: (json['vdevGroups'] as List<dynamic>)
          .map((e) => VdevGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
      spares: (json['spares'] as List<dynamic>)
          .map((e) => Disk.fromJson(e as Map<String, dynamic>))
          .toList(),
      cache: (json['cache'] as List<dynamic>)
          .map((e) => Disk.fromJson(e as Map<String, dynamic>))
          .toList(),
      log: (json['log'] as List<dynamic>)
          .map((e) => Disk.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PoolTopologyToJson(_PoolTopology instance) =>
    <String, dynamic>{
      'poolId': instance.poolId,
      'poolName': instance.poolName,
      'vdevGroups': instance.vdevGroups,
      'spares': instance.spares,
      'cache': instance.cache,
      'log': instance.log,
    };

_VdevGroup _$VdevGroupFromJson(Map<String, dynamic> json) => _VdevGroup(
  type: json['type'] as String,
  status: json['status'] as String,
  disks: (json['disks'] as List<dynamic>)
      .map((e) => Disk.fromJson(e as Map<String, dynamic>))
      .toList(),
  name: json['name'] as String?,
  guid: json['guid'] as String?,
);

Map<String, dynamic> _$VdevGroupToJson(_VdevGroup instance) =>
    <String, dynamic>{
      'type': instance.type,
      'status': instance.status,
      'disks': instance.disks,
      'name': instance.name,
      'guid': instance.guid,
    };

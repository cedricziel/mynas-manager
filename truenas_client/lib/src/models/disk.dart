import 'package:freezed_annotation/freezed_annotation.dart';

part 'disk.freezed.dart';
part 'disk.g.dart';

@freezed
sealed class Disk with _$Disk {
  const factory Disk({
    required String identifier,
    required String name,
    required String? serial,
    required String? lunid,
    required int size,
    required String? description,
    required String model,
    required DiskType type,
    required String bus,
    required String devname,
    required int? rotationrate,
    required String? zfsGuid,
    required String? pool,
    required int number,
    required String subsystem,
    required String transfermode,
    required String hddstandby,
    required String advpowermgmt,
    required bool togglesmart,
    required String smartoptions,
    required int? temperature,
    required bool? supportsSmart,
    String? enclosure,
    @Default(DiskHealth.unknown) DiskHealth health,
  }) = _Disk;

  factory Disk.fromJson(Map<String, dynamic> json) => _$DiskFromJson(json);
}

enum DiskType {
  @JsonValue('SSD')
  ssd,
  @JsonValue('HDD')
  hdd,
  @JsonValue('UNKNOWN')
  unknown,
}

enum DiskHealth {
  @JsonValue('HEALTHY')
  healthy,
  @JsonValue('WARNING')
  warning,
  @JsonValue('CRITICAL')
  critical,
  @JsonValue('UNKNOWN')
  unknown,
}

@freezed
sealed class DiskTemperature with _$DiskTemperature {
  const factory DiskTemperature({
    required String diskName,
    required int? temperature,
    required DateTime timestamp,
  }) = _DiskTemperature;

  factory DiskTemperature.fromJson(Map<String, dynamic> json) =>
      _$DiskTemperatureFromJson(json);
}

@freezed
sealed class PoolTopology with _$PoolTopology {
  const factory PoolTopology({
    required String poolId,
    required String poolName,
    required List<VdevGroup> vdevGroups,
    required List<Disk> spares,
    required List<Disk> cache,
    required List<Disk> log,
  }) = _PoolTopology;

  factory PoolTopology.fromJson(Map<String, dynamic> json) =>
      _$PoolTopologyFromJson(json);
}

@freezed
sealed class VdevGroup with _$VdevGroup {
  const factory VdevGroup({
    required String type,
    required String status,
    required List<Disk> disks,
    required String? name,
    required String? guid,
  }) = _VdevGroup;

  factory VdevGroup.fromJson(Map<String, dynamic> json) =>
      _$VdevGroupFromJson(json);
}

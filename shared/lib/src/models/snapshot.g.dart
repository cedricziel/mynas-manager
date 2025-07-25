// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Snapshot _$SnapshotFromJson(Map<String, dynamic> json) => _Snapshot(
  id: json['id'] as String,
  name: json['name'] as String,
  dataset: json['dataset'] as String,
  pool: json['pool'] as String,
  created: DateTime.parse(json['created'] as String),
  used: (json['used'] as num).toInt(),
  referenced: (json['referenced'] as num).toInt(),
  description: json['description'] as String?,
  properties: json['properties'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$SnapshotToJson(_Snapshot instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'dataset': instance.dataset,
  'pool': instance.pool,
  'created': instance.created.toIso8601String(),
  'used': instance.used,
  'referenced': instance.referenced,
  'description': instance.description,
  'properties': instance.properties,
};

_SnapshotTask _$SnapshotTaskFromJson(Map<String, dynamic> json) =>
    _SnapshotTask(
      id: json['id'] as String,
      dataset: json['dataset'] as String,
      namingSchema: json['namingSchema'] as String,
      schedule: json['schedule'] as String,
      enabled: json['enabled'] as bool? ?? true,
      recursive: json['recursive'] as bool? ?? false,
      excludeEmpty: json['excludeEmpty'] as bool? ?? false,
      lifetimeValue: (json['lifetimeValue'] as num).toInt(),
      lifetimeUnit: json['lifetimeUnit'] as String,
      nextRun: json['nextRun'] == null
          ? null
          : DateTime.parse(json['nextRun'] as String),
      lastRun: json['lastRun'] == null
          ? null
          : DateTime.parse(json['lastRun'] as String),
      keepCount: (json['keepCount'] as num?)?.toInt() ?? 0,
      options: json['options'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$SnapshotTaskToJson(_SnapshotTask instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dataset': instance.dataset,
      'namingSchema': instance.namingSchema,
      'schedule': instance.schedule,
      'enabled': instance.enabled,
      'recursive': instance.recursive,
      'excludeEmpty': instance.excludeEmpty,
      'lifetimeValue': instance.lifetimeValue,
      'lifetimeUnit': instance.lifetimeUnit,
      'nextRun': instance.nextRun?.toIso8601String(),
      'lastRun': instance.lastRun?.toIso8601String(),
      'keepCount': instance.keepCount,
      'options': instance.options,
    };

_SnapshotCount _$SnapshotCountFromJson(Map<String, dynamic> json) =>
    _SnapshotCount(
      dataset: json['dataset'] as String,
      totalSnapshots: (json['totalSnapshots'] as num).toInt(),
      manualSnapshots: (json['manualSnapshots'] as num).toInt(),
      taskSnapshots: (json['taskSnapshots'] as num).toInt(),
      totalSize: (json['totalSize'] as num).toInt(),
    );

Map<String, dynamic> _$SnapshotCountToJson(_SnapshotCount instance) =>
    <String, dynamic>{
      'dataset': instance.dataset,
      'totalSnapshots': instance.totalSnapshots,
      'manualSnapshots': instance.manualSnapshots,
      'taskSnapshots': instance.taskSnapshots,
      'totalSize': instance.totalSize,
    };

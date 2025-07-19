// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pool_scrub.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PoolScrubImpl _$$PoolScrubImplFromJson(Map<String, dynamic> json) =>
    _$PoolScrubImpl(
      id: json['id'] as String,
      pool: json['pool'] as String,
      status: $enumDecode(_$ScrubStatusEnumMap, json['status']),
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      duration: (json['duration'] as num?)?.toInt(),
      bytesProcessed: (json['bytesProcessed'] as num?)?.toInt(),
      bytesPerSecond: (json['bytesPerSecond'] as num?)?.toInt(),
      errorsFound: (json['errorsFound'] as num?)?.toInt(),
      description: json['description'] as String,
      enabled: json['enabled'] as bool? ?? false,
      schedule: json['schedule'] as String?,
    );

Map<String, dynamic> _$$PoolScrubImplToJson(_$PoolScrubImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pool': instance.pool,
      'status': _$ScrubStatusEnumMap[instance.status]!,
      'startTime': instance.startTime?.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'duration': instance.duration,
      'bytesProcessed': instance.bytesProcessed,
      'bytesPerSecond': instance.bytesPerSecond,
      'errorsFound': instance.errorsFound,
      'description': instance.description,
      'enabled': instance.enabled,
      'schedule': instance.schedule,
    };

const _$ScrubStatusEnumMap = {
  ScrubStatus.running: 'RUNNING',
  ScrubStatus.finished: 'FINISHED',
  ScrubStatus.canceled: 'CANCELED',
  ScrubStatus.error: 'ERROR',
  ScrubStatus.waiting: 'WAITING',
};

_$PoolScrubTaskImpl _$$PoolScrubTaskImplFromJson(Map<String, dynamic> json) =>
    _$PoolScrubTaskImpl(
      id: json['id'] as String,
      pool: json['pool'] as String,
      description: json['description'] as String,
      schedule: json['schedule'] as String,
      enabled: json['enabled'] as bool? ?? true,
      nextRun: json['nextRun'] == null
          ? null
          : DateTime.parse(json['nextRun'] as String),
      lastRun: json['lastRun'] == null
          ? null
          : DateTime.parse(json['lastRun'] as String),
      options: json['options'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$PoolScrubTaskImplToJson(_$PoolScrubTaskImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pool': instance.pool,
      'description': instance.description,
      'schedule': instance.schedule,
      'enabled': instance.enabled,
      'nextRun': instance.nextRun?.toIso8601String(),
      'lastRun': instance.lastRun?.toIso8601String(),
      'options': instance.options,
    };

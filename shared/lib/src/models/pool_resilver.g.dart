// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pool_resilver.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PoolResilver _$PoolResilverFromJson(Map<String, dynamic> json) =>
    _PoolResilver(
      pool: json['pool'] as String,
      status: $enumDecode(_$ResilverStatusEnumMap, json['status']),
      startTime: json['startTime'] == null
          ? null
          : DateTime.parse(json['startTime'] as String),
      estimatedEndTime: json['estimatedEndTime'] == null
          ? null
          : DateTime.parse(json['estimatedEndTime'] as String),
      bytesProcessed: (json['bytesProcessed'] as num?)?.toInt(),
      totalBytes: (json['totalBytes'] as num?)?.toInt(),
      percentComplete: (json['percentComplete'] as num?)?.toDouble(),
      bytesPerSecond: (json['bytesPerSecond'] as num?)?.toInt(),
      errorsFound: (json['errorsFound'] as num?)?.toInt(),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$PoolResilverToJson(_PoolResilver instance) =>
    <String, dynamic>{
      'pool': instance.pool,
      'status': _$ResilverStatusEnumMap[instance.status]!,
      'startTime': instance.startTime?.toIso8601String(),
      'estimatedEndTime': instance.estimatedEndTime?.toIso8601String(),
      'bytesProcessed': instance.bytesProcessed,
      'totalBytes': instance.totalBytes,
      'percentComplete': instance.percentComplete,
      'bytesPerSecond': instance.bytesPerSecond,
      'errorsFound': instance.errorsFound,
      'description': instance.description,
    };

const _$ResilverStatusEnumMap = {
  ResilverStatus.running: 'RUNNING',
  ResilverStatus.finished: 'FINISHED',
  ResilverStatus.canceled: 'CANCELED',
  ResilverStatus.error: 'ERROR',
  ResilverStatus.idle: 'IDLE',
};

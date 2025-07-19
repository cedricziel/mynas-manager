// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SystemInfoImpl _$$SystemInfoImplFromJson(Map<String, dynamic> json) =>
    _$SystemInfoImpl(
      hostname: json['hostname'] as String,
      version: json['version'] as String,
      uptime: json['uptime'] as String,
      cpuUsage: (json['cpuUsage'] as num).toDouble(),
      memory: MemoryInfo.fromJson(json['memory'] as Map<String, dynamic>),
      cpuTemperature: (json['cpuTemperature'] as num).toDouble(),
      alerts:
          (json['alerts'] as List<dynamic>?)
              ?.map((e) => Alert.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$SystemInfoImplToJson(_$SystemInfoImpl instance) =>
    <String, dynamic>{
      'hostname': instance.hostname,
      'version': instance.version,
      'uptime': instance.uptime,
      'cpuUsage': instance.cpuUsage,
      'memory': instance.memory,
      'cpuTemperature': instance.cpuTemperature,
      'alerts': instance.alerts,
    };

_$MemoryInfoImpl _$$MemoryInfoImplFromJson(Map<String, dynamic> json) =>
    _$MemoryInfoImpl(
      total: (json['total'] as num).toInt(),
      used: (json['used'] as num).toInt(),
      free: (json['free'] as num).toInt(),
      cached: (json['cached'] as num).toInt(),
    );

Map<String, dynamic> _$$MemoryInfoImplToJson(_$MemoryInfoImpl instance) =>
    <String, dynamic>{
      'total': instance.total,
      'used': instance.used,
      'free': instance.free,
      'cached': instance.cached,
    };

_$AlertImpl _$$AlertImplFromJson(Map<String, dynamic> json) => _$AlertImpl(
  id: json['id'] as String,
  level: $enumDecode(_$AlertLevelEnumMap, json['level']),
  message: json['message'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
  dismissed: json['dismissed'] as bool? ?? false,
);

Map<String, dynamic> _$$AlertImplToJson(_$AlertImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'level': _$AlertLevelEnumMap[instance.level]!,
      'message': instance.message,
      'timestamp': instance.timestamp.toIso8601String(),
      'dismissed': instance.dismissed,
    };

const _$AlertLevelEnumMap = {
  AlertLevel.info: 'info',
  AlertLevel.warning: 'warning',
  AlertLevel.error: 'error',
  AlertLevel.critical: 'critical',
};

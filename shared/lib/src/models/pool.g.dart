// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pool.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PoolImpl _$$PoolImplFromJson(Map<String, dynamic> json) => _$PoolImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  status: json['status'] as String,
  size: (json['size'] as num).toInt(),
  allocated: (json['allocated'] as num).toInt(),
  free: (json['free'] as num).toInt(),
  fragmentation: (json['fragmentation'] as num).toDouble(),
  isHealthy: json['isHealthy'] as bool,
  path: json['path'] as String?,
  vdevs:
      (json['vdevs'] as List<dynamic>?)
          ?.map((e) => PoolVdev.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$PoolImplToJson(_$PoolImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'size': instance.size,
      'allocated': instance.allocated,
      'free': instance.free,
      'fragmentation': instance.fragmentation,
      'isHealthy': instance.isHealthy,
      'path': instance.path,
      'vdevs': instance.vdevs,
    };

_$PoolVdevImpl _$$PoolVdevImplFromJson(Map<String, dynamic> json) =>
    _$PoolVdevImpl(
      type: json['type'] as String,
      status: json['status'] as String,
      disks:
          (json['disks'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
    );

Map<String, dynamic> _$$PoolVdevImplToJson(_$PoolVdevImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'status': instance.status,
      'disks': instance.disks,
    };

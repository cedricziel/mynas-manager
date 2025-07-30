// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dataset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Dataset _$DatasetFromJson(Map<String, dynamic> json) => _Dataset(
  id: json['id'] as String,
  name: json['name'] as String,
  pool: json['pool'] as String,
  type: json['type'] as String,
  used: (json['used'] as num).toInt(),
  available: (json['available'] as num).toInt(),
  referenced: (json['referenced'] as num).toInt(),
  mountpoint: json['mountpoint'] as String,
  encrypted: json['encrypted'] as bool? ?? false,
  children:
      (json['children'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  properties: json['properties'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$DatasetToJson(_Dataset instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'pool': instance.pool,
  'type': instance.type,
  'used': instance.used,
  'available': instance.available,
  'referenced': instance.referenced,
  'mountpoint': instance.mountpoint,
  'encrypted': instance.encrypted,
  'children': instance.children,
  'properties': instance.properties,
};

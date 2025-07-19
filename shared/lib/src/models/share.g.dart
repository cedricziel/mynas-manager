// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'share.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShareImpl _$$ShareImplFromJson(Map<String, dynamic> json) => _$ShareImpl(
  id: json['id'] as String,
  name: json['name'] as String,
  path: json['path'] as String,
  type: $enumDecode(_$ShareTypeEnumMap, json['type']),
  enabled: json['enabled'] as bool,
  comment: json['comment'] as String?,
  config: json['config'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$$ShareImplToJson(_$ShareImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'path': instance.path,
      'type': _$ShareTypeEnumMap[instance.type]!,
      'enabled': instance.enabled,
      'comment': instance.comment,
      'config': instance.config,
    };

const _$ShareTypeEnumMap = {
  ShareType.smb: 'smb',
  ShareType.nfs: 'nfs',
  ShareType.iscsi: 'iscsi',
  ShareType.webdav: 'webdav',
};

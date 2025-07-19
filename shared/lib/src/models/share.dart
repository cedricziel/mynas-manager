import 'package:freezed_annotation/freezed_annotation.dart';

part 'share.freezed.dart';
part 'share.g.dart';

@freezed
class Share with _$Share {
  const factory Share({
    required String id,
    required String name,
    required String path,
    required ShareType type,
    required bool enabled,
    String? comment,
    Map<String, dynamic>? config,
  }) = _Share;

  factory Share.fromJson(Map<String, dynamic> json) => _$ShareFromJson(json);
}

enum ShareType {
  @JsonValue('smb')
  smb,
  @JsonValue('nfs')
  nfs,
  @JsonValue('iscsi')
  iscsi,
  @JsonValue('webdav')
  webdav,
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'share.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Share _$ShareFromJson(Map<String, dynamic> json) {
  return _Share.fromJson(json);
}

/// @nodoc
mixin _$Share {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get path => throw _privateConstructorUsedError;
  ShareType get type => throw _privateConstructorUsedError;
  bool get enabled => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  Map<String, dynamic>? get config => throw _privateConstructorUsedError;

  /// Serializes this Share to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Share
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ShareCopyWith<Share> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShareCopyWith<$Res> {
  factory $ShareCopyWith(Share value, $Res Function(Share) then) =
      _$ShareCopyWithImpl<$Res, Share>;
  @useResult
  $Res call({
    String id,
    String name,
    String path,
    ShareType type,
    bool enabled,
    String? comment,
    Map<String, dynamic>? config,
  });
}

/// @nodoc
class _$ShareCopyWithImpl<$Res, $Val extends Share>
    implements $ShareCopyWith<$Res> {
  _$ShareCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Share
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? path = null,
    Object? type = null,
    Object? enabled = null,
    Object? comment = freezed,
    Object? config = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            path: null == path
                ? _value.path
                : path // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as ShareType,
            enabled: null == enabled
                ? _value.enabled
                : enabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            comment: freezed == comment
                ? _value.comment
                : comment // ignore: cast_nullable_to_non_nullable
                      as String?,
            config: freezed == config
                ? _value.config
                : config // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ShareImplCopyWith<$Res> implements $ShareCopyWith<$Res> {
  factory _$$ShareImplCopyWith(
    _$ShareImpl value,
    $Res Function(_$ShareImpl) then,
  ) = __$$ShareImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String path,
    ShareType type,
    bool enabled,
    String? comment,
    Map<String, dynamic>? config,
  });
}

/// @nodoc
class __$$ShareImplCopyWithImpl<$Res>
    extends _$ShareCopyWithImpl<$Res, _$ShareImpl>
    implements _$$ShareImplCopyWith<$Res> {
  __$$ShareImplCopyWithImpl(
    _$ShareImpl _value,
    $Res Function(_$ShareImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Share
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? path = null,
    Object? type = null,
    Object? enabled = null,
    Object? comment = freezed,
    Object? config = freezed,
  }) {
    return _then(
      _$ShareImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        path: null == path
            ? _value.path
            : path // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as ShareType,
        enabled: null == enabled
            ? _value.enabled
            : enabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        comment: freezed == comment
            ? _value.comment
            : comment // ignore: cast_nullable_to_non_nullable
                  as String?,
        config: freezed == config
            ? _value._config
            : config // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ShareImpl implements _Share {
  const _$ShareImpl({
    required this.id,
    required this.name,
    required this.path,
    required this.type,
    required this.enabled,
    this.comment,
    final Map<String, dynamic>? config,
  }) : _config = config;

  factory _$ShareImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShareImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String path;
  @override
  final ShareType type;
  @override
  final bool enabled;
  @override
  final String? comment;
  final Map<String, dynamic>? _config;
  @override
  Map<String, dynamic>? get config {
    final value = _config;
    if (value == null) return null;
    if (_config is EqualUnmodifiableMapView) return _config;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Share(id: $id, name: $name, path: $path, type: $type, enabled: $enabled, comment: $comment, config: $config)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShareImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            const DeepCollectionEquality().equals(other._config, _config));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    path,
    type,
    enabled,
    comment,
    const DeepCollectionEquality().hash(_config),
  );

  /// Create a copy of Share
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ShareImplCopyWith<_$ShareImpl> get copyWith =>
      __$$ShareImplCopyWithImpl<_$ShareImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShareImplToJson(this);
  }
}

abstract class _Share implements Share {
  const factory _Share({
    required final String id,
    required final String name,
    required final String path,
    required final ShareType type,
    required final bool enabled,
    final String? comment,
    final Map<String, dynamic>? config,
  }) = _$ShareImpl;

  factory _Share.fromJson(Map<String, dynamic> json) = _$ShareImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get path;
  @override
  ShareType get type;
  @override
  bool get enabled;
  @override
  String? get comment;
  @override
  Map<String, dynamic>? get config;

  /// Create a copy of Share
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ShareImplCopyWith<_$ShareImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dataset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Dataset _$DatasetFromJson(Map<String, dynamic> json) {
  return _Dataset.fromJson(json);
}

/// @nodoc
mixin _$Dataset {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get pool => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  int get used => throw _privateConstructorUsedError;
  int get available => throw _privateConstructorUsedError;
  int get referenced => throw _privateConstructorUsedError;
  String get mountpoint => throw _privateConstructorUsedError;
  bool get encrypted => throw _privateConstructorUsedError;
  List<String> get children => throw _privateConstructorUsedError;
  Map<String, dynamic>? get properties => throw _privateConstructorUsedError;

  /// Serializes this Dataset to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Dataset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DatasetCopyWith<Dataset> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DatasetCopyWith<$Res> {
  factory $DatasetCopyWith(Dataset value, $Res Function(Dataset) then) =
      _$DatasetCopyWithImpl<$Res, Dataset>;
  @useResult
  $Res call({
    String id,
    String name,
    String pool,
    String type,
    int used,
    int available,
    int referenced,
    String mountpoint,
    bool encrypted,
    List<String> children,
    Map<String, dynamic>? properties,
  });
}

/// @nodoc
class _$DatasetCopyWithImpl<$Res, $Val extends Dataset>
    implements $DatasetCopyWith<$Res> {
  _$DatasetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Dataset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? pool = null,
    Object? type = null,
    Object? used = null,
    Object? available = null,
    Object? referenced = null,
    Object? mountpoint = null,
    Object? encrypted = null,
    Object? children = null,
    Object? properties = freezed,
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
            pool: null == pool
                ? _value.pool
                : pool // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            used: null == used
                ? _value.used
                : used // ignore: cast_nullable_to_non_nullable
                      as int,
            available: null == available
                ? _value.available
                : available // ignore: cast_nullable_to_non_nullable
                      as int,
            referenced: null == referenced
                ? _value.referenced
                : referenced // ignore: cast_nullable_to_non_nullable
                      as int,
            mountpoint: null == mountpoint
                ? _value.mountpoint
                : mountpoint // ignore: cast_nullable_to_non_nullable
                      as String,
            encrypted: null == encrypted
                ? _value.encrypted
                : encrypted // ignore: cast_nullable_to_non_nullable
                      as bool,
            children: null == children
                ? _value.children
                : children // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            properties: freezed == properties
                ? _value.properties
                : properties // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DatasetImplCopyWith<$Res> implements $DatasetCopyWith<$Res> {
  factory _$$DatasetImplCopyWith(
    _$DatasetImpl value,
    $Res Function(_$DatasetImpl) then,
  ) = __$$DatasetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String pool,
    String type,
    int used,
    int available,
    int referenced,
    String mountpoint,
    bool encrypted,
    List<String> children,
    Map<String, dynamic>? properties,
  });
}

/// @nodoc
class __$$DatasetImplCopyWithImpl<$Res>
    extends _$DatasetCopyWithImpl<$Res, _$DatasetImpl>
    implements _$$DatasetImplCopyWith<$Res> {
  __$$DatasetImplCopyWithImpl(
    _$DatasetImpl _value,
    $Res Function(_$DatasetImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Dataset
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? pool = null,
    Object? type = null,
    Object? used = null,
    Object? available = null,
    Object? referenced = null,
    Object? mountpoint = null,
    Object? encrypted = null,
    Object? children = null,
    Object? properties = freezed,
  }) {
    return _then(
      _$DatasetImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        pool: null == pool
            ? _value.pool
            : pool // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        used: null == used
            ? _value.used
            : used // ignore: cast_nullable_to_non_nullable
                  as int,
        available: null == available
            ? _value.available
            : available // ignore: cast_nullable_to_non_nullable
                  as int,
        referenced: null == referenced
            ? _value.referenced
            : referenced // ignore: cast_nullable_to_non_nullable
                  as int,
        mountpoint: null == mountpoint
            ? _value.mountpoint
            : mountpoint // ignore: cast_nullable_to_non_nullable
                  as String,
        encrypted: null == encrypted
            ? _value.encrypted
            : encrypted // ignore: cast_nullable_to_non_nullable
                  as bool,
        children: null == children
            ? _value._children
            : children // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        properties: freezed == properties
            ? _value._properties
            : properties // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DatasetImpl implements _Dataset {
  const _$DatasetImpl({
    required this.id,
    required this.name,
    required this.pool,
    required this.type,
    required this.used,
    required this.available,
    required this.referenced,
    required this.mountpoint,
    this.encrypted = false,
    final List<String> children = const [],
    final Map<String, dynamic>? properties,
  }) : _children = children,
       _properties = properties;

  factory _$DatasetImpl.fromJson(Map<String, dynamic> json) =>
      _$$DatasetImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String pool;
  @override
  final String type;
  @override
  final int used;
  @override
  final int available;
  @override
  final int referenced;
  @override
  final String mountpoint;
  @override
  @JsonKey()
  final bool encrypted;
  final List<String> _children;
  @override
  @JsonKey()
  List<String> get children {
    if (_children is EqualUnmodifiableListView) return _children;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_children);
  }

  final Map<String, dynamic>? _properties;
  @override
  Map<String, dynamic>? get properties {
    final value = _properties;
    if (value == null) return null;
    if (_properties is EqualUnmodifiableMapView) return _properties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'Dataset(id: $id, name: $name, pool: $pool, type: $type, used: $used, available: $available, referenced: $referenced, mountpoint: $mountpoint, encrypted: $encrypted, children: $children, properties: $properties)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DatasetImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.pool, pool) || other.pool == pool) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.used, used) || other.used == used) &&
            (identical(other.available, available) ||
                other.available == available) &&
            (identical(other.referenced, referenced) ||
                other.referenced == referenced) &&
            (identical(other.mountpoint, mountpoint) ||
                other.mountpoint == mountpoint) &&
            (identical(other.encrypted, encrypted) ||
                other.encrypted == encrypted) &&
            const DeepCollectionEquality().equals(other._children, _children) &&
            const DeepCollectionEquality().equals(
              other._properties,
              _properties,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    pool,
    type,
    used,
    available,
    referenced,
    mountpoint,
    encrypted,
    const DeepCollectionEquality().hash(_children),
    const DeepCollectionEquality().hash(_properties),
  );

  /// Create a copy of Dataset
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DatasetImplCopyWith<_$DatasetImpl> get copyWith =>
      __$$DatasetImplCopyWithImpl<_$DatasetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DatasetImplToJson(this);
  }
}

abstract class _Dataset implements Dataset {
  const factory _Dataset({
    required final String id,
    required final String name,
    required final String pool,
    required final String type,
    required final int used,
    required final int available,
    required final int referenced,
    required final String mountpoint,
    final bool encrypted,
    final List<String> children,
    final Map<String, dynamic>? properties,
  }) = _$DatasetImpl;

  factory _Dataset.fromJson(Map<String, dynamic> json) = _$DatasetImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get pool;
  @override
  String get type;
  @override
  int get used;
  @override
  int get available;
  @override
  int get referenced;
  @override
  String get mountpoint;
  @override
  bool get encrypted;
  @override
  List<String> get children;
  @override
  Map<String, dynamic>? get properties;

  /// Create a copy of Dataset
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DatasetImplCopyWith<_$DatasetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

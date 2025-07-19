// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pool.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Pool _$PoolFromJson(Map<String, dynamic> json) {
  return _Pool.fromJson(json);
}

/// @nodoc
mixin _$Pool {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  int get allocated => throw _privateConstructorUsedError;
  int get free => throw _privateConstructorUsedError;
  double get fragmentation => throw _privateConstructorUsedError;
  bool get isHealthy => throw _privateConstructorUsedError;
  String? get path => throw _privateConstructorUsedError;
  List<PoolVdev> get vdevs => throw _privateConstructorUsedError;

  /// Serializes this Pool to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Pool
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PoolCopyWith<Pool> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PoolCopyWith<$Res> {
  factory $PoolCopyWith(Pool value, $Res Function(Pool) then) =
      _$PoolCopyWithImpl<$Res, Pool>;
  @useResult
  $Res call({
    String id,
    String name,
    String status,
    int size,
    int allocated,
    int free,
    double fragmentation,
    bool isHealthy,
    String? path,
    List<PoolVdev> vdevs,
  });
}

/// @nodoc
class _$PoolCopyWithImpl<$Res, $Val extends Pool>
    implements $PoolCopyWith<$Res> {
  _$PoolCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Pool
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? status = null,
    Object? size = null,
    Object? allocated = null,
    Object? free = null,
    Object? fragmentation = null,
    Object? isHealthy = null,
    Object? path = freezed,
    Object? vdevs = null,
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
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            size: null == size
                ? _value.size
                : size // ignore: cast_nullable_to_non_nullable
                      as int,
            allocated: null == allocated
                ? _value.allocated
                : allocated // ignore: cast_nullable_to_non_nullable
                      as int,
            free: null == free
                ? _value.free
                : free // ignore: cast_nullable_to_non_nullable
                      as int,
            fragmentation: null == fragmentation
                ? _value.fragmentation
                : fragmentation // ignore: cast_nullable_to_non_nullable
                      as double,
            isHealthy: null == isHealthy
                ? _value.isHealthy
                : isHealthy // ignore: cast_nullable_to_non_nullable
                      as bool,
            path: freezed == path
                ? _value.path
                : path // ignore: cast_nullable_to_non_nullable
                      as String?,
            vdevs: null == vdevs
                ? _value.vdevs
                : vdevs // ignore: cast_nullable_to_non_nullable
                      as List<PoolVdev>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PoolImplCopyWith<$Res> implements $PoolCopyWith<$Res> {
  factory _$$PoolImplCopyWith(
    _$PoolImpl value,
    $Res Function(_$PoolImpl) then,
  ) = __$$PoolImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String status,
    int size,
    int allocated,
    int free,
    double fragmentation,
    bool isHealthy,
    String? path,
    List<PoolVdev> vdevs,
  });
}

/// @nodoc
class __$$PoolImplCopyWithImpl<$Res>
    extends _$PoolCopyWithImpl<$Res, _$PoolImpl>
    implements _$$PoolImplCopyWith<$Res> {
  __$$PoolImplCopyWithImpl(_$PoolImpl _value, $Res Function(_$PoolImpl) _then)
    : super(_value, _then);

  /// Create a copy of Pool
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? status = null,
    Object? size = null,
    Object? allocated = null,
    Object? free = null,
    Object? fragmentation = null,
    Object? isHealthy = null,
    Object? path = freezed,
    Object? vdevs = null,
  }) {
    return _then(
      _$PoolImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        size: null == size
            ? _value.size
            : size // ignore: cast_nullable_to_non_nullable
                  as int,
        allocated: null == allocated
            ? _value.allocated
            : allocated // ignore: cast_nullable_to_non_nullable
                  as int,
        free: null == free
            ? _value.free
            : free // ignore: cast_nullable_to_non_nullable
                  as int,
        fragmentation: null == fragmentation
            ? _value.fragmentation
            : fragmentation // ignore: cast_nullable_to_non_nullable
                  as double,
        isHealthy: null == isHealthy
            ? _value.isHealthy
            : isHealthy // ignore: cast_nullable_to_non_nullable
                  as bool,
        path: freezed == path
            ? _value.path
            : path // ignore: cast_nullable_to_non_nullable
                  as String?,
        vdevs: null == vdevs
            ? _value._vdevs
            : vdevs // ignore: cast_nullable_to_non_nullable
                  as List<PoolVdev>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PoolImpl implements _Pool {
  const _$PoolImpl({
    required this.id,
    required this.name,
    required this.status,
    required this.size,
    required this.allocated,
    required this.free,
    required this.fragmentation,
    required this.isHealthy,
    this.path,
    final List<PoolVdev> vdevs = const [],
  }) : _vdevs = vdevs;

  factory _$PoolImpl.fromJson(Map<String, dynamic> json) =>
      _$$PoolImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String status;
  @override
  final int size;
  @override
  final int allocated;
  @override
  final int free;
  @override
  final double fragmentation;
  @override
  final bool isHealthy;
  @override
  final String? path;
  final List<PoolVdev> _vdevs;
  @override
  @JsonKey()
  List<PoolVdev> get vdevs {
    if (_vdevs is EqualUnmodifiableListView) return _vdevs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_vdevs);
  }

  @override
  String toString() {
    return 'Pool(id: $id, name: $name, status: $status, size: $size, allocated: $allocated, free: $free, fragmentation: $fragmentation, isHealthy: $isHealthy, path: $path, vdevs: $vdevs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoolImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.allocated, allocated) ||
                other.allocated == allocated) &&
            (identical(other.free, free) || other.free == free) &&
            (identical(other.fragmentation, fragmentation) ||
                other.fragmentation == fragmentation) &&
            (identical(other.isHealthy, isHealthy) ||
                other.isHealthy == isHealthy) &&
            (identical(other.path, path) || other.path == path) &&
            const DeepCollectionEquality().equals(other._vdevs, _vdevs));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    status,
    size,
    allocated,
    free,
    fragmentation,
    isHealthy,
    path,
    const DeepCollectionEquality().hash(_vdevs),
  );

  /// Create a copy of Pool
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PoolImplCopyWith<_$PoolImpl> get copyWith =>
      __$$PoolImplCopyWithImpl<_$PoolImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PoolImplToJson(this);
  }
}

abstract class _Pool implements Pool {
  const factory _Pool({
    required final String id,
    required final String name,
    required final String status,
    required final int size,
    required final int allocated,
    required final int free,
    required final double fragmentation,
    required final bool isHealthy,
    final String? path,
    final List<PoolVdev> vdevs,
  }) = _$PoolImpl;

  factory _Pool.fromJson(Map<String, dynamic> json) = _$PoolImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get status;
  @override
  int get size;
  @override
  int get allocated;
  @override
  int get free;
  @override
  double get fragmentation;
  @override
  bool get isHealthy;
  @override
  String? get path;
  @override
  List<PoolVdev> get vdevs;

  /// Create a copy of Pool
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PoolImplCopyWith<_$PoolImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PoolVdev _$PoolVdevFromJson(Map<String, dynamic> json) {
  return _PoolVdev.fromJson(json);
}

/// @nodoc
mixin _$PoolVdev {
  String get type => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  List<String> get disks => throw _privateConstructorUsedError;

  /// Serializes this PoolVdev to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PoolVdev
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PoolVdevCopyWith<PoolVdev> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PoolVdevCopyWith<$Res> {
  factory $PoolVdevCopyWith(PoolVdev value, $Res Function(PoolVdev) then) =
      _$PoolVdevCopyWithImpl<$Res, PoolVdev>;
  @useResult
  $Res call({String type, String status, List<String> disks});
}

/// @nodoc
class _$PoolVdevCopyWithImpl<$Res, $Val extends PoolVdev>
    implements $PoolVdevCopyWith<$Res> {
  _$PoolVdevCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PoolVdev
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? status = null,
    Object? disks = null,
  }) {
    return _then(
      _value.copyWith(
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            disks: null == disks
                ? _value.disks
                : disks // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PoolVdevImplCopyWith<$Res>
    implements $PoolVdevCopyWith<$Res> {
  factory _$$PoolVdevImplCopyWith(
    _$PoolVdevImpl value,
    $Res Function(_$PoolVdevImpl) then,
  ) = __$$PoolVdevImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String type, String status, List<String> disks});
}

/// @nodoc
class __$$PoolVdevImplCopyWithImpl<$Res>
    extends _$PoolVdevCopyWithImpl<$Res, _$PoolVdevImpl>
    implements _$$PoolVdevImplCopyWith<$Res> {
  __$$PoolVdevImplCopyWithImpl(
    _$PoolVdevImpl _value,
    $Res Function(_$PoolVdevImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoolVdev
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? status = null,
    Object? disks = null,
  }) {
    return _then(
      _$PoolVdevImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        disks: null == disks
            ? _value._disks
            : disks // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PoolVdevImpl implements _PoolVdev {
  const _$PoolVdevImpl({
    required this.type,
    required this.status,
    final List<String> disks = const [],
  }) : _disks = disks;

  factory _$PoolVdevImpl.fromJson(Map<String, dynamic> json) =>
      _$$PoolVdevImplFromJson(json);

  @override
  final String type;
  @override
  final String status;
  final List<String> _disks;
  @override
  @JsonKey()
  List<String> get disks {
    if (_disks is EqualUnmodifiableListView) return _disks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_disks);
  }

  @override
  String toString() {
    return 'PoolVdev(type: $type, status: $status, disks: $disks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoolVdevImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._disks, _disks));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    type,
    status,
    const DeepCollectionEquality().hash(_disks),
  );

  /// Create a copy of PoolVdev
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PoolVdevImplCopyWith<_$PoolVdevImpl> get copyWith =>
      __$$PoolVdevImplCopyWithImpl<_$PoolVdevImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PoolVdevImplToJson(this);
  }
}

abstract class _PoolVdev implements PoolVdev {
  const factory _PoolVdev({
    required final String type,
    required final String status,
    final List<String> disks,
  }) = _$PoolVdevImpl;

  factory _PoolVdev.fromJson(Map<String, dynamic> json) =
      _$PoolVdevImpl.fromJson;

  @override
  String get type;
  @override
  String get status;
  @override
  List<String> get disks;

  /// Create a copy of PoolVdev
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PoolVdevImplCopyWith<_$PoolVdevImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

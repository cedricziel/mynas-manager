// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Snapshot _$SnapshotFromJson(Map<String, dynamic> json) {
  return _Snapshot.fromJson(json);
}

/// @nodoc
mixin _$Snapshot {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get dataset => throw _privateConstructorUsedError;
  String get pool => throw _privateConstructorUsedError;
  DateTime get created => throw _privateConstructorUsedError;
  int get used => throw _privateConstructorUsedError;
  int get referenced => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  Map<String, dynamic>? get properties => throw _privateConstructorUsedError;

  /// Serializes this Snapshot to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Snapshot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SnapshotCopyWith<Snapshot> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SnapshotCopyWith<$Res> {
  factory $SnapshotCopyWith(Snapshot value, $Res Function(Snapshot) then) =
      _$SnapshotCopyWithImpl<$Res, Snapshot>;
  @useResult
  $Res call({
    String id,
    String name,
    String dataset,
    String pool,
    DateTime created,
    int used,
    int referenced,
    String? description,
    Map<String, dynamic>? properties,
  });
}

/// @nodoc
class _$SnapshotCopyWithImpl<$Res, $Val extends Snapshot>
    implements $SnapshotCopyWith<$Res> {
  _$SnapshotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Snapshot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? dataset = null,
    Object? pool = null,
    Object? created = null,
    Object? used = null,
    Object? referenced = null,
    Object? description = freezed,
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
            dataset: null == dataset
                ? _value.dataset
                : dataset // ignore: cast_nullable_to_non_nullable
                      as String,
            pool: null == pool
                ? _value.pool
                : pool // ignore: cast_nullable_to_non_nullable
                      as String,
            created: null == created
                ? _value.created
                : created // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            used: null == used
                ? _value.used
                : used // ignore: cast_nullable_to_non_nullable
                      as int,
            referenced: null == referenced
                ? _value.referenced
                : referenced // ignore: cast_nullable_to_non_nullable
                      as int,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
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
abstract class _$$SnapshotImplCopyWith<$Res>
    implements $SnapshotCopyWith<$Res> {
  factory _$$SnapshotImplCopyWith(
    _$SnapshotImpl value,
    $Res Function(_$SnapshotImpl) then,
  ) = __$$SnapshotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String dataset,
    String pool,
    DateTime created,
    int used,
    int referenced,
    String? description,
    Map<String, dynamic>? properties,
  });
}

/// @nodoc
class __$$SnapshotImplCopyWithImpl<$Res>
    extends _$SnapshotCopyWithImpl<$Res, _$SnapshotImpl>
    implements _$$SnapshotImplCopyWith<$Res> {
  __$$SnapshotImplCopyWithImpl(
    _$SnapshotImpl _value,
    $Res Function(_$SnapshotImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Snapshot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? dataset = null,
    Object? pool = null,
    Object? created = null,
    Object? used = null,
    Object? referenced = null,
    Object? description = freezed,
    Object? properties = freezed,
  }) {
    return _then(
      _$SnapshotImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        dataset: null == dataset
            ? _value.dataset
            : dataset // ignore: cast_nullable_to_non_nullable
                  as String,
        pool: null == pool
            ? _value.pool
            : pool // ignore: cast_nullable_to_non_nullable
                  as String,
        created: null == created
            ? _value.created
            : created // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        used: null == used
            ? _value.used
            : used // ignore: cast_nullable_to_non_nullable
                  as int,
        referenced: null == referenced
            ? _value.referenced
            : referenced // ignore: cast_nullable_to_non_nullable
                  as int,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
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
class _$SnapshotImpl implements _Snapshot {
  const _$SnapshotImpl({
    required this.id,
    required this.name,
    required this.dataset,
    required this.pool,
    required this.created,
    required this.used,
    required this.referenced,
    this.description,
    final Map<String, dynamic>? properties,
  }) : _properties = properties;

  factory _$SnapshotImpl.fromJson(Map<String, dynamic> json) =>
      _$$SnapshotImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String dataset;
  @override
  final String pool;
  @override
  final DateTime created;
  @override
  final int used;
  @override
  final int referenced;
  @override
  final String? description;
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
    return 'Snapshot(id: $id, name: $name, dataset: $dataset, pool: $pool, created: $created, used: $used, referenced: $referenced, description: $description, properties: $properties)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SnapshotImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.dataset, dataset) || other.dataset == dataset) &&
            (identical(other.pool, pool) || other.pool == pool) &&
            (identical(other.created, created) || other.created == created) &&
            (identical(other.used, used) || other.used == used) &&
            (identical(other.referenced, referenced) ||
                other.referenced == referenced) &&
            (identical(other.description, description) ||
                other.description == description) &&
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
    dataset,
    pool,
    created,
    used,
    referenced,
    description,
    const DeepCollectionEquality().hash(_properties),
  );

  /// Create a copy of Snapshot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SnapshotImplCopyWith<_$SnapshotImpl> get copyWith =>
      __$$SnapshotImplCopyWithImpl<_$SnapshotImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SnapshotImplToJson(this);
  }
}

abstract class _Snapshot implements Snapshot {
  const factory _Snapshot({
    required final String id,
    required final String name,
    required final String dataset,
    required final String pool,
    required final DateTime created,
    required final int used,
    required final int referenced,
    final String? description,
    final Map<String, dynamic>? properties,
  }) = _$SnapshotImpl;

  factory _Snapshot.fromJson(Map<String, dynamic> json) =
      _$SnapshotImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get dataset;
  @override
  String get pool;
  @override
  DateTime get created;
  @override
  int get used;
  @override
  int get referenced;
  @override
  String? get description;
  @override
  Map<String, dynamic>? get properties;

  /// Create a copy of Snapshot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SnapshotImplCopyWith<_$SnapshotImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SnapshotTask _$SnapshotTaskFromJson(Map<String, dynamic> json) {
  return _SnapshotTask.fromJson(json);
}

/// @nodoc
mixin _$SnapshotTask {
  String get id => throw _privateConstructorUsedError;
  String get dataset => throw _privateConstructorUsedError;
  String get namingSchema => throw _privateConstructorUsedError;
  String get schedule => throw _privateConstructorUsedError; // cron expression
  bool get enabled => throw _privateConstructorUsedError;
  bool get recursive => throw _privateConstructorUsedError;
  bool get excludeEmpty => throw _privateConstructorUsedError;
  int get lifetimeValue => throw _privateConstructorUsedError;
  String get lifetimeUnit =>
      throw _privateConstructorUsedError; // HOUR, DAY, WEEK, MONTH, YEAR
  DateTime? get nextRun => throw _privateConstructorUsedError;
  DateTime? get lastRun => throw _privateConstructorUsedError;
  int get keepCount => throw _privateConstructorUsedError;
  Map<String, dynamic>? get options => throw _privateConstructorUsedError;

  /// Serializes this SnapshotTask to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SnapshotTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SnapshotTaskCopyWith<SnapshotTask> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SnapshotTaskCopyWith<$Res> {
  factory $SnapshotTaskCopyWith(
    SnapshotTask value,
    $Res Function(SnapshotTask) then,
  ) = _$SnapshotTaskCopyWithImpl<$Res, SnapshotTask>;
  @useResult
  $Res call({
    String id,
    String dataset,
    String namingSchema,
    String schedule,
    bool enabled,
    bool recursive,
    bool excludeEmpty,
    int lifetimeValue,
    String lifetimeUnit,
    DateTime? nextRun,
    DateTime? lastRun,
    int keepCount,
    Map<String, dynamic>? options,
  });
}

/// @nodoc
class _$SnapshotTaskCopyWithImpl<$Res, $Val extends SnapshotTask>
    implements $SnapshotTaskCopyWith<$Res> {
  _$SnapshotTaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SnapshotTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dataset = null,
    Object? namingSchema = null,
    Object? schedule = null,
    Object? enabled = null,
    Object? recursive = null,
    Object? excludeEmpty = null,
    Object? lifetimeValue = null,
    Object? lifetimeUnit = null,
    Object? nextRun = freezed,
    Object? lastRun = freezed,
    Object? keepCount = null,
    Object? options = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            dataset: null == dataset
                ? _value.dataset
                : dataset // ignore: cast_nullable_to_non_nullable
                      as String,
            namingSchema: null == namingSchema
                ? _value.namingSchema
                : namingSchema // ignore: cast_nullable_to_non_nullable
                      as String,
            schedule: null == schedule
                ? _value.schedule
                : schedule // ignore: cast_nullable_to_non_nullable
                      as String,
            enabled: null == enabled
                ? _value.enabled
                : enabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            recursive: null == recursive
                ? _value.recursive
                : recursive // ignore: cast_nullable_to_non_nullable
                      as bool,
            excludeEmpty: null == excludeEmpty
                ? _value.excludeEmpty
                : excludeEmpty // ignore: cast_nullable_to_non_nullable
                      as bool,
            lifetimeValue: null == lifetimeValue
                ? _value.lifetimeValue
                : lifetimeValue // ignore: cast_nullable_to_non_nullable
                      as int,
            lifetimeUnit: null == lifetimeUnit
                ? _value.lifetimeUnit
                : lifetimeUnit // ignore: cast_nullable_to_non_nullable
                      as String,
            nextRun: freezed == nextRun
                ? _value.nextRun
                : nextRun // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            lastRun: freezed == lastRun
                ? _value.lastRun
                : lastRun // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            keepCount: null == keepCount
                ? _value.keepCount
                : keepCount // ignore: cast_nullable_to_non_nullable
                      as int,
            options: freezed == options
                ? _value.options
                : options // ignore: cast_nullable_to_non_nullable
                      as Map<String, dynamic>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SnapshotTaskImplCopyWith<$Res>
    implements $SnapshotTaskCopyWith<$Res> {
  factory _$$SnapshotTaskImplCopyWith(
    _$SnapshotTaskImpl value,
    $Res Function(_$SnapshotTaskImpl) then,
  ) = __$$SnapshotTaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String dataset,
    String namingSchema,
    String schedule,
    bool enabled,
    bool recursive,
    bool excludeEmpty,
    int lifetimeValue,
    String lifetimeUnit,
    DateTime? nextRun,
    DateTime? lastRun,
    int keepCount,
    Map<String, dynamic>? options,
  });
}

/// @nodoc
class __$$SnapshotTaskImplCopyWithImpl<$Res>
    extends _$SnapshotTaskCopyWithImpl<$Res, _$SnapshotTaskImpl>
    implements _$$SnapshotTaskImplCopyWith<$Res> {
  __$$SnapshotTaskImplCopyWithImpl(
    _$SnapshotTaskImpl _value,
    $Res Function(_$SnapshotTaskImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SnapshotTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dataset = null,
    Object? namingSchema = null,
    Object? schedule = null,
    Object? enabled = null,
    Object? recursive = null,
    Object? excludeEmpty = null,
    Object? lifetimeValue = null,
    Object? lifetimeUnit = null,
    Object? nextRun = freezed,
    Object? lastRun = freezed,
    Object? keepCount = null,
    Object? options = freezed,
  }) {
    return _then(
      _$SnapshotTaskImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        dataset: null == dataset
            ? _value.dataset
            : dataset // ignore: cast_nullable_to_non_nullable
                  as String,
        namingSchema: null == namingSchema
            ? _value.namingSchema
            : namingSchema // ignore: cast_nullable_to_non_nullable
                  as String,
        schedule: null == schedule
            ? _value.schedule
            : schedule // ignore: cast_nullable_to_non_nullable
                  as String,
        enabled: null == enabled
            ? _value.enabled
            : enabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        recursive: null == recursive
            ? _value.recursive
            : recursive // ignore: cast_nullable_to_non_nullable
                  as bool,
        excludeEmpty: null == excludeEmpty
            ? _value.excludeEmpty
            : excludeEmpty // ignore: cast_nullable_to_non_nullable
                  as bool,
        lifetimeValue: null == lifetimeValue
            ? _value.lifetimeValue
            : lifetimeValue // ignore: cast_nullable_to_non_nullable
                  as int,
        lifetimeUnit: null == lifetimeUnit
            ? _value.lifetimeUnit
            : lifetimeUnit // ignore: cast_nullable_to_non_nullable
                  as String,
        nextRun: freezed == nextRun
            ? _value.nextRun
            : nextRun // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        lastRun: freezed == lastRun
            ? _value.lastRun
            : lastRun // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        keepCount: null == keepCount
            ? _value.keepCount
            : keepCount // ignore: cast_nullable_to_non_nullable
                  as int,
        options: freezed == options
            ? _value._options
            : options // ignore: cast_nullable_to_non_nullable
                  as Map<String, dynamic>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SnapshotTaskImpl implements _SnapshotTask {
  const _$SnapshotTaskImpl({
    required this.id,
    required this.dataset,
    required this.namingSchema,
    required this.schedule,
    this.enabled = true,
    this.recursive = false,
    this.excludeEmpty = false,
    required this.lifetimeValue,
    required this.lifetimeUnit,
    required this.nextRun,
    required this.lastRun,
    this.keepCount = 0,
    final Map<String, dynamic>? options,
  }) : _options = options;

  factory _$SnapshotTaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$SnapshotTaskImplFromJson(json);

  @override
  final String id;
  @override
  final String dataset;
  @override
  final String namingSchema;
  @override
  final String schedule;
  // cron expression
  @override
  @JsonKey()
  final bool enabled;
  @override
  @JsonKey()
  final bool recursive;
  @override
  @JsonKey()
  final bool excludeEmpty;
  @override
  final int lifetimeValue;
  @override
  final String lifetimeUnit;
  // HOUR, DAY, WEEK, MONTH, YEAR
  @override
  final DateTime? nextRun;
  @override
  final DateTime? lastRun;
  @override
  @JsonKey()
  final int keepCount;
  final Map<String, dynamic>? _options;
  @override
  Map<String, dynamic>? get options {
    final value = _options;
    if (value == null) return null;
    if (_options is EqualUnmodifiableMapView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'SnapshotTask(id: $id, dataset: $dataset, namingSchema: $namingSchema, schedule: $schedule, enabled: $enabled, recursive: $recursive, excludeEmpty: $excludeEmpty, lifetimeValue: $lifetimeValue, lifetimeUnit: $lifetimeUnit, nextRun: $nextRun, lastRun: $lastRun, keepCount: $keepCount, options: $options)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SnapshotTaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.dataset, dataset) || other.dataset == dataset) &&
            (identical(other.namingSchema, namingSchema) ||
                other.namingSchema == namingSchema) &&
            (identical(other.schedule, schedule) ||
                other.schedule == schedule) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.recursive, recursive) ||
                other.recursive == recursive) &&
            (identical(other.excludeEmpty, excludeEmpty) ||
                other.excludeEmpty == excludeEmpty) &&
            (identical(other.lifetimeValue, lifetimeValue) ||
                other.lifetimeValue == lifetimeValue) &&
            (identical(other.lifetimeUnit, lifetimeUnit) ||
                other.lifetimeUnit == lifetimeUnit) &&
            (identical(other.nextRun, nextRun) || other.nextRun == nextRun) &&
            (identical(other.lastRun, lastRun) || other.lastRun == lastRun) &&
            (identical(other.keepCount, keepCount) ||
                other.keepCount == keepCount) &&
            const DeepCollectionEquality().equals(other._options, _options));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    dataset,
    namingSchema,
    schedule,
    enabled,
    recursive,
    excludeEmpty,
    lifetimeValue,
    lifetimeUnit,
    nextRun,
    lastRun,
    keepCount,
    const DeepCollectionEquality().hash(_options),
  );

  /// Create a copy of SnapshotTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SnapshotTaskImplCopyWith<_$SnapshotTaskImpl> get copyWith =>
      __$$SnapshotTaskImplCopyWithImpl<_$SnapshotTaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SnapshotTaskImplToJson(this);
  }
}

abstract class _SnapshotTask implements SnapshotTask {
  const factory _SnapshotTask({
    required final String id,
    required final String dataset,
    required final String namingSchema,
    required final String schedule,
    final bool enabled,
    final bool recursive,
    final bool excludeEmpty,
    required final int lifetimeValue,
    required final String lifetimeUnit,
    required final DateTime? nextRun,
    required final DateTime? lastRun,
    final int keepCount,
    final Map<String, dynamic>? options,
  }) = _$SnapshotTaskImpl;

  factory _SnapshotTask.fromJson(Map<String, dynamic> json) =
      _$SnapshotTaskImpl.fromJson;

  @override
  String get id;
  @override
  String get dataset;
  @override
  String get namingSchema;
  @override
  String get schedule; // cron expression
  @override
  bool get enabled;
  @override
  bool get recursive;
  @override
  bool get excludeEmpty;
  @override
  int get lifetimeValue;
  @override
  String get lifetimeUnit; // HOUR, DAY, WEEK, MONTH, YEAR
  @override
  DateTime? get nextRun;
  @override
  DateTime? get lastRun;
  @override
  int get keepCount;
  @override
  Map<String, dynamic>? get options;

  /// Create a copy of SnapshotTask
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SnapshotTaskImplCopyWith<_$SnapshotTaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SnapshotCount _$SnapshotCountFromJson(Map<String, dynamic> json) {
  return _SnapshotCount.fromJson(json);
}

/// @nodoc
mixin _$SnapshotCount {
  String get dataset => throw _privateConstructorUsedError;
  int get totalSnapshots => throw _privateConstructorUsedError;
  int get manualSnapshots => throw _privateConstructorUsedError;
  int get taskSnapshots => throw _privateConstructorUsedError;
  int get totalSize => throw _privateConstructorUsedError;

  /// Serializes this SnapshotCount to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SnapshotCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SnapshotCountCopyWith<SnapshotCount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SnapshotCountCopyWith<$Res> {
  factory $SnapshotCountCopyWith(
    SnapshotCount value,
    $Res Function(SnapshotCount) then,
  ) = _$SnapshotCountCopyWithImpl<$Res, SnapshotCount>;
  @useResult
  $Res call({
    String dataset,
    int totalSnapshots,
    int manualSnapshots,
    int taskSnapshots,
    int totalSize,
  });
}

/// @nodoc
class _$SnapshotCountCopyWithImpl<$Res, $Val extends SnapshotCount>
    implements $SnapshotCountCopyWith<$Res> {
  _$SnapshotCountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SnapshotCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dataset = null,
    Object? totalSnapshots = null,
    Object? manualSnapshots = null,
    Object? taskSnapshots = null,
    Object? totalSize = null,
  }) {
    return _then(
      _value.copyWith(
            dataset: null == dataset
                ? _value.dataset
                : dataset // ignore: cast_nullable_to_non_nullable
                      as String,
            totalSnapshots: null == totalSnapshots
                ? _value.totalSnapshots
                : totalSnapshots // ignore: cast_nullable_to_non_nullable
                      as int,
            manualSnapshots: null == manualSnapshots
                ? _value.manualSnapshots
                : manualSnapshots // ignore: cast_nullable_to_non_nullable
                      as int,
            taskSnapshots: null == taskSnapshots
                ? _value.taskSnapshots
                : taskSnapshots // ignore: cast_nullable_to_non_nullable
                      as int,
            totalSize: null == totalSize
                ? _value.totalSize
                : totalSize // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SnapshotCountImplCopyWith<$Res>
    implements $SnapshotCountCopyWith<$Res> {
  factory _$$SnapshotCountImplCopyWith(
    _$SnapshotCountImpl value,
    $Res Function(_$SnapshotCountImpl) then,
  ) = __$$SnapshotCountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String dataset,
    int totalSnapshots,
    int manualSnapshots,
    int taskSnapshots,
    int totalSize,
  });
}

/// @nodoc
class __$$SnapshotCountImplCopyWithImpl<$Res>
    extends _$SnapshotCountCopyWithImpl<$Res, _$SnapshotCountImpl>
    implements _$$SnapshotCountImplCopyWith<$Res> {
  __$$SnapshotCountImplCopyWithImpl(
    _$SnapshotCountImpl _value,
    $Res Function(_$SnapshotCountImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SnapshotCount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dataset = null,
    Object? totalSnapshots = null,
    Object? manualSnapshots = null,
    Object? taskSnapshots = null,
    Object? totalSize = null,
  }) {
    return _then(
      _$SnapshotCountImpl(
        dataset: null == dataset
            ? _value.dataset
            : dataset // ignore: cast_nullable_to_non_nullable
                  as String,
        totalSnapshots: null == totalSnapshots
            ? _value.totalSnapshots
            : totalSnapshots // ignore: cast_nullable_to_non_nullable
                  as int,
        manualSnapshots: null == manualSnapshots
            ? _value.manualSnapshots
            : manualSnapshots // ignore: cast_nullable_to_non_nullable
                  as int,
        taskSnapshots: null == taskSnapshots
            ? _value.taskSnapshots
            : taskSnapshots // ignore: cast_nullable_to_non_nullable
                  as int,
        totalSize: null == totalSize
            ? _value.totalSize
            : totalSize // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SnapshotCountImpl implements _SnapshotCount {
  const _$SnapshotCountImpl({
    required this.dataset,
    required this.totalSnapshots,
    required this.manualSnapshots,
    required this.taskSnapshots,
    required this.totalSize,
  });

  factory _$SnapshotCountImpl.fromJson(Map<String, dynamic> json) =>
      _$$SnapshotCountImplFromJson(json);

  @override
  final String dataset;
  @override
  final int totalSnapshots;
  @override
  final int manualSnapshots;
  @override
  final int taskSnapshots;
  @override
  final int totalSize;

  @override
  String toString() {
    return 'SnapshotCount(dataset: $dataset, totalSnapshots: $totalSnapshots, manualSnapshots: $manualSnapshots, taskSnapshots: $taskSnapshots, totalSize: $totalSize)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SnapshotCountImpl &&
            (identical(other.dataset, dataset) || other.dataset == dataset) &&
            (identical(other.totalSnapshots, totalSnapshots) ||
                other.totalSnapshots == totalSnapshots) &&
            (identical(other.manualSnapshots, manualSnapshots) ||
                other.manualSnapshots == manualSnapshots) &&
            (identical(other.taskSnapshots, taskSnapshots) ||
                other.taskSnapshots == taskSnapshots) &&
            (identical(other.totalSize, totalSize) ||
                other.totalSize == totalSize));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    dataset,
    totalSnapshots,
    manualSnapshots,
    taskSnapshots,
    totalSize,
  );

  /// Create a copy of SnapshotCount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SnapshotCountImplCopyWith<_$SnapshotCountImpl> get copyWith =>
      __$$SnapshotCountImplCopyWithImpl<_$SnapshotCountImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SnapshotCountImplToJson(this);
  }
}

abstract class _SnapshotCount implements SnapshotCount {
  const factory _SnapshotCount({
    required final String dataset,
    required final int totalSnapshots,
    required final int manualSnapshots,
    required final int taskSnapshots,
    required final int totalSize,
  }) = _$SnapshotCountImpl;

  factory _SnapshotCount.fromJson(Map<String, dynamic> json) =
      _$SnapshotCountImpl.fromJson;

  @override
  String get dataset;
  @override
  int get totalSnapshots;
  @override
  int get manualSnapshots;
  @override
  int get taskSnapshots;
  @override
  int get totalSize;

  /// Create a copy of SnapshotCount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SnapshotCountImplCopyWith<_$SnapshotCountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

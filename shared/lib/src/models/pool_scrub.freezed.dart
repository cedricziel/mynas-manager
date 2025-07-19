// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pool_scrub.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PoolScrub _$PoolScrubFromJson(Map<String, dynamic> json) {
  return _PoolScrub.fromJson(json);
}

/// @nodoc
mixin _$PoolScrub {
  String get id => throw _privateConstructorUsedError;
  String get pool => throw _privateConstructorUsedError;
  ScrubStatus get status => throw _privateConstructorUsedError;
  DateTime? get startTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;
  int? get duration => throw _privateConstructorUsedError; // seconds
  int? get bytesProcessed => throw _privateConstructorUsedError;
  int? get bytesPerSecond => throw _privateConstructorUsedError;
  int? get errorsFound => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  bool get enabled => throw _privateConstructorUsedError;
  String? get schedule => throw _privateConstructorUsedError;

  /// Serializes this PoolScrub to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PoolScrub
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PoolScrubCopyWith<PoolScrub> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PoolScrubCopyWith<$Res> {
  factory $PoolScrubCopyWith(PoolScrub value, $Res Function(PoolScrub) then) =
      _$PoolScrubCopyWithImpl<$Res, PoolScrub>;
  @useResult
  $Res call({
    String id,
    String pool,
    ScrubStatus status,
    DateTime? startTime,
    DateTime? endTime,
    int? duration,
    int? bytesProcessed,
    int? bytesPerSecond,
    int? errorsFound,
    String description,
    bool enabled,
    String? schedule,
  });
}

/// @nodoc
class _$PoolScrubCopyWithImpl<$Res, $Val extends PoolScrub>
    implements $PoolScrubCopyWith<$Res> {
  _$PoolScrubCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PoolScrub
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pool = null,
    Object? status = null,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? duration = freezed,
    Object? bytesProcessed = freezed,
    Object? bytesPerSecond = freezed,
    Object? errorsFound = freezed,
    Object? description = null,
    Object? enabled = null,
    Object? schedule = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            pool: null == pool
                ? _value.pool
                : pool // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as ScrubStatus,
            startTime: freezed == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            endTime: freezed == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            duration: freezed == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as int?,
            bytesProcessed: freezed == bytesProcessed
                ? _value.bytesProcessed
                : bytesProcessed // ignore: cast_nullable_to_non_nullable
                      as int?,
            bytesPerSecond: freezed == bytesPerSecond
                ? _value.bytesPerSecond
                : bytesPerSecond // ignore: cast_nullable_to_non_nullable
                      as int?,
            errorsFound: freezed == errorsFound
                ? _value.errorsFound
                : errorsFound // ignore: cast_nullable_to_non_nullable
                      as int?,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            enabled: null == enabled
                ? _value.enabled
                : enabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            schedule: freezed == schedule
                ? _value.schedule
                : schedule // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PoolScrubImplCopyWith<$Res>
    implements $PoolScrubCopyWith<$Res> {
  factory _$$PoolScrubImplCopyWith(
    _$PoolScrubImpl value,
    $Res Function(_$PoolScrubImpl) then,
  ) = __$$PoolScrubImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String pool,
    ScrubStatus status,
    DateTime? startTime,
    DateTime? endTime,
    int? duration,
    int? bytesProcessed,
    int? bytesPerSecond,
    int? errorsFound,
    String description,
    bool enabled,
    String? schedule,
  });
}

/// @nodoc
class __$$PoolScrubImplCopyWithImpl<$Res>
    extends _$PoolScrubCopyWithImpl<$Res, _$PoolScrubImpl>
    implements _$$PoolScrubImplCopyWith<$Res> {
  __$$PoolScrubImplCopyWithImpl(
    _$PoolScrubImpl _value,
    $Res Function(_$PoolScrubImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoolScrub
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pool = null,
    Object? status = null,
    Object? startTime = freezed,
    Object? endTime = freezed,
    Object? duration = freezed,
    Object? bytesProcessed = freezed,
    Object? bytesPerSecond = freezed,
    Object? errorsFound = freezed,
    Object? description = null,
    Object? enabled = null,
    Object? schedule = freezed,
  }) {
    return _then(
      _$PoolScrubImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        pool: null == pool
            ? _value.pool
            : pool // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ScrubStatus,
        startTime: freezed == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        endTime: freezed == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        duration: freezed == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as int?,
        bytesProcessed: freezed == bytesProcessed
            ? _value.bytesProcessed
            : bytesProcessed // ignore: cast_nullable_to_non_nullable
                  as int?,
        bytesPerSecond: freezed == bytesPerSecond
            ? _value.bytesPerSecond
            : bytesPerSecond // ignore: cast_nullable_to_non_nullable
                  as int?,
        errorsFound: freezed == errorsFound
            ? _value.errorsFound
            : errorsFound // ignore: cast_nullable_to_non_nullable
                  as int?,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        enabled: null == enabled
            ? _value.enabled
            : enabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        schedule: freezed == schedule
            ? _value.schedule
            : schedule // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PoolScrubImpl implements _PoolScrub {
  const _$PoolScrubImpl({
    required this.id,
    required this.pool,
    required this.status,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.bytesProcessed,
    required this.bytesPerSecond,
    required this.errorsFound,
    required this.description,
    this.enabled = false,
    this.schedule,
  });

  factory _$PoolScrubImpl.fromJson(Map<String, dynamic> json) =>
      _$$PoolScrubImplFromJson(json);

  @override
  final String id;
  @override
  final String pool;
  @override
  final ScrubStatus status;
  @override
  final DateTime? startTime;
  @override
  final DateTime? endTime;
  @override
  final int? duration;
  // seconds
  @override
  final int? bytesProcessed;
  @override
  final int? bytesPerSecond;
  @override
  final int? errorsFound;
  @override
  final String description;
  @override
  @JsonKey()
  final bool enabled;
  @override
  final String? schedule;

  @override
  String toString() {
    return 'PoolScrub(id: $id, pool: $pool, status: $status, startTime: $startTime, endTime: $endTime, duration: $duration, bytesProcessed: $bytesProcessed, bytesPerSecond: $bytesPerSecond, errorsFound: $errorsFound, description: $description, enabled: $enabled, schedule: $schedule)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoolScrubImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.pool, pool) || other.pool == pool) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.bytesProcessed, bytesProcessed) ||
                other.bytesProcessed == bytesProcessed) &&
            (identical(other.bytesPerSecond, bytesPerSecond) ||
                other.bytesPerSecond == bytesPerSecond) &&
            (identical(other.errorsFound, errorsFound) ||
                other.errorsFound == errorsFound) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.schedule, schedule) ||
                other.schedule == schedule));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    pool,
    status,
    startTime,
    endTime,
    duration,
    bytesProcessed,
    bytesPerSecond,
    errorsFound,
    description,
    enabled,
    schedule,
  );

  /// Create a copy of PoolScrub
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PoolScrubImplCopyWith<_$PoolScrubImpl> get copyWith =>
      __$$PoolScrubImplCopyWithImpl<_$PoolScrubImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PoolScrubImplToJson(this);
  }
}

abstract class _PoolScrub implements PoolScrub {
  const factory _PoolScrub({
    required final String id,
    required final String pool,
    required final ScrubStatus status,
    required final DateTime? startTime,
    required final DateTime? endTime,
    required final int? duration,
    required final int? bytesProcessed,
    required final int? bytesPerSecond,
    required final int? errorsFound,
    required final String description,
    final bool enabled,
    final String? schedule,
  }) = _$PoolScrubImpl;

  factory _PoolScrub.fromJson(Map<String, dynamic> json) =
      _$PoolScrubImpl.fromJson;

  @override
  String get id;
  @override
  String get pool;
  @override
  ScrubStatus get status;
  @override
  DateTime? get startTime;
  @override
  DateTime? get endTime;
  @override
  int? get duration; // seconds
  @override
  int? get bytesProcessed;
  @override
  int? get bytesPerSecond;
  @override
  int? get errorsFound;
  @override
  String get description;
  @override
  bool get enabled;
  @override
  String? get schedule;

  /// Create a copy of PoolScrub
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PoolScrubImplCopyWith<_$PoolScrubImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PoolScrubTask _$PoolScrubTaskFromJson(Map<String, dynamic> json) {
  return _PoolScrubTask.fromJson(json);
}

/// @nodoc
mixin _$PoolScrubTask {
  String get id => throw _privateConstructorUsedError;
  String get pool => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get schedule => throw _privateConstructorUsedError; // cron expression
  bool get enabled => throw _privateConstructorUsedError;
  DateTime? get nextRun => throw _privateConstructorUsedError;
  DateTime? get lastRun => throw _privateConstructorUsedError;
  Map<String, dynamic>? get options => throw _privateConstructorUsedError;

  /// Serializes this PoolScrubTask to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PoolScrubTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PoolScrubTaskCopyWith<PoolScrubTask> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PoolScrubTaskCopyWith<$Res> {
  factory $PoolScrubTaskCopyWith(
    PoolScrubTask value,
    $Res Function(PoolScrubTask) then,
  ) = _$PoolScrubTaskCopyWithImpl<$Res, PoolScrubTask>;
  @useResult
  $Res call({
    String id,
    String pool,
    String description,
    String schedule,
    bool enabled,
    DateTime? nextRun,
    DateTime? lastRun,
    Map<String, dynamic>? options,
  });
}

/// @nodoc
class _$PoolScrubTaskCopyWithImpl<$Res, $Val extends PoolScrubTask>
    implements $PoolScrubTaskCopyWith<$Res> {
  _$PoolScrubTaskCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PoolScrubTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pool = null,
    Object? description = null,
    Object? schedule = null,
    Object? enabled = null,
    Object? nextRun = freezed,
    Object? lastRun = freezed,
    Object? options = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            pool: null == pool
                ? _value.pool
                : pool // ignore: cast_nullable_to_non_nullable
                      as String,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            schedule: null == schedule
                ? _value.schedule
                : schedule // ignore: cast_nullable_to_non_nullable
                      as String,
            enabled: null == enabled
                ? _value.enabled
                : enabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            nextRun: freezed == nextRun
                ? _value.nextRun
                : nextRun // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            lastRun: freezed == lastRun
                ? _value.lastRun
                : lastRun // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
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
abstract class _$$PoolScrubTaskImplCopyWith<$Res>
    implements $PoolScrubTaskCopyWith<$Res> {
  factory _$$PoolScrubTaskImplCopyWith(
    _$PoolScrubTaskImpl value,
    $Res Function(_$PoolScrubTaskImpl) then,
  ) = __$$PoolScrubTaskImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String pool,
    String description,
    String schedule,
    bool enabled,
    DateTime? nextRun,
    DateTime? lastRun,
    Map<String, dynamic>? options,
  });
}

/// @nodoc
class __$$PoolScrubTaskImplCopyWithImpl<$Res>
    extends _$PoolScrubTaskCopyWithImpl<$Res, _$PoolScrubTaskImpl>
    implements _$$PoolScrubTaskImplCopyWith<$Res> {
  __$$PoolScrubTaskImplCopyWithImpl(
    _$PoolScrubTaskImpl _value,
    $Res Function(_$PoolScrubTaskImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoolScrubTask
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? pool = null,
    Object? description = null,
    Object? schedule = null,
    Object? enabled = null,
    Object? nextRun = freezed,
    Object? lastRun = freezed,
    Object? options = freezed,
  }) {
    return _then(
      _$PoolScrubTaskImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        pool: null == pool
            ? _value.pool
            : pool // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        schedule: null == schedule
            ? _value.schedule
            : schedule // ignore: cast_nullable_to_non_nullable
                  as String,
        enabled: null == enabled
            ? _value.enabled
            : enabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        nextRun: freezed == nextRun
            ? _value.nextRun
            : nextRun // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        lastRun: freezed == lastRun
            ? _value.lastRun
            : lastRun // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
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
class _$PoolScrubTaskImpl implements _PoolScrubTask {
  const _$PoolScrubTaskImpl({
    required this.id,
    required this.pool,
    required this.description,
    required this.schedule,
    this.enabled = true,
    required this.nextRun,
    required this.lastRun,
    final Map<String, dynamic>? options,
  }) : _options = options;

  factory _$PoolScrubTaskImpl.fromJson(Map<String, dynamic> json) =>
      _$$PoolScrubTaskImplFromJson(json);

  @override
  final String id;
  @override
  final String pool;
  @override
  final String description;
  @override
  final String schedule;
  // cron expression
  @override
  @JsonKey()
  final bool enabled;
  @override
  final DateTime? nextRun;
  @override
  final DateTime? lastRun;
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
    return 'PoolScrubTask(id: $id, pool: $pool, description: $description, schedule: $schedule, enabled: $enabled, nextRun: $nextRun, lastRun: $lastRun, options: $options)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoolScrubTaskImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.pool, pool) || other.pool == pool) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.schedule, schedule) ||
                other.schedule == schedule) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.nextRun, nextRun) || other.nextRun == nextRun) &&
            (identical(other.lastRun, lastRun) || other.lastRun == lastRun) &&
            const DeepCollectionEquality().equals(other._options, _options));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    pool,
    description,
    schedule,
    enabled,
    nextRun,
    lastRun,
    const DeepCollectionEquality().hash(_options),
  );

  /// Create a copy of PoolScrubTask
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PoolScrubTaskImplCopyWith<_$PoolScrubTaskImpl> get copyWith =>
      __$$PoolScrubTaskImplCopyWithImpl<_$PoolScrubTaskImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PoolScrubTaskImplToJson(this);
  }
}

abstract class _PoolScrubTask implements PoolScrubTask {
  const factory _PoolScrubTask({
    required final String id,
    required final String pool,
    required final String description,
    required final String schedule,
    final bool enabled,
    required final DateTime? nextRun,
    required final DateTime? lastRun,
    final Map<String, dynamic>? options,
  }) = _$PoolScrubTaskImpl;

  factory _PoolScrubTask.fromJson(Map<String, dynamic> json) =
      _$PoolScrubTaskImpl.fromJson;

  @override
  String get id;
  @override
  String get pool;
  @override
  String get description;
  @override
  String get schedule; // cron expression
  @override
  bool get enabled;
  @override
  DateTime? get nextRun;
  @override
  DateTime? get lastRun;
  @override
  Map<String, dynamic>? get options;

  /// Create a copy of PoolScrubTask
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PoolScrubTaskImplCopyWith<_$PoolScrubTaskImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

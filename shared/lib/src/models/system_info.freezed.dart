// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'system_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SystemInfo _$SystemInfoFromJson(Map<String, dynamic> json) {
  return _SystemInfo.fromJson(json);
}

/// @nodoc
mixin _$SystemInfo {
  String get hostname => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  String get uptime => throw _privateConstructorUsedError;
  double get cpuUsage => throw _privateConstructorUsedError;
  MemoryInfo get memory => throw _privateConstructorUsedError;
  double get cpuTemperature => throw _privateConstructorUsedError;
  List<Alert> get alerts => throw _privateConstructorUsedError;

  /// Serializes this SystemInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SystemInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SystemInfoCopyWith<SystemInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SystemInfoCopyWith<$Res> {
  factory $SystemInfoCopyWith(
    SystemInfo value,
    $Res Function(SystemInfo) then,
  ) = _$SystemInfoCopyWithImpl<$Res, SystemInfo>;
  @useResult
  $Res call({
    String hostname,
    String version,
    String uptime,
    double cpuUsage,
    MemoryInfo memory,
    double cpuTemperature,
    List<Alert> alerts,
  });

  $MemoryInfoCopyWith<$Res> get memory;
}

/// @nodoc
class _$SystemInfoCopyWithImpl<$Res, $Val extends SystemInfo>
    implements $SystemInfoCopyWith<$Res> {
  _$SystemInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SystemInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hostname = null,
    Object? version = null,
    Object? uptime = null,
    Object? cpuUsage = null,
    Object? memory = null,
    Object? cpuTemperature = null,
    Object? alerts = null,
  }) {
    return _then(
      _value.copyWith(
            hostname: null == hostname
                ? _value.hostname
                : hostname // ignore: cast_nullable_to_non_nullable
                      as String,
            version: null == version
                ? _value.version
                : version // ignore: cast_nullable_to_non_nullable
                      as String,
            uptime: null == uptime
                ? _value.uptime
                : uptime // ignore: cast_nullable_to_non_nullable
                      as String,
            cpuUsage: null == cpuUsage
                ? _value.cpuUsage
                : cpuUsage // ignore: cast_nullable_to_non_nullable
                      as double,
            memory: null == memory
                ? _value.memory
                : memory // ignore: cast_nullable_to_non_nullable
                      as MemoryInfo,
            cpuTemperature: null == cpuTemperature
                ? _value.cpuTemperature
                : cpuTemperature // ignore: cast_nullable_to_non_nullable
                      as double,
            alerts: null == alerts
                ? _value.alerts
                : alerts // ignore: cast_nullable_to_non_nullable
                      as List<Alert>,
          )
          as $Val,
    );
  }

  /// Create a copy of SystemInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MemoryInfoCopyWith<$Res> get memory {
    return $MemoryInfoCopyWith<$Res>(_value.memory, (value) {
      return _then(_value.copyWith(memory: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SystemInfoImplCopyWith<$Res>
    implements $SystemInfoCopyWith<$Res> {
  factory _$$SystemInfoImplCopyWith(
    _$SystemInfoImpl value,
    $Res Function(_$SystemInfoImpl) then,
  ) = __$$SystemInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String hostname,
    String version,
    String uptime,
    double cpuUsage,
    MemoryInfo memory,
    double cpuTemperature,
    List<Alert> alerts,
  });

  @override
  $MemoryInfoCopyWith<$Res> get memory;
}

/// @nodoc
class __$$SystemInfoImplCopyWithImpl<$Res>
    extends _$SystemInfoCopyWithImpl<$Res, _$SystemInfoImpl>
    implements _$$SystemInfoImplCopyWith<$Res> {
  __$$SystemInfoImplCopyWithImpl(
    _$SystemInfoImpl _value,
    $Res Function(_$SystemInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SystemInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hostname = null,
    Object? version = null,
    Object? uptime = null,
    Object? cpuUsage = null,
    Object? memory = null,
    Object? cpuTemperature = null,
    Object? alerts = null,
  }) {
    return _then(
      _$SystemInfoImpl(
        hostname: null == hostname
            ? _value.hostname
            : hostname // ignore: cast_nullable_to_non_nullable
                  as String,
        version: null == version
            ? _value.version
            : version // ignore: cast_nullable_to_non_nullable
                  as String,
        uptime: null == uptime
            ? _value.uptime
            : uptime // ignore: cast_nullable_to_non_nullable
                  as String,
        cpuUsage: null == cpuUsage
            ? _value.cpuUsage
            : cpuUsage // ignore: cast_nullable_to_non_nullable
                  as double,
        memory: null == memory
            ? _value.memory
            : memory // ignore: cast_nullable_to_non_nullable
                  as MemoryInfo,
        cpuTemperature: null == cpuTemperature
            ? _value.cpuTemperature
            : cpuTemperature // ignore: cast_nullable_to_non_nullable
                  as double,
        alerts: null == alerts
            ? _value._alerts
            : alerts // ignore: cast_nullable_to_non_nullable
                  as List<Alert>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SystemInfoImpl implements _SystemInfo {
  const _$SystemInfoImpl({
    required this.hostname,
    required this.version,
    required this.uptime,
    required this.cpuUsage,
    required this.memory,
    required this.cpuTemperature,
    final List<Alert> alerts = const [],
  }) : _alerts = alerts;

  factory _$SystemInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$SystemInfoImplFromJson(json);

  @override
  final String hostname;
  @override
  final String version;
  @override
  final String uptime;
  @override
  final double cpuUsage;
  @override
  final MemoryInfo memory;
  @override
  final double cpuTemperature;
  final List<Alert> _alerts;
  @override
  @JsonKey()
  List<Alert> get alerts {
    if (_alerts is EqualUnmodifiableListView) return _alerts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_alerts);
  }

  @override
  String toString() {
    return 'SystemInfo(hostname: $hostname, version: $version, uptime: $uptime, cpuUsage: $cpuUsage, memory: $memory, cpuTemperature: $cpuTemperature, alerts: $alerts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SystemInfoImpl &&
            (identical(other.hostname, hostname) ||
                other.hostname == hostname) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.uptime, uptime) || other.uptime == uptime) &&
            (identical(other.cpuUsage, cpuUsage) ||
                other.cpuUsage == cpuUsage) &&
            (identical(other.memory, memory) || other.memory == memory) &&
            (identical(other.cpuTemperature, cpuTemperature) ||
                other.cpuTemperature == cpuTemperature) &&
            const DeepCollectionEquality().equals(other._alerts, _alerts));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    hostname,
    version,
    uptime,
    cpuUsage,
    memory,
    cpuTemperature,
    const DeepCollectionEquality().hash(_alerts),
  );

  /// Create a copy of SystemInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SystemInfoImplCopyWith<_$SystemInfoImpl> get copyWith =>
      __$$SystemInfoImplCopyWithImpl<_$SystemInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SystemInfoImplToJson(this);
  }
}

abstract class _SystemInfo implements SystemInfo {
  const factory _SystemInfo({
    required final String hostname,
    required final String version,
    required final String uptime,
    required final double cpuUsage,
    required final MemoryInfo memory,
    required final double cpuTemperature,
    final List<Alert> alerts,
  }) = _$SystemInfoImpl;

  factory _SystemInfo.fromJson(Map<String, dynamic> json) =
      _$SystemInfoImpl.fromJson;

  @override
  String get hostname;
  @override
  String get version;
  @override
  String get uptime;
  @override
  double get cpuUsage;
  @override
  MemoryInfo get memory;
  @override
  double get cpuTemperature;
  @override
  List<Alert> get alerts;

  /// Create a copy of SystemInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SystemInfoImplCopyWith<_$SystemInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MemoryInfo _$MemoryInfoFromJson(Map<String, dynamic> json) {
  return _MemoryInfo.fromJson(json);
}

/// @nodoc
mixin _$MemoryInfo {
  int get total => throw _privateConstructorUsedError;
  int get used => throw _privateConstructorUsedError;
  int get free => throw _privateConstructorUsedError;
  int get cached => throw _privateConstructorUsedError;

  /// Serializes this MemoryInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MemoryInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemoryInfoCopyWith<MemoryInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemoryInfoCopyWith<$Res> {
  factory $MemoryInfoCopyWith(
    MemoryInfo value,
    $Res Function(MemoryInfo) then,
  ) = _$MemoryInfoCopyWithImpl<$Res, MemoryInfo>;
  @useResult
  $Res call({int total, int used, int free, int cached});
}

/// @nodoc
class _$MemoryInfoCopyWithImpl<$Res, $Val extends MemoryInfo>
    implements $MemoryInfoCopyWith<$Res> {
  _$MemoryInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MemoryInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? used = null,
    Object? free = null,
    Object? cached = null,
  }) {
    return _then(
      _value.copyWith(
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as int,
            used: null == used
                ? _value.used
                : used // ignore: cast_nullable_to_non_nullable
                      as int,
            free: null == free
                ? _value.free
                : free // ignore: cast_nullable_to_non_nullable
                      as int,
            cached: null == cached
                ? _value.cached
                : cached // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MemoryInfoImplCopyWith<$Res>
    implements $MemoryInfoCopyWith<$Res> {
  factory _$$MemoryInfoImplCopyWith(
    _$MemoryInfoImpl value,
    $Res Function(_$MemoryInfoImpl) then,
  ) = __$$MemoryInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int total, int used, int free, int cached});
}

/// @nodoc
class __$$MemoryInfoImplCopyWithImpl<$Res>
    extends _$MemoryInfoCopyWithImpl<$Res, _$MemoryInfoImpl>
    implements _$$MemoryInfoImplCopyWith<$Res> {
  __$$MemoryInfoImplCopyWithImpl(
    _$MemoryInfoImpl _value,
    $Res Function(_$MemoryInfoImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MemoryInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? total = null,
    Object? used = null,
    Object? free = null,
    Object? cached = null,
  }) {
    return _then(
      _$MemoryInfoImpl(
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int,
        used: null == used
            ? _value.used
            : used // ignore: cast_nullable_to_non_nullable
                  as int,
        free: null == free
            ? _value.free
            : free // ignore: cast_nullable_to_non_nullable
                  as int,
        cached: null == cached
            ? _value.cached
            : cached // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MemoryInfoImpl implements _MemoryInfo {
  const _$MemoryInfoImpl({
    required this.total,
    required this.used,
    required this.free,
    required this.cached,
  });

  factory _$MemoryInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemoryInfoImplFromJson(json);

  @override
  final int total;
  @override
  final int used;
  @override
  final int free;
  @override
  final int cached;

  @override
  String toString() {
    return 'MemoryInfo(total: $total, used: $used, free: $free, cached: $cached)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemoryInfoImpl &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.used, used) || other.used == used) &&
            (identical(other.free, free) || other.free == free) &&
            (identical(other.cached, cached) || other.cached == cached));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, total, used, free, cached);

  /// Create a copy of MemoryInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemoryInfoImplCopyWith<_$MemoryInfoImpl> get copyWith =>
      __$$MemoryInfoImplCopyWithImpl<_$MemoryInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemoryInfoImplToJson(this);
  }
}

abstract class _MemoryInfo implements MemoryInfo {
  const factory _MemoryInfo({
    required final int total,
    required final int used,
    required final int free,
    required final int cached,
  }) = _$MemoryInfoImpl;

  factory _MemoryInfo.fromJson(Map<String, dynamic> json) =
      _$MemoryInfoImpl.fromJson;

  @override
  int get total;
  @override
  int get used;
  @override
  int get free;
  @override
  int get cached;

  /// Create a copy of MemoryInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemoryInfoImplCopyWith<_$MemoryInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Alert _$AlertFromJson(Map<String, dynamic> json) {
  return _Alert.fromJson(json);
}

/// @nodoc
mixin _$Alert {
  String get id => throw _privateConstructorUsedError;
  AlertLevel get level => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  bool get dismissed => throw _privateConstructorUsedError;

  /// Serializes this Alert to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Alert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlertCopyWith<Alert> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlertCopyWith<$Res> {
  factory $AlertCopyWith(Alert value, $Res Function(Alert) then) =
      _$AlertCopyWithImpl<$Res, Alert>;
  @useResult
  $Res call({
    String id,
    AlertLevel level,
    String message,
    DateTime timestamp,
    bool dismissed,
  });
}

/// @nodoc
class _$AlertCopyWithImpl<$Res, $Val extends Alert>
    implements $AlertCopyWith<$Res> {
  _$AlertCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Alert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? level = null,
    Object? message = null,
    Object? timestamp = null,
    Object? dismissed = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            level: null == level
                ? _value.level
                : level // ignore: cast_nullable_to_non_nullable
                      as AlertLevel,
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
            timestamp: null == timestamp
                ? _value.timestamp
                : timestamp // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            dismissed: null == dismissed
                ? _value.dismissed
                : dismissed // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AlertImplCopyWith<$Res> implements $AlertCopyWith<$Res> {
  factory _$$AlertImplCopyWith(
    _$AlertImpl value,
    $Res Function(_$AlertImpl) then,
  ) = __$$AlertImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    AlertLevel level,
    String message,
    DateTime timestamp,
    bool dismissed,
  });
}

/// @nodoc
class __$$AlertImplCopyWithImpl<$Res>
    extends _$AlertCopyWithImpl<$Res, _$AlertImpl>
    implements _$$AlertImplCopyWith<$Res> {
  __$$AlertImplCopyWithImpl(
    _$AlertImpl _value,
    $Res Function(_$AlertImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Alert
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? level = null,
    Object? message = null,
    Object? timestamp = null,
    Object? dismissed = null,
  }) {
    return _then(
      _$AlertImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        level: null == level
            ? _value.level
            : level // ignore: cast_nullable_to_non_nullable
                  as AlertLevel,
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        dismissed: null == dismissed
            ? _value.dismissed
            : dismissed // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AlertImpl implements _Alert {
  const _$AlertImpl({
    required this.id,
    required this.level,
    required this.message,
    required this.timestamp,
    this.dismissed = false,
  });

  factory _$AlertImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlertImplFromJson(json);

  @override
  final String id;
  @override
  final AlertLevel level;
  @override
  final String message;
  @override
  final DateTime timestamp;
  @override
  @JsonKey()
  final bool dismissed;

  @override
  String toString() {
    return 'Alert(id: $id, level: $level, message: $message, timestamp: $timestamp, dismissed: $dismissed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlertImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.dismissed, dismissed) ||
                other.dismissed == dismissed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, level, message, timestamp, dismissed);

  /// Create a copy of Alert
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlertImplCopyWith<_$AlertImpl> get copyWith =>
      __$$AlertImplCopyWithImpl<_$AlertImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlertImplToJson(this);
  }
}

abstract class _Alert implements Alert {
  const factory _Alert({
    required final String id,
    required final AlertLevel level,
    required final String message,
    required final DateTime timestamp,
    final bool dismissed,
  }) = _$AlertImpl;

  factory _Alert.fromJson(Map<String, dynamic> json) = _$AlertImpl.fromJson;

  @override
  String get id;
  @override
  AlertLevel get level;
  @override
  String get message;
  @override
  DateTime get timestamp;
  @override
  bool get dismissed;

  /// Create a copy of Alert
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlertImplCopyWith<_$AlertImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

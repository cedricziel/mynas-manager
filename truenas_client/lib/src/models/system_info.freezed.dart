// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'system_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SystemInfo {

 String get hostname; String get version; String get uptime; double get cpuUsage; MemoryInfo get memory; double get cpuTemperature; List<Alert> get alerts;
/// Create a copy of SystemInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SystemInfoCopyWith<SystemInfo> get copyWith => _$SystemInfoCopyWithImpl<SystemInfo>(this as SystemInfo, _$identity);

  /// Serializes this SystemInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SystemInfo&&(identical(other.hostname, hostname) || other.hostname == hostname)&&(identical(other.version, version) || other.version == version)&&(identical(other.uptime, uptime) || other.uptime == uptime)&&(identical(other.cpuUsage, cpuUsage) || other.cpuUsage == cpuUsage)&&(identical(other.memory, memory) || other.memory == memory)&&(identical(other.cpuTemperature, cpuTemperature) || other.cpuTemperature == cpuTemperature)&&const DeepCollectionEquality().equals(other.alerts, alerts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hostname,version,uptime,cpuUsage,memory,cpuTemperature,const DeepCollectionEquality().hash(alerts));

@override
String toString() {
  return 'SystemInfo(hostname: $hostname, version: $version, uptime: $uptime, cpuUsage: $cpuUsage, memory: $memory, cpuTemperature: $cpuTemperature, alerts: $alerts)';
}


}

/// @nodoc
abstract mixin class $SystemInfoCopyWith<$Res>  {
  factory $SystemInfoCopyWith(SystemInfo value, $Res Function(SystemInfo) _then) = _$SystemInfoCopyWithImpl;
@useResult
$Res call({
 String hostname, String version, String uptime, double cpuUsage, MemoryInfo memory, double cpuTemperature, List<Alert> alerts
});


$MemoryInfoCopyWith<$Res> get memory;

}
/// @nodoc
class _$SystemInfoCopyWithImpl<$Res>
    implements $SystemInfoCopyWith<$Res> {
  _$SystemInfoCopyWithImpl(this._self, this._then);

  final SystemInfo _self;
  final $Res Function(SystemInfo) _then;

/// Create a copy of SystemInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hostname = null,Object? version = null,Object? uptime = null,Object? cpuUsage = null,Object? memory = null,Object? cpuTemperature = null,Object? alerts = null,}) {
  return _then(_self.copyWith(
hostname: null == hostname ? _self.hostname : hostname // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,uptime: null == uptime ? _self.uptime : uptime // ignore: cast_nullable_to_non_nullable
as String,cpuUsage: null == cpuUsage ? _self.cpuUsage : cpuUsage // ignore: cast_nullable_to_non_nullable
as double,memory: null == memory ? _self.memory : memory // ignore: cast_nullable_to_non_nullable
as MemoryInfo,cpuTemperature: null == cpuTemperature ? _self.cpuTemperature : cpuTemperature // ignore: cast_nullable_to_non_nullable
as double,alerts: null == alerts ? _self.alerts : alerts // ignore: cast_nullable_to_non_nullable
as List<Alert>,
  ));
}
/// Create a copy of SystemInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MemoryInfoCopyWith<$Res> get memory {
  
  return $MemoryInfoCopyWith<$Res>(_self.memory, (value) {
    return _then(_self.copyWith(memory: value));
  });
}
}


/// Adds pattern-matching-related methods to [SystemInfo].
extension SystemInfoPatterns on SystemInfo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SystemInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SystemInfo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SystemInfo value)  $default,){
final _that = this;
switch (_that) {
case _SystemInfo():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SystemInfo value)?  $default,){
final _that = this;
switch (_that) {
case _SystemInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String hostname,  String version,  String uptime,  double cpuUsage,  MemoryInfo memory,  double cpuTemperature,  List<Alert> alerts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SystemInfo() when $default != null:
return $default(_that.hostname,_that.version,_that.uptime,_that.cpuUsage,_that.memory,_that.cpuTemperature,_that.alerts);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String hostname,  String version,  String uptime,  double cpuUsage,  MemoryInfo memory,  double cpuTemperature,  List<Alert> alerts)  $default,) {final _that = this;
switch (_that) {
case _SystemInfo():
return $default(_that.hostname,_that.version,_that.uptime,_that.cpuUsage,_that.memory,_that.cpuTemperature,_that.alerts);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String hostname,  String version,  String uptime,  double cpuUsage,  MemoryInfo memory,  double cpuTemperature,  List<Alert> alerts)?  $default,) {final _that = this;
switch (_that) {
case _SystemInfo() when $default != null:
return $default(_that.hostname,_that.version,_that.uptime,_that.cpuUsage,_that.memory,_that.cpuTemperature,_that.alerts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SystemInfo implements SystemInfo {
  const _SystemInfo({required this.hostname, required this.version, required this.uptime, required this.cpuUsage, required this.memory, required this.cpuTemperature, final  List<Alert> alerts = const []}): _alerts = alerts;
  factory _SystemInfo.fromJson(Map<String, dynamic> json) => _$SystemInfoFromJson(json);

@override final  String hostname;
@override final  String version;
@override final  String uptime;
@override final  double cpuUsage;
@override final  MemoryInfo memory;
@override final  double cpuTemperature;
 final  List<Alert> _alerts;
@override@JsonKey() List<Alert> get alerts {
  if (_alerts is EqualUnmodifiableListView) return _alerts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_alerts);
}


/// Create a copy of SystemInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SystemInfoCopyWith<_SystemInfo> get copyWith => __$SystemInfoCopyWithImpl<_SystemInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SystemInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SystemInfo&&(identical(other.hostname, hostname) || other.hostname == hostname)&&(identical(other.version, version) || other.version == version)&&(identical(other.uptime, uptime) || other.uptime == uptime)&&(identical(other.cpuUsage, cpuUsage) || other.cpuUsage == cpuUsage)&&(identical(other.memory, memory) || other.memory == memory)&&(identical(other.cpuTemperature, cpuTemperature) || other.cpuTemperature == cpuTemperature)&&const DeepCollectionEquality().equals(other._alerts, _alerts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hostname,version,uptime,cpuUsage,memory,cpuTemperature,const DeepCollectionEquality().hash(_alerts));

@override
String toString() {
  return 'SystemInfo(hostname: $hostname, version: $version, uptime: $uptime, cpuUsage: $cpuUsage, memory: $memory, cpuTemperature: $cpuTemperature, alerts: $alerts)';
}


}

/// @nodoc
abstract mixin class _$SystemInfoCopyWith<$Res> implements $SystemInfoCopyWith<$Res> {
  factory _$SystemInfoCopyWith(_SystemInfo value, $Res Function(_SystemInfo) _then) = __$SystemInfoCopyWithImpl;
@override @useResult
$Res call({
 String hostname, String version, String uptime, double cpuUsage, MemoryInfo memory, double cpuTemperature, List<Alert> alerts
});


@override $MemoryInfoCopyWith<$Res> get memory;

}
/// @nodoc
class __$SystemInfoCopyWithImpl<$Res>
    implements _$SystemInfoCopyWith<$Res> {
  __$SystemInfoCopyWithImpl(this._self, this._then);

  final _SystemInfo _self;
  final $Res Function(_SystemInfo) _then;

/// Create a copy of SystemInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hostname = null,Object? version = null,Object? uptime = null,Object? cpuUsage = null,Object? memory = null,Object? cpuTemperature = null,Object? alerts = null,}) {
  return _then(_SystemInfo(
hostname: null == hostname ? _self.hostname : hostname // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String,uptime: null == uptime ? _self.uptime : uptime // ignore: cast_nullable_to_non_nullable
as String,cpuUsage: null == cpuUsage ? _self.cpuUsage : cpuUsage // ignore: cast_nullable_to_non_nullable
as double,memory: null == memory ? _self.memory : memory // ignore: cast_nullable_to_non_nullable
as MemoryInfo,cpuTemperature: null == cpuTemperature ? _self.cpuTemperature : cpuTemperature // ignore: cast_nullable_to_non_nullable
as double,alerts: null == alerts ? _self._alerts : alerts // ignore: cast_nullable_to_non_nullable
as List<Alert>,
  ));
}

/// Create a copy of SystemInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MemoryInfoCopyWith<$Res> get memory {
  
  return $MemoryInfoCopyWith<$Res>(_self.memory, (value) {
    return _then(_self.copyWith(memory: value));
  });
}
}


/// @nodoc
mixin _$MemoryInfo {

 int get total; int get used; int get free; int get cached;
/// Create a copy of MemoryInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoryInfoCopyWith<MemoryInfo> get copyWith => _$MemoryInfoCopyWithImpl<MemoryInfo>(this as MemoryInfo, _$identity);

  /// Serializes this MemoryInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryInfo&&(identical(other.total, total) || other.total == total)&&(identical(other.used, used) || other.used == used)&&(identical(other.free, free) || other.free == free)&&(identical(other.cached, cached) || other.cached == cached));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,used,free,cached);

@override
String toString() {
  return 'MemoryInfo(total: $total, used: $used, free: $free, cached: $cached)';
}


}

/// @nodoc
abstract mixin class $MemoryInfoCopyWith<$Res>  {
  factory $MemoryInfoCopyWith(MemoryInfo value, $Res Function(MemoryInfo) _then) = _$MemoryInfoCopyWithImpl;
@useResult
$Res call({
 int total, int used, int free, int cached
});




}
/// @nodoc
class _$MemoryInfoCopyWithImpl<$Res>
    implements $MemoryInfoCopyWith<$Res> {
  _$MemoryInfoCopyWithImpl(this._self, this._then);

  final MemoryInfo _self;
  final $Res Function(MemoryInfo) _then;

/// Create a copy of MemoryInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? used = null,Object? free = null,Object? cached = null,}) {
  return _then(_self.copyWith(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as int,free: null == free ? _self.free : free // ignore: cast_nullable_to_non_nullable
as int,cached: null == cached ? _self.cached : cached // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [MemoryInfo].
extension MemoryInfoPatterns on MemoryInfo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemoryInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemoryInfo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemoryInfo value)  $default,){
final _that = this;
switch (_that) {
case _MemoryInfo():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemoryInfo value)?  $default,){
final _that = this;
switch (_that) {
case _MemoryInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  int used,  int free,  int cached)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemoryInfo() when $default != null:
return $default(_that.total,_that.used,_that.free,_that.cached);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  int used,  int free,  int cached)  $default,) {final _that = this;
switch (_that) {
case _MemoryInfo():
return $default(_that.total,_that.used,_that.free,_that.cached);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  int used,  int free,  int cached)?  $default,) {final _that = this;
switch (_that) {
case _MemoryInfo() when $default != null:
return $default(_that.total,_that.used,_that.free,_that.cached);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MemoryInfo implements MemoryInfo {
  const _MemoryInfo({required this.total, required this.used, required this.free, required this.cached});
  factory _MemoryInfo.fromJson(Map<String, dynamic> json) => _$MemoryInfoFromJson(json);

@override final  int total;
@override final  int used;
@override final  int free;
@override final  int cached;

/// Create a copy of MemoryInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemoryInfoCopyWith<_MemoryInfo> get copyWith => __$MemoryInfoCopyWithImpl<_MemoryInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemoryInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemoryInfo&&(identical(other.total, total) || other.total == total)&&(identical(other.used, used) || other.used == used)&&(identical(other.free, free) || other.free == free)&&(identical(other.cached, cached) || other.cached == cached));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,used,free,cached);

@override
String toString() {
  return 'MemoryInfo(total: $total, used: $used, free: $free, cached: $cached)';
}


}

/// @nodoc
abstract mixin class _$MemoryInfoCopyWith<$Res> implements $MemoryInfoCopyWith<$Res> {
  factory _$MemoryInfoCopyWith(_MemoryInfo value, $Res Function(_MemoryInfo) _then) = __$MemoryInfoCopyWithImpl;
@override @useResult
$Res call({
 int total, int used, int free, int cached
});




}
/// @nodoc
class __$MemoryInfoCopyWithImpl<$Res>
    implements _$MemoryInfoCopyWith<$Res> {
  __$MemoryInfoCopyWithImpl(this._self, this._then);

  final _MemoryInfo _self;
  final $Res Function(_MemoryInfo) _then;

/// Create a copy of MemoryInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? used = null,Object? free = null,Object? cached = null,}) {
  return _then(_MemoryInfo(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as int,free: null == free ? _self.free : free // ignore: cast_nullable_to_non_nullable
as int,cached: null == cached ? _self.cached : cached // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Alert {

 String get id; AlertLevel get level; String get message; DateTime get timestamp; bool get dismissed;
/// Create a copy of Alert
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlertCopyWith<Alert> get copyWith => _$AlertCopyWithImpl<Alert>(this as Alert, _$identity);

  /// Serializes this Alert to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Alert&&(identical(other.id, id) || other.id == id)&&(identical(other.level, level) || other.level == level)&&(identical(other.message, message) || other.message == message)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.dismissed, dismissed) || other.dismissed == dismissed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,level,message,timestamp,dismissed);

@override
String toString() {
  return 'Alert(id: $id, level: $level, message: $message, timestamp: $timestamp, dismissed: $dismissed)';
}


}

/// @nodoc
abstract mixin class $AlertCopyWith<$Res>  {
  factory $AlertCopyWith(Alert value, $Res Function(Alert) _then) = _$AlertCopyWithImpl;
@useResult
$Res call({
 String id, AlertLevel level, String message, DateTime timestamp, bool dismissed
});




}
/// @nodoc
class _$AlertCopyWithImpl<$Res>
    implements $AlertCopyWith<$Res> {
  _$AlertCopyWithImpl(this._self, this._then);

  final Alert _self;
  final $Res Function(Alert) _then;

/// Create a copy of Alert
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? level = null,Object? message = null,Object? timestamp = null,Object? dismissed = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as AlertLevel,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,dismissed: null == dismissed ? _self.dismissed : dismissed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Alert].
extension AlertPatterns on Alert {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Alert value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Alert() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Alert value)  $default,){
final _that = this;
switch (_that) {
case _Alert():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Alert value)?  $default,){
final _that = this;
switch (_that) {
case _Alert() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  AlertLevel level,  String message,  DateTime timestamp,  bool dismissed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Alert() when $default != null:
return $default(_that.id,_that.level,_that.message,_that.timestamp,_that.dismissed);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  AlertLevel level,  String message,  DateTime timestamp,  bool dismissed)  $default,) {final _that = this;
switch (_that) {
case _Alert():
return $default(_that.id,_that.level,_that.message,_that.timestamp,_that.dismissed);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  AlertLevel level,  String message,  DateTime timestamp,  bool dismissed)?  $default,) {final _that = this;
switch (_that) {
case _Alert() when $default != null:
return $default(_that.id,_that.level,_that.message,_that.timestamp,_that.dismissed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Alert implements Alert {
  const _Alert({required this.id, required this.level, required this.message, required this.timestamp, this.dismissed = false});
  factory _Alert.fromJson(Map<String, dynamic> json) => _$AlertFromJson(json);

@override final  String id;
@override final  AlertLevel level;
@override final  String message;
@override final  DateTime timestamp;
@override@JsonKey() final  bool dismissed;

/// Create a copy of Alert
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlertCopyWith<_Alert> get copyWith => __$AlertCopyWithImpl<_Alert>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlertToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Alert&&(identical(other.id, id) || other.id == id)&&(identical(other.level, level) || other.level == level)&&(identical(other.message, message) || other.message == message)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.dismissed, dismissed) || other.dismissed == dismissed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,level,message,timestamp,dismissed);

@override
String toString() {
  return 'Alert(id: $id, level: $level, message: $message, timestamp: $timestamp, dismissed: $dismissed)';
}


}

/// @nodoc
abstract mixin class _$AlertCopyWith<$Res> implements $AlertCopyWith<$Res> {
  factory _$AlertCopyWith(_Alert value, $Res Function(_Alert) _then) = __$AlertCopyWithImpl;
@override @useResult
$Res call({
 String id, AlertLevel level, String message, DateTime timestamp, bool dismissed
});




}
/// @nodoc
class __$AlertCopyWithImpl<$Res>
    implements _$AlertCopyWith<$Res> {
  __$AlertCopyWithImpl(this._self, this._then);

  final _Alert _self;
  final $Res Function(_Alert) _then;

/// Create a copy of Alert
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? level = null,Object? message = null,Object? timestamp = null,Object? dismissed = null,}) {
  return _then(_Alert(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as AlertLevel,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,dismissed: null == dismissed ? _self.dismissed : dismissed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

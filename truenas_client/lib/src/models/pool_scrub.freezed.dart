// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pool_scrub.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PoolScrub {

 String get id; String get pool; ScrubStatus get status; DateTime? get startTime; DateTime? get endTime; int? get duration;// seconds
 int? get bytesProcessed; int? get bytesPerSecond; int? get errorsFound; String get description; bool get enabled; String? get schedule;
/// Create a copy of PoolScrub
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PoolScrubCopyWith<PoolScrub> get copyWith => _$PoolScrubCopyWithImpl<PoolScrub>(this as PoolScrub, _$identity);

  /// Serializes this PoolScrub to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PoolScrub&&(identical(other.id, id) || other.id == id)&&(identical(other.pool, pool) || other.pool == pool)&&(identical(other.status, status) || other.status == status)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.bytesProcessed, bytesProcessed) || other.bytesProcessed == bytesProcessed)&&(identical(other.bytesPerSecond, bytesPerSecond) || other.bytesPerSecond == bytesPerSecond)&&(identical(other.errorsFound, errorsFound) || other.errorsFound == errorsFound)&&(identical(other.description, description) || other.description == description)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.schedule, schedule) || other.schedule == schedule));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pool,status,startTime,endTime,duration,bytesProcessed,bytesPerSecond,errorsFound,description,enabled,schedule);

@override
String toString() {
  return 'PoolScrub(id: $id, pool: $pool, status: $status, startTime: $startTime, endTime: $endTime, duration: $duration, bytesProcessed: $bytesProcessed, bytesPerSecond: $bytesPerSecond, errorsFound: $errorsFound, description: $description, enabled: $enabled, schedule: $schedule)';
}


}

/// @nodoc
abstract mixin class $PoolScrubCopyWith<$Res>  {
  factory $PoolScrubCopyWith(PoolScrub value, $Res Function(PoolScrub) _then) = _$PoolScrubCopyWithImpl;
@useResult
$Res call({
 String id, String pool, ScrubStatus status, DateTime? startTime, DateTime? endTime, int? duration, int? bytesProcessed, int? bytesPerSecond, int? errorsFound, String description, bool enabled, String? schedule
});




}
/// @nodoc
class _$PoolScrubCopyWithImpl<$Res>
    implements $PoolScrubCopyWith<$Res> {
  _$PoolScrubCopyWithImpl(this._self, this._then);

  final PoolScrub _self;
  final $Res Function(PoolScrub) _then;

/// Create a copy of PoolScrub
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? pool = null,Object? status = null,Object? startTime = freezed,Object? endTime = freezed,Object? duration = freezed,Object? bytesProcessed = freezed,Object? bytesPerSecond = freezed,Object? errorsFound = freezed,Object? description = null,Object? enabled = null,Object? schedule = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pool: null == pool ? _self.pool : pool // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ScrubStatus,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,bytesProcessed: freezed == bytesProcessed ? _self.bytesProcessed : bytesProcessed // ignore: cast_nullable_to_non_nullable
as int?,bytesPerSecond: freezed == bytesPerSecond ? _self.bytesPerSecond : bytesPerSecond // ignore: cast_nullable_to_non_nullable
as int?,errorsFound: freezed == errorsFound ? _self.errorsFound : errorsFound // ignore: cast_nullable_to_non_nullable
as int?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,schedule: freezed == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PoolScrub].
extension PoolScrubPatterns on PoolScrub {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PoolScrub value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PoolScrub() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PoolScrub value)  $default,){
final _that = this;
switch (_that) {
case _PoolScrub():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PoolScrub value)?  $default,){
final _that = this;
switch (_that) {
case _PoolScrub() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String pool,  ScrubStatus status,  DateTime? startTime,  DateTime? endTime,  int? duration,  int? bytesProcessed,  int? bytesPerSecond,  int? errorsFound,  String description,  bool enabled,  String? schedule)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PoolScrub() when $default != null:
return $default(_that.id,_that.pool,_that.status,_that.startTime,_that.endTime,_that.duration,_that.bytesProcessed,_that.bytesPerSecond,_that.errorsFound,_that.description,_that.enabled,_that.schedule);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String pool,  ScrubStatus status,  DateTime? startTime,  DateTime? endTime,  int? duration,  int? bytesProcessed,  int? bytesPerSecond,  int? errorsFound,  String description,  bool enabled,  String? schedule)  $default,) {final _that = this;
switch (_that) {
case _PoolScrub():
return $default(_that.id,_that.pool,_that.status,_that.startTime,_that.endTime,_that.duration,_that.bytesProcessed,_that.bytesPerSecond,_that.errorsFound,_that.description,_that.enabled,_that.schedule);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String pool,  ScrubStatus status,  DateTime? startTime,  DateTime? endTime,  int? duration,  int? bytesProcessed,  int? bytesPerSecond,  int? errorsFound,  String description,  bool enabled,  String? schedule)?  $default,) {final _that = this;
switch (_that) {
case _PoolScrub() when $default != null:
return $default(_that.id,_that.pool,_that.status,_that.startTime,_that.endTime,_that.duration,_that.bytesProcessed,_that.bytesPerSecond,_that.errorsFound,_that.description,_that.enabled,_that.schedule);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PoolScrub implements PoolScrub {
  const _PoolScrub({required this.id, required this.pool, required this.status, required this.startTime, required this.endTime, required this.duration, required this.bytesProcessed, required this.bytesPerSecond, required this.errorsFound, required this.description, this.enabled = false, this.schedule});
  factory _PoolScrub.fromJson(Map<String, dynamic> json) => _$PoolScrubFromJson(json);

@override final  String id;
@override final  String pool;
@override final  ScrubStatus status;
@override final  DateTime? startTime;
@override final  DateTime? endTime;
@override final  int? duration;
// seconds
@override final  int? bytesProcessed;
@override final  int? bytesPerSecond;
@override final  int? errorsFound;
@override final  String description;
@override@JsonKey() final  bool enabled;
@override final  String? schedule;

/// Create a copy of PoolScrub
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PoolScrubCopyWith<_PoolScrub> get copyWith => __$PoolScrubCopyWithImpl<_PoolScrub>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PoolScrubToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PoolScrub&&(identical(other.id, id) || other.id == id)&&(identical(other.pool, pool) || other.pool == pool)&&(identical(other.status, status) || other.status == status)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.bytesProcessed, bytesProcessed) || other.bytesProcessed == bytesProcessed)&&(identical(other.bytesPerSecond, bytesPerSecond) || other.bytesPerSecond == bytesPerSecond)&&(identical(other.errorsFound, errorsFound) || other.errorsFound == errorsFound)&&(identical(other.description, description) || other.description == description)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.schedule, schedule) || other.schedule == schedule));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pool,status,startTime,endTime,duration,bytesProcessed,bytesPerSecond,errorsFound,description,enabled,schedule);

@override
String toString() {
  return 'PoolScrub(id: $id, pool: $pool, status: $status, startTime: $startTime, endTime: $endTime, duration: $duration, bytesProcessed: $bytesProcessed, bytesPerSecond: $bytesPerSecond, errorsFound: $errorsFound, description: $description, enabled: $enabled, schedule: $schedule)';
}


}

/// @nodoc
abstract mixin class _$PoolScrubCopyWith<$Res> implements $PoolScrubCopyWith<$Res> {
  factory _$PoolScrubCopyWith(_PoolScrub value, $Res Function(_PoolScrub) _then) = __$PoolScrubCopyWithImpl;
@override @useResult
$Res call({
 String id, String pool, ScrubStatus status, DateTime? startTime, DateTime? endTime, int? duration, int? bytesProcessed, int? bytesPerSecond, int? errorsFound, String description, bool enabled, String? schedule
});




}
/// @nodoc
class __$PoolScrubCopyWithImpl<$Res>
    implements _$PoolScrubCopyWith<$Res> {
  __$PoolScrubCopyWithImpl(this._self, this._then);

  final _PoolScrub _self;
  final $Res Function(_PoolScrub) _then;

/// Create a copy of PoolScrub
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? pool = null,Object? status = null,Object? startTime = freezed,Object? endTime = freezed,Object? duration = freezed,Object? bytesProcessed = freezed,Object? bytesPerSecond = freezed,Object? errorsFound = freezed,Object? description = null,Object? enabled = null,Object? schedule = freezed,}) {
  return _then(_PoolScrub(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pool: null == pool ? _self.pool : pool // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ScrubStatus,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime?,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,bytesProcessed: freezed == bytesProcessed ? _self.bytesProcessed : bytesProcessed // ignore: cast_nullable_to_non_nullable
as int?,bytesPerSecond: freezed == bytesPerSecond ? _self.bytesPerSecond : bytesPerSecond // ignore: cast_nullable_to_non_nullable
as int?,errorsFound: freezed == errorsFound ? _self.errorsFound : errorsFound // ignore: cast_nullable_to_non_nullable
as int?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,schedule: freezed == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PoolScrubTask {

 String get id; String get pool; String get description; String get schedule;// cron expression
 bool get enabled; DateTime? get nextRun; DateTime? get lastRun; Map<String, dynamic>? get options;
/// Create a copy of PoolScrubTask
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PoolScrubTaskCopyWith<PoolScrubTask> get copyWith => _$PoolScrubTaskCopyWithImpl<PoolScrubTask>(this as PoolScrubTask, _$identity);

  /// Serializes this PoolScrubTask to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PoolScrubTask&&(identical(other.id, id) || other.id == id)&&(identical(other.pool, pool) || other.pool == pool)&&(identical(other.description, description) || other.description == description)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.nextRun, nextRun) || other.nextRun == nextRun)&&(identical(other.lastRun, lastRun) || other.lastRun == lastRun)&&const DeepCollectionEquality().equals(other.options, options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pool,description,schedule,enabled,nextRun,lastRun,const DeepCollectionEquality().hash(options));

@override
String toString() {
  return 'PoolScrubTask(id: $id, pool: $pool, description: $description, schedule: $schedule, enabled: $enabled, nextRun: $nextRun, lastRun: $lastRun, options: $options)';
}


}

/// @nodoc
abstract mixin class $PoolScrubTaskCopyWith<$Res>  {
  factory $PoolScrubTaskCopyWith(PoolScrubTask value, $Res Function(PoolScrubTask) _then) = _$PoolScrubTaskCopyWithImpl;
@useResult
$Res call({
 String id, String pool, String description, String schedule, bool enabled, DateTime? nextRun, DateTime? lastRun, Map<String, dynamic>? options
});




}
/// @nodoc
class _$PoolScrubTaskCopyWithImpl<$Res>
    implements $PoolScrubTaskCopyWith<$Res> {
  _$PoolScrubTaskCopyWithImpl(this._self, this._then);

  final PoolScrubTask _self;
  final $Res Function(PoolScrubTask) _then;

/// Create a copy of PoolScrubTask
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? pool = null,Object? description = null,Object? schedule = null,Object? enabled = null,Object? nextRun = freezed,Object? lastRun = freezed,Object? options = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pool: null == pool ? _self.pool : pool // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,nextRun: freezed == nextRun ? _self.nextRun : nextRun // ignore: cast_nullable_to_non_nullable
as DateTime?,lastRun: freezed == lastRun ? _self.lastRun : lastRun // ignore: cast_nullable_to_non_nullable
as DateTime?,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [PoolScrubTask].
extension PoolScrubTaskPatterns on PoolScrubTask {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PoolScrubTask value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PoolScrubTask() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PoolScrubTask value)  $default,){
final _that = this;
switch (_that) {
case _PoolScrubTask():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PoolScrubTask value)?  $default,){
final _that = this;
switch (_that) {
case _PoolScrubTask() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String pool,  String description,  String schedule,  bool enabled,  DateTime? nextRun,  DateTime? lastRun,  Map<String, dynamic>? options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PoolScrubTask() when $default != null:
return $default(_that.id,_that.pool,_that.description,_that.schedule,_that.enabled,_that.nextRun,_that.lastRun,_that.options);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String pool,  String description,  String schedule,  bool enabled,  DateTime? nextRun,  DateTime? lastRun,  Map<String, dynamic>? options)  $default,) {final _that = this;
switch (_that) {
case _PoolScrubTask():
return $default(_that.id,_that.pool,_that.description,_that.schedule,_that.enabled,_that.nextRun,_that.lastRun,_that.options);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String pool,  String description,  String schedule,  bool enabled,  DateTime? nextRun,  DateTime? lastRun,  Map<String, dynamic>? options)?  $default,) {final _that = this;
switch (_that) {
case _PoolScrubTask() when $default != null:
return $default(_that.id,_that.pool,_that.description,_that.schedule,_that.enabled,_that.nextRun,_that.lastRun,_that.options);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PoolScrubTask implements PoolScrubTask {
  const _PoolScrubTask({required this.id, required this.pool, required this.description, required this.schedule, this.enabled = true, required this.nextRun, required this.lastRun, final  Map<String, dynamic>? options}): _options = options;
  factory _PoolScrubTask.fromJson(Map<String, dynamic> json) => _$PoolScrubTaskFromJson(json);

@override final  String id;
@override final  String pool;
@override final  String description;
@override final  String schedule;
// cron expression
@override@JsonKey() final  bool enabled;
@override final  DateTime? nextRun;
@override final  DateTime? lastRun;
 final  Map<String, dynamic>? _options;
@override Map<String, dynamic>? get options {
  final value = _options;
  if (value == null) return null;
  if (_options is EqualUnmodifiableMapView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of PoolScrubTask
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PoolScrubTaskCopyWith<_PoolScrubTask> get copyWith => __$PoolScrubTaskCopyWithImpl<_PoolScrubTask>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PoolScrubTaskToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PoolScrubTask&&(identical(other.id, id) || other.id == id)&&(identical(other.pool, pool) || other.pool == pool)&&(identical(other.description, description) || other.description == description)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.nextRun, nextRun) || other.nextRun == nextRun)&&(identical(other.lastRun, lastRun) || other.lastRun == lastRun)&&const DeepCollectionEquality().equals(other._options, _options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,pool,description,schedule,enabled,nextRun,lastRun,const DeepCollectionEquality().hash(_options));

@override
String toString() {
  return 'PoolScrubTask(id: $id, pool: $pool, description: $description, schedule: $schedule, enabled: $enabled, nextRun: $nextRun, lastRun: $lastRun, options: $options)';
}


}

/// @nodoc
abstract mixin class _$PoolScrubTaskCopyWith<$Res> implements $PoolScrubTaskCopyWith<$Res> {
  factory _$PoolScrubTaskCopyWith(_PoolScrubTask value, $Res Function(_PoolScrubTask) _then) = __$PoolScrubTaskCopyWithImpl;
@override @useResult
$Res call({
 String id, String pool, String description, String schedule, bool enabled, DateTime? nextRun, DateTime? lastRun, Map<String, dynamic>? options
});




}
/// @nodoc
class __$PoolScrubTaskCopyWithImpl<$Res>
    implements _$PoolScrubTaskCopyWith<$Res> {
  __$PoolScrubTaskCopyWithImpl(this._self, this._then);

  final _PoolScrubTask _self;
  final $Res Function(_PoolScrubTask) _then;

/// Create a copy of PoolScrubTask
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? pool = null,Object? description = null,Object? schedule = null,Object? enabled = null,Object? nextRun = freezed,Object? lastRun = freezed,Object? options = freezed,}) {
  return _then(_PoolScrubTask(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,pool: null == pool ? _self.pool : pool // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,nextRun: freezed == nextRun ? _self.nextRun : nextRun // ignore: cast_nullable_to_non_nullable
as DateTime?,lastRun: freezed == lastRun ? _self.lastRun : lastRun // ignore: cast_nullable_to_non_nullable
as DateTime?,options: freezed == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on

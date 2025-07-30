// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pool_resilver.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PoolResilver {

 String get pool; ResilverStatus get status; DateTime? get startTime; DateTime? get estimatedEndTime; int? get bytesProcessed; int? get totalBytes; double? get percentComplete; int? get bytesPerSecond; int? get errorsFound; String? get description;
/// Create a copy of PoolResilver
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PoolResilverCopyWith<PoolResilver> get copyWith => _$PoolResilverCopyWithImpl<PoolResilver>(this as PoolResilver, _$identity);

  /// Serializes this PoolResilver to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PoolResilver&&(identical(other.pool, pool) || other.pool == pool)&&(identical(other.status, status) || other.status == status)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.estimatedEndTime, estimatedEndTime) || other.estimatedEndTime == estimatedEndTime)&&(identical(other.bytesProcessed, bytesProcessed) || other.bytesProcessed == bytesProcessed)&&(identical(other.totalBytes, totalBytes) || other.totalBytes == totalBytes)&&(identical(other.percentComplete, percentComplete) || other.percentComplete == percentComplete)&&(identical(other.bytesPerSecond, bytesPerSecond) || other.bytesPerSecond == bytesPerSecond)&&(identical(other.errorsFound, errorsFound) || other.errorsFound == errorsFound)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pool,status,startTime,estimatedEndTime,bytesProcessed,totalBytes,percentComplete,bytesPerSecond,errorsFound,description);

@override
String toString() {
  return 'PoolResilver(pool: $pool, status: $status, startTime: $startTime, estimatedEndTime: $estimatedEndTime, bytesProcessed: $bytesProcessed, totalBytes: $totalBytes, percentComplete: $percentComplete, bytesPerSecond: $bytesPerSecond, errorsFound: $errorsFound, description: $description)';
}


}

/// @nodoc
abstract mixin class $PoolResilverCopyWith<$Res>  {
  factory $PoolResilverCopyWith(PoolResilver value, $Res Function(PoolResilver) _then) = _$PoolResilverCopyWithImpl;
@useResult
$Res call({
 String pool, ResilverStatus status, DateTime? startTime, DateTime? estimatedEndTime, int? bytesProcessed, int? totalBytes, double? percentComplete, int? bytesPerSecond, int? errorsFound, String? description
});




}
/// @nodoc
class _$PoolResilverCopyWithImpl<$Res>
    implements $PoolResilverCopyWith<$Res> {
  _$PoolResilverCopyWithImpl(this._self, this._then);

  final PoolResilver _self;
  final $Res Function(PoolResilver) _then;

/// Create a copy of PoolResilver
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pool = null,Object? status = null,Object? startTime = freezed,Object? estimatedEndTime = freezed,Object? bytesProcessed = freezed,Object? totalBytes = freezed,Object? percentComplete = freezed,Object? bytesPerSecond = freezed,Object? errorsFound = freezed,Object? description = freezed,}) {
  return _then(_self.copyWith(
pool: null == pool ? _self.pool : pool // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ResilverStatus,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime?,estimatedEndTime: freezed == estimatedEndTime ? _self.estimatedEndTime : estimatedEndTime // ignore: cast_nullable_to_non_nullable
as DateTime?,bytesProcessed: freezed == bytesProcessed ? _self.bytesProcessed : bytesProcessed // ignore: cast_nullable_to_non_nullable
as int?,totalBytes: freezed == totalBytes ? _self.totalBytes : totalBytes // ignore: cast_nullable_to_non_nullable
as int?,percentComplete: freezed == percentComplete ? _self.percentComplete : percentComplete // ignore: cast_nullable_to_non_nullable
as double?,bytesPerSecond: freezed == bytesPerSecond ? _self.bytesPerSecond : bytesPerSecond // ignore: cast_nullable_to_non_nullable
as int?,errorsFound: freezed == errorsFound ? _self.errorsFound : errorsFound // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PoolResilver].
extension PoolResilverPatterns on PoolResilver {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PoolResilver value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PoolResilver() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PoolResilver value)  $default,){
final _that = this;
switch (_that) {
case _PoolResilver():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PoolResilver value)?  $default,){
final _that = this;
switch (_that) {
case _PoolResilver() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String pool,  ResilverStatus status,  DateTime? startTime,  DateTime? estimatedEndTime,  int? bytesProcessed,  int? totalBytes,  double? percentComplete,  int? bytesPerSecond,  int? errorsFound,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PoolResilver() when $default != null:
return $default(_that.pool,_that.status,_that.startTime,_that.estimatedEndTime,_that.bytesProcessed,_that.totalBytes,_that.percentComplete,_that.bytesPerSecond,_that.errorsFound,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String pool,  ResilverStatus status,  DateTime? startTime,  DateTime? estimatedEndTime,  int? bytesProcessed,  int? totalBytes,  double? percentComplete,  int? bytesPerSecond,  int? errorsFound,  String? description)  $default,) {final _that = this;
switch (_that) {
case _PoolResilver():
return $default(_that.pool,_that.status,_that.startTime,_that.estimatedEndTime,_that.bytesProcessed,_that.totalBytes,_that.percentComplete,_that.bytesPerSecond,_that.errorsFound,_that.description);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String pool,  ResilverStatus status,  DateTime? startTime,  DateTime? estimatedEndTime,  int? bytesProcessed,  int? totalBytes,  double? percentComplete,  int? bytesPerSecond,  int? errorsFound,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _PoolResilver() when $default != null:
return $default(_that.pool,_that.status,_that.startTime,_that.estimatedEndTime,_that.bytesProcessed,_that.totalBytes,_that.percentComplete,_that.bytesPerSecond,_that.errorsFound,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PoolResilver implements PoolResilver {
  const _PoolResilver({required this.pool, required this.status, required this.startTime, required this.estimatedEndTime, required this.bytesProcessed, required this.totalBytes, required this.percentComplete, required this.bytesPerSecond, required this.errorsFound, this.description});
  factory _PoolResilver.fromJson(Map<String, dynamic> json) => _$PoolResilverFromJson(json);

@override final  String pool;
@override final  ResilverStatus status;
@override final  DateTime? startTime;
@override final  DateTime? estimatedEndTime;
@override final  int? bytesProcessed;
@override final  int? totalBytes;
@override final  double? percentComplete;
@override final  int? bytesPerSecond;
@override final  int? errorsFound;
@override final  String? description;

/// Create a copy of PoolResilver
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PoolResilverCopyWith<_PoolResilver> get copyWith => __$PoolResilverCopyWithImpl<_PoolResilver>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PoolResilverToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PoolResilver&&(identical(other.pool, pool) || other.pool == pool)&&(identical(other.status, status) || other.status == status)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.estimatedEndTime, estimatedEndTime) || other.estimatedEndTime == estimatedEndTime)&&(identical(other.bytesProcessed, bytesProcessed) || other.bytesProcessed == bytesProcessed)&&(identical(other.totalBytes, totalBytes) || other.totalBytes == totalBytes)&&(identical(other.percentComplete, percentComplete) || other.percentComplete == percentComplete)&&(identical(other.bytesPerSecond, bytesPerSecond) || other.bytesPerSecond == bytesPerSecond)&&(identical(other.errorsFound, errorsFound) || other.errorsFound == errorsFound)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,pool,status,startTime,estimatedEndTime,bytesProcessed,totalBytes,percentComplete,bytesPerSecond,errorsFound,description);

@override
String toString() {
  return 'PoolResilver(pool: $pool, status: $status, startTime: $startTime, estimatedEndTime: $estimatedEndTime, bytesProcessed: $bytesProcessed, totalBytes: $totalBytes, percentComplete: $percentComplete, bytesPerSecond: $bytesPerSecond, errorsFound: $errorsFound, description: $description)';
}


}

/// @nodoc
abstract mixin class _$PoolResilverCopyWith<$Res> implements $PoolResilverCopyWith<$Res> {
  factory _$PoolResilverCopyWith(_PoolResilver value, $Res Function(_PoolResilver) _then) = __$PoolResilverCopyWithImpl;
@override @useResult
$Res call({
 String pool, ResilverStatus status, DateTime? startTime, DateTime? estimatedEndTime, int? bytesProcessed, int? totalBytes, double? percentComplete, int? bytesPerSecond, int? errorsFound, String? description
});




}
/// @nodoc
class __$PoolResilverCopyWithImpl<$Res>
    implements _$PoolResilverCopyWith<$Res> {
  __$PoolResilverCopyWithImpl(this._self, this._then);

  final _PoolResilver _self;
  final $Res Function(_PoolResilver) _then;

/// Create a copy of PoolResilver
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pool = null,Object? status = null,Object? startTime = freezed,Object? estimatedEndTime = freezed,Object? bytesProcessed = freezed,Object? totalBytes = freezed,Object? percentComplete = freezed,Object? bytesPerSecond = freezed,Object? errorsFound = freezed,Object? description = freezed,}) {
  return _then(_PoolResilver(
pool: null == pool ? _self.pool : pool // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ResilverStatus,startTime: freezed == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime?,estimatedEndTime: freezed == estimatedEndTime ? _self.estimatedEndTime : estimatedEndTime // ignore: cast_nullable_to_non_nullable
as DateTime?,bytesProcessed: freezed == bytesProcessed ? _self.bytesProcessed : bytesProcessed // ignore: cast_nullable_to_non_nullable
as int?,totalBytes: freezed == totalBytes ? _self.totalBytes : totalBytes // ignore: cast_nullable_to_non_nullable
as int?,percentComplete: freezed == percentComplete ? _self.percentComplete : percentComplete // ignore: cast_nullable_to_non_nullable
as double?,bytesPerSecond: freezed == bytesPerSecond ? _self.bytesPerSecond : bytesPerSecond // ignore: cast_nullable_to_non_nullable
as int?,errorsFound: freezed == errorsFound ? _self.errorsFound : errorsFound // ignore: cast_nullable_to_non_nullable
as int?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

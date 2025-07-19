// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pool.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Pool {

 String get id; String get name; String get status; int get size; int get allocated; int get free; double get fragmentation; bool get isHealthy; String? get path; List<PoolVdev> get vdevs;
/// Create a copy of Pool
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PoolCopyWith<Pool> get copyWith => _$PoolCopyWithImpl<Pool>(this as Pool, _$identity);

  /// Serializes this Pool to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Pool&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.size, size) || other.size == size)&&(identical(other.allocated, allocated) || other.allocated == allocated)&&(identical(other.free, free) || other.free == free)&&(identical(other.fragmentation, fragmentation) || other.fragmentation == fragmentation)&&(identical(other.isHealthy, isHealthy) || other.isHealthy == isHealthy)&&(identical(other.path, path) || other.path == path)&&const DeepCollectionEquality().equals(other.vdevs, vdevs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,status,size,allocated,free,fragmentation,isHealthy,path,const DeepCollectionEquality().hash(vdevs));

@override
String toString() {
  return 'Pool(id: $id, name: $name, status: $status, size: $size, allocated: $allocated, free: $free, fragmentation: $fragmentation, isHealthy: $isHealthy, path: $path, vdevs: $vdevs)';
}


}

/// @nodoc
abstract mixin class $PoolCopyWith<$Res>  {
  factory $PoolCopyWith(Pool value, $Res Function(Pool) _then) = _$PoolCopyWithImpl;
@useResult
$Res call({
 String id, String name, String status, int size, int allocated, int free, double fragmentation, bool isHealthy, String? path, List<PoolVdev> vdevs
});




}
/// @nodoc
class _$PoolCopyWithImpl<$Res>
    implements $PoolCopyWith<$Res> {
  _$PoolCopyWithImpl(this._self, this._then);

  final Pool _self;
  final $Res Function(Pool) _then;

/// Create a copy of Pool
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? status = null,Object? size = null,Object? allocated = null,Object? free = null,Object? fragmentation = null,Object? isHealthy = null,Object? path = freezed,Object? vdevs = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,allocated: null == allocated ? _self.allocated : allocated // ignore: cast_nullable_to_non_nullable
as int,free: null == free ? _self.free : free // ignore: cast_nullable_to_non_nullable
as int,fragmentation: null == fragmentation ? _self.fragmentation : fragmentation // ignore: cast_nullable_to_non_nullable
as double,isHealthy: null == isHealthy ? _self.isHealthy : isHealthy // ignore: cast_nullable_to_non_nullable
as bool,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,vdevs: null == vdevs ? _self.vdevs : vdevs // ignore: cast_nullable_to_non_nullable
as List<PoolVdev>,
  ));
}

}


/// Adds pattern-matching-related methods to [Pool].
extension PoolPatterns on Pool {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Pool value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Pool() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Pool value)  $default,){
final _that = this;
switch (_that) {
case _Pool():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Pool value)?  $default,){
final _that = this;
switch (_that) {
case _Pool() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String status,  int size,  int allocated,  int free,  double fragmentation,  bool isHealthy,  String? path,  List<PoolVdev> vdevs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Pool() when $default != null:
return $default(_that.id,_that.name,_that.status,_that.size,_that.allocated,_that.free,_that.fragmentation,_that.isHealthy,_that.path,_that.vdevs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String status,  int size,  int allocated,  int free,  double fragmentation,  bool isHealthy,  String? path,  List<PoolVdev> vdevs)  $default,) {final _that = this;
switch (_that) {
case _Pool():
return $default(_that.id,_that.name,_that.status,_that.size,_that.allocated,_that.free,_that.fragmentation,_that.isHealthy,_that.path,_that.vdevs);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String status,  int size,  int allocated,  int free,  double fragmentation,  bool isHealthy,  String? path,  List<PoolVdev> vdevs)?  $default,) {final _that = this;
switch (_that) {
case _Pool() when $default != null:
return $default(_that.id,_that.name,_that.status,_that.size,_that.allocated,_that.free,_that.fragmentation,_that.isHealthy,_that.path,_that.vdevs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Pool implements Pool {
  const _Pool({required this.id, required this.name, required this.status, required this.size, required this.allocated, required this.free, required this.fragmentation, required this.isHealthy, this.path, final  List<PoolVdev> vdevs = const []}): _vdevs = vdevs;
  factory _Pool.fromJson(Map<String, dynamic> json) => _$PoolFromJson(json);

@override final  String id;
@override final  String name;
@override final  String status;
@override final  int size;
@override final  int allocated;
@override final  int free;
@override final  double fragmentation;
@override final  bool isHealthy;
@override final  String? path;
 final  List<PoolVdev> _vdevs;
@override@JsonKey() List<PoolVdev> get vdevs {
  if (_vdevs is EqualUnmodifiableListView) return _vdevs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_vdevs);
}


/// Create a copy of Pool
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PoolCopyWith<_Pool> get copyWith => __$PoolCopyWithImpl<_Pool>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PoolToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Pool&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.status, status) || other.status == status)&&(identical(other.size, size) || other.size == size)&&(identical(other.allocated, allocated) || other.allocated == allocated)&&(identical(other.free, free) || other.free == free)&&(identical(other.fragmentation, fragmentation) || other.fragmentation == fragmentation)&&(identical(other.isHealthy, isHealthy) || other.isHealthy == isHealthy)&&(identical(other.path, path) || other.path == path)&&const DeepCollectionEquality().equals(other._vdevs, _vdevs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,status,size,allocated,free,fragmentation,isHealthy,path,const DeepCollectionEquality().hash(_vdevs));

@override
String toString() {
  return 'Pool(id: $id, name: $name, status: $status, size: $size, allocated: $allocated, free: $free, fragmentation: $fragmentation, isHealthy: $isHealthy, path: $path, vdevs: $vdevs)';
}


}

/// @nodoc
abstract mixin class _$PoolCopyWith<$Res> implements $PoolCopyWith<$Res> {
  factory _$PoolCopyWith(_Pool value, $Res Function(_Pool) _then) = __$PoolCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String status, int size, int allocated, int free, double fragmentation, bool isHealthy, String? path, List<PoolVdev> vdevs
});




}
/// @nodoc
class __$PoolCopyWithImpl<$Res>
    implements _$PoolCopyWith<$Res> {
  __$PoolCopyWithImpl(this._self, this._then);

  final _Pool _self;
  final $Res Function(_Pool) _then;

/// Create a copy of Pool
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? status = null,Object? size = null,Object? allocated = null,Object? free = null,Object? fragmentation = null,Object? isHealthy = null,Object? path = freezed,Object? vdevs = null,}) {
  return _then(_Pool(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,allocated: null == allocated ? _self.allocated : allocated // ignore: cast_nullable_to_non_nullable
as int,free: null == free ? _self.free : free // ignore: cast_nullable_to_non_nullable
as int,fragmentation: null == fragmentation ? _self.fragmentation : fragmentation // ignore: cast_nullable_to_non_nullable
as double,isHealthy: null == isHealthy ? _self.isHealthy : isHealthy // ignore: cast_nullable_to_non_nullable
as bool,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,vdevs: null == vdevs ? _self._vdevs : vdevs // ignore: cast_nullable_to_non_nullable
as List<PoolVdev>,
  ));
}


}


/// @nodoc
mixin _$PoolVdev {

 String get type; String get status; List<String> get disks;
/// Create a copy of PoolVdev
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PoolVdevCopyWith<PoolVdev> get copyWith => _$PoolVdevCopyWithImpl<PoolVdev>(this as PoolVdev, _$identity);

  /// Serializes this PoolVdev to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PoolVdev&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.disks, disks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,status,const DeepCollectionEquality().hash(disks));

@override
String toString() {
  return 'PoolVdev(type: $type, status: $status, disks: $disks)';
}


}

/// @nodoc
abstract mixin class $PoolVdevCopyWith<$Res>  {
  factory $PoolVdevCopyWith(PoolVdev value, $Res Function(PoolVdev) _then) = _$PoolVdevCopyWithImpl;
@useResult
$Res call({
 String type, String status, List<String> disks
});




}
/// @nodoc
class _$PoolVdevCopyWithImpl<$Res>
    implements $PoolVdevCopyWith<$Res> {
  _$PoolVdevCopyWithImpl(this._self, this._then);

  final PoolVdev _self;
  final $Res Function(PoolVdev) _then;

/// Create a copy of PoolVdev
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? status = null,Object? disks = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,disks: null == disks ? _self.disks : disks // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [PoolVdev].
extension PoolVdevPatterns on PoolVdev {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PoolVdev value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PoolVdev() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PoolVdev value)  $default,){
final _that = this;
switch (_that) {
case _PoolVdev():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PoolVdev value)?  $default,){
final _that = this;
switch (_that) {
case _PoolVdev() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String status,  List<String> disks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PoolVdev() when $default != null:
return $default(_that.type,_that.status,_that.disks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String status,  List<String> disks)  $default,) {final _that = this;
switch (_that) {
case _PoolVdev():
return $default(_that.type,_that.status,_that.disks);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String status,  List<String> disks)?  $default,) {final _that = this;
switch (_that) {
case _PoolVdev() when $default != null:
return $default(_that.type,_that.status,_that.disks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PoolVdev implements PoolVdev {
  const _PoolVdev({required this.type, required this.status, final  List<String> disks = const []}): _disks = disks;
  factory _PoolVdev.fromJson(Map<String, dynamic> json) => _$PoolVdevFromJson(json);

@override final  String type;
@override final  String status;
 final  List<String> _disks;
@override@JsonKey() List<String> get disks {
  if (_disks is EqualUnmodifiableListView) return _disks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_disks);
}


/// Create a copy of PoolVdev
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PoolVdevCopyWith<_PoolVdev> get copyWith => __$PoolVdevCopyWithImpl<_PoolVdev>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PoolVdevToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PoolVdev&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._disks, _disks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,status,const DeepCollectionEquality().hash(_disks));

@override
String toString() {
  return 'PoolVdev(type: $type, status: $status, disks: $disks)';
}


}

/// @nodoc
abstract mixin class _$PoolVdevCopyWith<$Res> implements $PoolVdevCopyWith<$Res> {
  factory _$PoolVdevCopyWith(_PoolVdev value, $Res Function(_PoolVdev) _then) = __$PoolVdevCopyWithImpl;
@override @useResult
$Res call({
 String type, String status, List<String> disks
});




}
/// @nodoc
class __$PoolVdevCopyWithImpl<$Res>
    implements _$PoolVdevCopyWith<$Res> {
  __$PoolVdevCopyWithImpl(this._self, this._then);

  final _PoolVdev _self;
  final $Res Function(_PoolVdev) _then;

/// Create a copy of PoolVdev
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? status = null,Object? disks = null,}) {
  return _then(_PoolVdev(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,disks: null == disks ? _self._disks : disks // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'share.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Share {

 String get id; String get name; String get path; ShareType get type; bool get enabled; String? get comment; Map<String, dynamic>? get config;
/// Create a copy of Share
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShareCopyWith<Share> get copyWith => _$ShareCopyWithImpl<Share>(this as Share, _$identity);

  /// Serializes this Share to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Share&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.path, path) || other.path == path)&&(identical(other.type, type) || other.type == type)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.comment, comment) || other.comment == comment)&&const DeepCollectionEquality().equals(other.config, config));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,path,type,enabled,comment,const DeepCollectionEquality().hash(config));

@override
String toString() {
  return 'Share(id: $id, name: $name, path: $path, type: $type, enabled: $enabled, comment: $comment, config: $config)';
}


}

/// @nodoc
abstract mixin class $ShareCopyWith<$Res>  {
  factory $ShareCopyWith(Share value, $Res Function(Share) _then) = _$ShareCopyWithImpl;
@useResult
$Res call({
 String id, String name, String path, ShareType type, bool enabled, String? comment, Map<String, dynamic>? config
});




}
/// @nodoc
class _$ShareCopyWithImpl<$Res>
    implements $ShareCopyWith<$Res> {
  _$ShareCopyWithImpl(this._self, this._then);

  final Share _self;
  final $Res Function(Share) _then;

/// Create a copy of Share
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? path = null,Object? type = null,Object? enabled = null,Object? comment = freezed,Object? config = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ShareType,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,config: freezed == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [Share].
extension SharePatterns on Share {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Share value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Share() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Share value)  $default,){
final _that = this;
switch (_that) {
case _Share():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Share value)?  $default,){
final _that = this;
switch (_that) {
case _Share() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String path,  ShareType type,  bool enabled,  String? comment,  Map<String, dynamic>? config)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Share() when $default != null:
return $default(_that.id,_that.name,_that.path,_that.type,_that.enabled,_that.comment,_that.config);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String path,  ShareType type,  bool enabled,  String? comment,  Map<String, dynamic>? config)  $default,) {final _that = this;
switch (_that) {
case _Share():
return $default(_that.id,_that.name,_that.path,_that.type,_that.enabled,_that.comment,_that.config);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String path,  ShareType type,  bool enabled,  String? comment,  Map<String, dynamic>? config)?  $default,) {final _that = this;
switch (_that) {
case _Share() when $default != null:
return $default(_that.id,_that.name,_that.path,_that.type,_that.enabled,_that.comment,_that.config);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Share implements Share {
  const _Share({required this.id, required this.name, required this.path, required this.type, required this.enabled, this.comment, final  Map<String, dynamic>? config}): _config = config;
  factory _Share.fromJson(Map<String, dynamic> json) => _$ShareFromJson(json);

@override final  String id;
@override final  String name;
@override final  String path;
@override final  ShareType type;
@override final  bool enabled;
@override final  String? comment;
 final  Map<String, dynamic>? _config;
@override Map<String, dynamic>? get config {
  final value = _config;
  if (value == null) return null;
  if (_config is EqualUnmodifiableMapView) return _config;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of Share
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShareCopyWith<_Share> get copyWith => __$ShareCopyWithImpl<_Share>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShareToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Share&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.path, path) || other.path == path)&&(identical(other.type, type) || other.type == type)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.comment, comment) || other.comment == comment)&&const DeepCollectionEquality().equals(other._config, _config));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,path,type,enabled,comment,const DeepCollectionEquality().hash(_config));

@override
String toString() {
  return 'Share(id: $id, name: $name, path: $path, type: $type, enabled: $enabled, comment: $comment, config: $config)';
}


}

/// @nodoc
abstract mixin class _$ShareCopyWith<$Res> implements $ShareCopyWith<$Res> {
  factory _$ShareCopyWith(_Share value, $Res Function(_Share) _then) = __$ShareCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String path, ShareType type, bool enabled, String? comment, Map<String, dynamic>? config
});




}
/// @nodoc
class __$ShareCopyWithImpl<$Res>
    implements _$ShareCopyWith<$Res> {
  __$ShareCopyWithImpl(this._self, this._then);

  final _Share _self;
  final $Res Function(_Share) _then;

/// Create a copy of Share
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? path = null,Object? type = null,Object? enabled = null,Object? comment = freezed,Object? config = freezed,}) {
  return _then(_Share(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ShareType,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,config: freezed == config ? _self._config : config // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on

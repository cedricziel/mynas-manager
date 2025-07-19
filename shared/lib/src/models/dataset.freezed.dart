// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dataset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Dataset {

 String get id; String get name; String get pool; String get type; int get used; int get available; int get referenced; String get mountpoint; bool get encrypted; List<String> get children; Map<String, dynamic>? get properties;
/// Create a copy of Dataset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DatasetCopyWith<Dataset> get copyWith => _$DatasetCopyWithImpl<Dataset>(this as Dataset, _$identity);

  /// Serializes this Dataset to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Dataset&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.pool, pool) || other.pool == pool)&&(identical(other.type, type) || other.type == type)&&(identical(other.used, used) || other.used == used)&&(identical(other.available, available) || other.available == available)&&(identical(other.referenced, referenced) || other.referenced == referenced)&&(identical(other.mountpoint, mountpoint) || other.mountpoint == mountpoint)&&(identical(other.encrypted, encrypted) || other.encrypted == encrypted)&&const DeepCollectionEquality().equals(other.children, children)&&const DeepCollectionEquality().equals(other.properties, properties));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,pool,type,used,available,referenced,mountpoint,encrypted,const DeepCollectionEquality().hash(children),const DeepCollectionEquality().hash(properties));

@override
String toString() {
  return 'Dataset(id: $id, name: $name, pool: $pool, type: $type, used: $used, available: $available, referenced: $referenced, mountpoint: $mountpoint, encrypted: $encrypted, children: $children, properties: $properties)';
}


}

/// @nodoc
abstract mixin class $DatasetCopyWith<$Res>  {
  factory $DatasetCopyWith(Dataset value, $Res Function(Dataset) _then) = _$DatasetCopyWithImpl;
@useResult
$Res call({
 String id, String name, String pool, String type, int used, int available, int referenced, String mountpoint, bool encrypted, List<String> children, Map<String, dynamic>? properties
});




}
/// @nodoc
class _$DatasetCopyWithImpl<$Res>
    implements $DatasetCopyWith<$Res> {
  _$DatasetCopyWithImpl(this._self, this._then);

  final Dataset _self;
  final $Res Function(Dataset) _then;

/// Create a copy of Dataset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? pool = null,Object? type = null,Object? used = null,Object? available = null,Object? referenced = null,Object? mountpoint = null,Object? encrypted = null,Object? children = null,Object? properties = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,pool: null == pool ? _self.pool : pool // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as int,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as int,referenced: null == referenced ? _self.referenced : referenced // ignore: cast_nullable_to_non_nullable
as int,mountpoint: null == mountpoint ? _self.mountpoint : mountpoint // ignore: cast_nullable_to_non_nullable
as String,encrypted: null == encrypted ? _self.encrypted : encrypted // ignore: cast_nullable_to_non_nullable
as bool,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<String>,properties: freezed == properties ? _self.properties : properties // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [Dataset].
extension DatasetPatterns on Dataset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Dataset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Dataset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Dataset value)  $default,){
final _that = this;
switch (_that) {
case _Dataset():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Dataset value)?  $default,){
final _that = this;
switch (_that) {
case _Dataset() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String pool,  String type,  int used,  int available,  int referenced,  String mountpoint,  bool encrypted,  List<String> children,  Map<String, dynamic>? properties)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Dataset() when $default != null:
return $default(_that.id,_that.name,_that.pool,_that.type,_that.used,_that.available,_that.referenced,_that.mountpoint,_that.encrypted,_that.children,_that.properties);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String pool,  String type,  int used,  int available,  int referenced,  String mountpoint,  bool encrypted,  List<String> children,  Map<String, dynamic>? properties)  $default,) {final _that = this;
switch (_that) {
case _Dataset():
return $default(_that.id,_that.name,_that.pool,_that.type,_that.used,_that.available,_that.referenced,_that.mountpoint,_that.encrypted,_that.children,_that.properties);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String pool,  String type,  int used,  int available,  int referenced,  String mountpoint,  bool encrypted,  List<String> children,  Map<String, dynamic>? properties)?  $default,) {final _that = this;
switch (_that) {
case _Dataset() when $default != null:
return $default(_that.id,_that.name,_that.pool,_that.type,_that.used,_that.available,_that.referenced,_that.mountpoint,_that.encrypted,_that.children,_that.properties);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Dataset implements Dataset {
  const _Dataset({required this.id, required this.name, required this.pool, required this.type, required this.used, required this.available, required this.referenced, required this.mountpoint, this.encrypted = false, final  List<String> children = const [], final  Map<String, dynamic>? properties}): _children = children,_properties = properties;
  factory _Dataset.fromJson(Map<String, dynamic> json) => _$DatasetFromJson(json);

@override final  String id;
@override final  String name;
@override final  String pool;
@override final  String type;
@override final  int used;
@override final  int available;
@override final  int referenced;
@override final  String mountpoint;
@override@JsonKey() final  bool encrypted;
 final  List<String> _children;
@override@JsonKey() List<String> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}

 final  Map<String, dynamic>? _properties;
@override Map<String, dynamic>? get properties {
  final value = _properties;
  if (value == null) return null;
  if (_properties is EqualUnmodifiableMapView) return _properties;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of Dataset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DatasetCopyWith<_Dataset> get copyWith => __$DatasetCopyWithImpl<_Dataset>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DatasetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Dataset&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.pool, pool) || other.pool == pool)&&(identical(other.type, type) || other.type == type)&&(identical(other.used, used) || other.used == used)&&(identical(other.available, available) || other.available == available)&&(identical(other.referenced, referenced) || other.referenced == referenced)&&(identical(other.mountpoint, mountpoint) || other.mountpoint == mountpoint)&&(identical(other.encrypted, encrypted) || other.encrypted == encrypted)&&const DeepCollectionEquality().equals(other._children, _children)&&const DeepCollectionEquality().equals(other._properties, _properties));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,pool,type,used,available,referenced,mountpoint,encrypted,const DeepCollectionEquality().hash(_children),const DeepCollectionEquality().hash(_properties));

@override
String toString() {
  return 'Dataset(id: $id, name: $name, pool: $pool, type: $type, used: $used, available: $available, referenced: $referenced, mountpoint: $mountpoint, encrypted: $encrypted, children: $children, properties: $properties)';
}


}

/// @nodoc
abstract mixin class _$DatasetCopyWith<$Res> implements $DatasetCopyWith<$Res> {
  factory _$DatasetCopyWith(_Dataset value, $Res Function(_Dataset) _then) = __$DatasetCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String pool, String type, int used, int available, int referenced, String mountpoint, bool encrypted, List<String> children, Map<String, dynamic>? properties
});




}
/// @nodoc
class __$DatasetCopyWithImpl<$Res>
    implements _$DatasetCopyWith<$Res> {
  __$DatasetCopyWithImpl(this._self, this._then);

  final _Dataset _self;
  final $Res Function(_Dataset) _then;

/// Create a copy of Dataset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? pool = null,Object? type = null,Object? used = null,Object? available = null,Object? referenced = null,Object? mountpoint = null,Object? encrypted = null,Object? children = null,Object? properties = freezed,}) {
  return _then(_Dataset(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,pool: null == pool ? _self.pool : pool // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as int,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as int,referenced: null == referenced ? _self.referenced : referenced // ignore: cast_nullable_to_non_nullable
as int,mountpoint: null == mountpoint ? _self.mountpoint : mountpoint // ignore: cast_nullable_to_non_nullable
as String,encrypted: null == encrypted ? _self.encrypted : encrypted // ignore: cast_nullable_to_non_nullable
as bool,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<String>,properties: freezed == properties ? _self._properties : properties // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Snapshot {

 String get id; String get name; String get dataset; String get pool; DateTime get created; int get used; int get referenced; String? get description; Map<String, dynamic>? get properties;
/// Create a copy of Snapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SnapshotCopyWith<Snapshot> get copyWith => _$SnapshotCopyWithImpl<Snapshot>(this as Snapshot, _$identity);

  /// Serializes this Snapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Snapshot&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.dataset, dataset) || other.dataset == dataset)&&(identical(other.pool, pool) || other.pool == pool)&&(identical(other.created, created) || other.created == created)&&(identical(other.used, used) || other.used == used)&&(identical(other.referenced, referenced) || other.referenced == referenced)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.properties, properties));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,dataset,pool,created,used,referenced,description,const DeepCollectionEquality().hash(properties));

@override
String toString() {
  return 'Snapshot(id: $id, name: $name, dataset: $dataset, pool: $pool, created: $created, used: $used, referenced: $referenced, description: $description, properties: $properties)';
}


}

/// @nodoc
abstract mixin class $SnapshotCopyWith<$Res>  {
  factory $SnapshotCopyWith(Snapshot value, $Res Function(Snapshot) _then) = _$SnapshotCopyWithImpl;
@useResult
$Res call({
 String id, String name, String dataset, String pool, DateTime created, int used, int referenced, String? description, Map<String, dynamic>? properties
});




}
/// @nodoc
class _$SnapshotCopyWithImpl<$Res>
    implements $SnapshotCopyWith<$Res> {
  _$SnapshotCopyWithImpl(this._self, this._then);

  final Snapshot _self;
  final $Res Function(Snapshot) _then;

/// Create a copy of Snapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? dataset = null,Object? pool = null,Object? created = null,Object? used = null,Object? referenced = null,Object? description = freezed,Object? properties = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dataset: null == dataset ? _self.dataset : dataset // ignore: cast_nullable_to_non_nullable
as String,pool: null == pool ? _self.pool : pool // ignore: cast_nullable_to_non_nullable
as String,created: null == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as DateTime,used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as int,referenced: null == referenced ? _self.referenced : referenced // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,properties: freezed == properties ? _self.properties : properties // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [Snapshot].
extension SnapshotPatterns on Snapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Snapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Snapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Snapshot value)  $default,){
final _that = this;
switch (_that) {
case _Snapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Snapshot value)?  $default,){
final _that = this;
switch (_that) {
case _Snapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String dataset,  String pool,  DateTime created,  int used,  int referenced,  String? description,  Map<String, dynamic>? properties)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Snapshot() when $default != null:
return $default(_that.id,_that.name,_that.dataset,_that.pool,_that.created,_that.used,_that.referenced,_that.description,_that.properties);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String dataset,  String pool,  DateTime created,  int used,  int referenced,  String? description,  Map<String, dynamic>? properties)  $default,) {final _that = this;
switch (_that) {
case _Snapshot():
return $default(_that.id,_that.name,_that.dataset,_that.pool,_that.created,_that.used,_that.referenced,_that.description,_that.properties);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String dataset,  String pool,  DateTime created,  int used,  int referenced,  String? description,  Map<String, dynamic>? properties)?  $default,) {final _that = this;
switch (_that) {
case _Snapshot() when $default != null:
return $default(_that.id,_that.name,_that.dataset,_that.pool,_that.created,_that.used,_that.referenced,_that.description,_that.properties);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Snapshot implements Snapshot {
  const _Snapshot({required this.id, required this.name, required this.dataset, required this.pool, required this.created, required this.used, required this.referenced, this.description, final  Map<String, dynamic>? properties}): _properties = properties;
  factory _Snapshot.fromJson(Map<String, dynamic> json) => _$SnapshotFromJson(json);

@override final  String id;
@override final  String name;
@override final  String dataset;
@override final  String pool;
@override final  DateTime created;
@override final  int used;
@override final  int referenced;
@override final  String? description;
 final  Map<String, dynamic>? _properties;
@override Map<String, dynamic>? get properties {
  final value = _properties;
  if (value == null) return null;
  if (_properties is EqualUnmodifiableMapView) return _properties;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of Snapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SnapshotCopyWith<_Snapshot> get copyWith => __$SnapshotCopyWithImpl<_Snapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Snapshot&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.dataset, dataset) || other.dataset == dataset)&&(identical(other.pool, pool) || other.pool == pool)&&(identical(other.created, created) || other.created == created)&&(identical(other.used, used) || other.used == used)&&(identical(other.referenced, referenced) || other.referenced == referenced)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._properties, _properties));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,dataset,pool,created,used,referenced,description,const DeepCollectionEquality().hash(_properties));

@override
String toString() {
  return 'Snapshot(id: $id, name: $name, dataset: $dataset, pool: $pool, created: $created, used: $used, referenced: $referenced, description: $description, properties: $properties)';
}


}

/// @nodoc
abstract mixin class _$SnapshotCopyWith<$Res> implements $SnapshotCopyWith<$Res> {
  factory _$SnapshotCopyWith(_Snapshot value, $Res Function(_Snapshot) _then) = __$SnapshotCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String dataset, String pool, DateTime created, int used, int referenced, String? description, Map<String, dynamic>? properties
});




}
/// @nodoc
class __$SnapshotCopyWithImpl<$Res>
    implements _$SnapshotCopyWith<$Res> {
  __$SnapshotCopyWithImpl(this._self, this._then);

  final _Snapshot _self;
  final $Res Function(_Snapshot) _then;

/// Create a copy of Snapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? dataset = null,Object? pool = null,Object? created = null,Object? used = null,Object? referenced = null,Object? description = freezed,Object? properties = freezed,}) {
  return _then(_Snapshot(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dataset: null == dataset ? _self.dataset : dataset // ignore: cast_nullable_to_non_nullable
as String,pool: null == pool ? _self.pool : pool // ignore: cast_nullable_to_non_nullable
as String,created: null == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as DateTime,used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as int,referenced: null == referenced ? _self.referenced : referenced // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,properties: freezed == properties ? _self._properties : properties // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}


/// @nodoc
mixin _$SnapshotTask {

 String get id; String get dataset; String get namingSchema; String get schedule;// cron expression
 bool get enabled; bool get recursive; bool get excludeEmpty; int get lifetimeValue; String get lifetimeUnit;// HOUR, DAY, WEEK, MONTH, YEAR
 DateTime? get nextRun; DateTime? get lastRun; int get keepCount; Map<String, dynamic>? get options;
/// Create a copy of SnapshotTask
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SnapshotTaskCopyWith<SnapshotTask> get copyWith => _$SnapshotTaskCopyWithImpl<SnapshotTask>(this as SnapshotTask, _$identity);

  /// Serializes this SnapshotTask to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SnapshotTask&&(identical(other.id, id) || other.id == id)&&(identical(other.dataset, dataset) || other.dataset == dataset)&&(identical(other.namingSchema, namingSchema) || other.namingSchema == namingSchema)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.recursive, recursive) || other.recursive == recursive)&&(identical(other.excludeEmpty, excludeEmpty) || other.excludeEmpty == excludeEmpty)&&(identical(other.lifetimeValue, lifetimeValue) || other.lifetimeValue == lifetimeValue)&&(identical(other.lifetimeUnit, lifetimeUnit) || other.lifetimeUnit == lifetimeUnit)&&(identical(other.nextRun, nextRun) || other.nextRun == nextRun)&&(identical(other.lastRun, lastRun) || other.lastRun == lastRun)&&(identical(other.keepCount, keepCount) || other.keepCount == keepCount)&&const DeepCollectionEquality().equals(other.options, options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,dataset,namingSchema,schedule,enabled,recursive,excludeEmpty,lifetimeValue,lifetimeUnit,nextRun,lastRun,keepCount,const DeepCollectionEquality().hash(options));

@override
String toString() {
  return 'SnapshotTask(id: $id, dataset: $dataset, namingSchema: $namingSchema, schedule: $schedule, enabled: $enabled, recursive: $recursive, excludeEmpty: $excludeEmpty, lifetimeValue: $lifetimeValue, lifetimeUnit: $lifetimeUnit, nextRun: $nextRun, lastRun: $lastRun, keepCount: $keepCount, options: $options)';
}


}

/// @nodoc
abstract mixin class $SnapshotTaskCopyWith<$Res>  {
  factory $SnapshotTaskCopyWith(SnapshotTask value, $Res Function(SnapshotTask) _then) = _$SnapshotTaskCopyWithImpl;
@useResult
$Res call({
 String id, String dataset, String namingSchema, String schedule, bool enabled, bool recursive, bool excludeEmpty, int lifetimeValue, String lifetimeUnit, DateTime? nextRun, DateTime? lastRun, int keepCount, Map<String, dynamic>? options
});




}
/// @nodoc
class _$SnapshotTaskCopyWithImpl<$Res>
    implements $SnapshotTaskCopyWith<$Res> {
  _$SnapshotTaskCopyWithImpl(this._self, this._then);

  final SnapshotTask _self;
  final $Res Function(SnapshotTask) _then;

/// Create a copy of SnapshotTask
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? dataset = null,Object? namingSchema = null,Object? schedule = null,Object? enabled = null,Object? recursive = null,Object? excludeEmpty = null,Object? lifetimeValue = null,Object? lifetimeUnit = null,Object? nextRun = freezed,Object? lastRun = freezed,Object? keepCount = null,Object? options = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dataset: null == dataset ? _self.dataset : dataset // ignore: cast_nullable_to_non_nullable
as String,namingSchema: null == namingSchema ? _self.namingSchema : namingSchema // ignore: cast_nullable_to_non_nullable
as String,schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,recursive: null == recursive ? _self.recursive : recursive // ignore: cast_nullable_to_non_nullable
as bool,excludeEmpty: null == excludeEmpty ? _self.excludeEmpty : excludeEmpty // ignore: cast_nullable_to_non_nullable
as bool,lifetimeValue: null == lifetimeValue ? _self.lifetimeValue : lifetimeValue // ignore: cast_nullable_to_non_nullable
as int,lifetimeUnit: null == lifetimeUnit ? _self.lifetimeUnit : lifetimeUnit // ignore: cast_nullable_to_non_nullable
as String,nextRun: freezed == nextRun ? _self.nextRun : nextRun // ignore: cast_nullable_to_non_nullable
as DateTime?,lastRun: freezed == lastRun ? _self.lastRun : lastRun // ignore: cast_nullable_to_non_nullable
as DateTime?,keepCount: null == keepCount ? _self.keepCount : keepCount // ignore: cast_nullable_to_non_nullable
as int,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}

}


/// Adds pattern-matching-related methods to [SnapshotTask].
extension SnapshotTaskPatterns on SnapshotTask {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SnapshotTask value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SnapshotTask() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SnapshotTask value)  $default,){
final _that = this;
switch (_that) {
case _SnapshotTask():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SnapshotTask value)?  $default,){
final _that = this;
switch (_that) {
case _SnapshotTask() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String dataset,  String namingSchema,  String schedule,  bool enabled,  bool recursive,  bool excludeEmpty,  int lifetimeValue,  String lifetimeUnit,  DateTime? nextRun,  DateTime? lastRun,  int keepCount,  Map<String, dynamic>? options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SnapshotTask() when $default != null:
return $default(_that.id,_that.dataset,_that.namingSchema,_that.schedule,_that.enabled,_that.recursive,_that.excludeEmpty,_that.lifetimeValue,_that.lifetimeUnit,_that.nextRun,_that.lastRun,_that.keepCount,_that.options);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String dataset,  String namingSchema,  String schedule,  bool enabled,  bool recursive,  bool excludeEmpty,  int lifetimeValue,  String lifetimeUnit,  DateTime? nextRun,  DateTime? lastRun,  int keepCount,  Map<String, dynamic>? options)  $default,) {final _that = this;
switch (_that) {
case _SnapshotTask():
return $default(_that.id,_that.dataset,_that.namingSchema,_that.schedule,_that.enabled,_that.recursive,_that.excludeEmpty,_that.lifetimeValue,_that.lifetimeUnit,_that.nextRun,_that.lastRun,_that.keepCount,_that.options);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String dataset,  String namingSchema,  String schedule,  bool enabled,  bool recursive,  bool excludeEmpty,  int lifetimeValue,  String lifetimeUnit,  DateTime? nextRun,  DateTime? lastRun,  int keepCount,  Map<String, dynamic>? options)?  $default,) {final _that = this;
switch (_that) {
case _SnapshotTask() when $default != null:
return $default(_that.id,_that.dataset,_that.namingSchema,_that.schedule,_that.enabled,_that.recursive,_that.excludeEmpty,_that.lifetimeValue,_that.lifetimeUnit,_that.nextRun,_that.lastRun,_that.keepCount,_that.options);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SnapshotTask implements SnapshotTask {
  const _SnapshotTask({required this.id, required this.dataset, required this.namingSchema, required this.schedule, this.enabled = true, this.recursive = false, this.excludeEmpty = false, required this.lifetimeValue, required this.lifetimeUnit, required this.nextRun, required this.lastRun, this.keepCount = 0, final  Map<String, dynamic>? options}): _options = options;
  factory _SnapshotTask.fromJson(Map<String, dynamic> json) => _$SnapshotTaskFromJson(json);

@override final  String id;
@override final  String dataset;
@override final  String namingSchema;
@override final  String schedule;
// cron expression
@override@JsonKey() final  bool enabled;
@override@JsonKey() final  bool recursive;
@override@JsonKey() final  bool excludeEmpty;
@override final  int lifetimeValue;
@override final  String lifetimeUnit;
// HOUR, DAY, WEEK, MONTH, YEAR
@override final  DateTime? nextRun;
@override final  DateTime? lastRun;
@override@JsonKey() final  int keepCount;
 final  Map<String, dynamic>? _options;
@override Map<String, dynamic>? get options {
  final value = _options;
  if (value == null) return null;
  if (_options is EqualUnmodifiableMapView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of SnapshotTask
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SnapshotTaskCopyWith<_SnapshotTask> get copyWith => __$SnapshotTaskCopyWithImpl<_SnapshotTask>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SnapshotTaskToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SnapshotTask&&(identical(other.id, id) || other.id == id)&&(identical(other.dataset, dataset) || other.dataset == dataset)&&(identical(other.namingSchema, namingSchema) || other.namingSchema == namingSchema)&&(identical(other.schedule, schedule) || other.schedule == schedule)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.recursive, recursive) || other.recursive == recursive)&&(identical(other.excludeEmpty, excludeEmpty) || other.excludeEmpty == excludeEmpty)&&(identical(other.lifetimeValue, lifetimeValue) || other.lifetimeValue == lifetimeValue)&&(identical(other.lifetimeUnit, lifetimeUnit) || other.lifetimeUnit == lifetimeUnit)&&(identical(other.nextRun, nextRun) || other.nextRun == nextRun)&&(identical(other.lastRun, lastRun) || other.lastRun == lastRun)&&(identical(other.keepCount, keepCount) || other.keepCount == keepCount)&&const DeepCollectionEquality().equals(other._options, _options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,dataset,namingSchema,schedule,enabled,recursive,excludeEmpty,lifetimeValue,lifetimeUnit,nextRun,lastRun,keepCount,const DeepCollectionEquality().hash(_options));

@override
String toString() {
  return 'SnapshotTask(id: $id, dataset: $dataset, namingSchema: $namingSchema, schedule: $schedule, enabled: $enabled, recursive: $recursive, excludeEmpty: $excludeEmpty, lifetimeValue: $lifetimeValue, lifetimeUnit: $lifetimeUnit, nextRun: $nextRun, lastRun: $lastRun, keepCount: $keepCount, options: $options)';
}


}

/// @nodoc
abstract mixin class _$SnapshotTaskCopyWith<$Res> implements $SnapshotTaskCopyWith<$Res> {
  factory _$SnapshotTaskCopyWith(_SnapshotTask value, $Res Function(_SnapshotTask) _then) = __$SnapshotTaskCopyWithImpl;
@override @useResult
$Res call({
 String id, String dataset, String namingSchema, String schedule, bool enabled, bool recursive, bool excludeEmpty, int lifetimeValue, String lifetimeUnit, DateTime? nextRun, DateTime? lastRun, int keepCount, Map<String, dynamic>? options
});




}
/// @nodoc
class __$SnapshotTaskCopyWithImpl<$Res>
    implements _$SnapshotTaskCopyWith<$Res> {
  __$SnapshotTaskCopyWithImpl(this._self, this._then);

  final _SnapshotTask _self;
  final $Res Function(_SnapshotTask) _then;

/// Create a copy of SnapshotTask
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? dataset = null,Object? namingSchema = null,Object? schedule = null,Object? enabled = null,Object? recursive = null,Object? excludeEmpty = null,Object? lifetimeValue = null,Object? lifetimeUnit = null,Object? nextRun = freezed,Object? lastRun = freezed,Object? keepCount = null,Object? options = freezed,}) {
  return _then(_SnapshotTask(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dataset: null == dataset ? _self.dataset : dataset // ignore: cast_nullable_to_non_nullable
as String,namingSchema: null == namingSchema ? _self.namingSchema : namingSchema // ignore: cast_nullable_to_non_nullable
as String,schedule: null == schedule ? _self.schedule : schedule // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,recursive: null == recursive ? _self.recursive : recursive // ignore: cast_nullable_to_non_nullable
as bool,excludeEmpty: null == excludeEmpty ? _self.excludeEmpty : excludeEmpty // ignore: cast_nullable_to_non_nullable
as bool,lifetimeValue: null == lifetimeValue ? _self.lifetimeValue : lifetimeValue // ignore: cast_nullable_to_non_nullable
as int,lifetimeUnit: null == lifetimeUnit ? _self.lifetimeUnit : lifetimeUnit // ignore: cast_nullable_to_non_nullable
as String,nextRun: freezed == nextRun ? _self.nextRun : nextRun // ignore: cast_nullable_to_non_nullable
as DateTime?,lastRun: freezed == lastRun ? _self.lastRun : lastRun // ignore: cast_nullable_to_non_nullable
as DateTime?,keepCount: null == keepCount ? _self.keepCount : keepCount // ignore: cast_nullable_to_non_nullable
as int,options: freezed == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,
  ));
}


}


/// @nodoc
mixin _$SnapshotCount {

 String get dataset; int get totalSnapshots; int get manualSnapshots; int get taskSnapshots; int get totalSize;
/// Create a copy of SnapshotCount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SnapshotCountCopyWith<SnapshotCount> get copyWith => _$SnapshotCountCopyWithImpl<SnapshotCount>(this as SnapshotCount, _$identity);

  /// Serializes this SnapshotCount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SnapshotCount&&(identical(other.dataset, dataset) || other.dataset == dataset)&&(identical(other.totalSnapshots, totalSnapshots) || other.totalSnapshots == totalSnapshots)&&(identical(other.manualSnapshots, manualSnapshots) || other.manualSnapshots == manualSnapshots)&&(identical(other.taskSnapshots, taskSnapshots) || other.taskSnapshots == taskSnapshots)&&(identical(other.totalSize, totalSize) || other.totalSize == totalSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dataset,totalSnapshots,manualSnapshots,taskSnapshots,totalSize);

@override
String toString() {
  return 'SnapshotCount(dataset: $dataset, totalSnapshots: $totalSnapshots, manualSnapshots: $manualSnapshots, taskSnapshots: $taskSnapshots, totalSize: $totalSize)';
}


}

/// @nodoc
abstract mixin class $SnapshotCountCopyWith<$Res>  {
  factory $SnapshotCountCopyWith(SnapshotCount value, $Res Function(SnapshotCount) _then) = _$SnapshotCountCopyWithImpl;
@useResult
$Res call({
 String dataset, int totalSnapshots, int manualSnapshots, int taskSnapshots, int totalSize
});




}
/// @nodoc
class _$SnapshotCountCopyWithImpl<$Res>
    implements $SnapshotCountCopyWith<$Res> {
  _$SnapshotCountCopyWithImpl(this._self, this._then);

  final SnapshotCount _self;
  final $Res Function(SnapshotCount) _then;

/// Create a copy of SnapshotCount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dataset = null,Object? totalSnapshots = null,Object? manualSnapshots = null,Object? taskSnapshots = null,Object? totalSize = null,}) {
  return _then(_self.copyWith(
dataset: null == dataset ? _self.dataset : dataset // ignore: cast_nullable_to_non_nullable
as String,totalSnapshots: null == totalSnapshots ? _self.totalSnapshots : totalSnapshots // ignore: cast_nullable_to_non_nullable
as int,manualSnapshots: null == manualSnapshots ? _self.manualSnapshots : manualSnapshots // ignore: cast_nullable_to_non_nullable
as int,taskSnapshots: null == taskSnapshots ? _self.taskSnapshots : taskSnapshots // ignore: cast_nullable_to_non_nullable
as int,totalSize: null == totalSize ? _self.totalSize : totalSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SnapshotCount].
extension SnapshotCountPatterns on SnapshotCount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SnapshotCount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SnapshotCount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SnapshotCount value)  $default,){
final _that = this;
switch (_that) {
case _SnapshotCount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SnapshotCount value)?  $default,){
final _that = this;
switch (_that) {
case _SnapshotCount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String dataset,  int totalSnapshots,  int manualSnapshots,  int taskSnapshots,  int totalSize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SnapshotCount() when $default != null:
return $default(_that.dataset,_that.totalSnapshots,_that.manualSnapshots,_that.taskSnapshots,_that.totalSize);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String dataset,  int totalSnapshots,  int manualSnapshots,  int taskSnapshots,  int totalSize)  $default,) {final _that = this;
switch (_that) {
case _SnapshotCount():
return $default(_that.dataset,_that.totalSnapshots,_that.manualSnapshots,_that.taskSnapshots,_that.totalSize);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String dataset,  int totalSnapshots,  int manualSnapshots,  int taskSnapshots,  int totalSize)?  $default,) {final _that = this;
switch (_that) {
case _SnapshotCount() when $default != null:
return $default(_that.dataset,_that.totalSnapshots,_that.manualSnapshots,_that.taskSnapshots,_that.totalSize);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SnapshotCount implements SnapshotCount {
  const _SnapshotCount({required this.dataset, required this.totalSnapshots, required this.manualSnapshots, required this.taskSnapshots, required this.totalSize});
  factory _SnapshotCount.fromJson(Map<String, dynamic> json) => _$SnapshotCountFromJson(json);

@override final  String dataset;
@override final  int totalSnapshots;
@override final  int manualSnapshots;
@override final  int taskSnapshots;
@override final  int totalSize;

/// Create a copy of SnapshotCount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SnapshotCountCopyWith<_SnapshotCount> get copyWith => __$SnapshotCountCopyWithImpl<_SnapshotCount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SnapshotCountToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SnapshotCount&&(identical(other.dataset, dataset) || other.dataset == dataset)&&(identical(other.totalSnapshots, totalSnapshots) || other.totalSnapshots == totalSnapshots)&&(identical(other.manualSnapshots, manualSnapshots) || other.manualSnapshots == manualSnapshots)&&(identical(other.taskSnapshots, taskSnapshots) || other.taskSnapshots == taskSnapshots)&&(identical(other.totalSize, totalSize) || other.totalSize == totalSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dataset,totalSnapshots,manualSnapshots,taskSnapshots,totalSize);

@override
String toString() {
  return 'SnapshotCount(dataset: $dataset, totalSnapshots: $totalSnapshots, manualSnapshots: $manualSnapshots, taskSnapshots: $taskSnapshots, totalSize: $totalSize)';
}


}

/// @nodoc
abstract mixin class _$SnapshotCountCopyWith<$Res> implements $SnapshotCountCopyWith<$Res> {
  factory _$SnapshotCountCopyWith(_SnapshotCount value, $Res Function(_SnapshotCount) _then) = __$SnapshotCountCopyWithImpl;
@override @useResult
$Res call({
 String dataset, int totalSnapshots, int manualSnapshots, int taskSnapshots, int totalSize
});




}
/// @nodoc
class __$SnapshotCountCopyWithImpl<$Res>
    implements _$SnapshotCountCopyWith<$Res> {
  __$SnapshotCountCopyWithImpl(this._self, this._then);

  final _SnapshotCount _self;
  final $Res Function(_SnapshotCount) _then;

/// Create a copy of SnapshotCount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dataset = null,Object? totalSnapshots = null,Object? manualSnapshots = null,Object? taskSnapshots = null,Object? totalSize = null,}) {
  return _then(_SnapshotCount(
dataset: null == dataset ? _self.dataset : dataset // ignore: cast_nullable_to_non_nullable
as String,totalSnapshots: null == totalSnapshots ? _self.totalSnapshots : totalSnapshots // ignore: cast_nullable_to_non_nullable
as int,manualSnapshots: null == manualSnapshots ? _self.manualSnapshots : manualSnapshots // ignore: cast_nullable_to_non_nullable
as int,taskSnapshots: null == taskSnapshots ? _self.taskSnapshots : taskSnapshots // ignore: cast_nullable_to_non_nullable
as int,totalSize: null == totalSize ? _self.totalSize : totalSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

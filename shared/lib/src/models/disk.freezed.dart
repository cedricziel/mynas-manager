// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'disk.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Disk {

 String get identifier; String get name; String? get serial; String? get lunid; int get size; String? get description; String get model; DiskType get type; String get bus; String get devname; int? get rotationrate; String? get zfsGuid; String? get pool; int get number; String get subsystem; String get transfermode; String get hddstandby; String get advpowermgmt; bool get togglesmart; String get smartoptions; int? get temperature; bool? get supportsSmart; String? get enclosure; DiskHealth get health;
/// Create a copy of Disk
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiskCopyWith<Disk> get copyWith => _$DiskCopyWithImpl<Disk>(this as Disk, _$identity);

  /// Serializes this Disk to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Disk&&(identical(other.identifier, identifier) || other.identifier == identifier)&&(identical(other.name, name) || other.name == name)&&(identical(other.serial, serial) || other.serial == serial)&&(identical(other.lunid, lunid) || other.lunid == lunid)&&(identical(other.size, size) || other.size == size)&&(identical(other.description, description) || other.description == description)&&(identical(other.model, model) || other.model == model)&&(identical(other.type, type) || other.type == type)&&(identical(other.bus, bus) || other.bus == bus)&&(identical(other.devname, devname) || other.devname == devname)&&(identical(other.rotationrate, rotationrate) || other.rotationrate == rotationrate)&&(identical(other.zfsGuid, zfsGuid) || other.zfsGuid == zfsGuid)&&(identical(other.pool, pool) || other.pool == pool)&&(identical(other.number, number) || other.number == number)&&(identical(other.subsystem, subsystem) || other.subsystem == subsystem)&&(identical(other.transfermode, transfermode) || other.transfermode == transfermode)&&(identical(other.hddstandby, hddstandby) || other.hddstandby == hddstandby)&&(identical(other.advpowermgmt, advpowermgmt) || other.advpowermgmt == advpowermgmt)&&(identical(other.togglesmart, togglesmart) || other.togglesmart == togglesmart)&&(identical(other.smartoptions, smartoptions) || other.smartoptions == smartoptions)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.supportsSmart, supportsSmart) || other.supportsSmart == supportsSmart)&&(identical(other.enclosure, enclosure) || other.enclosure == enclosure)&&(identical(other.health, health) || other.health == health));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,identifier,name,serial,lunid,size,description,model,type,bus,devname,rotationrate,zfsGuid,pool,number,subsystem,transfermode,hddstandby,advpowermgmt,togglesmart,smartoptions,temperature,supportsSmart,enclosure,health]);

@override
String toString() {
  return 'Disk(identifier: $identifier, name: $name, serial: $serial, lunid: $lunid, size: $size, description: $description, model: $model, type: $type, bus: $bus, devname: $devname, rotationrate: $rotationrate, zfsGuid: $zfsGuid, pool: $pool, number: $number, subsystem: $subsystem, transfermode: $transfermode, hddstandby: $hddstandby, advpowermgmt: $advpowermgmt, togglesmart: $togglesmart, smartoptions: $smartoptions, temperature: $temperature, supportsSmart: $supportsSmart, enclosure: $enclosure, health: $health)';
}


}

/// @nodoc
abstract mixin class $DiskCopyWith<$Res>  {
  factory $DiskCopyWith(Disk value, $Res Function(Disk) _then) = _$DiskCopyWithImpl;
@useResult
$Res call({
 String identifier, String name, String? serial, String? lunid, int size, String? description, String model, DiskType type, String bus, String devname, int? rotationrate, String? zfsGuid, String? pool, int number, String subsystem, String transfermode, String hddstandby, String advpowermgmt, bool togglesmart, String smartoptions, int? temperature, bool? supportsSmart, String? enclosure, DiskHealth health
});




}
/// @nodoc
class _$DiskCopyWithImpl<$Res>
    implements $DiskCopyWith<$Res> {
  _$DiskCopyWithImpl(this._self, this._then);

  final Disk _self;
  final $Res Function(Disk) _then;

/// Create a copy of Disk
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? identifier = null,Object? name = null,Object? serial = freezed,Object? lunid = freezed,Object? size = null,Object? description = freezed,Object? model = null,Object? type = null,Object? bus = null,Object? devname = null,Object? rotationrate = freezed,Object? zfsGuid = freezed,Object? pool = freezed,Object? number = null,Object? subsystem = null,Object? transfermode = null,Object? hddstandby = null,Object? advpowermgmt = null,Object? togglesmart = null,Object? smartoptions = null,Object? temperature = freezed,Object? supportsSmart = freezed,Object? enclosure = freezed,Object? health = null,}) {
  return _then(_self.copyWith(
identifier: null == identifier ? _self.identifier : identifier // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,serial: freezed == serial ? _self.serial : serial // ignore: cast_nullable_to_non_nullable
as String?,lunid: freezed == lunid ? _self.lunid : lunid // ignore: cast_nullable_to_non_nullable
as String?,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DiskType,bus: null == bus ? _self.bus : bus // ignore: cast_nullable_to_non_nullable
as String,devname: null == devname ? _self.devname : devname // ignore: cast_nullable_to_non_nullable
as String,rotationrate: freezed == rotationrate ? _self.rotationrate : rotationrate // ignore: cast_nullable_to_non_nullable
as int?,zfsGuid: freezed == zfsGuid ? _self.zfsGuid : zfsGuid // ignore: cast_nullable_to_non_nullable
as String?,pool: freezed == pool ? _self.pool : pool // ignore: cast_nullable_to_non_nullable
as String?,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,subsystem: null == subsystem ? _self.subsystem : subsystem // ignore: cast_nullable_to_non_nullable
as String,transfermode: null == transfermode ? _self.transfermode : transfermode // ignore: cast_nullable_to_non_nullable
as String,hddstandby: null == hddstandby ? _self.hddstandby : hddstandby // ignore: cast_nullable_to_non_nullable
as String,advpowermgmt: null == advpowermgmt ? _self.advpowermgmt : advpowermgmt // ignore: cast_nullable_to_non_nullable
as String,togglesmart: null == togglesmart ? _self.togglesmart : togglesmart // ignore: cast_nullable_to_non_nullable
as bool,smartoptions: null == smartoptions ? _self.smartoptions : smartoptions // ignore: cast_nullable_to_non_nullable
as String,temperature: freezed == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as int?,supportsSmart: freezed == supportsSmart ? _self.supportsSmart : supportsSmart // ignore: cast_nullable_to_non_nullable
as bool?,enclosure: freezed == enclosure ? _self.enclosure : enclosure // ignore: cast_nullable_to_non_nullable
as String?,health: null == health ? _self.health : health // ignore: cast_nullable_to_non_nullable
as DiskHealth,
  ));
}

}


/// Adds pattern-matching-related methods to [Disk].
extension DiskPatterns on Disk {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Disk value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Disk() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Disk value)  $default,){
final _that = this;
switch (_that) {
case _Disk():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Disk value)?  $default,){
final _that = this;
switch (_that) {
case _Disk() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String identifier,  String name,  String? serial,  String? lunid,  int size,  String? description,  String model,  DiskType type,  String bus,  String devname,  int? rotationrate,  String? zfsGuid,  String? pool,  int number,  String subsystem,  String transfermode,  String hddstandby,  String advpowermgmt,  bool togglesmart,  String smartoptions,  int? temperature,  bool? supportsSmart,  String? enclosure,  DiskHealth health)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Disk() when $default != null:
return $default(_that.identifier,_that.name,_that.serial,_that.lunid,_that.size,_that.description,_that.model,_that.type,_that.bus,_that.devname,_that.rotationrate,_that.zfsGuid,_that.pool,_that.number,_that.subsystem,_that.transfermode,_that.hddstandby,_that.advpowermgmt,_that.togglesmart,_that.smartoptions,_that.temperature,_that.supportsSmart,_that.enclosure,_that.health);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String identifier,  String name,  String? serial,  String? lunid,  int size,  String? description,  String model,  DiskType type,  String bus,  String devname,  int? rotationrate,  String? zfsGuid,  String? pool,  int number,  String subsystem,  String transfermode,  String hddstandby,  String advpowermgmt,  bool togglesmart,  String smartoptions,  int? temperature,  bool? supportsSmart,  String? enclosure,  DiskHealth health)  $default,) {final _that = this;
switch (_that) {
case _Disk():
return $default(_that.identifier,_that.name,_that.serial,_that.lunid,_that.size,_that.description,_that.model,_that.type,_that.bus,_that.devname,_that.rotationrate,_that.zfsGuid,_that.pool,_that.number,_that.subsystem,_that.transfermode,_that.hddstandby,_that.advpowermgmt,_that.togglesmart,_that.smartoptions,_that.temperature,_that.supportsSmart,_that.enclosure,_that.health);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String identifier,  String name,  String? serial,  String? lunid,  int size,  String? description,  String model,  DiskType type,  String bus,  String devname,  int? rotationrate,  String? zfsGuid,  String? pool,  int number,  String subsystem,  String transfermode,  String hddstandby,  String advpowermgmt,  bool togglesmart,  String smartoptions,  int? temperature,  bool? supportsSmart,  String? enclosure,  DiskHealth health)?  $default,) {final _that = this;
switch (_that) {
case _Disk() when $default != null:
return $default(_that.identifier,_that.name,_that.serial,_that.lunid,_that.size,_that.description,_that.model,_that.type,_that.bus,_that.devname,_that.rotationrate,_that.zfsGuid,_that.pool,_that.number,_that.subsystem,_that.transfermode,_that.hddstandby,_that.advpowermgmt,_that.togglesmart,_that.smartoptions,_that.temperature,_that.supportsSmart,_that.enclosure,_that.health);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Disk implements Disk {
  const _Disk({required this.identifier, required this.name, required this.serial, required this.lunid, required this.size, required this.description, required this.model, required this.type, required this.bus, required this.devname, required this.rotationrate, required this.zfsGuid, required this.pool, required this.number, required this.subsystem, required this.transfermode, required this.hddstandby, required this.advpowermgmt, required this.togglesmart, required this.smartoptions, required this.temperature, required this.supportsSmart, this.enclosure, this.health = DiskHealth.unknown});
  factory _Disk.fromJson(Map<String, dynamic> json) => _$DiskFromJson(json);

@override final  String identifier;
@override final  String name;
@override final  String? serial;
@override final  String? lunid;
@override final  int size;
@override final  String? description;
@override final  String model;
@override final  DiskType type;
@override final  String bus;
@override final  String devname;
@override final  int? rotationrate;
@override final  String? zfsGuid;
@override final  String? pool;
@override final  int number;
@override final  String subsystem;
@override final  String transfermode;
@override final  String hddstandby;
@override final  String advpowermgmt;
@override final  bool togglesmart;
@override final  String smartoptions;
@override final  int? temperature;
@override final  bool? supportsSmart;
@override final  String? enclosure;
@override@JsonKey() final  DiskHealth health;

/// Create a copy of Disk
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiskCopyWith<_Disk> get copyWith => __$DiskCopyWithImpl<_Disk>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiskToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Disk&&(identical(other.identifier, identifier) || other.identifier == identifier)&&(identical(other.name, name) || other.name == name)&&(identical(other.serial, serial) || other.serial == serial)&&(identical(other.lunid, lunid) || other.lunid == lunid)&&(identical(other.size, size) || other.size == size)&&(identical(other.description, description) || other.description == description)&&(identical(other.model, model) || other.model == model)&&(identical(other.type, type) || other.type == type)&&(identical(other.bus, bus) || other.bus == bus)&&(identical(other.devname, devname) || other.devname == devname)&&(identical(other.rotationrate, rotationrate) || other.rotationrate == rotationrate)&&(identical(other.zfsGuid, zfsGuid) || other.zfsGuid == zfsGuid)&&(identical(other.pool, pool) || other.pool == pool)&&(identical(other.number, number) || other.number == number)&&(identical(other.subsystem, subsystem) || other.subsystem == subsystem)&&(identical(other.transfermode, transfermode) || other.transfermode == transfermode)&&(identical(other.hddstandby, hddstandby) || other.hddstandby == hddstandby)&&(identical(other.advpowermgmt, advpowermgmt) || other.advpowermgmt == advpowermgmt)&&(identical(other.togglesmart, togglesmart) || other.togglesmart == togglesmart)&&(identical(other.smartoptions, smartoptions) || other.smartoptions == smartoptions)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.supportsSmart, supportsSmart) || other.supportsSmart == supportsSmart)&&(identical(other.enclosure, enclosure) || other.enclosure == enclosure)&&(identical(other.health, health) || other.health == health));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,identifier,name,serial,lunid,size,description,model,type,bus,devname,rotationrate,zfsGuid,pool,number,subsystem,transfermode,hddstandby,advpowermgmt,togglesmart,smartoptions,temperature,supportsSmart,enclosure,health]);

@override
String toString() {
  return 'Disk(identifier: $identifier, name: $name, serial: $serial, lunid: $lunid, size: $size, description: $description, model: $model, type: $type, bus: $bus, devname: $devname, rotationrate: $rotationrate, zfsGuid: $zfsGuid, pool: $pool, number: $number, subsystem: $subsystem, transfermode: $transfermode, hddstandby: $hddstandby, advpowermgmt: $advpowermgmt, togglesmart: $togglesmart, smartoptions: $smartoptions, temperature: $temperature, supportsSmart: $supportsSmart, enclosure: $enclosure, health: $health)';
}


}

/// @nodoc
abstract mixin class _$DiskCopyWith<$Res> implements $DiskCopyWith<$Res> {
  factory _$DiskCopyWith(_Disk value, $Res Function(_Disk) _then) = __$DiskCopyWithImpl;
@override @useResult
$Res call({
 String identifier, String name, String? serial, String? lunid, int size, String? description, String model, DiskType type, String bus, String devname, int? rotationrate, String? zfsGuid, String? pool, int number, String subsystem, String transfermode, String hddstandby, String advpowermgmt, bool togglesmart, String smartoptions, int? temperature, bool? supportsSmart, String? enclosure, DiskHealth health
});




}
/// @nodoc
class __$DiskCopyWithImpl<$Res>
    implements _$DiskCopyWith<$Res> {
  __$DiskCopyWithImpl(this._self, this._then);

  final _Disk _self;
  final $Res Function(_Disk) _then;

/// Create a copy of Disk
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? identifier = null,Object? name = null,Object? serial = freezed,Object? lunid = freezed,Object? size = null,Object? description = freezed,Object? model = null,Object? type = null,Object? bus = null,Object? devname = null,Object? rotationrate = freezed,Object? zfsGuid = freezed,Object? pool = freezed,Object? number = null,Object? subsystem = null,Object? transfermode = null,Object? hddstandby = null,Object? advpowermgmt = null,Object? togglesmart = null,Object? smartoptions = null,Object? temperature = freezed,Object? supportsSmart = freezed,Object? enclosure = freezed,Object? health = null,}) {
  return _then(_Disk(
identifier: null == identifier ? _self.identifier : identifier // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,serial: freezed == serial ? _self.serial : serial // ignore: cast_nullable_to_non_nullable
as String?,lunid: freezed == lunid ? _self.lunid : lunid // ignore: cast_nullable_to_non_nullable
as String?,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DiskType,bus: null == bus ? _self.bus : bus // ignore: cast_nullable_to_non_nullable
as String,devname: null == devname ? _self.devname : devname // ignore: cast_nullable_to_non_nullable
as String,rotationrate: freezed == rotationrate ? _self.rotationrate : rotationrate // ignore: cast_nullable_to_non_nullable
as int?,zfsGuid: freezed == zfsGuid ? _self.zfsGuid : zfsGuid // ignore: cast_nullable_to_non_nullable
as String?,pool: freezed == pool ? _self.pool : pool // ignore: cast_nullable_to_non_nullable
as String?,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,subsystem: null == subsystem ? _self.subsystem : subsystem // ignore: cast_nullable_to_non_nullable
as String,transfermode: null == transfermode ? _self.transfermode : transfermode // ignore: cast_nullable_to_non_nullable
as String,hddstandby: null == hddstandby ? _self.hddstandby : hddstandby // ignore: cast_nullable_to_non_nullable
as String,advpowermgmt: null == advpowermgmt ? _self.advpowermgmt : advpowermgmt // ignore: cast_nullable_to_non_nullable
as String,togglesmart: null == togglesmart ? _self.togglesmart : togglesmart // ignore: cast_nullable_to_non_nullable
as bool,smartoptions: null == smartoptions ? _self.smartoptions : smartoptions // ignore: cast_nullable_to_non_nullable
as String,temperature: freezed == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as int?,supportsSmart: freezed == supportsSmart ? _self.supportsSmart : supportsSmart // ignore: cast_nullable_to_non_nullable
as bool?,enclosure: freezed == enclosure ? _self.enclosure : enclosure // ignore: cast_nullable_to_non_nullable
as String?,health: null == health ? _self.health : health // ignore: cast_nullable_to_non_nullable
as DiskHealth,
  ));
}


}


/// @nodoc
mixin _$DiskTemperature {

 String get diskName; int? get temperature; DateTime get timestamp;
/// Create a copy of DiskTemperature
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiskTemperatureCopyWith<DiskTemperature> get copyWith => _$DiskTemperatureCopyWithImpl<DiskTemperature>(this as DiskTemperature, _$identity);

  /// Serializes this DiskTemperature to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiskTemperature&&(identical(other.diskName, diskName) || other.diskName == diskName)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,diskName,temperature,timestamp);

@override
String toString() {
  return 'DiskTemperature(diskName: $diskName, temperature: $temperature, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $DiskTemperatureCopyWith<$Res>  {
  factory $DiskTemperatureCopyWith(DiskTemperature value, $Res Function(DiskTemperature) _then) = _$DiskTemperatureCopyWithImpl;
@useResult
$Res call({
 String diskName, int? temperature, DateTime timestamp
});




}
/// @nodoc
class _$DiskTemperatureCopyWithImpl<$Res>
    implements $DiskTemperatureCopyWith<$Res> {
  _$DiskTemperatureCopyWithImpl(this._self, this._then);

  final DiskTemperature _self;
  final $Res Function(DiskTemperature) _then;

/// Create a copy of DiskTemperature
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? diskName = null,Object? temperature = freezed,Object? timestamp = null,}) {
  return _then(_self.copyWith(
diskName: null == diskName ? _self.diskName : diskName // ignore: cast_nullable_to_non_nullable
as String,temperature: freezed == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as int?,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DiskTemperature].
extension DiskTemperaturePatterns on DiskTemperature {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiskTemperature value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiskTemperature() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiskTemperature value)  $default,){
final _that = this;
switch (_that) {
case _DiskTemperature():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiskTemperature value)?  $default,){
final _that = this;
switch (_that) {
case _DiskTemperature() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String diskName,  int? temperature,  DateTime timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiskTemperature() when $default != null:
return $default(_that.diskName,_that.temperature,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String diskName,  int? temperature,  DateTime timestamp)  $default,) {final _that = this;
switch (_that) {
case _DiskTemperature():
return $default(_that.diskName,_that.temperature,_that.timestamp);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String diskName,  int? temperature,  DateTime timestamp)?  $default,) {final _that = this;
switch (_that) {
case _DiskTemperature() when $default != null:
return $default(_that.diskName,_that.temperature,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiskTemperature implements DiskTemperature {
  const _DiskTemperature({required this.diskName, required this.temperature, required this.timestamp});
  factory _DiskTemperature.fromJson(Map<String, dynamic> json) => _$DiskTemperatureFromJson(json);

@override final  String diskName;
@override final  int? temperature;
@override final  DateTime timestamp;

/// Create a copy of DiskTemperature
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiskTemperatureCopyWith<_DiskTemperature> get copyWith => __$DiskTemperatureCopyWithImpl<_DiskTemperature>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiskTemperatureToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiskTemperature&&(identical(other.diskName, diskName) || other.diskName == diskName)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,diskName,temperature,timestamp);

@override
String toString() {
  return 'DiskTemperature(diskName: $diskName, temperature: $temperature, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$DiskTemperatureCopyWith<$Res> implements $DiskTemperatureCopyWith<$Res> {
  factory _$DiskTemperatureCopyWith(_DiskTemperature value, $Res Function(_DiskTemperature) _then) = __$DiskTemperatureCopyWithImpl;
@override @useResult
$Res call({
 String diskName, int? temperature, DateTime timestamp
});




}
/// @nodoc
class __$DiskTemperatureCopyWithImpl<$Res>
    implements _$DiskTemperatureCopyWith<$Res> {
  __$DiskTemperatureCopyWithImpl(this._self, this._then);

  final _DiskTemperature _self;
  final $Res Function(_DiskTemperature) _then;

/// Create a copy of DiskTemperature
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? diskName = null,Object? temperature = freezed,Object? timestamp = null,}) {
  return _then(_DiskTemperature(
diskName: null == diskName ? _self.diskName : diskName // ignore: cast_nullable_to_non_nullable
as String,temperature: freezed == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as int?,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$PoolTopology {

 String get poolId; String get poolName; List<VdevGroup> get vdevGroups; List<Disk> get spares; List<Disk> get cache; List<Disk> get log;
/// Create a copy of PoolTopology
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PoolTopologyCopyWith<PoolTopology> get copyWith => _$PoolTopologyCopyWithImpl<PoolTopology>(this as PoolTopology, _$identity);

  /// Serializes this PoolTopology to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PoolTopology&&(identical(other.poolId, poolId) || other.poolId == poolId)&&(identical(other.poolName, poolName) || other.poolName == poolName)&&const DeepCollectionEquality().equals(other.vdevGroups, vdevGroups)&&const DeepCollectionEquality().equals(other.spares, spares)&&const DeepCollectionEquality().equals(other.cache, cache)&&const DeepCollectionEquality().equals(other.log, log));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,poolId,poolName,const DeepCollectionEquality().hash(vdevGroups),const DeepCollectionEquality().hash(spares),const DeepCollectionEquality().hash(cache),const DeepCollectionEquality().hash(log));

@override
String toString() {
  return 'PoolTopology(poolId: $poolId, poolName: $poolName, vdevGroups: $vdevGroups, spares: $spares, cache: $cache, log: $log)';
}


}

/// @nodoc
abstract mixin class $PoolTopologyCopyWith<$Res>  {
  factory $PoolTopologyCopyWith(PoolTopology value, $Res Function(PoolTopology) _then) = _$PoolTopologyCopyWithImpl;
@useResult
$Res call({
 String poolId, String poolName, List<VdevGroup> vdevGroups, List<Disk> spares, List<Disk> cache, List<Disk> log
});




}
/// @nodoc
class _$PoolTopologyCopyWithImpl<$Res>
    implements $PoolTopologyCopyWith<$Res> {
  _$PoolTopologyCopyWithImpl(this._self, this._then);

  final PoolTopology _self;
  final $Res Function(PoolTopology) _then;

/// Create a copy of PoolTopology
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? poolId = null,Object? poolName = null,Object? vdevGroups = null,Object? spares = null,Object? cache = null,Object? log = null,}) {
  return _then(_self.copyWith(
poolId: null == poolId ? _self.poolId : poolId // ignore: cast_nullable_to_non_nullable
as String,poolName: null == poolName ? _self.poolName : poolName // ignore: cast_nullable_to_non_nullable
as String,vdevGroups: null == vdevGroups ? _self.vdevGroups : vdevGroups // ignore: cast_nullable_to_non_nullable
as List<VdevGroup>,spares: null == spares ? _self.spares : spares // ignore: cast_nullable_to_non_nullable
as List<Disk>,cache: null == cache ? _self.cache : cache // ignore: cast_nullable_to_non_nullable
as List<Disk>,log: null == log ? _self.log : log // ignore: cast_nullable_to_non_nullable
as List<Disk>,
  ));
}

}


/// Adds pattern-matching-related methods to [PoolTopology].
extension PoolTopologyPatterns on PoolTopology {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PoolTopology value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PoolTopology() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PoolTopology value)  $default,){
final _that = this;
switch (_that) {
case _PoolTopology():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PoolTopology value)?  $default,){
final _that = this;
switch (_that) {
case _PoolTopology() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String poolId,  String poolName,  List<VdevGroup> vdevGroups,  List<Disk> spares,  List<Disk> cache,  List<Disk> log)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PoolTopology() when $default != null:
return $default(_that.poolId,_that.poolName,_that.vdevGroups,_that.spares,_that.cache,_that.log);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String poolId,  String poolName,  List<VdevGroup> vdevGroups,  List<Disk> spares,  List<Disk> cache,  List<Disk> log)  $default,) {final _that = this;
switch (_that) {
case _PoolTopology():
return $default(_that.poolId,_that.poolName,_that.vdevGroups,_that.spares,_that.cache,_that.log);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String poolId,  String poolName,  List<VdevGroup> vdevGroups,  List<Disk> spares,  List<Disk> cache,  List<Disk> log)?  $default,) {final _that = this;
switch (_that) {
case _PoolTopology() when $default != null:
return $default(_that.poolId,_that.poolName,_that.vdevGroups,_that.spares,_that.cache,_that.log);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PoolTopology implements PoolTopology {
  const _PoolTopology({required this.poolId, required this.poolName, required final  List<VdevGroup> vdevGroups, required final  List<Disk> spares, required final  List<Disk> cache, required final  List<Disk> log}): _vdevGroups = vdevGroups,_spares = spares,_cache = cache,_log = log;
  factory _PoolTopology.fromJson(Map<String, dynamic> json) => _$PoolTopologyFromJson(json);

@override final  String poolId;
@override final  String poolName;
 final  List<VdevGroup> _vdevGroups;
@override List<VdevGroup> get vdevGroups {
  if (_vdevGroups is EqualUnmodifiableListView) return _vdevGroups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_vdevGroups);
}

 final  List<Disk> _spares;
@override List<Disk> get spares {
  if (_spares is EqualUnmodifiableListView) return _spares;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_spares);
}

 final  List<Disk> _cache;
@override List<Disk> get cache {
  if (_cache is EqualUnmodifiableListView) return _cache;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cache);
}

 final  List<Disk> _log;
@override List<Disk> get log {
  if (_log is EqualUnmodifiableListView) return _log;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_log);
}


/// Create a copy of PoolTopology
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PoolTopologyCopyWith<_PoolTopology> get copyWith => __$PoolTopologyCopyWithImpl<_PoolTopology>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PoolTopologyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PoolTopology&&(identical(other.poolId, poolId) || other.poolId == poolId)&&(identical(other.poolName, poolName) || other.poolName == poolName)&&const DeepCollectionEquality().equals(other._vdevGroups, _vdevGroups)&&const DeepCollectionEquality().equals(other._spares, _spares)&&const DeepCollectionEquality().equals(other._cache, _cache)&&const DeepCollectionEquality().equals(other._log, _log));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,poolId,poolName,const DeepCollectionEquality().hash(_vdevGroups),const DeepCollectionEquality().hash(_spares),const DeepCollectionEquality().hash(_cache),const DeepCollectionEquality().hash(_log));

@override
String toString() {
  return 'PoolTopology(poolId: $poolId, poolName: $poolName, vdevGroups: $vdevGroups, spares: $spares, cache: $cache, log: $log)';
}


}

/// @nodoc
abstract mixin class _$PoolTopologyCopyWith<$Res> implements $PoolTopologyCopyWith<$Res> {
  factory _$PoolTopologyCopyWith(_PoolTopology value, $Res Function(_PoolTopology) _then) = __$PoolTopologyCopyWithImpl;
@override @useResult
$Res call({
 String poolId, String poolName, List<VdevGroup> vdevGroups, List<Disk> spares, List<Disk> cache, List<Disk> log
});




}
/// @nodoc
class __$PoolTopologyCopyWithImpl<$Res>
    implements _$PoolTopologyCopyWith<$Res> {
  __$PoolTopologyCopyWithImpl(this._self, this._then);

  final _PoolTopology _self;
  final $Res Function(_PoolTopology) _then;

/// Create a copy of PoolTopology
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? poolId = null,Object? poolName = null,Object? vdevGroups = null,Object? spares = null,Object? cache = null,Object? log = null,}) {
  return _then(_PoolTopology(
poolId: null == poolId ? _self.poolId : poolId // ignore: cast_nullable_to_non_nullable
as String,poolName: null == poolName ? _self.poolName : poolName // ignore: cast_nullable_to_non_nullable
as String,vdevGroups: null == vdevGroups ? _self._vdevGroups : vdevGroups // ignore: cast_nullable_to_non_nullable
as List<VdevGroup>,spares: null == spares ? _self._spares : spares // ignore: cast_nullable_to_non_nullable
as List<Disk>,cache: null == cache ? _self._cache : cache // ignore: cast_nullable_to_non_nullable
as List<Disk>,log: null == log ? _self._log : log // ignore: cast_nullable_to_non_nullable
as List<Disk>,
  ));
}


}


/// @nodoc
mixin _$VdevGroup {

 String get type; String get status; List<Disk> get disks; String? get name; String? get guid;
/// Create a copy of VdevGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VdevGroupCopyWith<VdevGroup> get copyWith => _$VdevGroupCopyWithImpl<VdevGroup>(this as VdevGroup, _$identity);

  /// Serializes this VdevGroup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VdevGroup&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.disks, disks)&&(identical(other.name, name) || other.name == name)&&(identical(other.guid, guid) || other.guid == guid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,status,const DeepCollectionEquality().hash(disks),name,guid);

@override
String toString() {
  return 'VdevGroup(type: $type, status: $status, disks: $disks, name: $name, guid: $guid)';
}


}

/// @nodoc
abstract mixin class $VdevGroupCopyWith<$Res>  {
  factory $VdevGroupCopyWith(VdevGroup value, $Res Function(VdevGroup) _then) = _$VdevGroupCopyWithImpl;
@useResult
$Res call({
 String type, String status, List<Disk> disks, String? name, String? guid
});




}
/// @nodoc
class _$VdevGroupCopyWithImpl<$Res>
    implements $VdevGroupCopyWith<$Res> {
  _$VdevGroupCopyWithImpl(this._self, this._then);

  final VdevGroup _self;
  final $Res Function(VdevGroup) _then;

/// Create a copy of VdevGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? status = null,Object? disks = null,Object? name = freezed,Object? guid = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,disks: null == disks ? _self.disks : disks // ignore: cast_nullable_to_non_nullable
as List<Disk>,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,guid: freezed == guid ? _self.guid : guid // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [VdevGroup].
extension VdevGroupPatterns on VdevGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VdevGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VdevGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VdevGroup value)  $default,){
final _that = this;
switch (_that) {
case _VdevGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VdevGroup value)?  $default,){
final _that = this;
switch (_that) {
case _VdevGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String status,  List<Disk> disks,  String? name,  String? guid)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VdevGroup() when $default != null:
return $default(_that.type,_that.status,_that.disks,_that.name,_that.guid);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String status,  List<Disk> disks,  String? name,  String? guid)  $default,) {final _that = this;
switch (_that) {
case _VdevGroup():
return $default(_that.type,_that.status,_that.disks,_that.name,_that.guid);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String status,  List<Disk> disks,  String? name,  String? guid)?  $default,) {final _that = this;
switch (_that) {
case _VdevGroup() when $default != null:
return $default(_that.type,_that.status,_that.disks,_that.name,_that.guid);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VdevGroup implements VdevGroup {
  const _VdevGroup({required this.type, required this.status, required final  List<Disk> disks, required this.name, required this.guid}): _disks = disks;
  factory _VdevGroup.fromJson(Map<String, dynamic> json) => _$VdevGroupFromJson(json);

@override final  String type;
@override final  String status;
 final  List<Disk> _disks;
@override List<Disk> get disks {
  if (_disks is EqualUnmodifiableListView) return _disks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_disks);
}

@override final  String? name;
@override final  String? guid;

/// Create a copy of VdevGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VdevGroupCopyWith<_VdevGroup> get copyWith => __$VdevGroupCopyWithImpl<_VdevGroup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VdevGroupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VdevGroup&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._disks, _disks)&&(identical(other.name, name) || other.name == name)&&(identical(other.guid, guid) || other.guid == guid));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,status,const DeepCollectionEquality().hash(_disks),name,guid);

@override
String toString() {
  return 'VdevGroup(type: $type, status: $status, disks: $disks, name: $name, guid: $guid)';
}


}

/// @nodoc
abstract mixin class _$VdevGroupCopyWith<$Res> implements $VdevGroupCopyWith<$Res> {
  factory _$VdevGroupCopyWith(_VdevGroup value, $Res Function(_VdevGroup) _then) = __$VdevGroupCopyWithImpl;
@override @useResult
$Res call({
 String type, String status, List<Disk> disks, String? name, String? guid
});




}
/// @nodoc
class __$VdevGroupCopyWithImpl<$Res>
    implements _$VdevGroupCopyWith<$Res> {
  __$VdevGroupCopyWithImpl(this._self, this._then);

  final _VdevGroup _self;
  final $Res Function(_VdevGroup) _then;

/// Create a copy of VdevGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? status = null,Object? disks = null,Object? name = freezed,Object? guid = freezed,}) {
  return _then(_VdevGroup(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,disks: null == disks ? _self._disks : disks // ignore: cast_nullable_to_non_nullable
as List<Disk>,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,guid: freezed == guid ? _self.guid : guid // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

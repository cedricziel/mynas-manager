// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pool_resilver.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

PoolResilver _$PoolResilverFromJson(Map<String, dynamic> json) {
  return _PoolResilver.fromJson(json);
}

/// @nodoc
mixin _$PoolResilver {
  String get pool => throw _privateConstructorUsedError;
  ResilverStatus get status => throw _privateConstructorUsedError;
  DateTime? get startTime => throw _privateConstructorUsedError;
  DateTime? get estimatedEndTime => throw _privateConstructorUsedError;
  int? get bytesProcessed => throw _privateConstructorUsedError;
  int? get totalBytes => throw _privateConstructorUsedError;
  double? get percentComplete => throw _privateConstructorUsedError;
  int? get bytesPerSecond => throw _privateConstructorUsedError;
  int? get errorsFound => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this PoolResilver to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PoolResilver
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PoolResilverCopyWith<PoolResilver> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PoolResilverCopyWith<$Res> {
  factory $PoolResilverCopyWith(
    PoolResilver value,
    $Res Function(PoolResilver) then,
  ) = _$PoolResilverCopyWithImpl<$Res, PoolResilver>;
  @useResult
  $Res call({
    String pool,
    ResilverStatus status,
    DateTime? startTime,
    DateTime? estimatedEndTime,
    int? bytesProcessed,
    int? totalBytes,
    double? percentComplete,
    int? bytesPerSecond,
    int? errorsFound,
    String? description,
  });
}

/// @nodoc
class _$PoolResilverCopyWithImpl<$Res, $Val extends PoolResilver>
    implements $PoolResilverCopyWith<$Res> {
  _$PoolResilverCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PoolResilver
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pool = null,
    Object? status = null,
    Object? startTime = freezed,
    Object? estimatedEndTime = freezed,
    Object? bytesProcessed = freezed,
    Object? totalBytes = freezed,
    Object? percentComplete = freezed,
    Object? bytesPerSecond = freezed,
    Object? errorsFound = freezed,
    Object? description = freezed,
  }) {
    return _then(
      _value.copyWith(
            pool: null == pool
                ? _value.pool
                : pool // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as ResilverStatus,
            startTime: freezed == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            estimatedEndTime: freezed == estimatedEndTime
                ? _value.estimatedEndTime
                : estimatedEndTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            bytesProcessed: freezed == bytesProcessed
                ? _value.bytesProcessed
                : bytesProcessed // ignore: cast_nullable_to_non_nullable
                      as int?,
            totalBytes: freezed == totalBytes
                ? _value.totalBytes
                : totalBytes // ignore: cast_nullable_to_non_nullable
                      as int?,
            percentComplete: freezed == percentComplete
                ? _value.percentComplete
                : percentComplete // ignore: cast_nullable_to_non_nullable
                      as double?,
            bytesPerSecond: freezed == bytesPerSecond
                ? _value.bytesPerSecond
                : bytesPerSecond // ignore: cast_nullable_to_non_nullable
                      as int?,
            errorsFound: freezed == errorsFound
                ? _value.errorsFound
                : errorsFound // ignore: cast_nullable_to_non_nullable
                      as int?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PoolResilverImplCopyWith<$Res>
    implements $PoolResilverCopyWith<$Res> {
  factory _$$PoolResilverImplCopyWith(
    _$PoolResilverImpl value,
    $Res Function(_$PoolResilverImpl) then,
  ) = __$$PoolResilverImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String pool,
    ResilverStatus status,
    DateTime? startTime,
    DateTime? estimatedEndTime,
    int? bytesProcessed,
    int? totalBytes,
    double? percentComplete,
    int? bytesPerSecond,
    int? errorsFound,
    String? description,
  });
}

/// @nodoc
class __$$PoolResilverImplCopyWithImpl<$Res>
    extends _$PoolResilverCopyWithImpl<$Res, _$PoolResilverImpl>
    implements _$$PoolResilverImplCopyWith<$Res> {
  __$$PoolResilverImplCopyWithImpl(
    _$PoolResilverImpl _value,
    $Res Function(_$PoolResilverImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PoolResilver
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pool = null,
    Object? status = null,
    Object? startTime = freezed,
    Object? estimatedEndTime = freezed,
    Object? bytesProcessed = freezed,
    Object? totalBytes = freezed,
    Object? percentComplete = freezed,
    Object? bytesPerSecond = freezed,
    Object? errorsFound = freezed,
    Object? description = freezed,
  }) {
    return _then(
      _$PoolResilverImpl(
        pool: null == pool
            ? _value.pool
            : pool // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as ResilverStatus,
        startTime: freezed == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        estimatedEndTime: freezed == estimatedEndTime
            ? _value.estimatedEndTime
            : estimatedEndTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        bytesProcessed: freezed == bytesProcessed
            ? _value.bytesProcessed
            : bytesProcessed // ignore: cast_nullable_to_non_nullable
                  as int?,
        totalBytes: freezed == totalBytes
            ? _value.totalBytes
            : totalBytes // ignore: cast_nullable_to_non_nullable
                  as int?,
        percentComplete: freezed == percentComplete
            ? _value.percentComplete
            : percentComplete // ignore: cast_nullable_to_non_nullable
                  as double?,
        bytesPerSecond: freezed == bytesPerSecond
            ? _value.bytesPerSecond
            : bytesPerSecond // ignore: cast_nullable_to_non_nullable
                  as int?,
        errorsFound: freezed == errorsFound
            ? _value.errorsFound
            : errorsFound // ignore: cast_nullable_to_non_nullable
                  as int?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PoolResilverImpl implements _PoolResilver {
  const _$PoolResilverImpl({
    required this.pool,
    required this.status,
    required this.startTime,
    required this.estimatedEndTime,
    required this.bytesProcessed,
    required this.totalBytes,
    required this.percentComplete,
    required this.bytesPerSecond,
    required this.errorsFound,
    this.description,
  });

  factory _$PoolResilverImpl.fromJson(Map<String, dynamic> json) =>
      _$$PoolResilverImplFromJson(json);

  @override
  final String pool;
  @override
  final ResilverStatus status;
  @override
  final DateTime? startTime;
  @override
  final DateTime? estimatedEndTime;
  @override
  final int? bytesProcessed;
  @override
  final int? totalBytes;
  @override
  final double? percentComplete;
  @override
  final int? bytesPerSecond;
  @override
  final int? errorsFound;
  @override
  final String? description;

  @override
  String toString() {
    return 'PoolResilver(pool: $pool, status: $status, startTime: $startTime, estimatedEndTime: $estimatedEndTime, bytesProcessed: $bytesProcessed, totalBytes: $totalBytes, percentComplete: $percentComplete, bytesPerSecond: $bytesPerSecond, errorsFound: $errorsFound, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PoolResilverImpl &&
            (identical(other.pool, pool) || other.pool == pool) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.estimatedEndTime, estimatedEndTime) ||
                other.estimatedEndTime == estimatedEndTime) &&
            (identical(other.bytesProcessed, bytesProcessed) ||
                other.bytesProcessed == bytesProcessed) &&
            (identical(other.totalBytes, totalBytes) ||
                other.totalBytes == totalBytes) &&
            (identical(other.percentComplete, percentComplete) ||
                other.percentComplete == percentComplete) &&
            (identical(other.bytesPerSecond, bytesPerSecond) ||
                other.bytesPerSecond == bytesPerSecond) &&
            (identical(other.errorsFound, errorsFound) ||
                other.errorsFound == errorsFound) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    pool,
    status,
    startTime,
    estimatedEndTime,
    bytesProcessed,
    totalBytes,
    percentComplete,
    bytesPerSecond,
    errorsFound,
    description,
  );

  /// Create a copy of PoolResilver
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PoolResilverImplCopyWith<_$PoolResilverImpl> get copyWith =>
      __$$PoolResilverImplCopyWithImpl<_$PoolResilverImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PoolResilverImplToJson(this);
  }
}

abstract class _PoolResilver implements PoolResilver {
  const factory _PoolResilver({
    required final String pool,
    required final ResilverStatus status,
    required final DateTime? startTime,
    required final DateTime? estimatedEndTime,
    required final int? bytesProcessed,
    required final int? totalBytes,
    required final double? percentComplete,
    required final int? bytesPerSecond,
    required final int? errorsFound,
    final String? description,
  }) = _$PoolResilverImpl;

  factory _PoolResilver.fromJson(Map<String, dynamic> json) =
      _$PoolResilverImpl.fromJson;

  @override
  String get pool;
  @override
  ResilverStatus get status;
  @override
  DateTime? get startTime;
  @override
  DateTime? get estimatedEndTime;
  @override
  int? get bytesProcessed;
  @override
  int? get totalBytes;
  @override
  double? get percentComplete;
  @override
  int? get bytesPerSecond;
  @override
  int? get errorsFound;
  @override
  String? get description;

  /// Create a copy of PoolResilver
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PoolResilverImplCopyWith<_$PoolResilverImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

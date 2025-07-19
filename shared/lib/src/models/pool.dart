import 'package:freezed_annotation/freezed_annotation.dart';

part 'pool.freezed.dart';
part 'pool.g.dart';

@freezed
sealed class Pool with _$Pool {
  const factory Pool({
    required String id,
    required String name,
    required String status,
    required int size,
    required int allocated,
    required int free,
    required double fragmentation,
    required bool isHealthy,
    String? path,
    @Default([]) List<PoolVdev> vdevs,
  }) = _Pool;

  factory Pool.fromJson(Map<String, dynamic> json) => _$PoolFromJson(json);
}

@freezed
sealed class PoolVdev with _$PoolVdev {
  const factory PoolVdev({
    required String type,
    required String status,
    @Default([]) List<String> disks,
  }) = _PoolVdev;

  factory PoolVdev.fromJson(Map<String, dynamic> json) =>
      _$PoolVdevFromJson(json);
}

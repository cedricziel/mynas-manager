import 'package:freezed_annotation/freezed_annotation.dart';

part 'snapshot.freezed.dart';
part 'snapshot.g.dart';

@freezed
class Snapshot with _$Snapshot {
  const factory Snapshot({
    required String id,
    required String name,
    required String dataset,
    required String pool,
    required DateTime created,
    required int used,
    required int referenced,
    String? description,
    Map<String, dynamic>? properties,
  }) = _Snapshot;

  factory Snapshot.fromJson(Map<String, dynamic> json) =>
      _$SnapshotFromJson(json);
}

@freezed
class SnapshotTask with _$SnapshotTask {
  const factory SnapshotTask({
    required String id,
    required String dataset,
    required String namingSchema,
    required String schedule, // cron expression
    @Default(true) bool enabled,
    @Default(false) bool recursive,
    @Default(false) bool excludeEmpty,
    required int lifetimeValue,
    required String lifetimeUnit, // HOUR, DAY, WEEK, MONTH, YEAR
    required DateTime? nextRun,
    required DateTime? lastRun,
    @Default(0) int keepCount,
    Map<String, dynamic>? options,
  }) = _SnapshotTask;

  factory SnapshotTask.fromJson(Map<String, dynamic> json) =>
      _$SnapshotTaskFromJson(json);
}

@freezed
class SnapshotCount with _$SnapshotCount {
  const factory SnapshotCount({
    required String dataset,
    required int totalSnapshots,
    required int manualSnapshots,
    required int taskSnapshots,
    required int totalSize,
  }) = _SnapshotCount;

  factory SnapshotCount.fromJson(Map<String, dynamic> json) =>
      _$SnapshotCountFromJson(json);
}

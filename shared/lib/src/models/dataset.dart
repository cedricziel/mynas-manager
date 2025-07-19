import 'package:freezed_annotation/freezed_annotation.dart';

part 'dataset.freezed.dart';
part 'dataset.g.dart';

@freezed
class Dataset with _$Dataset {
  const factory Dataset({
    required String id,
    required String name,
    required String pool,
    required String type,
    required int used,
    required int available,
    required int referenced,
    required String mountpoint,
    @Default(false) bool encrypted,
    @Default([]) List<String> children,
    Map<String, dynamic>? properties,
  }) = _Dataset;

  factory Dataset.fromJson(Map<String, dynamic> json) =>
      _$DatasetFromJson(json);
}

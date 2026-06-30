import 'package:freezed_annotation/freezed_annotation.dart';

part 'building.freezed.dart';
part 'building.g.dart';

@freezed
abstract class Building with _$Building {
  const factory Building({
    required String id,
    required String name,
    @JsonKey(name: 'total_floors') required int totalFloors,
    @JsonKey(name: 'svg_asset_name') required String svgAssetName,
  }) = _Building;

  factory Building.fromJson(Map<String, dynamic> json) => _$BuildingFromJson(json);
}

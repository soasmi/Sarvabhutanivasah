import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_svg_mapping.freezed.dart';
part 'room_svg_mapping.g.dart';

@freezed
abstract class RoomSvgMapping with _$RoomSvgMapping {
  const factory RoomSvgMapping({
    required String id,
    @JsonKey(name: 'building_id') required String buildingId,
    @JsonKey(name: 'room_id') required String roomId,
    @JsonKey(name: 'svg_element_index') required int svgElementIndex,
  }) = _RoomSvgMapping;

  factory RoomSvgMapping.fromJson(Map<String, dynamic> json) => _$RoomSvgMappingFromJson(json);
}

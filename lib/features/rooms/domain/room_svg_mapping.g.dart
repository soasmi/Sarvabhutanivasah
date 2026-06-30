// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_svg_mapping.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoomSvgMapping _$RoomSvgMappingFromJson(Map<String, dynamic> json) =>
    _RoomSvgMapping(
      id: json['id'] as String,
      buildingId: json['building_id'] as String,
      roomId: json['room_id'] as String,
      svgElementIndex: (json['svg_element_index'] as num).toInt(),
    );

Map<String, dynamic> _$RoomSvgMappingToJson(_RoomSvgMapping instance) =>
    <String, dynamic>{
      'id': instance.id,
      'building_id': instance.buildingId,
      'room_id': instance.roomId,
      'svg_element_index': instance.svgElementIndex,
    };

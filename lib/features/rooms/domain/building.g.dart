// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'building.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Building _$BuildingFromJson(Map<String, dynamic> json) => _Building(
  id: json['id'] as String,
  name: json['name'] as String,
  totalFloors: (json['total_floors'] as num).toInt(),
  svgAssetName: json['svg_asset_name'] as String,
);

Map<String, dynamic> _$BuildingToJson(_Building instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'total_floors': instance.totalFloors,
  'svg_asset_name': instance.svgAssetName,
};

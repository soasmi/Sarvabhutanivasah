// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Room _$RoomFromJson(Map<String, dynamic> json) => _Room(
  id: json['id'] as String,
  floorId: json['floor_id'] as String,
  roomNumber: json['room_number'] as String,
  category: json['category'] as String,
  baseTariff: (json['base_tariff'] as num).toDouble(),
);

Map<String, dynamic> _$RoomToJson(_Room instance) => <String, dynamic>{
  'id': instance.id,
  'floor_id': instance.floorId,
  'room_number': instance.roomNumber,
  'category': instance.category,
  'base_tariff': instance.baseTariff,
};

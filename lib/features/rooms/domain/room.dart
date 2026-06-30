import 'package:freezed_annotation/freezed_annotation.dart';

part 'room.freezed.dart';
part 'room.g.dart';

@freezed
abstract class Room with _$Room {
  const factory Room({
    required String id,
    @JsonKey(name: 'floor_id') required String floorId,
    @JsonKey(name: 'room_number') required String roomNumber,
    required String category,
    @JsonKey(name: 'base_tariff') required double baseTariff,
  }) = _Room;

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
}

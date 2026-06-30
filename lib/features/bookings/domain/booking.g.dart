// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Booking _$BookingFromJson(Map<String, dynamic> json) => _Booking(
  id: json['id'] as String,
  roomId: json['room_id'] as String,
  guestId: json['guest_id'] as String,
  checkInDate: DateTime.parse(json['check_in_date'] as String),
  checkOutDate: DateTime.parse(json['check_out_date'] as String),
  status: json['status'] as String,
  tariffAtBooking: (json['tariff_at_booking'] as num).toDouble(),
  totalAmount: (json['total_amount'] as num).toDouble(),
  paymentStatus: json['payment_status'] as String,
  createdBy: json['created_by'] as String,
);

Map<String, dynamic> _$BookingToJson(_Booking instance) => <String, dynamic>{
  'id': instance.id,
  'room_id': instance.roomId,
  'guest_id': instance.guestId,
  'check_in_date': instance.checkInDate.toIso8601String(),
  'check_out_date': instance.checkOutDate.toIso8601String(),
  'status': instance.status,
  'tariff_at_booking': instance.tariffAtBooking,
  'total_amount': instance.totalAmount,
  'payment_status': instance.paymentStatus,
  'created_by': instance.createdBy,
};

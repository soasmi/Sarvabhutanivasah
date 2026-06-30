import 'package:freezed_annotation/freezed_annotation.dart';

part 'booking.freezed.dart';
part 'booking.g.dart';

@freezed
abstract class Booking with _$Booking {
  const factory Booking({
    required String id,
    @JsonKey(name: 'room_id') required String roomId,
    @JsonKey(name: 'guest_id') required String guestId,
    @JsonKey(name: 'check_in_date') required DateTime checkInDate,
    @JsonKey(name: 'check_out_date') required DateTime checkOutDate,
    required String status,
    @JsonKey(name: 'tariff_at_booking') required double tariffAtBooking,
    @JsonKey(name: 'total_amount') required double totalAmount,
    @JsonKey(name: 'payment_status') required String paymentStatus,
    @JsonKey(name: 'created_by') required String createdBy,
  }) = _Booking;

  factory Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_transaction.freezed.dart';
part 'payment_transaction.g.dart';

@freezed
abstract class PaymentTransaction with _$PaymentTransaction {
  const factory PaymentTransaction({
    required String id,
    @JsonKey(name: 'booking_id') required String bookingId,
    required double amount,
    @JsonKey(name: 'payment_date') required DateTime paymentDate,
    @JsonKey(name: 'payment_mode') required String paymentMode,
    @JsonKey(name: 'recorded_by') required String recordedBy,
  }) = _PaymentTransaction;

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) => _$PaymentTransactionFromJson(json);
}

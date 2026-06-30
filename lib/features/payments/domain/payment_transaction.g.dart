// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaymentTransaction _$PaymentTransactionFromJson(Map<String, dynamic> json) =>
    _PaymentTransaction(
      id: json['id'] as String,
      bookingId: json['booking_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      paymentDate: DateTime.parse(json['payment_date'] as String),
      paymentMode: json['payment_mode'] as String,
      recordedBy: json['recorded_by'] as String,
    );

Map<String, dynamic> _$PaymentTransactionToJson(_PaymentTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'booking_id': instance.bookingId,
      'amount': instance.amount,
      'payment_date': instance.paymentDate.toIso8601String(),
      'payment_mode': instance.paymentMode,
      'recorded_by': instance.recordedBy,
    };

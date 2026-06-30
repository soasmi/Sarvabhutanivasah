// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'booking.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Booking {

 String get id;@JsonKey(name: 'room_id') String get roomId;@JsonKey(name: 'guest_id') String get guestId;@JsonKey(name: 'check_in_date') DateTime get checkInDate;@JsonKey(name: 'check_out_date') DateTime get checkOutDate; String get status;@JsonKey(name: 'tariff_at_booking') double get tariffAtBooking;@JsonKey(name: 'total_amount') double get totalAmount;@JsonKey(name: 'payment_status') String get paymentStatus;@JsonKey(name: 'created_by') String get createdBy;
/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BookingCopyWith<Booking> get copyWith => _$BookingCopyWithImpl<Booking>(this as Booking, _$identity);

  /// Serializes this Booking to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Booking&&(identical(other.id, id) || other.id == id)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.guestId, guestId) || other.guestId == guestId)&&(identical(other.checkInDate, checkInDate) || other.checkInDate == checkInDate)&&(identical(other.checkOutDate, checkOutDate) || other.checkOutDate == checkOutDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.tariffAtBooking, tariffAtBooking) || other.tariffAtBooking == tariffAtBooking)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,roomId,guestId,checkInDate,checkOutDate,status,tariffAtBooking,totalAmount,paymentStatus,createdBy);

@override
String toString() {
  return 'Booking(id: $id, roomId: $roomId, guestId: $guestId, checkInDate: $checkInDate, checkOutDate: $checkOutDate, status: $status, tariffAtBooking: $tariffAtBooking, totalAmount: $totalAmount, paymentStatus: $paymentStatus, createdBy: $createdBy)';
}


}

/// @nodoc
abstract mixin class $BookingCopyWith<$Res>  {
  factory $BookingCopyWith(Booking value, $Res Function(Booking) _then) = _$BookingCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'room_id') String roomId,@JsonKey(name: 'guest_id') String guestId,@JsonKey(name: 'check_in_date') DateTime checkInDate,@JsonKey(name: 'check_out_date') DateTime checkOutDate, String status,@JsonKey(name: 'tariff_at_booking') double tariffAtBooking,@JsonKey(name: 'total_amount') double totalAmount,@JsonKey(name: 'payment_status') String paymentStatus,@JsonKey(name: 'created_by') String createdBy
});




}
/// @nodoc
class _$BookingCopyWithImpl<$Res>
    implements $BookingCopyWith<$Res> {
  _$BookingCopyWithImpl(this._self, this._then);

  final Booking _self;
  final $Res Function(Booking) _then;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? roomId = null,Object? guestId = null,Object? checkInDate = null,Object? checkOutDate = null,Object? status = null,Object? tariffAtBooking = null,Object? totalAmount = null,Object? paymentStatus = null,Object? createdBy = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,guestId: null == guestId ? _self.guestId : guestId // ignore: cast_nullable_to_non_nullable
as String,checkInDate: null == checkInDate ? _self.checkInDate : checkInDate // ignore: cast_nullable_to_non_nullable
as DateTime,checkOutDate: null == checkOutDate ? _self.checkOutDate : checkOutDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,tariffAtBooking: null == tariffAtBooking ? _self.tariffAtBooking : tariffAtBooking // ignore: cast_nullable_to_non_nullable
as double,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,paymentStatus: null == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as String,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Booking].
extension BookingPatterns on Booking {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Booking value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Booking value)  $default,){
final _that = this;
switch (_that) {
case _Booking():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Booking value)?  $default,){
final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'room_id')  String roomId, @JsonKey(name: 'guest_id')  String guestId, @JsonKey(name: 'check_in_date')  DateTime checkInDate, @JsonKey(name: 'check_out_date')  DateTime checkOutDate,  String status, @JsonKey(name: 'tariff_at_booking')  double tariffAtBooking, @JsonKey(name: 'total_amount')  double totalAmount, @JsonKey(name: 'payment_status')  String paymentStatus, @JsonKey(name: 'created_by')  String createdBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that.id,_that.roomId,_that.guestId,_that.checkInDate,_that.checkOutDate,_that.status,_that.tariffAtBooking,_that.totalAmount,_that.paymentStatus,_that.createdBy);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'room_id')  String roomId, @JsonKey(name: 'guest_id')  String guestId, @JsonKey(name: 'check_in_date')  DateTime checkInDate, @JsonKey(name: 'check_out_date')  DateTime checkOutDate,  String status, @JsonKey(name: 'tariff_at_booking')  double tariffAtBooking, @JsonKey(name: 'total_amount')  double totalAmount, @JsonKey(name: 'payment_status')  String paymentStatus, @JsonKey(name: 'created_by')  String createdBy)  $default,) {final _that = this;
switch (_that) {
case _Booking():
return $default(_that.id,_that.roomId,_that.guestId,_that.checkInDate,_that.checkOutDate,_that.status,_that.tariffAtBooking,_that.totalAmount,_that.paymentStatus,_that.createdBy);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'room_id')  String roomId, @JsonKey(name: 'guest_id')  String guestId, @JsonKey(name: 'check_in_date')  DateTime checkInDate, @JsonKey(name: 'check_out_date')  DateTime checkOutDate,  String status, @JsonKey(name: 'tariff_at_booking')  double tariffAtBooking, @JsonKey(name: 'total_amount')  double totalAmount, @JsonKey(name: 'payment_status')  String paymentStatus, @JsonKey(name: 'created_by')  String createdBy)?  $default,) {final _that = this;
switch (_that) {
case _Booking() when $default != null:
return $default(_that.id,_that.roomId,_that.guestId,_that.checkInDate,_that.checkOutDate,_that.status,_that.tariffAtBooking,_that.totalAmount,_that.paymentStatus,_that.createdBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Booking implements Booking {
  const _Booking({required this.id, @JsonKey(name: 'room_id') required this.roomId, @JsonKey(name: 'guest_id') required this.guestId, @JsonKey(name: 'check_in_date') required this.checkInDate, @JsonKey(name: 'check_out_date') required this.checkOutDate, required this.status, @JsonKey(name: 'tariff_at_booking') required this.tariffAtBooking, @JsonKey(name: 'total_amount') required this.totalAmount, @JsonKey(name: 'payment_status') required this.paymentStatus, @JsonKey(name: 'created_by') required this.createdBy});
  factory _Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);

@override final  String id;
@override@JsonKey(name: 'room_id') final  String roomId;
@override@JsonKey(name: 'guest_id') final  String guestId;
@override@JsonKey(name: 'check_in_date') final  DateTime checkInDate;
@override@JsonKey(name: 'check_out_date') final  DateTime checkOutDate;
@override final  String status;
@override@JsonKey(name: 'tariff_at_booking') final  double tariffAtBooking;
@override@JsonKey(name: 'total_amount') final  double totalAmount;
@override@JsonKey(name: 'payment_status') final  String paymentStatus;
@override@JsonKey(name: 'created_by') final  String createdBy;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BookingCopyWith<_Booking> get copyWith => __$BookingCopyWithImpl<_Booking>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BookingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Booking&&(identical(other.id, id) || other.id == id)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.guestId, guestId) || other.guestId == guestId)&&(identical(other.checkInDate, checkInDate) || other.checkInDate == checkInDate)&&(identical(other.checkOutDate, checkOutDate) || other.checkOutDate == checkOutDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.tariffAtBooking, tariffAtBooking) || other.tariffAtBooking == tariffAtBooking)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.paymentStatus, paymentStatus) || other.paymentStatus == paymentStatus)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,roomId,guestId,checkInDate,checkOutDate,status,tariffAtBooking,totalAmount,paymentStatus,createdBy);

@override
String toString() {
  return 'Booking(id: $id, roomId: $roomId, guestId: $guestId, checkInDate: $checkInDate, checkOutDate: $checkOutDate, status: $status, tariffAtBooking: $tariffAtBooking, totalAmount: $totalAmount, paymentStatus: $paymentStatus, createdBy: $createdBy)';
}


}

/// @nodoc
abstract mixin class _$BookingCopyWith<$Res> implements $BookingCopyWith<$Res> {
  factory _$BookingCopyWith(_Booking value, $Res Function(_Booking) _then) = __$BookingCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'room_id') String roomId,@JsonKey(name: 'guest_id') String guestId,@JsonKey(name: 'check_in_date') DateTime checkInDate,@JsonKey(name: 'check_out_date') DateTime checkOutDate, String status,@JsonKey(name: 'tariff_at_booking') double tariffAtBooking,@JsonKey(name: 'total_amount') double totalAmount,@JsonKey(name: 'payment_status') String paymentStatus,@JsonKey(name: 'created_by') String createdBy
});




}
/// @nodoc
class __$BookingCopyWithImpl<$Res>
    implements _$BookingCopyWith<$Res> {
  __$BookingCopyWithImpl(this._self, this._then);

  final _Booking _self;
  final $Res Function(_Booking) _then;

/// Create a copy of Booking
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? roomId = null,Object? guestId = null,Object? checkInDate = null,Object? checkOutDate = null,Object? status = null,Object? tariffAtBooking = null,Object? totalAmount = null,Object? paymentStatus = null,Object? createdBy = null,}) {
  return _then(_Booking(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,guestId: null == guestId ? _self.guestId : guestId // ignore: cast_nullable_to_non_nullable
as String,checkInDate: null == checkInDate ? _self.checkInDate : checkInDate // ignore: cast_nullable_to_non_nullable
as DateTime,checkOutDate: null == checkOutDate ? _self.checkOutDate : checkOutDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,tariffAtBooking: null == tariffAtBooking ? _self.tariffAtBooking : tariffAtBooking // ignore: cast_nullable_to_non_nullable
as double,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,paymentStatus: null == paymentStatus ? _self.paymentStatus : paymentStatus // ignore: cast_nullable_to_non_nullable
as String,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

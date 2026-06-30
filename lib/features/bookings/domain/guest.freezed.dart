// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'guest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Guest {

 String get id; String get name;@JsonKey(name: 'phone_number') String get phoneNumber;@JsonKey(name: 'identity_document_type') String? get identityDocumentType;@JsonKey(name: 'identity_document_number') String? get identityDocumentNumber;
/// Create a copy of Guest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GuestCopyWith<Guest> get copyWith => _$GuestCopyWithImpl<Guest>(this as Guest, _$identity);

  /// Serializes this Guest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Guest&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.identityDocumentType, identityDocumentType) || other.identityDocumentType == identityDocumentType)&&(identical(other.identityDocumentNumber, identityDocumentNumber) || other.identityDocumentNumber == identityDocumentNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phoneNumber,identityDocumentType,identityDocumentNumber);

@override
String toString() {
  return 'Guest(id: $id, name: $name, phoneNumber: $phoneNumber, identityDocumentType: $identityDocumentType, identityDocumentNumber: $identityDocumentNumber)';
}


}

/// @nodoc
abstract mixin class $GuestCopyWith<$Res>  {
  factory $GuestCopyWith(Guest value, $Res Function(Guest) _then) = _$GuestCopyWithImpl;
@useResult
$Res call({
 String id, String name,@JsonKey(name: 'phone_number') String phoneNumber,@JsonKey(name: 'identity_document_type') String? identityDocumentType,@JsonKey(name: 'identity_document_number') String? identityDocumentNumber
});




}
/// @nodoc
class _$GuestCopyWithImpl<$Res>
    implements $GuestCopyWith<$Res> {
  _$GuestCopyWithImpl(this._self, this._then);

  final Guest _self;
  final $Res Function(Guest) _then;

/// Create a copy of Guest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? phoneNumber = null,Object? identityDocumentType = freezed,Object? identityDocumentNumber = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,identityDocumentType: freezed == identityDocumentType ? _self.identityDocumentType : identityDocumentType // ignore: cast_nullable_to_non_nullable
as String?,identityDocumentNumber: freezed == identityDocumentNumber ? _self.identityDocumentNumber : identityDocumentNumber // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Guest].
extension GuestPatterns on Guest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Guest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Guest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Guest value)  $default,){
final _that = this;
switch (_that) {
case _Guest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Guest value)?  $default,){
final _that = this;
switch (_that) {
case _Guest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'phone_number')  String phoneNumber, @JsonKey(name: 'identity_document_type')  String? identityDocumentType, @JsonKey(name: 'identity_document_number')  String? identityDocumentNumber)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Guest() when $default != null:
return $default(_that.id,_that.name,_that.phoneNumber,_that.identityDocumentType,_that.identityDocumentNumber);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'phone_number')  String phoneNumber, @JsonKey(name: 'identity_document_type')  String? identityDocumentType, @JsonKey(name: 'identity_document_number')  String? identityDocumentNumber)  $default,) {final _that = this;
switch (_that) {
case _Guest():
return $default(_that.id,_that.name,_that.phoneNumber,_that.identityDocumentType,_that.identityDocumentNumber);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @JsonKey(name: 'phone_number')  String phoneNumber, @JsonKey(name: 'identity_document_type')  String? identityDocumentType, @JsonKey(name: 'identity_document_number')  String? identityDocumentNumber)?  $default,) {final _that = this;
switch (_that) {
case _Guest() when $default != null:
return $default(_that.id,_that.name,_that.phoneNumber,_that.identityDocumentType,_that.identityDocumentNumber);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Guest implements Guest {
  const _Guest({required this.id, required this.name, @JsonKey(name: 'phone_number') required this.phoneNumber, @JsonKey(name: 'identity_document_type') this.identityDocumentType, @JsonKey(name: 'identity_document_number') this.identityDocumentNumber});
  factory _Guest.fromJson(Map<String, dynamic> json) => _$GuestFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey(name: 'phone_number') final  String phoneNumber;
@override@JsonKey(name: 'identity_document_type') final  String? identityDocumentType;
@override@JsonKey(name: 'identity_document_number') final  String? identityDocumentNumber;

/// Create a copy of Guest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GuestCopyWith<_Guest> get copyWith => __$GuestCopyWithImpl<_Guest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GuestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Guest&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.identityDocumentType, identityDocumentType) || other.identityDocumentType == identityDocumentType)&&(identical(other.identityDocumentNumber, identityDocumentNumber) || other.identityDocumentNumber == identityDocumentNumber));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,phoneNumber,identityDocumentType,identityDocumentNumber);

@override
String toString() {
  return 'Guest(id: $id, name: $name, phoneNumber: $phoneNumber, identityDocumentType: $identityDocumentType, identityDocumentNumber: $identityDocumentNumber)';
}


}

/// @nodoc
abstract mixin class _$GuestCopyWith<$Res> implements $GuestCopyWith<$Res> {
  factory _$GuestCopyWith(_Guest value, $Res Function(_Guest) _then) = __$GuestCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@JsonKey(name: 'phone_number') String phoneNumber,@JsonKey(name: 'identity_document_type') String? identityDocumentType,@JsonKey(name: 'identity_document_number') String? identityDocumentNumber
});




}
/// @nodoc
class __$GuestCopyWithImpl<$Res>
    implements _$GuestCopyWith<$Res> {
  __$GuestCopyWithImpl(this._self, this._then);

  final _Guest _self;
  final $Res Function(_Guest) _then;

/// Create a copy of Guest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? phoneNumber = null,Object? identityDocumentType = freezed,Object? identityDocumentNumber = freezed,}) {
  return _then(_Guest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,identityDocumentType: freezed == identityDocumentType ? _self.identityDocumentType : identityDocumentType // ignore: cast_nullable_to_non_nullable
as String?,identityDocumentNumber: freezed == identityDocumentNumber ? _self.identityDocumentNumber : identityDocumentNumber // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

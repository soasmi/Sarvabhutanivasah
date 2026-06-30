// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Guest _$GuestFromJson(Map<String, dynamic> json) => _Guest(
  id: json['id'] as String,
  name: json['name'] as String,
  phoneNumber: json['phone_number'] as String,
  identityDocumentType: json['identity_document_type'] as String?,
  identityDocumentNumber: json['identity_document_number'] as String?,
);

Map<String, dynamic> _$GuestToJson(_Guest instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'phone_number': instance.phoneNumber,
  'identity_document_type': instance.identityDocumentType,
  'identity_document_number': instance.identityDocumentNumber,
};

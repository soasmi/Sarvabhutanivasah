import 'package:freezed_annotation/freezed_annotation.dart';

part 'guest.freezed.dart';
part 'guest.g.dart';

@freezed
abstract class Guest with _$Guest {
  const factory Guest({
    required String id,
    required String name,
    @JsonKey(name: 'phone_number') required String phoneNumber,
    @JsonKey(name: 'identity_document_type') String? identityDocumentType,
    @JsonKey(name: 'identity_document_number') String? identityDocumentNumber,
  }) = _Guest;

  factory Guest.fromJson(Map<String, dynamic> json) => _$GuestFromJson(json);
}

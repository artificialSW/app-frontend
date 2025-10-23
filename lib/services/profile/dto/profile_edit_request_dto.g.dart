// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_edit_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileEditRequestDto _$ProfileEditRequestDtoFromJson(
  Map<String, dynamic> json,
) => ProfileEditRequestDto(
  name: json['name'] as String,
  birth: json['birth'] as String,
  familyType: json['familyType'] as String,
);

Map<String, dynamic> _$ProfileEditRequestDtoToJson(
  ProfileEditRequestDto instance,
) => <String, dynamic>{
  'name': instance.name,
  'birth': instance.birth,
  'familyType': instance.familyType,
};

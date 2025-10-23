// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileResponseDto _$ProfileResponseDtoFromJson(Map<String, dynamic> json) =>
    ProfileResponseDto(
      name: json['name'] as String,
      birth: json['birth'] as String,
      familyType: json['family_type'] as String,
      familyCode: json['family_code'] as String,
    );

Map<String, dynamic> _$ProfileResponseDtoToJson(ProfileResponseDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'birth': instance.birth,
      'family_type': instance.familyType,
      'family_code': instance.familyCode,
    };

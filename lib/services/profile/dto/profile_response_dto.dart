import 'package:json_annotation/json_annotation.dart';

part 'profile_response_dto.g.dart';

@JsonSerializable()
class ProfileResponseDto {
  @JsonKey(name: 'name')
  final String name;
  
  @JsonKey(name: 'birth')
  final String birth;
  
  @JsonKey(name: 'family_type')
  final String familyType;
  
  @JsonKey(name: 'family_code')
  final String familyCode;

  const ProfileResponseDto({
    required this.name,
    required this.birth,
    required this.familyType,
    required this.familyCode,
  });

  factory ProfileResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseDtoFromJson(json);
      
  Map<String, dynamic> toJson() => _$ProfileResponseDtoToJson(this);
}

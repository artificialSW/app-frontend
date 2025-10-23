import 'package:json_annotation/json_annotation.dart';

part 'profile_edit_request_dto.g.dart';

@JsonSerializable()
class ProfileEditRequestDto {
  final String name;
  final String birth;
  
  @JsonKey(name: 'familyType')
  final String familyType;

  const ProfileEditRequestDto({
    required this.name,
    required this.birth,
    required this.familyType,
  });

  factory ProfileEditRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileEditRequestDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileEditRequestDtoToJson(this);
}

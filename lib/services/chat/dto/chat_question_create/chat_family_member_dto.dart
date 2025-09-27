import 'package:json_annotation/json_annotation.dart';

part 'chat_family_member_dto.g.dart';

@JsonSerializable()
class ChatFamilyMemberDto {
  final int id;
  final String role;

  ChatFamilyMemberDto({
    required this.id,
    required this.role,
  });

  factory ChatFamilyMemberDto.fromJson(Map<String, dynamic> json) =>
      _$ChatFamilyMemberDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChatFamilyMemberDtoToJson(this);
}

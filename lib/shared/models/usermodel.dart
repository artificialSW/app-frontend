import 'package:json_annotation/json_annotation.dart';

part 'usermodel.g.dart'; // 자동 생성 파일

@JsonSerializable()
class User{
  final String name;
  final int id;
  final String role;

  User({
    required this.name,
    required this.id,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
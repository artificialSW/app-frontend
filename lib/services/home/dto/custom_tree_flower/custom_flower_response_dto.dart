import 'package:json_annotation/json_annotation.dart';

part 'custom_flower_response_dto.g.dart';

/// 커스텀 나무 꽃 조회 응답용 DTO
/// 서버에서 커스텀 나무의 꽃 정보를 받아올 때 사용
@JsonSerializable()
class CustomFlowerResponseDto {
  final List<CustomFlowerItem> flowers;

  const CustomFlowerResponseDto({
    required this.flowers,
  });

  /// JSON에서 CustomFlowerResponseDto 생성
  factory CustomFlowerResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CustomFlowerResponseDtoFromJson(json);

  /// CustomFlowerResponseDto를 JSON으로 변환
  Map<String, dynamic> toJson() => _$CustomFlowerResponseDtoToJson(this);
}

/// 커스텀 꽃 아이템 DTO
@JsonSerializable()
class CustomFlowerItem {
  final String id;
  final String name;
  final String question;
  final String category;
  final int order;
  final String date;

  const CustomFlowerItem({
    required this.id,
    required this.name,
    required this.question,
    required this.category,
    required this.order,
    required this.date,
  });

  /// JSON에서 CustomFlowerItem 생성
  factory CustomFlowerItem.fromJson(Map<String, dynamic> json) =>
      _$CustomFlowerItemFromJson(json);

  /// CustomFlowerItem을 JSON으로 변환
  Map<String, dynamic> toJson() => _$CustomFlowerItemToJson(this);
}

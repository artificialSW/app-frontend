import 'package:json_annotation/json_annotation.dart';

part 'custom_fruit_response_dto.g.dart';

/// 커스텀 나무 과일 조회 응답용 DTO
/// 서버에서 커스텀 나무의 과일 정보를 받아올 때 사용
@JsonSerializable()
class CustomFruitResponseDto {
  final List<CustomFruitItem> fruits;

  const CustomFruitResponseDto({
    required this.fruits,
  });

  /// JSON에서 CustomFruitResponseDto 생성
  factory CustomFruitResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CustomFruitResponseDtoFromJson(json);

  /// CustomFruitResponseDto를 JSON으로 변환
  Map<String, dynamic> toJson() => _$CustomFruitResponseDtoToJson(this);
}

/// 커스텀 과일 아이템 DTO
@JsonSerializable()
class CustomFruitItem {
  final String id;
  final String name;
  @JsonKey(name: 'imageUrl')
  final String imageUrl;
  final String category;
  final int order;
  final String date;

  const CustomFruitItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.order,
    required this.date,
  });

  /// JSON에서 CustomFruitItem 생성
  factory CustomFruitItem.fromJson(Map<String, dynamic> json) =>
      _$CustomFruitItemFromJson(json);

  /// CustomFruitItem을 JSON으로 변환
  Map<String, dynamic> toJson() => _$CustomFruitItemToJson(this);
}

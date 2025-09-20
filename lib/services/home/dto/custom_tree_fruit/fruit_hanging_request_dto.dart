import 'package:json_annotation/json_annotation.dart';

part 'fruit_hanging_request_dto.g.dart';

/// 과일 달기 요청용 DTO
/// 서버에 과일 달기 정보를 전송할 때 사용
@JsonSerializable()
class FruitHangingRequestDto {
  @JsonKey(name: 'fruit-hanging')
  final List<FruitHangingItem> fruitHanging;

  const FruitHangingRequestDto({
    required this.fruitHanging,
  });

  /// JSON에서 FruitHangingRequestDto 생성
  factory FruitHangingRequestDto.fromJson(Map<String, dynamic> json) =>
      _$FruitHangingRequestDtoFromJson(json);

  /// FruitHangingRequestDto를 JSON으로 변환
  Map<String, dynamic> toJson() => _$FruitHangingRequestDtoToJson(this);
}

/// 과일 달기 아이템 DTO
@JsonSerializable()
class FruitHangingItem {
  final String id;
  final int order;

  const FruitHangingItem({
    required this.id,
    required this.order,
  });

  /// JSON에서 FruitHangingItem 생성
  factory FruitHangingItem.fromJson(Map<String, dynamic> json) =>
      _$FruitHangingItemFromJson(json);

  /// FruitHangingItem을 JSON으로 변환
  Map<String, dynamic> toJson() => _$FruitHangingItemToJson(this);
}

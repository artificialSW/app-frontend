import 'package:json_annotation/json_annotation.dart';

part 'flower_hanging_request_dto.g.dart';

/// 꽃 달기 요청용 DTO
/// 서버에 꽃 달기 정보를 전송할 때 사용
@JsonSerializable()
class FlowerHangingRequestDto {
  @JsonKey(name: 'flower-hanging')
  final List<FlowerHangingItem> flowerHanging;

  const FlowerHangingRequestDto({
    required this.flowerHanging,
  });

  /// JSON에서 FlowerHangingRequestDto 생성
  factory FlowerHangingRequestDto.fromJson(Map<String, dynamic> json) =>
      _$FlowerHangingRequestDtoFromJson(json);

  /// FlowerHangingRequestDto를 JSON으로 변환
  Map<String, dynamic> toJson() => _$FlowerHangingRequestDtoToJson(this);
}

/// 꽃 달기 아이템 DTO
@JsonSerializable()
class FlowerHangingItem {
  final String id;
  final int order;

  const FlowerHangingItem({
    required this.id,
    required this.order,
  });

  /// JSON에서 FlowerHangingItem 생성
  factory FlowerHangingItem.fromJson(Map<String, dynamic> json) =>
      _$FlowerHangingItemFromJson(json);

  /// FlowerHangingItem을 JSON으로 변환
  Map<String, dynamic> toJson() => _$FlowerHangingItemToJson(this);
}

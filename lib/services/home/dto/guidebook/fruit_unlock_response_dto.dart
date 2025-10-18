import 'package:json_annotation/json_annotation.dart';

part 'fruit_unlock_response_dto.g.dart';

/// 과일 도감 해금 상태 응답 DTO
@JsonSerializable()
class FruitUnlockResponseDto {
  /// 해금된 과일 ID 리스트 (0-15)
  final List<int> resolvedFruits;

  const FruitUnlockResponseDto({
    required this.resolvedFruits,
  });

  factory FruitUnlockResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FruitUnlockResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FruitUnlockResponseDtoToJson(this);
}

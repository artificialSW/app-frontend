import 'package:json_annotation/json_annotation.dart';

part 'flower_unlock_response_dto.g.dart';

/// 꽃 도감 해금 상태 응답 DTO
@JsonSerializable()
class FlowerUnlockResponseDto {
  /// 해금된 꽃 ID 리스트 (0-11)
  final List<int> resolvedFlowers;

  const FlowerUnlockResponseDto({
    required this.resolvedFlowers,
  });

  factory FlowerUnlockResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FlowerUnlockResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FlowerUnlockResponseDtoToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'fruit_card_dialog_response_dto.g.dart';

/// 아카이브 꽃 데이터 응답 DTO
@JsonSerializable()
class FruitCardDialogResponseDto {
  final String imageUrl;
  final String category;
  final String message;

  const FruitCardDialogResponseDto({
    required this.imageUrl,
    required this.category,
    required this.message,
  });

  factory FruitCardDialogResponseDto.fromJson(Map<String, dynamic> json) =>
      _$FruitCardDialogResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FruitCardDialogResponseDtoToJson(this);

}

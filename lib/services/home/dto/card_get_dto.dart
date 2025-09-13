import 'package:json_annotation/json_annotation.dart';

part 'card_get_dto.g.dart';

/// 카드 조회 API 응답용 DTO
/// 서버에서 받아온 카드 데이터를 담는 클래스
@JsonSerializable()
class CardGetDto {
  final List<FruitCardDto> fruitCards;
  final List<FlowerCardDto> flowerCards;

  const CardGetDto({
    required this.fruitCards,
    required this.flowerCards,
  });

  /// JSON에서 CardGetDto 생성
  factory CardGetDto.fromJson(Map<String, dynamic> json) =>
      _$CardGetDtoFromJson(json);

  /// CardGetDto를 JSON으로 변환
  Map<String, dynamic> toJson() => _$CardGetDtoToJson(this);
}

/// 과일 카드 DTO
@JsonSerializable()
class FruitCardDto {
  final String id;
  final String name;
  final String imagePath;
  final String date;
  final String puzzleImagePath;

  const FruitCardDto({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.date,
    required this.puzzleImagePath,
  });

  /// JSON에서 FruitCardDto 생성
  factory FruitCardDto.fromJson(Map<String, dynamic> json) =>
      _$FruitCardDtoFromJson(json);

  /// FruitCardDto를 JSON으로 변환
  Map<String, dynamic> toJson() => _$FruitCardDtoToJson(this);
}

/// 꽃 카드 DTO
@JsonSerializable()
class FlowerCardDto {
  final String id;
  final String name;
  final String imagePath;
  final String emotion;
  final String date;
  final String communicationText;

  const FlowerCardDto({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.emotion,
    required this.date,
    required this.communicationText,
  });

  /// JSON에서 FlowerCardDto 생성
  factory FlowerCardDto.fromJson(Map<String, dynamic> json) =>
      _$FlowerCardDtoFromJson(json);

  /// FlowerCardDto를 JSON으로 변환
  Map<String, dynamic> toJson() => _$FlowerCardDtoToJson(this);
}

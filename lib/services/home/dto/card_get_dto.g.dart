// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_get_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardGetDto _$CardGetDtoFromJson(Map<String, dynamic> json) => CardGetDto(
      fruitCards: (json['fruitCards'] as List<dynamic>)
          .map((e) => FruitCardDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      flowerCards: (json['flowerCards'] as List<dynamic>)
          .map((e) => FlowerCardDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CardGetDtoToJson(CardGetDto instance) =>
    <String, dynamic>{
      'fruitCards': instance.fruitCards,
      'flowerCards': instance.flowerCards,
    };

FruitCardDto _$FruitCardDtoFromJson(Map<String, dynamic> json) => FruitCardDto(
      id: json['id'] as String,
      name: json['name'] as String,
      imagePath: json['imagePath'] as String,
      date: json['date'] as String,
      puzzleImagePath: json['puzzleImagePath'] as String,
    );

Map<String, dynamic> _$FruitCardDtoToJson(FruitCardDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imagePath': instance.imagePath,
      'date': instance.date,
      'puzzleImagePath': instance.puzzleImagePath,
    };

FlowerCardDto _$FlowerCardDtoFromJson(Map<String, dynamic> json) =>
    FlowerCardDto(
      id: json['id'] as String,
      name: json['name'] as String,
      imagePath: json['imagePath'] as String,
      emotion: json['emotion'] as String,
      date: json['date'] as String,
      communicationText: json['communicationText'] as String,
    );

Map<String, dynamic> _$FlowerCardDtoToJson(FlowerCardDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imagePath': instance.imagePath,
      'emotion': instance.emotion,
      'date': instance.date,
      'communicationText': instance.communicationText,
    };

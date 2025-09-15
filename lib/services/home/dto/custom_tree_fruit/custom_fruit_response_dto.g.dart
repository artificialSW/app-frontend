// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_fruit_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomFruitResponseDto _$CustomFruitResponseDtoFromJson(Map<String, dynamic> json) =>
    CustomFruitResponseDto(
      fruits: (json['fruits'] as List<dynamic>)
          .map((e) => CustomFruitItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CustomFruitResponseDtoToJson(CustomFruitResponseDto instance) =>
    <String, dynamic>{
      'fruits': instance.fruits,
    };

CustomFruitItem _$CustomFruitItemFromJson(Map<String, dynamic> json) =>
    CustomFruitItem(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
      order: json['order'] as int,
      date: json['date'] as String,
    );

Map<String, dynamic> _$CustomFruitItemToJson(CustomFruitItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'imageUrl': instance.imageUrl,
      'category': instance.category,
      'order': instance.order,
      'date': instance.date,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_flower_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomFlowerResponseDto _$CustomFlowerResponseDtoFromJson(
  Map<String, dynamic> json,
) => CustomFlowerResponseDto(
  flowers:
      (json['flowers'] as List<dynamic>)
          .map((e) => CustomFlowerItem.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$CustomFlowerResponseDtoToJson(
  CustomFlowerResponseDto instance,
) => <String, dynamic>{'flowers': instance.flowers};

CustomFlowerItem _$CustomFlowerItemFromJson(Map<String, dynamic> json) =>
    CustomFlowerItem(
      id: json['id'] as String,
      name: json['name'] as String,
      question: json['question'] as String,
      category: json['category'] as String,
      order: (json['order'] as num).toInt(),
      date: json['date'] as String,
    );

Map<String, dynamic> _$CustomFlowerItemToJson(CustomFlowerItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'question': instance.question,
      'category': instance.category,
      'order': instance.order,
      'date': instance.date,
    };

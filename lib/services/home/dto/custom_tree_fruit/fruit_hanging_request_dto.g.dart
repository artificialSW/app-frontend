// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fruit_hanging_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FruitHangingRequestDto _$FruitHangingRequestDtoFromJson(
  Map<String, dynamic> json,
) => FruitHangingRequestDto(
  fruitHanging:
      (json['fruit-hanging'] as List<dynamic>)
          .map((e) => FruitHangingItem.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$FruitHangingRequestDtoToJson(
  FruitHangingRequestDto instance,
) => <String, dynamic>{'fruit-hanging': instance.fruitHanging};

FruitHangingItem _$FruitHangingItemFromJson(Map<String, dynamic> json) =>
    FruitHangingItem(
      id: json['id'] as String,
      order: (json['order'] as num).toInt(),
    );

Map<String, dynamic> _$FruitHangingItemToJson(FruitHangingItem instance) =>
    <String, dynamic>{'id': instance.id, 'order': instance.order};

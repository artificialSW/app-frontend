// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flower_hanging_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlowerHangingRequestDto _$FlowerHangingRequestDtoFromJson(Map<String, dynamic> json) =>
    FlowerHangingRequestDto(
      flowerHanging: (json['flower-hanging'] as List<dynamic>)
          .map((e) => FlowerHangingItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$FlowerHangingRequestDtoToJson(FlowerHangingRequestDto instance) =>
    <String, dynamic>{
      'flower-hanging': instance.flowerHanging,
    };

FlowerHangingItem _$FlowerHangingItemFromJson(Map<String, dynamic> json) =>
    FlowerHangingItem(
      id: json['id'] as String,
      order: json['order'] as int,
    );

Map<String, dynamic> _$FlowerHangingItemToJson(FlowerHangingItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order': instance.order,
    };

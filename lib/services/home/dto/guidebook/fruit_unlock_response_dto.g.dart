// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fruit_unlock_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FruitUnlockResponseDto _$FruitUnlockResponseDtoFromJson(
  Map<String, dynamic> json,
) => FruitUnlockResponseDto(
  resolvedFruits:
      (json['resolvedFruits'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
);

Map<String, dynamic> _$FruitUnlockResponseDtoToJson(
  FruitUnlockResponseDto instance,
) => <String, dynamic>{'resolvedFruits': instance.resolvedFruits};

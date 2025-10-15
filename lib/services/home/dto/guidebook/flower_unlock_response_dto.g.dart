// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flower_unlock_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlowerUnlockResponseDto _$FlowerUnlockResponseDtoFromJson(
  Map<String, dynamic> json,
) => FlowerUnlockResponseDto(
  resolvedFlowers:
      (json['resolvedFlowers'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
);

Map<String, dynamic> _$FlowerUnlockResponseDtoToJson(
  FlowerUnlockResponseDto instance,
) => <String, dynamic>{'resolvedFlowers': instance.resolvedFlowers};

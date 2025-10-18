// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_fruit_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArchiveFruitResponseDto _$ArchiveFruitResponseDtoFromJson(
  Map<String, dynamic> json,
) => ArchiveFruitResponseDto(
  fruitId: (json['fruitId'] as num).toInt(),
  fruitName: json['fruitName'] as String,
  archivedAt: json['archivedAt'] as String,
);

Map<String, dynamic> _$ArchiveFruitResponseDtoToJson(
  ArchiveFruitResponseDto instance,
) => <String, dynamic>{
  'fruitId': instance.fruitId,
  'fruitName': instance.fruitName,
  'archivedAt': instance.archivedAt,
};

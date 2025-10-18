// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archive_flower_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ArchiveFlowerResponseDto _$ArchiveFlowerResponseDtoFromJson(
  Map<String, dynamic> json,
) => ArchiveFlowerResponseDto(
  flowerId: (json['flowerId'] as num).toInt(),
  flowerName: json['flowerName'] as String,
  archivedAt: json['archivedAt'] as String,
);

Map<String, dynamic> _$ArchiveFlowerResponseDtoToJson(
  ArchiveFlowerResponseDto instance,
) => <String, dynamic>{
  'flowerId': instance.flowerId,
  'flowerName': instance.flowerName,
  'archivedAt': instance.archivedAt,
};

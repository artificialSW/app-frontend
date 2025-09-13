// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'puzzle_create_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PuzzleCreateRequestDto _$PuzzleCreateRequestDtoFromJson(
  Map<String, dynamic> json,
) => PuzzleCreateRequestDto(
  userId: json['userId'] as String,
  size: (json['size'] as num).toInt(),
);

Map<String, dynamic> _$PuzzleCreateRequestDtoToJson(
  PuzzleCreateRequestDto instance,
) => <String, dynamic>{'userId': instance.userId, 'size': instance.size};

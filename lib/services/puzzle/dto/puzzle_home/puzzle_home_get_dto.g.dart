// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'puzzle_home_get_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PuzzleHomeGetDto _$PuzzleHomeGetDtoFromJson(Map<String, dynamic> json) =>
    PuzzleHomeGetDto(
      ongoing1: PuzzleHomeOngoingPreviewDto.fromJson(
        json['ongoing1'] as Map<String, dynamic>,
      ),
      ongoing2: PuzzleHomeOngoingPreviewDto.fromJson(
        json['ongoing2'] as Map<String, dynamic>,
      ),
      completed1: PuzzleHomeCompletedPreviewDto.fromJson(
        json['completed1'] as Map<String, dynamic>,
      ),
      completed2: PuzzleHomeCompletedPreviewDto.fromJson(
        json['completed2'] as Map<String, dynamic>,
      ),
      keywords:
          (json['keywords'] as List<dynamic>).map((e) => e as String).toList(),
      isFull: json['isFull'] as bool,
    );

Map<String, dynamic> _$PuzzleHomeGetDtoToJson(PuzzleHomeGetDto instance) =>
    <String, dynamic>{
      'ongoing1': instance.ongoing1,
      'ongoing2': instance.ongoing2,
      'completed1': instance.completed1,
      'completed2': instance.completed2,
      'keywords': instance.keywords,
      'isFull': instance.isFull,
    };

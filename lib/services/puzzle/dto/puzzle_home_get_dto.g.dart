// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'puzzle_home_get_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PuzzleHomeGetDto _$PuzzleHomeGetDtoFromJson(Map<String, dynamic> json) =>
    PuzzleHomeGetDto(
      ongoing: PuzzleHomeOngoingPreviewDto.fromJson(
        json['ongoing'] as Map<String, dynamic>,
      ),
      completed: PuzzleHomeCompletedPreviewDto.fromJson(
        json['completed'] as Map<String, dynamic>,
      ),
      keywords:
          (json['keywords'] as List<dynamic>).map((e) => e as String).toList(),
      isFull: json['isFull'] as bool,
    );

Map<String, dynamic> _$PuzzleHomeGetDtoToJson(PuzzleHomeGetDto instance) =>
    <String, dynamic>{
      'ongoing': instance.ongoing,
      'completed': instance.completed,
      'keywords': instance.keywords,
      'isFull': instance.isFull,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'puzzle_home_get_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PuzzleHomeGetDto _$PuzzleHomeGetDtoFromJson(Map<String, dynamic> json) =>
    PuzzleHomeGetDto(
      category:
          (json['category'] as List<dynamic>).map((e) => e as String).toList(),
      inProgress:
          (json['inProgress'] as List<dynamic>)
              .map(
                (e) =>
                    e == null
                        ? null
                        : PuzzleHomeOngoingPreviewDto.fromJson(
                          e as Map<String, dynamic>,
                        ),
              )
              .toList(),
      completedThisWeek:
          (json['completedThisWeek'] as List<dynamic>)
              .map(
                (e) =>
                    e == null
                        ? null
                        : PuzzleHomeCompletedPreviewDto.fromJson(
                          e as Map<String, dynamic>,
                        ),
              )
              .toList(),
      empty: json['empty'] as bool,
      full: json['full'] as bool,
    );

Map<String, dynamic> _$PuzzleHomeGetDtoToJson(PuzzleHomeGetDto instance) =>
    <String, dynamic>{
      'category': instance.category,
      'inProgress': instance.inProgress,
      'completedThisWeek': instance.completedThisWeek,
      'empty': instance.empty,
      'full': instance.full,
    };

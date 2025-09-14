// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'puzzle_home_get_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PuzzleHomeGetDto _$PuzzleHomeGetDtoFromJson(
  Map<String, dynamic> json,
) => PuzzleHomeGetDto(
  subject: (json['subject'] as List<dynamic>).map((e) => e as String).toList(),
  inProgress:
      (json['inProgress'] as List<dynamic>)
          .map(
            (e) =>
                PuzzleHomeOngoingPreviewDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
  completedThisWeek:
      (json['completedThisWeek'] as List<dynamic>)
          .map(
            (e) => PuzzleHomeCompletedPreviewDto.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
  isFull: json['isFull'] as bool,
);

Map<String, dynamic> _$PuzzleHomeGetDtoToJson(PuzzleHomeGetDto instance) =>
    <String, dynamic>{
      'subject': instance.subject,
      'inProgress': instance.inProgress,
      'completedThisWeek': instance.completedThisWeek,
      'isFull': instance.isFull,
    };

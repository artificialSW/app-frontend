// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'puzzle_get_in_progress_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PuzzleGetInProgressListDto _$PuzzleGetInProgressListDtoFromJson(
  Map<String, dynamic> json,
) => PuzzleGetInProgressListDto(
  inProgressList:
      (json['inProgressList'] as List<dynamic>)
          .map(
            (e) =>
                PuzzleGetInProgressDataDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
);

Map<String, dynamic> _$PuzzleGetInProgressListDtoToJson(
  PuzzleGetInProgressListDto instance,
) => <String, dynamic>{'inProgressList': instance.inProgressList};

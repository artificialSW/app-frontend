// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'puzzle_get_completed_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PuzzleGetCompletedListDto _$PuzzleGetCompletedListDtoFromJson(
  Map<String, dynamic> json,
) => PuzzleGetCompletedListDto(
  completedList:
      (json['completedList'] as List<dynamic>)
          .map(
            (e) =>
                PuzzleGetCompletedDataDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
);

Map<String, dynamic> _$PuzzleGetCompletedListDtoToJson(
  PuzzleGetCompletedListDto instance,
) => <String, dynamic>{'completedList': instance.completedList};

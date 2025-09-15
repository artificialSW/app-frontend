// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'puzzle_get_archived_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PuzzleGetArchivedListDto _$PuzzleGetArchivedListDtoFromJson(
  Map<String, dynamic> json,
) => PuzzleGetArchivedListDto(
  archivedList:
      (json['archivedList'] as List<dynamic>)
          .map(
            (e) => PuzzleGetArchivedDataDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
);

Map<String, dynamic> _$PuzzleGetArchivedListDtoToJson(
  PuzzleGetArchivedListDto instance,
) => <String, dynamic>{'archivedList': instance.archivedList};

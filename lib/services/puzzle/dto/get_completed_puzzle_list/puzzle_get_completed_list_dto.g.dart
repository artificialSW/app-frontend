// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'puzzle_get_completed_list_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PuzzleGetCompletedListDto _$PuzzleGetCompletedListDtoFromJson(
  Map<String, dynamic> json,
) => PuzzleGetCompletedListDto(
  puzzleId: (json['puzzleId'] as num).toInt(),
  imageUrl: json['imageUrl'] as String,
  category: json['category'] as String,
  contributors:
      (json['contributors'] as List<dynamic>).map((e) => e as String).toList(),
  message: json['message'] as String,
);

Map<String, dynamic> _$PuzzleGetCompletedListDtoToJson(
  PuzzleGetCompletedListDto instance,
) => <String, dynamic>{
  'puzzleId': instance.puzzleId,
  'imageUrl': instance.imageUrl,
  'category': instance.category,
  'contributors': instance.contributors,
  'message': instance.message,
};

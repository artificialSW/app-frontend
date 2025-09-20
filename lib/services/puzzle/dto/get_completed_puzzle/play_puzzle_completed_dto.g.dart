// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'play_puzzle_completed_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayPuzzleCompletedDto _$PlayPuzzleCompletedDtoFromJson(
  Map<String, dynamic> json,
) => PlayPuzzleCompletedDto(
  imageUrl: json['imageUrl'] as String,
  size: (json['size'] as num).toInt(),
  message: json['message'] as String,
);

Map<String, dynamic> _$PlayPuzzleCompletedDtoToJson(
  PlayPuzzleCompletedDto instance,
) => <String, dynamic>{
  'imageUrl': instance.imageUrl,
  'size': instance.size,
  'message': instance.message,
};

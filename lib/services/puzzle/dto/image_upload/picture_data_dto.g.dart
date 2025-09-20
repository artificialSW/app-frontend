// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picture_data_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PictureDataDto _$PictureDataDtoFromJson(Map<String, dynamic> json) =>
    PictureDataDto(
      userId: json['userId'] as String,
      imageBase64: json['imageBase64'] as String,
      comment: json['comment'] as String,
      category: json['category'] as String,
    );

Map<String, dynamic> _$PictureDataDtoToJson(PictureDataDto instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'imageBase64': instance.imageBase64,
      'comment': instance.comment,
      'category': instance.category,
    };

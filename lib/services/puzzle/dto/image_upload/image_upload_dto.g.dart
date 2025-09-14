// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_upload_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageUploadDto _$ImageUploadDtoFromJson(Map<String, dynamic> json) =>
    ImageUploadDto(
      pictureData:
          (json['pictureData'] as List<dynamic>)
              .map((e) => PictureDataDto.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$ImageUploadDtoToJson(ImageUploadDto instance) =>
    <String, dynamic>{'pictureData': instance.pictureData};

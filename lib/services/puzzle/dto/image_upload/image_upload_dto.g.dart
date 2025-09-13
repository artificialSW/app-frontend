// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_upload_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageUploadDto _$ImageUploadDtoFromJson(Map<String, dynamic> json) =>
    ImageUploadDto(
      pictureData1: PictureDataDto.fromJson(
        json['pictureData1'] as Map<String, dynamic>,
      ),
      pictureData2: PictureDataDto.fromJson(
        json['pictureData2'] as Map<String, dynamic>,
      ),
      pictureData3: PictureDataDto.fromJson(
        json['pictureData3'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$ImageUploadDtoToJson(ImageUploadDto instance) =>
    <String, dynamic>{
      'pictureData1': instance.pictureData1,
      'pictureData2': instance.pictureData2,
      'pictureData3': instance.pictureData3,
    };

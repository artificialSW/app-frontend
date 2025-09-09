// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_upload_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageUploadDto _$ImageUploadDtoFromJson(Map<String, dynamic> json) =>
    ImageUploadDto(
      pictureData: PictureDataDto.fromJson(
        json['pictureData'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$ImageUploadDtoToJson(ImageUploadDto instance) =>
    <String, dynamic>{'pictureData': instance.pictureData};

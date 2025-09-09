import 'package:artificialsw_frontend/services/puzzle/dto/image_upload/picture_data_dto.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'image_upload_dto.g.dart'; // 자동 생성 파일

@JsonSerializable()
class ImageUploadDto {
  final PictureDataDto pictureData1;
  final PictureDataDto pictureData2;
  final PictureDataDto pictureData3;

  ImageUploadDto({
    required this.pictureData1,
    required this.pictureData2,
    required this.pictureData3,
  });

  factory ImageUploadDto.fromJson(Map<String, dynamic> json) =>
      _$ImageUploadDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ImageUploadDtoToJson(this);
}

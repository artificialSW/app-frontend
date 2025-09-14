import 'package:artificialsw_frontend/services/puzzle/dto/image_upload/picture_data_dto.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'image_upload_dto.g.dart'; // 자동 생성 파일

@JsonSerializable()
class ImageUploadDto {
  final List<PictureDataDto> pictureData;

  ImageUploadDto({
    required this.pictureData,
  });

  factory ImageUploadDto.fromJson(Map<String, dynamic> json) =>
      _$ImageUploadDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ImageUploadDtoToJson(this);
}

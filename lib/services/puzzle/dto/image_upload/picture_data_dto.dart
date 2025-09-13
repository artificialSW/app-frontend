import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'picture_data_dto.g.dart'; // 자동 생성 파일

@JsonSerializable()
class PictureDataDto {
  final String userId;
  final String imageFile;
  final String comment;
  final String category;

  PictureDataDto({
    required this.userId,
    required this.imageFile,
    required this.comment,
    required this.category,
  });

  factory PictureDataDto.fromJson(Map<String, dynamic> json) =>
      _$PictureDataDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PictureDataDtoToJson(this);
}

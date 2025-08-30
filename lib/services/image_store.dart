import 'dart:io';
import 'package:flutter/material.dart';

class ImageStore {
  static final ImageStore _instance = ImageStore._internal();
  factory ImageStore() => _instance;
  ImageStore._internal();

  final List<File> imageFileList = [];     // 실제 파일
  final List<Image> imageWidgetList = [];
}
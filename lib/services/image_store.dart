import 'dart:io';
import 'package:flutter/material.dart';

class ImageStore extends ChangeNotifier { ///지금은 이거 원격 DB 느낌으로 쓰고 있지만 실제로는 로컬에서 '너 3장 제출했어?' 이거 체크용으로 쓸듯 간단하게
  // 싱글턴 패턴 유지
  static final ImageStore _instance = ImageStore._internal();
  factory ImageStore() => _instance;
  ImageStore._internal();

  // 원본 파일 리스트
  final List<File> imageFileList = [];

  // UI에 표시할 이미지 위젯 리스트
  final List<Image> _imageWidgetList = [];

  // 외부에서 읽기 전용으로 접근
  List<Image> get imageWidgetList => List.unmodifiable(_imageWidgetList);

  // 이미지 위젯 추가
  void addImageWidget(Image image) {
    _imageWidgetList.add(image);
    notifyListeners();
  }

  // 여러 이미지 위젯 한꺼번에 추가
  void addImageWidgets(List<Image> images) {
    _imageWidgetList.addAll(images);
    notifyListeners();
  }

  // 모든 이미지 위젯 삭제
  void clearImageWidgets() {
    _imageWidgetList.clear();
    notifyListeners();
  }

  // 특정 이미지 위젯 삭제
  void removeImageWidgetAt(int index) {
    if (index >= 0 && index < _imageWidgetList.length) {
      _imageWidgetList.removeAt(index);
      notifyListeners();
    }
  }

  // 이미지 위젯 개수 반환
  int get widgetCount => _imageWidgetList.length;

  // 리스트가 비어 있는지 여부
  bool get isEmpty => _imageWidgetList.isEmpty;

  // 리스트가 비어 있지 않은지 여부
  bool get isNotEmpty => _imageWidgetList.isNotEmpty;
}


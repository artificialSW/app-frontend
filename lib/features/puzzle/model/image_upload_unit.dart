import 'dart:io';

class UploadUnit {
  final File imageFile;
  final String comment;
  final String category;

  UploadUnit({
    required this.imageFile,
    required this.comment,
    required this.category,
  });
}
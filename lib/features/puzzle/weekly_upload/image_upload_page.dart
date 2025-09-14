import 'dart:convert';
import 'dart:io';
import 'package:artificialsw_frontend/features/puzzle/model/image_upload_unit.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/image_upload/image_upload_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/image_upload/picture_data_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/puzzle_service.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadPage extends StatefulWidget {
  final List<String> category;

  const ImageUploadPage({super.key, required this.category});

  @override
  State<ImageUploadPage> createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {

  @override
  void initState() {
    super.initState();
    _commentController.addListener(() {
      setState(() {});
    });
  }


  final List<UploadUnit> _uploads = [];
  File? _currentImage;
  final TextEditingController _commentController = TextEditingController();

  final int maxCount = 3;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _currentImage = File(picked.path);
      });
    }
  }

  void _saveCurrentEntry(int curridx) {
    if (_currentImage != null && _commentController.text.isNotEmpty) {
      setState(() {
        _uploads.add(
          UploadUnit(
            imageFile: _currentImage!,
            comment: _commentController.text,
            category: widget.category[curridx],
          ),
        );
        _currentImage = null;
        _commentController.clear();
      });
    }
    print('${_uploads[curridx].category} UploadUnit 등록 완료');
  }

  Future<void> _submitAll() async {
    // pictureData 배열 준비
    final List<Map<String, dynamic>> pictureDataList = [];

    for (final item in _uploads) {
      final base64String = await imageFileToBase64(item.imageFile);

      pictureDataList.add({
        "userId": 123, // int로 그대로 넣음
        "imageBase64": "${base64String.substring(0, 50)}...",
        "comment": item.comment,
        "category": item.category,
      });

      // 실제 업로드
      await PuzzleService().uploadPuzzleImagesWithMetadata(
        ImageUploadDto(
          pictureData: [
            PictureDataDto(
              userId: "123",
              imageBase64: base64String,
              comment: item.comment,
              category: item.category,
            ),
          ],
        ),
      );
    }

    // ✅ JSON 형식으로 보기 좋게 출력
    const encoder = JsonEncoder.withIndent('  ');
    print('pictureData: ${encoder.convert(pictureDataList)}');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ 전체 업로드 완료!')),
    );

    Navigator.of(context).pushNamed('/');
  }

  Future<String> imageFileToBase64(File imageFile) async {
    final imageBytes = await imageFile.readAsBytesSync();
    return base64Encode(imageBytes);
  }

  @override
  Widget build(BuildContext context) {
    final isEntryComplete = _currentImage != null && _commentController.text.isNotEmpty;
    final isDone = _uploads.length >= maxCount;
    final currentIndex = _uploads.length;

    return Scaffold(
      appBar: AppBar(title: Text('사진 + 코멘트 입력')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_uploads.length < maxCount) ...[
              Text(
                '주제: ${widget.category[currentIndex]}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text(_currentImage == null ? '이미지 선택' : '이미지 다시 선택'),
              ),
              SizedBox(height: 10),
              if (_currentImage != null) Image.file(_currentImage!, height: 150),
              SizedBox(height: 10),
              TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: '코멘트를 입력하세요',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: isEntryComplete ? () => _saveCurrentEntry(currentIndex) : null,
                child: Text('저장 (${_uploads.length + 1}/$maxCount)'),
              ),
            ] else
              Text('모든 이미지와 코멘트 입력 완료'),
            Spacer(),
            ElevatedButton(
              onPressed: isDone ? _submitAll : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDone ? Colors.blue : Colors.grey,
              ),
              child: Text('🚀 업로드하기'),
            ),
          ],
        ),
      ),
    );
  }
}


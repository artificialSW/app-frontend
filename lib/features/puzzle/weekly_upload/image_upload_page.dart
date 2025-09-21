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
// 디자인 통일: CustomAppBar, CustomButton 적용
// 색상, 폰트: AppColors, AppTextStyles 적용

import 'dart:convert';
import 'dart:io';

import 'package:artificialsw_frontend/features/puzzle/model/image_upload_unit.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/image_upload/image_upload_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/image_upload/picture_data_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/puzzle_service.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadPage extends StatefulWidget {
  final List<String> category;

  const ImageUploadPage({super.key, required this.category});

  @override
  State<ImageUploadPage> createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  final List<UploadUnit> _uploads = [];
  File? _currentImage;
  final TextEditingController _commentController = TextEditingController();
  final int maxCount = 3;

  @override
  void initState() {
    super.initState();
    _commentController.addListener(() => setState(() {}));
  }

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
  }

  Future<void> _submitAll() async {
    final List<Map<String, dynamic>> pictureDataList = [];

    for (final item in _uploads) {
      final base64String = base64Encode(await item.imageFile.readAsBytes());

      pictureDataList.add({
        "userId": 123,
        "imageBase64": "${base64String.substring(0, 50)}...",
        "comment": item.comment,
        "category": item.category,
      });

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

    // ✅ 보기 좋게 JSON 출력 (디버깅용)
    const encoder = JsonEncoder.withIndent('  ');
    print('pictureData: ${encoder.convert(pictureDataList)}');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ 전체 업로드 완료!')),
    );

    Navigator.of(context).pushNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    final isEntryComplete = _currentImage != null && _commentController.text.isNotEmpty;
    final isDone = _uploads.length >= maxCount;
    final currentIndex = _uploads.length;

    return Scaffold(
      appBar: CanGoBackTopBar('사진 업로드', context),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_uploads.length < maxCount) ...[
              Text(
                '주제: ${widget.category[currentIndex]}',
                style: AppTextStyles.pretendard_bold.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: _currentImage == null ? '이미지 선택' : '이미지 다시 선택',
                onPressed: _pickImage,
              ),
              const SizedBox(height: 12),
              if (_currentImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(_currentImage!, height: 160),
                ),
              const SizedBox(height: 12),
              TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: '코멘트를 입력하세요',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: '저장 (${_uploads.length + 1}/$maxCount)',
                onPressed: isEntryComplete ? () => _saveCurrentEntry(currentIndex) : null,
              ),
            ] else ...[
              Center(
                child: Text(
                  '모든 이미지와 코멘트 입력 완료 🎉',
                  style: AppTextStyles.pretendard_bold.copyWith(fontSize: 16),
                ),
              ),
            ],
            const Spacer(),
            CustomButton(
              text: '🚀 업로드하기',
              onPressed: isDone ? _submitAll : null,
              backgroundColor: isDone ? AppColors.plumu_green_main : AppColors.plumu_gray_3,
            ),
          ],
        ),
      ),
    );
  }
}

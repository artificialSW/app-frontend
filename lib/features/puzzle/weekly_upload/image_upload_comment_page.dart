import 'dart:io';
import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_top_bar.dart';
import 'dart:math';

class CommentPage extends StatefulWidget {
  final String currentCategory;
  final File? currentImage;   // 새로 고른 이미지 (없으면 null)
  final File? existingImage;  // 기존 저장된 이미지 (없으면 null)
  final String initialText;   // 초기 코멘트 텍스트

  const CommentPage({
    super.key,
    required this.currentCategory,
    this.currentImage,
    this.existingImage,
    this.initialText = '',
  });

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText);
    _controller.addListener(_onTextChange);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChange);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChange() {
    print('현재 텍스트: "${_controller.text}"'); // 👈 디버깅
    if (mounted) setState(() {});
  }

  File? get _previewImage => widget.currentImage ?? widget.existingImage;

  bool get _canSave =>
      _previewImage != null && _controller.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    print("CommentPage 들어옴, currentImage=${widget.currentImage?.path}, existingImage=${widget.existingImage?.path}");

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CanGoBackTopBar('코멘트', context),
      backgroundColor: AppColors.plumu_white,
      body: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 카테고리 라벨
            Container( //주제(카테고리)
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.plumu_green_main,
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: Text(
                widget.currentCategory,
                style: AppTextStyles.pretendard_bold.copyWith(
                  fontSize: 14,
                  color: AppColors.plumu_white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // 이미지 미리보기
            if (_previewImage != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  _previewImage!,
                  height: min(screenHeight*0.3, screenWidth*0.8),
                  width: min(screenHeight*0.3, screenWidth*0.8),
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
            ],
            // 텍스트 입력
            Container(
              width: screenWidth*0.8,
              height: screenHeight*0.1,
              child: TextField(
                controller: _controller,
                autofocus: true,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: '코멘트를 남겨주세요.',
                  filled: true,
                  fillColor: const Color(0xFFFFFFFF), // background: #FFF
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFAAAAAA), // border: 1px solid #AAA
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16), // border-radius: 16px
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFFAAAAAA),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const Spacer(),
            // 저장 버튼
            SizedBox(width: double.infinity,), ///이거 중앙정렬 위해 필요함.(지우지말기)
            SizedBox(
              width: screenWidth*0.7,
              child: TextButton(
                onPressed: _canSave
                    ? () => Navigator.pop(context, {
                  'image': _previewImage,
                  'comment': _controller.text.trim(),
                })
                    : null,
                style: TextButton.styleFrom(
                  backgroundColor: _canSave
                      ? AppColors.plumu_green_main
                      : AppColors.plumu_gray_3,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  '코멘트 남기기',
                  style: AppTextStyles.pretendard_bold.copyWith(
                    color: AppColors.plumu_white,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}

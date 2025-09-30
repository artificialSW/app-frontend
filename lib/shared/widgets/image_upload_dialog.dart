import 'dart:io';
import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';

class CommentDialog extends StatefulWidget {
  final TextEditingController controller;
  final String currentCategory;
  final File? currentImage;   // 새로 고른 이미지 (없으면 null)
  final File? existingImage;  // 기존 저장된 이미지 (없으면 null)
  final VoidCallback onCancel; // 취소 콜백 (예: _currentImage = null; controller.clear();)
  final VoidCallback onSave;   // 저장 콜백 (예: _saveCurrentEntry(idx))

  const CommentDialog({
    super.key,
    required this.controller,
    required this.currentCategory,
    required this.onCancel,
    required this.onSave,
    this.currentImage,
    this.existingImage,
  });

  @override
  State<CommentDialog> createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChange);
    super.dispose();
  }

  void _onTextChange() {
    // 텍스트 변경 시 저장 버튼 활성/비활성 즉시 반영
    if (mounted) setState(() {});
  }

  File? get _previewImage => widget.currentImage ?? widget.existingImage;

  bool get _canSave =>
      _previewImage != null && widget.controller.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.plumu_white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.plumu_green_main,
            borderRadius: const BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          child: Text(
            widget.currentCategory,
            style: AppTextStyles.pretendard_bold.copyWith(
              fontSize: 14,
              color: AppColors.plumu_white,
            ),
          ),
        )
      ),
      content: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (_previewImage != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                _previewImage!,
                height: 230,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
          ],
          TextField(
            controller: widget.controller,
            autofocus: true,
            maxLines: null,
            decoration: const InputDecoration(
              hintText: '사진에 대한 코멘트를 입력하세요',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      actions: [
        TextButton(
          onPressed: widget.onCancel,
          child: Text(
            '취소',
            style: AppTextStyles.pretendard_medium.copyWith(
              color: AppColors.plumu_gray_6,
              fontSize: 14,
            ),
          ),
        ),
        TextButton(
          onPressed: _canSave ? widget.onSave : null,
          style: TextButton.styleFrom(
            backgroundColor:
            _canSave ? AppColors.plumu_green_main : AppColors.plumu_gray_3,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(
            '저장',
            style: AppTextStyles.pretendard_bold.copyWith(
              color: AppColors.plumu_white,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

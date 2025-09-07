import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';

/// 단계 제목
class QuestionStepTitle extends StatelessWidget {
  final String title;
  const QuestionStepTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.pretendard_bold.copyWith(
        fontSize: 20,
        color: AppColors.plumu_gray_7,
        height: 1.35,
      ),
    );
  }
}

/// 선택 버튼 (가족/공개여부)
class QuestionSelectButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final double? width;
  final double? height;

  const QuestionSelectButton({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final button = CustomButton(
      text: text,
      onPressed: onTap,
      width: width ?? 100,
      height: height ?? 48,
      fontSize: 16,
      textColor: isSelected ? AppColors.plumu_white : AppColors.plumu_gray_7,
      backgroundColor:
      isSelected ? AppColors.plumu_green_main : AppColors.plumu_white,
      borderRadius: BorderRadius.circular(12),
    );

    // 비선택 상태일 때 border 추가
    if (!isSelected) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.plumu_gray_3, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: button,
      );
    }
    return button;
  }
}

/// 텍스트 입력
class QuestionTextInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;
  final int maxLength;

  const QuestionTextInput({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.hintText,
    this.maxLength = 150,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: AppColors.plumu_white,
        border: Border.all(color: AppColors.plumu_gray_3, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          TextField(
            controller: controller,
            maxLength: maxLength,
            maxLines: null,
            expands: true,
            textAlignVertical: TextAlignVertical.top,
            style: AppTextStyles.pretendard_regular.copyWith(fontSize: 16),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: AppTextStyles.pretendard_regular.copyWith(
                fontSize: 16,
                color: AppColors.plumu_gray_5,
              ),
              contentPadding: const EdgeInsets.all(16),
              border: InputBorder.none,
              counterText: '',
            ),
            onChanged: onChanged,
          ),
          Positioned(
            bottom: 8,
            right: 12,
            child: Text(
              '${controller.text.length}/$maxLength',
              style: AppTextStyles.pretendard_regular.copyWith(
                fontSize: 12,
                color: AppColors.plumu_gray_5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 성공 화면
class QuestionSuccessScreen extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color backgroundColor;

  const QuestionSuccessScreen({
    super.key,
    required this.message,
    this.icon = Icons.check_rounded,
    this.backgroundColor = AppColors.plumu_green_main,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor, // #5CBD56
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.plumu_white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: backgroundColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.pretendard_bold.copyWith(
                color: AppColors.plumu_white,
                fontSize: 27,
                height: 1.33,
                letterSpacing: -0.05,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

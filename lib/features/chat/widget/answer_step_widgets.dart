import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';

/// 개인 답변 카드 위젯
class PersonalAnswerCard extends StatelessWidget {
  final String sender;
  final String question;
  final VoidCallback onReply;
  final bool isActive;

  const PersonalAnswerCard({
    super.key,
    required this.sender,
    required this.question,
    required this.onReply,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      height: 94,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          // 텍스트
          Positioned(
            left: 16,
            top: 12,
            right: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "'$sender'가 보냈어요!",
                  style: AppTextStyles.pretendard_bold.copyWith(
                    color: AppColors.plumu_gray_7,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  question,
                  style: AppTextStyles.pretendard_regular.copyWith(
                    color: AppColors.plumu_gray_7,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // 잠금 아이콘
          Positioned(
            right: 12,
            top: 10,
            child: Image.asset(AppAssets.lock_fill, width: 20, height: 25, color: const Color(0x7F5CBD56)),
          ),
          // 답변하기 버튼
          Positioned(
            right: 16,
            bottom: 12,
            child: CustomButton(
              text: '답변하기',
              onPressed: onReply,
              width: 79,
              height: 31,
              fontSize: 12,
              textColor: AppColors.plumu_gray_7,
              backgroundColor: Colors.white.withValues(alpha: 0.60),
              borderRadius: BorderRadius.circular(15.50),
            ),
          ),
        ],
      ),
    );
  }
}

/// 답변 작성 텍스트 필드 위젯
class AnswerTextInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;

  const AnswerTextInput({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.plumu_white,
        border: Border.all(color: AppColors.plumu_gray_2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
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
        ),
        onChanged: onChanged,
      ),
    );
  }
}

/// 성공 화면 위젯
class AnswerSuccessScreen extends StatelessWidget {
  final String message;

  const AnswerSuccessScreen({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.plumu_green_main,
      extendBodyBehindAppBar: true,
      // AppBar 완전 제거로 진짜 전체화면 구현
      body: Stack(
        children: [
          Builder(
            builder: (context) {
              final size = MediaQuery.of(context).size;

              // 디자인(스크린샷) 기준 캔버스
              const double designW = 412.0;
              const double designH = 917.0;

              const double chickWDesign = 372.0 ; // 25% 크게
              const double rightDesign   = -4.0;
              const double bottomDesign  = -2.0; // 맨 하단에 거의 붙도록 내림

              final double scaleW = size.width / designW;
              final double scaleH = size.height / designH;

              final double chickW = chickWDesign * scaleW;
              final double right  = rightDesign * scaleW;
              final double bottom = bottomDesign * scaleH;

              return Positioned(
                right: right,
                bottom: bottom,
                width: chickW,
                height: chickW,
                child: IgnorePointer(
                  child: Image.asset(
                    'assets/images/app_character_smile.png',
                    fit: BoxFit.contain, // 이미지 자체는 잘리지 않음
                    alignment: Alignment.bottomRight,
                  ),
                ),
              );
            },
          ),
          // ⬆⬆⬆ 병아리 부분 끝 (다른 요소는 그대로) ⬆⬆⬆

          // 중앙 성공 메시지
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: AppColors.plumu_white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 36,
                    color: AppColors.plumu_green_main,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.pretendard_bold.copyWith(
                    color: AppColors.plumu_white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

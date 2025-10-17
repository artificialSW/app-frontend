import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import '../../widget/send_step_widgets.dart';

class StepWrite extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const StepWrite({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final widthRatio = screenWidth / 412.0;
    final heightRatio = screenHeight / 917.0;

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // 제목: 좌측패딩 32, 하단패딩 740 (화면 맨 아래부터)
          Positioned(
            left: 32 * widthRatio,
            bottom: 740 * heightRatio,
            child: Text(
              '질문을 작성해주세요',
              style: TextStyle(
                color: const Color(0xFF1B1D1B),
                fontSize: 27 * widthRatio,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w700,
                height: 1.19,
                letterSpacing: -0.32 * widthRatio,
              ),
            ),
          ),
          
          // 질문 작성 박스: 좌우로는 중앙, 하단패딩 418 (화면 맨 아래부터)
          Positioned(
            left: 0,
            right: 0,
            bottom: 418 * heightRatio,
            child: Center(
              child: Container(
                width: 348 * widthRatio,
                height: 267 * heightRatio,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: const Color(0xFFAAAAAA),
                    ),
                    borderRadius: BorderRadius.circular(16 * widthRatio),
                  ),
                ),
                child: Stack(
                  children: [
                    TextField(
                      controller: controller,
                      maxLength: 150,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      style: AppTextStyles.pretendard_regular.copyWith(fontSize: 16 * widthRatio),
                      decoration: InputDecoration(
                        hintText: '질문을 작성해주세요',
                        hintStyle: AppTextStyles.pretendard_regular.copyWith(
                          fontSize: 16 * widthRatio,
                          color: AppColors.plumu_gray_5,
                        ),
                        contentPadding: EdgeInsets.all(16 * widthRatio),
                        border: InputBorder.none,
                        counterText: '',
                      ),
                      onChanged: onChanged,
                    ),
                    Positioned(
                      bottom: 8 * heightRatio,
                      right: 12 * widthRatio,
                      child: Text(
                        '${controller.text.length}/150',
                        style: AppTextStyles.pretendard_regular.copyWith(
                          fontSize: 12 * widthRatio,
                          color: AppColors.plumu_gray_5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';

class MessageBubble extends StatelessWidget {
  final TextEditingController controller;

  const MessageBubble({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTextStyles.pretendard_medium.copyWith(
      color: AppColors.plumu_green_main,
      fontSize: 14,
    );
    
    return Padding(
      padding: const EdgeInsets.only(left: 32.0), // 퍼즐 아이콘과 메시지 아이콘과 동일한 패딩
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 버블 본체
          Container(
            width: 197.11,
            height: 53.94,
            decoration: ShapeDecoration(
              color: const Color(0xFFC6EEC8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(33),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x26000000),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 162.20,
                  maxHeight: 16.67,
                ),
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  cursorColor: AppColors.plumu_green_main,
                  style: textStyle,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    hintText: '간단한 메세지를 남겨봐요!',
                    hintStyle: textStyle,
                  ),
                ),
              ),
            ),
          ),
          // 꼬리 이미지 (아래 중앙 배치)
          Positioned(
            bottom: -20, // 더 아래로 빼서 자연스럽게
            left: 80, // 버블 본체 중앙 (197.11 / 2 - 37 / 2)
            child: Image.asset(
              'assets/icons/bubble_2.png',
              width: 37, // 컨테이너 폭 대비 200:37 비율로 조정
              height: 25,
            ),
          ),
        ],
      ),
    );
  }
}

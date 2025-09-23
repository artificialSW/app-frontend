import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';

/// 해시태그 위젯
/// 동백꽃 상세 페이지에서 사용되는 해시태그 컴포넌트
class HashTagWidget extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  
  const HashTagWidget({
    super.key,
    required this.text,
    this.backgroundColor = AppColors.plumu_flower_love_card_end,
    this.borderColor = AppColors.plumu_flower_love_check,
    this.textColor = AppColors.plumu_flower_love_check,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.41, vertical: 7.09),
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1.01,
            color: borderColor,
          ),
          borderRadius: BorderRadius.circular(21.13),
        ),
      ),
      alignment: Alignment.centerLeft, // 왼쪽 정렬로 변경
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 16.10,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

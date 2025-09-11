import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';

class FlowerCard extends StatelessWidget {
  final String flowerName;
  final String flowerImagePath;
  final String date;

  const FlowerCard({
    super.key,
    required this.flowerName,
    required this.flowerImagePath,
    this.date = '2025.09.11',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF4FFEC), Color(0xFFAEE77D)],
        ),
      ),
      child: Stack(
        children: [
          // 체크 아이콘
          Positioned(
            right: 6,
            top: 6,
            child: Icon(
              Icons.check_circle,
              color: const Color(0xFF7DD334),
              size: 20,
            ),
          ),

          // 꽃 이미지
          Center(
            child: Image.asset(
              flowerImagePath,
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            ),
          ),

          // 날짜
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Text(
              date,
              textAlign: TextAlign.center,
              style: AppTextStyles.pretendard_medium.copyWith(
                fontSize: 10,
                color: AppColors.plumu_gray_2,
              ),
            ),
          ),

          // 꽃 이름
          Positioned(
            bottom: 6,
            left: 0,
            right: 0,
            child: Text(
              flowerName,
              textAlign: TextAlign.center,
              style: AppTextStyles.pretendard_bold.copyWith(
                fontSize: 12,
                color: AppColors.plumu_black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

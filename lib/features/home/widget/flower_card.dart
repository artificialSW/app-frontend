import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';

/// 꽃 카드 위젯
/// 소통을 통해 얻은 꽃을 표시하는 카드 컴포넌트
/// 클릭 시 나무에 달기/해제 가능
class FlowerCard extends StatelessWidget {
  final String flowerName;        // 꽃 이름 (예: "장미", "벚꽃")
  final String flowerImagePath;   // 꽃 이미지 경로
  final String date;              // 소통한 날짜
  final int order;                // 나무에 달린 위치 (0: 안달림, 1-3: 위치)
  final VoidCallback? onTap;      // 카드 클릭 시 호출되는 콜백

  const FlowerCard({
    super.key,
    required this.flowerName,
    required this.flowerImagePath,
    this.date = '2025.09.11',
    this.order = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xFFF7F7F7), // 단일 색상으로 변경
      ),
      child: Stack(
        children: [
          // 꽃 이미지 (카드 중앙에서 조금 위로)
          Positioned(
            top: 15, // 위쪽에서 15px 떨어진 위치
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                flowerImagePath,
                width: 60, // 크기를 50에서 60으로 증가
                height: 60, // 크기를 50에서 60으로 증가
                fit: BoxFit.contain,
              ),
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
                color: Color(0xFF797979),
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

import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';

/// 과일 카드 위젯
/// 퍼즐을 완성한 과일을 표시하는 카드 컴포넌트
/// 계절별 색상과 체크 상태를 표시하며, 클릭 시 나무에 달기/해제 가능
class FruitCard extends StatelessWidget {
  final String fruitName;        // 과일 이름 (예: "사과", "딸기")
  final String fruitImagePath;   // 과일 이미지 경로
  final String date;             // 퍼즐을 푼 날짜
  final String season;           // 계절 ('spring', 'summer', 'fall', 'winter')
  final int order;               // 나무에 달린 위치 (0: 안달림, 1-3: 위치)
  final VoidCallback? onTap;     // 카드 클릭 시 호출되는 콜백

  const FruitCard({
    super.key,
    required this.fruitName,
    required this.fruitImagePath,
    required this.season,
    this.date = '2025.09.11',
    this.order = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 계절별 색상 설정 (카드 배경 그라데이션과 체크 아이콘 색상)
    List<Color> cardColors;
    Color checkColor;
    
    switch (season) {
      case 'spring':  // 봄: 연한 핑크/그린 계열
        cardColors = [AppColors.plumu_spring_card_start, AppColors.plumu_spring_card_end];
        checkColor = AppColors.plumu_spring_check;
        break;
      case 'summer':  // 여름: 밝은 오렌지/옐로우 계열
        cardColors = [AppColors.plumu_summer_card_start, AppColors.plumu_summer_card_end];
        checkColor = AppColors.plumu_summer_check;
        break;
      case 'fall':    // 가을: 따뜻한 오렌지/브라운 계열
        cardColors = [AppColors.plumu_fall_card_start, AppColors.plumu_fall_card_end];
        checkColor = AppColors.plumu_fall_check;
        break;
      case 'winter':  // 겨울: 차가운 블루/퍼플 계열
        cardColors = [AppColors.plumu_winter_card_start, AppColors.plumu_winter_card_end];
        checkColor = AppColors.plumu_winter_check;
        break;
      default:        // 기본값: 여름 색상
        cardColors = [AppColors.plumu_summer_card_start, AppColors.plumu_summer_card_end];
        checkColor = AppColors.plumu_summer_check;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: cardColors,  // 계절별 그라데이션 색상
        ),
      ),
      child: Stack(
        children: [
          // 체크 아이콘 (클릭 가능) - 나무에 달렸는지 표시
          Positioned(
            right: 6,
            top: 6,
            child: GestureDetector(
              onTap: onTap,  // 클릭 시 나무에 달기/해제
              child: Icon(
                order > 0 ? Icons.check_circle : Icons.check_circle_outline,
                color: checkColor,  // 계절별 체크 아이콘 색상
                size: 20,
              ),
            ),
          ),

          // 과일 이미지 (카드 중앙)
          Center(
            child: Image.asset(
              fruitImagePath,
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            ),
          ),

          // 퍼즐 완성 날짜 (카드 하단)
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Text(
              date,
              textAlign: TextAlign.center,
              style: AppTextStyles.pretendard_medium.copyWith(
                fontSize: 10,
                color: Color(0xFF797979),  // 회색 텍스트
              ),
            ),
          ),

          // 과일 이름 (카드 최하단)
          Positioned(
            bottom: 6,
            left: 0,
            right: 0,
            child: Text(
              fruitName,
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

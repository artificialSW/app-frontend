import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';

class FruitCard extends StatelessWidget {
  final String fruitName;
  final String fruitImagePath;
  final String date;
  final String season; // 'spring', 'summer', 'fall', 'winter'
  final bool isSelected;
  final VoidCallback? onTap;

  const FruitCard({
    super.key,
    required this.fruitName,
    required this.fruitImagePath,
    required this.season,
    this.date = '2025.09.11',
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 계절별 색상 설정
    List<Color> cardColors;
    Color checkColor;
    
    switch (season) {
      case 'spring':
        cardColors = [AppColors.plumu_spring_card_start, AppColors.plumu_spring_card_end];
        checkColor = AppColors.plumu_spring_check;
        break;
      case 'summer':
        cardColors = [AppColors.plumu_summer_card_start, AppColors.plumu_summer_card_end];
        checkColor = AppColors.plumu_summer_check;
        break;
      case 'fall':
        cardColors = [AppColors.plumu_fall_card_start, AppColors.plumu_fall_card_end];
        checkColor = AppColors.plumu_fall_check;
        break;
      case 'winter':
        cardColors = [AppColors.plumu_winter_card_start, AppColors.plumu_winter_card_end];
        checkColor = AppColors.plumu_winter_check;
        break;
      default:
        cardColors = [AppColors.plumu_summer_card_start, AppColors.plumu_summer_card_end];
        checkColor = AppColors.plumu_summer_check;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: cardColors,
          ),
        ),
        child: Stack(
          children: [
            // 체크 아이콘
            Positioned(
              right: 6,
              top: 6,
              child: Icon(
                isSelected ? Icons.check_circle : Icons.check_circle_outline,
                color: checkColor,
                size: 20,
              ),
            ),

          // 과일 이미지
          Center(
            child: Image.asset(
              fruitImagePath,
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
                color: Color(0xFF797979),
              ),
            ),
          ),

          // 과일 이름
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
      ),
    );
  }
}

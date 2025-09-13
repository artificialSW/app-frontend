import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';

class FlowerCard extends StatelessWidget {
  final String flowerName;
  final String flowerImagePath;
  final String date;
  final String emotion; // 'love', 'comfort', 'special', 'memory', 'joy', 'hobby'
  final bool isSelected;
  final VoidCallback? onTap;

  const FlowerCard({
    super.key,
    required this.flowerName,
    required this.flowerImagePath,
    required this.emotion,
    this.date = '2025.09.11',
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 감정별 색상 설정
    List<Color> cardColors;
    Color checkColor;
    
    switch (emotion) {
      case 'love':
        cardColors = [AppColors.plumu_flower_love_card_start, AppColors.plumu_flower_love_card_end];
        checkColor = AppColors.plumu_flower_love_check;
        break;
      case 'comfort':
        cardColors = [AppColors.plumu_flower_comfort_card_start, AppColors.plumu_flower_comfort_card_end];
        checkColor = AppColors.plumu_flower_comfort_check;
        break;
      case 'special':
        cardColors = [AppColors.plumu_flower_special_card_start, AppColors.plumu_flower_special_card_end];
        checkColor = AppColors.plumu_flower_special_check;
        break;
      case 'memory':
        cardColors = [AppColors.plumu_flower_memory_card_start, AppColors.plumu_flower_memory_card_end];
        checkColor = AppColors.plumu_flower_memory_check;
        break;
      case 'joy':
        cardColors = [AppColors.plumu_flower_joy_card_start, AppColors.plumu_flower_joy_card_end];
        checkColor = AppColors.plumu_flower_joy_check;
        break;
      case 'hobby':
        cardColors = [AppColors.plumu_flower_hobby_card_start, AppColors.plumu_flower_hobby_card_end];
        checkColor = AppColors.plumu_flower_hobby_check;
        break;
      default:
        cardColors = [AppColors.plumu_flower_joy_card_start, AppColors.plumu_flower_joy_card_end];
        checkColor = AppColors.plumu_flower_joy_check;
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
      ),
    );
  }
}

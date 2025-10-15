import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';

/// 꽃 카드 위젯
/// 소통을 통해 얻은 꽃을 표시하는 카드 컴포넌트
/// 감정별 색상과 체크 상태를 표시하며, 클릭 시 나무에 달기/해제 가능
class FlowerCard extends StatelessWidget {
  final String flowerName;        // 꽃 이름 (예: "장미", "벚꽃")
  final String flowerImagePath;   // 꽃 이미지 경로
  final String date;              // 소통한 날짜
  final String emotion;           // 감정 ('love', 'comfort', 'special', 'memory', 'joy', 'hobby')
  final int order;                // 나무에 달린 위치 (0: 안달림, 1-3: 위치)
  final VoidCallback? onTap;      // 카드 클릭 시 호출되는 콜백

  const FlowerCard({
    super.key,
    required this.flowerName,
    required this.flowerImagePath,
    required this.emotion,
    this.date = '2025.09.11',
    this.order = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // 감정별 색상 설정 (카드 배경 그라데이션과 체크 아이콘 색상)
    List<Color> cardColors;
    Color checkColor;
    
    switch (emotion) {
      case 'love':      // 사랑: 핑크/레드 계열
        cardColors = [AppColors.plumu_flower_love_card_start, AppColors.plumu_flower_love_card_end];
        checkColor = AppColors.plumu_flower_love_check;
        break;
      case 'comfort':   // 위로: 파스텔 블루/그린 계열
        cardColors = [AppColors.plumu_flower_comfort_card_start, AppColors.plumu_flower_comfort_card_end];
        checkColor = AppColors.plumu_flower_comfort_check;
        break;
      case 'special':   // 특별함: 골드/옐로우 계열
        cardColors = [AppColors.plumu_flower_special_card_start, AppColors.plumu_flower_special_card_end];
        checkColor = AppColors.plumu_flower_special_check;
        break;
      case 'memory':    // 추억: 퍼플/바이올렛 계열
        cardColors = [AppColors.plumu_flower_memory_card_start, AppColors.plumu_flower_memory_card_end];
        checkColor = AppColors.plumu_flower_memory_check;
        break;
      case 'joy':       // 기쁨: 오렌지/옐로우 계열
        cardColors = [AppColors.plumu_flower_joy_card_start, AppColors.plumu_flower_joy_card_end];
        checkColor = AppColors.plumu_flower_joy_check;
        break;
      case 'hobby':     // 취미: 그린/민트 계열
        cardColors = [AppColors.plumu_flower_hobby_card_start, AppColors.plumu_flower_hobby_card_end];
        checkColor = AppColors.plumu_flower_hobby_check;
        break;
      default:          // 기본값: 기쁨 색상
        cardColors = [AppColors.plumu_flower_joy_card_start, AppColors.plumu_flower_joy_card_end];
        checkColor = AppColors.plumu_flower_joy_check;
    }

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

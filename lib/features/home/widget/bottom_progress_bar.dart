import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';

class BottomProgressBar extends StatelessWidget {
  final double progress;
  final Color calendarCircleColor;
  final List<Color> barColors;

  const BottomProgressBar({
    super.key,
    required this.progress,
    required this.calendarCircleColor,
    required this.barColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.plumu_white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 8,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          // 상단 progress bar 영역
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Progress bar (pill) - 캘린더 원 공간을 고려해서 줄임
              Container(
                margin: EdgeInsets.only(left: 25), // 캘린더 원 절반 정도 공간 확보
                height: 30,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: const Color(0xFFCDCDCD),
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Stack(
                  children: [
                    // 배경
                    Container(
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColors.plumu_white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    // 진행률
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress.clamp(0.0, 1.0),
                      child: Container(
                        height: 30,
                        decoration: ShapeDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.00, 0.50),
                            end: Alignment(1.00, 0.50),
                            colors: barColors,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ),
                    // 중앙 퍼센트 텍스트
                    Center(
                      child: Text(
                        '${(progress * 100).toInt()}%',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // 캘린더 아이콘 (카드 왼쪽에서 16px 떨어진 위치)
              Positioned(
                left: 0, // 카드 패딩과 동일한 위치
                top: -5,
                child: Container(
                  width: 45.67,
                  height: 42,
                  decoration: ShapeDecoration(
                    color: calendarCircleColor,
                    shape: OvalBorder(),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/icons/calendar.png',
                      width: 28.95,
                      height: 28.95,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          // 하단 버튼
          CustomButton(
            text: '나무 아카이브', 
            onPressed: null,
            backgroundColor: AppColors.plumu_green_main,
          )
        ],
      ),
    );
  }
}

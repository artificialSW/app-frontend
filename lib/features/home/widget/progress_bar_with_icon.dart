import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';

class ProgressBarWithIcon extends StatelessWidget {
  final Widget icon;
  final String score;
  final double progress;
  final bool showHeart;

  const ProgressBarWithIcon({
    super.key,
    required this.icon,
    required this.score,
    required this.progress,
    this.showHeart = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 32, right: 32),
      child: Row(
        children: [
          // 아이콘 (하트가 있으면 중앙에 배치)
          if (showHeart)
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 29.67,
                  height: 29.67,
                  child: icon,
                ),
                Positioned(
                  child: Image.asset(
                    'assets/icons/home_heart.png',
                    width: 16,
                    height: 16,
                  ),
                ),
              ],
            )
          else
            SizedBox(
              width: 31,
              height: 31,
              child: icon,
            ),
          SizedBox(width: 8),
          // 점수 텍스트
          Text(
            score,
            style: TextStyle(
              color: AppColors.plumu_green_main,
              fontSize: 12,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 8),
          // Progress bar
          Expanded(
            child: Container(
              height: 12,
              decoration: ShapeDecoration(
                color: AppColors.plumu_green_20per,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress.clamp(0.0, 1.0),
                child: Container(
                  decoration: ShapeDecoration(
                    color: AppColors.plumu_green_main,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


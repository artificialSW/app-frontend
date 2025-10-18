import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';

class PuzzleReCompleteDialog extends StatelessWidget {
  final String imageUrl; // 퍼즐 이미지 (asset 경로)

  const PuzzleReCompleteDialog({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter, // 👈 하단 기준
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '🎉 축하해요 퍼즐이 완성되었어요',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                imageUrl,
                width: 260,
                height: 260,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8,),
            Text(
              '다시 풀어진 퍼즐은 열매가 쌓이지 않아요',
              style: AppTextStyles.pretendard_bold.copyWith(
                fontSize: 12,
                color: AppColors.plumu_green_main,
                letterSpacing: 0.01,
              ),
            ),
            const SizedBox(height: 56),
            ClipRect(
              child: Align(
                alignment: Alignment.topCenter, // 위쪽 기준으로 맞춤
                heightFactor: 0.6, // 👈 0.0~1.0 (1.0 = 전체, 0.5면 상단 절반만 보임)
                child: Image.asset(
                  'assets/images/app_character.png',
                  width: 280,
                  height: 280,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
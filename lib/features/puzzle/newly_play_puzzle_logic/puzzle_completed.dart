import 'package:artificialsw_frontend/services/puzzle/dto/puzzle_complete/puzzle_complete_response_dto.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/fruit.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_top_bar.dart';

class PuzzleCompleted extends StatelessWidget {
  final String message;
  final String fruitName;
  final String fruitMessage;
  final List<String> contributors;

  const PuzzleCompleted({
    Key? key,
    required this.message,
    required this.fruitName,
    required this.fruitMessage,
    required this.contributors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.50, -0.00),
          end: Alignment(0.50, 1.00),
          colors: [fruitMap[fruitName]!.backgroundColor1, fruitMap[fruitName]!.backgroundColor2],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Card(
                elevation: 6, // 그림자 깊이
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: Colors.white, // 카드 배경색 (배경과 구분되게)
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), // 화면과 여백
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 36),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 과일 이미지
                      Image.asset(
                        fruitMap[fruitName]?.imagePath ??
                            'assets/images/fruit/winter/apple.png', // null이면 사과 표시
                        width: 140,
                      ),
                      const SizedBox(height: 40),
                      // 과일 메시지
                      Text(
                        fruitMessage,
                        style: TextStyle(
                          color: fruitMap[fruitName]?.textColor ??
                              AppColors.plumu_green_main,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      // 덕분에 ~ 열매 문구
                      Text(
                        "${contributors.join(', ')} 덕분에\n${fruitMap[fruitName]?.koreanName} 열매가 자라났어요!",
                        style: AppTextStyles.pretendard_bold.copyWith(
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 100,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    backgroundColor: AppColors.plumu_white,
                    textColor: AppColors.plumu_gray_7,
                    text: '퍼즐 홈으로',
                    onPressed: () => Navigator.of(context).pushNamed('/'),
                    width: 150,
                    height: 45,
                    fontSize: 14,
                  ),
                  SizedBox(width: 16),
                  CustomButton(
                    backgroundColor: fruitMap[fruitName]!.goFruitColor,
                    text: '열매 보러가기',
                    onPressed: () => Navigator.of(context).pushNamed('/'),
                    width: 150,
                    height: 45,
                    fontSize: 14,
                  ),
                ],
              ),
              SizedBox(height: 20,),
            ],
          )
      ),
    );
  }
}
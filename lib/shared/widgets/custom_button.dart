// ElevatedButton(
// onPressed: () => Navigator.of(context).pushNamed('/puzzle/completed-list'),
// child: const Text(">")
// ),
import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';


//왜 함수가 아닌 class로? => 확장성과 유지 보수성 고려 + 다양한 속성들 커스터마이징 가능
class CustomButton extends StatelessWidget {
  final String text; // 버튼 안의 텍스트
  final VoidCallback? onPressed; // 클릭 시 실행될 함수
  final double width; // 너비 커스터마이징
  final double height; // 높이 커스터마이징
  final double fontSize; //텍스트 크기 커스터마이징
  final Color textColor;
  final Color backgroundColor; // 배경 색 커스터마이징
  final BorderRadius? borderRadius; // 모서리 둥글기

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = 348,
    this.height = 52,
    this.fontSize = 16,
    this.textColor = AppColors.plumu_white,
    this.backgroundColor = AppColors.plumu_green_main,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        child: Stack(
          children: [
            // 배경 박스
            Container(
              width: width,
              height: height,
              decoration: ShapeDecoration(
                color: onPressed == null ? AppColors.plumu_gray_2 : backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: borderRadius ?? BorderRadius.circular(8),
                ),
              ),
            ),
      
            // 정중앙 텍스트
            Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  height: 1.25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

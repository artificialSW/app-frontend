import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';

/// 살펴보러가기 버튼 위젯
/// 도움말 페이지에서 사용하는 버튼 컴포넌트
class ExploreButton extends StatelessWidget {
  final VoidCallback? onPressed;
  
  const ExploreButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 기준 화면 크기 (412x917)에 대한 비율 계산
    final widthRatio = screenWidth / 412.0;
    final heightRatio = screenHeight / 917.0;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 151 * widthRatio, // 고정 너비 151px (적응형)
        height: 48 * heightRatio, // 고정 높이 48px (적응형)
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12 * widthRatio),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 1.27 * widthRatio,
              offset: Offset(0.32 * widthRatio, 0.64 * heightRatio),
              spreadRadius: 0,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 좌측 텍스트 (좌측 패딩 20px, 위아래 패딩 동일)
            Padding(
              padding: EdgeInsets.only(
                left: 20 * widthRatio,
                top: 12 * heightRatio,
                bottom: 12 * heightRatio,
              ),
              child: Text(
                '살펴보러가기',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF282828),
                  fontSize: 17 * widthRatio,
                  fontFamily: 'SF Pro Text',
                  fontWeight: FontWeight.w600,
                  height: 1.29,
                  letterSpacing: -0.41 * widthRatio,
                ),
              ),
            ),
            // 우측 next 아이콘 (우측 패딩 20px, 위아래 패딩 동일)
            Padding(
              padding: EdgeInsets.only(
                right: 20 * widthRatio,
                top: 12 * heightRatio,
                bottom: 12 * heightRatio,
              ),
              child: Container(
                width: 16 * widthRatio, // next 아이콘 크기
                height: 16 * heightRatio,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppAssets.next),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/features/home/widget/explore_button.dart';
import 'package:artificialsw_frontend/features/home/tutorial_logic/tutorial_page.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';

/// 도움말 페이지 위젯
/// help 아이콘 클릭 시 표시되는 도움말 화면
class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  void _onExplorePressed(BuildContext context) {
    // 살펴보러가기 버튼 클릭 시 튜토리얼 페이지로 이동
    Navigator.of(context).pop(); // 도움말 페이지 닫기
    
    // 튜토리얼 페이지를 Dialog로 표시
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const TutorialPage(),
    );
  }

  void _onClosePressed(BuildContext context) {
    Navigator.of(context).pop(); // 도움말 페이지 닫기
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 기준 화면 크기 (412x917)에 대한 비율 계산
    final widthRatio = screenWidth / 412.0;
    final heightRatio = screenHeight / 917.0;

    return Dialog(
      backgroundColor: Colors.transparent, // 투명한 배경
      insetPadding: EdgeInsets.zero, // 여백 제거
      child: Container(
        width: screenWidth, // 전체 화면 너비
        height: screenHeight, // 전체 화면 높이
        color: const Color(0x801B1B1B), // 50% 투명한 어두운 배경 (뒤가 비치도록)
        child: Stack(
          children: [
            // 상단 텍스트 (좌우 중앙 정렬)
            Positioned(
              left: 0,
              right: 0,
              top: 357 * heightRatio, // 위쪽에서 357px 떨어진 위치
              child: Text(
                'plumu의 기능을\n알아보러 갈까요?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24 * widthRatio,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  height: 1.50,
                  letterSpacing: -0.25 * widthRatio,
                ),
              ),
            ),
            
            // 하단 버튼 (좌우 중앙 정렬)
            Positioned(
              left: 0,
              right: 0,
              top: 460 * heightRatio, // 위쪽에서 460px 떨어진 위치
              child: Center(
                child: ExploreButton(
                  onPressed: () => _onExplorePressed(context),
                ),
              ),
            ),
            
            // X 닫기 아이콘 (우측 상단, AppBar와 같은 높이) - 제일 위에 오도록 Stack 마지막에 배치
            Positioned(
              right: 34 * widthRatio, // 우측 패딩 34px (적응형)
              top: MediaQuery.of(context).padding.top + 12 * heightRatio, // AppBar 높이 + 약간의 패딩
              child: GestureDetector(
                onTap: () => _onClosePressed(context),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30 * widthRatio, // X 아이콘 크기 30 (적응형)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

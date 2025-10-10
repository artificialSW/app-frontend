import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/features/home/guidebook_logic/guidebook_main.dart';

/// 홈 화면 하단 버튼 위젯
/// - 도감 버튼: 꽃/열매 도감으로 연결
/// - 섬 보관소 버튼
/// - 시간대별 아이콘과 색상 적용
/// - 반응형 크기 조정
class HomeBottomButtons extends StatelessWidget {
  const HomeBottomButtons({super.key});

  /// 현재 시간에 따른 그림자 색상 반환
  Color _getTimeBasedShadowColor() {
    final now = DateTime.now();
    final hour = now.hour;
    
    if (hour >= 4 && hour < 8) {
      return Color(0x193A0D10); // dawn
    } else if (hour >= 8 && hour < 16) {
      return Color(0x193A0D10); // morning
    } else if (hour >= 16 && hour < 20) {
      return Color(0x193A0D10); // afternoon
    } else {
      return Color(0x193A0D10); // night
    }
  }

  /// 현재 시간에 따른 도감 아이콘 경로 반환
  String _getBookIconPath() {
    final now = DateTime.now();
    final hour = now.hour;
    
    if (hour >= 4 && hour < 8) {
      return 'assets/icons/book_dawn.png';
    } else if (hour >= 8 && hour < 16) {
      return 'assets/icons/book_morning.png';
    } else if (hour >= 16 && hour < 20) {
      return 'assets/icons/book_afternoon.png';
    } else {
      return 'assets/icons/book_night.png';
    }
  }

  /// 현재 시간에 따른 섬 보관소 아이콘 경로 반환
  String _getIslandIconPath() {
    final now = DateTime.now();
    final hour = now.hour;
    
    if (hour >= 4 && hour < 8) {
      return 'assets/icons/island_dawn.png';
    } else if (hour >= 8 && hour < 16) {
      return 'assets/icons/island_morning.png';
    } else if (hour >= 16 && hour < 20) {
      return 'assets/icons/island_afternoon.png';
    } else {
      return 'assets/icons/island_night.png';
    }
  }

  /// 현재 시간에 따른 텍스트 색상 반환
  Color _getTimeBasedTextColor() {
    final now = DateTime.now();
    final hour = now.hour;
    
    if (hour >= 4 && hour < 8) {
      return Color(0xFF937516); // dawn
    } else if (hour >= 8 && hour < 16) {
      return Color(0xFF276CAD); // morning
    } else if (hour >= 16 && hour < 20) {
      return Color(0xFF937516); // afternoon
    } else {
      return Color(0xFF233B76); // night
    }
  }

  /// 도감 버튼 클릭 처리
  void _onDogaamPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GuidebookMainPage(),
      ),
    );
  }

  /// 섬 보관소 버튼 클릭 처리 (추후 구현)
  void _onIslandStoragePressed(BuildContext context) {
    // TODO: 섬 보관소 페이지로 이동
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('섬 보관소 기능은 추후 구현됩니다')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // 기준 화면 크기 (412x917)에 대한 비율 계산
    final widthRatio = screenWidth / 412.0;
    final heightRatio = screenHeight / 917.0;
    
    // 버튼 크기 (반응형)
    final buttonWidth = 163.53 * widthRatio;
    final buttonHeight = 101.71 * heightRatio;
    
    // 버튼 간격 (반응형)
    final buttonGap = 19.94 * widthRatio;
    
    // 아이콘 크기 (반응형) - 더 크게 증가
    final bookIconWidth = 130.0 * widthRatio; // 110.0에서 더 증가
    final bookIconHeight = 100.0 * heightRatio; // 비율 유지하면서 증가
    final islandIconWidth = 140.0 * widthRatio; //  120.0에서 더 증가
    final islandIconHeight = 120.0 * heightRatio; // 비율 유지하면서 증가
    
    // 폰트 크기 (반응형) - 디버깅을 위해 크게 설정
    final fontSize = 14.0 * widthRatio; // 11.97에서 14로 임시 증가

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 도감 버튼
        GestureDetector(
          onTap: () => _onDogaamPressed(context),
          child: Container(
            width: buttonWidth,
            height: buttonHeight,
            decoration: ShapeDecoration(
              color: Colors.white.withValues(alpha: 0.60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(19.94 * widthRatio),
              ),
              shadows: [
                BoxShadow(
                  color: _getTimeBasedShadowColor(),
                  blurRadius: 19.94 * widthRatio,
                  offset: Offset(0, 3.99 * heightRatio),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Column(
              children: [
                // 상단 여백
                SizedBox(height: 15 * heightRatio), // 상단에 여백 추가
                // 아이콘과 텍스트를 함께 아래로 이동
                Column(
                  children: [
                    // 아이콘 (아래쪽으로 내려서 글자와 더 가깝게)
                    Container(
                      height: (buttonHeight - 15 * heightRatio - 8 * heightRatio) * (2/5), // 여백과 패딩을 고려한 높이
                      child: Align(
                        alignment: Alignment.bottomCenter, // 아이콘을 아래쪽으로 정렬
                        child: Image.asset(
                          _getBookIconPath(),
                          width: bookIconWidth,
                          height: bookIconHeight,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    // 텍스트 (아래쪽 배치)
                    Container(
                      height: (buttonHeight - 15 * heightRatio - 8 * heightRatio) * (3/5), // 여백과 패딩을 고려한 높이
                      padding: EdgeInsets.only(
                        bottom: 15 * heightRatio, // 하단 패딩을 늘려서 글자를 더 아래로
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter, // 텍스트를 아래쪽으로 정렬
                        child: Text(
                          '도감',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _getTimeBasedTextColor(),
                            fontSize: fontSize,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        SizedBox(width: buttonGap),
        
        // 섬 보관소 버튼
        GestureDetector(
          onTap: () => _onIslandStoragePressed(context),
          child: Container(
            width: buttonWidth,
            height: buttonHeight,
            decoration: ShapeDecoration(
              color: Colors.white.withValues(alpha: 0.60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(19.94 * widthRatio),
              ),
              shadows: [
                BoxShadow(
                  color: _getTimeBasedShadowColor(),
                  blurRadius: 19.94 * widthRatio,
                  offset: Offset(0, 3.99 * heightRatio),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Column(
              children: [
                // 상단 여백
                SizedBox(height: 15 * heightRatio), // 상단에 여백 추가
                // 아이콘과 텍스트를 함께 아래로 이동
                Column(
                  children: [
                    // 아이콘 (아래쪽으로 내려서 글자와 더 가깝게)
                    Container(
                      height: (buttonHeight - 15 * heightRatio - 8 * heightRatio) * (2/5), // 여백과 패딩을 고려한 높이
                      child: Align(
                        alignment: Alignment.bottomCenter, // 아이콘을 아래쪽으로 정렬
                        child: Image.asset(
                          _getIslandIconPath(),
                          width: islandIconWidth,
                          height: islandIconHeight,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    // 텍스트 (아래쪽 배치)
                    Container(
                      height: (buttonHeight - 15 * heightRatio - 8 * heightRatio) * (3/5), // 여백과 패딩을 고려한 높이
                      padding: EdgeInsets.only(
                        bottom: 15 * heightRatio, // 하단 패딩을 늘려서 글자를 더 아래로
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter, // 텍스트를 아래쪽으로 정렬
                        child: Text(
                          '섬 보관소',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _getTimeBasedTextColor(),
                            fontSize: fontSize,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

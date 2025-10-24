import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/features/home/guidebook_logic/guidebook_main.dart';
import 'package:artificialsw_frontend/features/home/island_archive_logic/island_archive_page.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';

/// 홈 화면 하단 버튼 위젯
/// - 도감 버튼: 꽃/열매 도감으로 연결
/// - 섬 보관소 버튼
/// - 시간대별 아이콘과 색상 적용
/// - 반응형 크기 조정
class HomeBottomButtons extends StatelessWidget {
  const HomeBottomButtons({super.key});
  //
  // /// 현재 시간에 따른 그림자 색상 반환
  // Color _getTimeBasedShadowColor() {
  //   final now = DateTime.now();
  //   final hour = now.hour;
  //  
  //   if (hour >= 4 && hour < 8) {
  //     return Color(0x193A0D10); // dawn
  //   } else if (hour >= 8 && hour < 16) {
  //     return Color(0x193A0D10); // morning
  //   } else if (hour >= 16 && hour < 20) {
  //     return Color(0x193A0D10); // afternoon
  //   } else {
  //     return Color(0x193A0D10); // night
  //   }
  // }

  // /// 현재 시간에 따른 도감 아이콘 경로 반환
  // String _getBookIconPath() {
  //   final now = DateTime.now();
  //   final hour = now.hour;
  //  
  //   if (hour >= 4 && hour < 8) {
  //     return 'assets/icons/book_dawn.png';
  //   } else if (hour >= 8 && hour < 16) {
  //     return 'assets/icons/book_morning.png';
  //   } else if (hour >= 16 && hour < 20) {
  //     return 'assets/icons/book_afternoon.png';
  //   } else {
  //     return 'assets/icons/book_night.png';
  //   }
  // }

  /// 현재 시간에 따른 도감 버튼 경로 반환 !!!!
  String _getBookButtonPath() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 4 && hour < 8) {
      return '${AppAssets.dawn_dogaam}';
    } else if (hour >= 8 && hour < 16) {
      return '${AppAssets.morning_dogaam}';
    } else if (hour >= 16 && hour < 20) {
      return '${AppAssets.afternoon_dogaam}';
    } else {
      return '${AppAssets.night_dogaam}';
    }
  }

  /// 현재 시간에 따른 섬보관소 버튼 경로 반환 !!!!
  String _getArchiveButtonPath() {
    final now = DateTime.now();
    final hour = now.hour;

    if (hour >= 4 && hour < 8) {
      return '${AppAssets.dawn_archive}';
    } else if (hour >= 8 && hour < 16) {
      return '${AppAssets.morning_archive}';
    } else if (hour >= 16 && hour < 20) {
      return '${AppAssets.afternoon_archive}';
    } else {
      return '${AppAssets.night_archive}';
    }
  }
  //
  // /// 현재 시간에 따른 섬 보관소 아이콘 경로 반환
  // String _getIslandIconPath() {
  //   final now = DateTime.now();
  //   final hour = now.hour;
  //  
  //   if (hour >= 4 && hour < 8) {
  //     return 'assets/icons/island_dawn.png';
  //   } else if (hour >= 8 && hour < 16) {
  //     return 'assets/icons/island_morning.png';
  //   } else if (hour >= 16 && hour < 20) {
  //     return 'assets/icons/island_afternoon.png';
  //   } else {
  //     return 'assets/icons/island_night.png';
  //   }
  // }

  // /// 현재 시간에 따른 텍스트 색상 반환
  // Color _getTimeBasedTextColor() {
  //   final now = DateTime.now();
  //   final hour = now.hour;
  //  
  //   if (hour >= 4 && hour < 8) {
  //     return Color(0xFF937516); // dawn
  //   } else if (hour >= 8 && hour < 16) {
  //     return Color(0xFF276CAD); // morning
  //   } else if (hour >= 16 && hour < 20) {
  //     return Color(0xFF937516); // afternoon
  //   } else {
  //     return Color(0xFF233B76); // night
  //   }
  // }

  /// 도감 버튼 클릭 처리
  void _onDogaamPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const GuidebookMainPage(),
      ),
    );
  }

  /// 섬 보관소 버튼 클릭 처리
  void _onIslandStoragePressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const IslandArchivePage(),
      ),
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
    final fontSize = 13.0 * widthRatio; // 11.97에서 14로 임시 증가

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 도감 버튼
        GestureDetector(
          onTap: () => _onDogaamPressed(context),
          child: Container(
            width: buttonWidth,
            height: buttonHeight,
            child: Image.asset(_getBookButtonPath()),
          ),
        ),

        SizedBox(width: buttonGap),
        
        // 섬 보관소 버튼
        GestureDetector(
          onTap: () => _onIslandStoragePressed(context),
          child: Container(
            width: buttonWidth,
            height: buttonHeight,
            child: Image.asset(_getArchiveButtonPath()),
          ),
        ),
      ],
    );
  }
}

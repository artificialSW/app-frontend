import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_top_bar.dart';
import 'package:artificialsw_frontend/features/home/widget/progress_bar_with_icon.dart';
import 'package:artificialsw_frontend/features/home/widget/home_bottom_buttons.dart';
import 'package:artificialsw_frontend/features/home/widget/tree_loading_page.dart';
import 'package:flutter/material.dart';

/// 새로운 홈 화면의 메인 위젯
/// - 시간대별 배경 이미지
/// - main_island 이미지 표시
/// - 반응형 레이아웃
class HomeRoot extends StatefulWidget {
  const HomeRoot({super.key});
  @override
  State<HomeRoot> createState() => _HomeRootState();
}

class _HomeRootState extends State<HomeRoot> {
  
  /// 현재 시간에 따른 배경 이미지 반환
  String _getTimeBasedBackground() {
    final now = DateTime.now();
    final hour = now.hour;
    
    if (hour >= 4 && hour < 8) {
      return 'assets/images/dawn.png';
    } else if (hour >= 8 && hour < 16) {
      return 'assets/images/morning.png';
    } else if (hour >= 16 && hour < 20) {
      return 'assets/images/afternoon.png';
    } else {
      return 'assets/images/night.png';
    }
  }

  /// 현재 시간에 따른 main_island 이미지 반환
  String _getTimeBasedIslandImage() {
    final now = DateTime.now();
    final hour = now.hour;
    
    if (hour >= 8 && hour < 16) {
      return 'assets/images/main_island_morning.png';
    } else {
      return 'assets/images/main_island.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // 기준 화면 크기 (412x917)에 대한 비율 계산
    final widthRatio = screenWidth / 412.0;
    final heightRatio = screenHeight / 917.0;
    
    // 섬 컨테이너 크기 (338x302.46)를 반응형으로 계산
    final islandWidth = 338.0 * widthRatio;
    final islandHeight = 302.46 * heightRatio;
    
    // 패딩을 반응형으로 계산
    final horizontalPadding = 37.0 * widthRatio;
    final topPadding = 276.0 * heightRatio; // 기준 화면 높이 비율에 맞춰 계산
    
    // Progress bar 위치 (양쪽 패딩 16, 화면 맨 위부터 98)
    final progressBarHorizontalPadding = 16.0 * widthRatio;
    final progressBarTopPadding = 98.0 * heightRatio;
    
    // 하단 버튼 위치 (화면 맨 위부터 717)
    final bottomButtonsTopPadding = 717.0 * heightRatio;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: HomeTopBar(),
      body: Stack(
        children: [
          // 시간대별 배경 이미지 (화면 가득 채우기)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(_getTimeBasedBackground()),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          
          // Progress Bar (꽃 + 과일)
          Positioned(
            left: progressBarHorizontalPadding,
            right: progressBarHorizontalPadding,
            top: progressBarTopPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 꽃 Progress Bar
                ProgressBarWithIcon(
                  isFlower: true,
                  progress: 0.4, // 4개 세그먼트 채워짐
                ),
                // 7px 간격 (반응형)
                SizedBox(width: 7.0 * widthRatio),
                // 과일 Progress Bar
                ProgressBarWithIcon(
                  isFlower: false,
                  progress: 0.5, // 5개 세그먼트 채워짐
                ),
              ],
            ),
          ),
          
          // 하단 버튼들 (도감, 섬 보관소)
          Positioned(
            left: 0,
            right: 0,
            top: bottomButtonsTopPadding,
            child: HomeBottomButtons(),
          ),
          
          // main_island 이미지 (정확한 위치 배치)
          Positioned(
            left: horizontalPadding,
            right: horizontalPadding,
            top: topPadding, // 화면 최상단부터 276px (반응형)
            child: Container(
              width: islandWidth,
              height: islandHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(_getTimeBasedIslandImage()),
                  fit: BoxFit.contain,
                ),
              ),
                          child: Stack(
                children: [
                              // 1번째 나무 (맨 왼쪽 꽃나무)
                              Positioned(
                                left: islandWidth * 0.15, // 섬 왼쪽에서 15% 지점
                                top: islandHeight * 0.3,   // 섬 위쪽에서 30% 지점
                                child: GestureDetector(
                                  onTap: () {
                                    // 첫 번째 꽃나무 클릭 시 로딩 Dialog 표시
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => TreeLoadingPage(treeType: 'flower-1'),
                                    );
                                  },
                                  child: Container(
                                    width: islandWidth * 0.18,   // 나무 크기
                                    height: islandHeight * 0.4,  // 나무 높이
                                    color: Colors.transparent, // 투명하지만 클릭 가능
                                  ),
                                ),
                              ),
                              
                              // 2번째 나무 (왼쪽에서 두 번째 꽃나무)
                              Positioned(
                                left: islandWidth * 0.35, // 섬 왼쪽에서 35% 지점
                                top: islandHeight * 0.25,  // 섬 위쪽에서 25% 지점
                                child: GestureDetector(
                                  onTap: () {
                                    // 두 번째 꽃나무 클릭 시 로딩 Dialog 표시
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => TreeLoadingPage(treeType: 'flower-2'),
                                    );
                                  },
                                  child: Container(
                                    width: islandWidth * 0.18,
                                    height: islandHeight * 0.4,
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                              
                              // 3번째 나무 (오른쪽에서 두 번째 과일나무)
                              Positioned(
                                left: islandWidth * 0.55, // 섬 왼쪽에서 55% 지점
                                top: islandHeight * 0.3,   // 섬 위쪽에서 30% 지점
                                child: GestureDetector(
                                  onTap: () {
                                    // 첫 번째 과일나무 클릭 시 로딩 Dialog 표시
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => TreeLoadingPage(treeType: 'fruit-1'),
                                    );
                                  },
                                  child: Container(
                                    width: islandWidth * 0.18,
                                    height: islandHeight * 0.4,
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                              
                              // 4번째 나무 (맨 오른쪽 과일나무)
                              Positioned(
                                left: islandWidth * 0.75, // 섬 왼쪽에서 75% 지점
                                top: islandHeight * 0.25,  // 섬 위쪽에서 25% 지점
                                child: GestureDetector(
                                  onTap: () {
                                    // 두 번째 과일나무 클릭 시 로딩 Dialog 표시
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => TreeLoadingPage(treeType: 'fruit-2'),
                                    );
                                  },
                                  child: Container(
                                    width: islandWidth * 0.18,
                                    height: islandHeight * 0.4,
                                    color: Colors.transparent,
                                  ),
                                ),
                            ),
                          ],
                        ),
                      ),
             ),
        ],
      ),
    );
  }
}

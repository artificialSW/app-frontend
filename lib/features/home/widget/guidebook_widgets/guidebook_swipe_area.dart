import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';

/// 가이드북 책 스와이프 영역 위젯
class GuidebookSwipeArea extends StatelessWidget {
  final PageController pageController;
  final int currentPage;
  final int selectedTab;
  final ValueChanged<int> onPageChanged;
  final List<bool> flowerUnlockedStates; // 꽃 해금 상태 (12개)

  const GuidebookSwipeArea({
    super.key,
    required this.pageController,
    required this.currentPage,
    required this.selectedTab,
    required this.onPageChanged,
    this.flowerUnlockedStates = const [], // 기본값: 모두 잠금
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: double.infinity,
          height: 440,
          margin: const EdgeInsets.only(top: 100),
          child: PageView.builder(
            controller: pageController,
            physics: const ClampingScrollPhysics(),
            padEnds: false,
            onPageChanged: onPageChanged,
            itemCount: 2,
            itemBuilder: (context, index) => _buildBookPage(index),
          ),
        ),
      ),
    );
  }

  /// 책 페이지를 생성하는 위젯
  /// - 꽃 탭(0): guidebook_1, guidebook_2 (페이지 번호 포함)
  /// - 열매 탭(1): guidebook_1, guidebook_2 (빈 책)
  Widget _buildBookPage(int pageIndex) {
    String imagePath;
    Alignment alignment;

    if (pageIndex == 0) {
      imagePath = AppAssets.guidebook_1;
      alignment = Alignment.centerRight;
    } else {
      imagePath = AppAssets.guidebook_2;
      alignment = Alignment.centerLeft;
    }

    // 기본 책 이미지
    final baseBookImage = Image.asset(
      imagePath,
      fit: BoxFit.contain,
      alignment: alignment,
      width: double.infinity,
      height: double.infinity,
      filterQuality: FilterQuality.high,
    );

    // 열매 탭일 때는 페이지 번호만 표시
    if (selectedTab == 1) {
      return Stack(
        children: [
          baseBookImage,
          // 페이지 번호 01 (왼쪽 책 아이콘의 왼쪽 끝으로부터 182)
          if (pageIndex == 0)
            Positioned(
              top: 280,
              left: 182,
              child: Text(
                '01',
                style: AppTextStyles.pretendard_bold.copyWith(
                  color: AppColors.plumu_black,
                  fontSize: 12.48,
                  height: 2.92,
                  letterSpacing: -0.32,
                ),
              ),
            ),
          // 페이지 번호 02 (오른쪽 책 아이콘의 오른쪽 끝으로부터 182)
          if (pageIndex == 1)
            Positioned(
              top: 280,
              right: 182,
              child: Text(
                '02',
                style: AppTextStyles.pretendard_bold.copyWith(
                  color: AppColors.plumu_black,
                  fontSize: 12.48,
                  height: 2.92,
                  letterSpacing: -0.32,
                ),
              ),
            ),
        ],
      );
    }

    // 꽃 탭일 때는 페이지 번호와 잠금 장치 추가
    return Stack(
      children: [
        baseBookImage,
        // 잠금 장치/꽃들 (3x2 그리드)
        if (pageIndex == 0) // 01페이지
          Positioned(
            top: 110,
            left: 185,
            child: _buildLockGrid(pageIndex),
          ),
        if (pageIndex == 1) // 02페이지
          Positioned(
            top: 110,
            right: 185,
            child: _buildLockGrid(pageIndex),
          ),
        // 페이지 번호 01 (왼쪽 책 아이콘의 왼쪽 끝으로부터 158)
        if (pageIndex == 0)
          Positioned(
            top: 280,
            left: 182,
            child: Text(
              '01',
              style: AppTextStyles.pretendard_bold.copyWith(
                color: AppColors.plumu_black,
                fontSize: 12.48,
                height: 2.92,
                letterSpacing: -0.32,
              ),
            ),
          ),
        // 페이지 번호 02 (오른쪽 책 아이콘의 오른쪽 끝으로부터 158)
        if (pageIndex == 1)
          Positioned(
            top: 280,
            right: 182,
            child: Text(
              '02',
              style: AppTextStyles.pretendard_bold.copyWith(
                color: AppColors.plumu_black,
                fontSize: 12.48,
                height: 2.92,
                letterSpacing: -0.32,
              ),
            ),
          ),
      ],
    );
  }

  /// 잠금 장치/꽃 그리드 (6x2)
  Widget _buildLockGrid(int pageIndex) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(2, (rowIndex) => 
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(6, (colIndex) => 
            Padding(
              padding: EdgeInsets.only(
                right: colIndex < 5 ? 20 : 0,
                bottom: rowIndex < 1 ? 20 : 0,
              ),
              child: _buildFlowerOrLock(pageIndex, rowIndex, colIndex),
            ),
          ),
        ),
      ),
    );
  }

  /// 꽃 또는 잠금 장치 위젯
  Widget _buildFlowerOrLock(int pageIndex, int rowIndex, int colIndex) {
    final flowerIndex = pageIndex * 6 + rowIndex * 6 + colIndex; // 0-11 인덱스
    
    // 해금 상태 확인 (기본값: 잠금)
    final isUnlocked = flowerIndex < flowerUnlockedStates.length 
        ? flowerUnlockedStates[flowerIndex] 
        : false;
    
    if (isUnlocked) {
      return GestureDetector(
        onTap: () => _onFlowerTap(flowerIndex),
        child: _buildFlowerIcon(flowerIndex),
      );
    } else {
      return _buildLockIcon();
    }
  }

  /// 꽃 아이콘 위젯
  Widget _buildFlowerIcon(int flowerIndex) {
    String flowerAsset;
    
    // 꽃 인덱스에 따른 아이콘 매핑 (6x2 그리드)
    // 1행: 동백꽃, 아카시아, 매화, 팥배꽃, 벚꽃, 목련
    // 2행: 장미, 수국, 튤립, 제비꽃, 코스모스, 해바라기
    switch (flowerIndex) {
      case 0: flowerAsset = AppAssets.flower_camellia; break; // 동백꽃
      case 1: flowerAsset = AppAssets.flower_acacia; break; // 아카시아
      case 2: flowerAsset = AppAssets.flower_plum; break; // 매화
      case 3: flowerAsset = AppAssets.flower_patbae; break; // 팥배꽃
      case 4: flowerAsset = AppAssets.flower_cherry; break; // 벚꽃
      case 5: flowerAsset = AppAssets.flower_magnolia; break; // 목련
      case 6: flowerAsset = AppAssets.flower_rose; break; // 장미
      case 7: flowerAsset = AppAssets.flower_hydrangea; break; // 수국
      case 8: flowerAsset = AppAssets.flower_tulip; break; // 튤립
      case 9: flowerAsset = AppAssets.flower_violet; break; // 제비꽃
      case 10: flowerAsset = AppAssets.flower_cosmos; break; // 코스모스
      case 11: flowerAsset = AppAssets.flower_sunflower; break; // 해바라기
      default: flowerAsset = AppAssets.flower_patbae; break;
    }
    
    return Image.asset(
      flowerAsset,
      width: 57,
      height: 57,
    );
  }

  /// 꽃 클릭 처리
  void _onFlowerTap(int flowerIndex) {
    // TODO: 꽃 클릭 시 상세 정보 표시 또는 다른 액션
    print('꽃 클릭: $flowerIndex');
  }

  /// 잠금 아이콘 위젯
  Widget _buildLockIcon() {
    return Image.asset(
      AppAssets.lock,
      width: 57,
      height: 57,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/features/home/guidebook_logic/guidebook_flower_detail.dart';

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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;
          final widthRatio = screenWidth / 430;
          final heightRatio = screenHeight / 932;
          
          return Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: double.infinity,
              height: 471 * heightRatio,
              margin: EdgeInsets.only(top: 60 * heightRatio),
              child: PageView.builder(
                controller: pageController,
                physics: const ClampingScrollPhysics(),
                padEnds: false,
                onPageChanged: onPageChanged,
                itemCount: 2,
                itemBuilder: (context, index) => _buildBookPage(index),
              ),
            ),
          );
        },
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

    // 열매 탭일 때는 페이지 번호와 자물쇠 아이콘들 표시
    if (selectedTab == 1) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;
          final widthRatio = screenWidth / 430;
          final heightRatio = screenHeight / 932;
          
          return Stack(
            children: [
              baseBookImage,
              // 자물쇠 아이콘들 (5개) - 꽃 탭과 동일한 위치
              if (pageIndex == 0) // 01페이지
                Positioned(
                  top: 118 * heightRatio,
                  left: 190 * widthRatio,
                  child: Builder(
                    builder: (context) => _buildFruitLockGrid(context, pageIndex),
                  ),
                ),
              if (pageIndex == 1) // 02페이지
                Positioned(
                  top: 118 * heightRatio,
                  right: 190 * widthRatio,
                  child: Builder(
                    builder: (context) => _buildFruitLockGrid(context, pageIndex),
                  ),
                ),
              // 페이지 번호 01 (왼쪽 책 아이콘의 왼쪽 끝으로부터 190 - 꽃 탭과 동일)
              if (pageIndex == 0)
                Positioned(
                  top: 300 * heightRatio,
                  left: 190 * widthRatio,
                  child: Text(
                    '01',
                    style: AppTextStyles.pretendard_bold.copyWith(
                      color: AppColors.plumu_black,
                      fontSize: 12.48 * widthRatio,
                      height: 2.92,
                      letterSpacing: -0.32 * widthRatio,
                    ),
                  ),
                ),
              // 페이지 번호 02 (오른쪽 책 아이콘의 오른쪽 끝으로부터 190 - 꽃 탭과 동일)
              if (pageIndex == 1)
                Positioned(
                  top: 300 * heightRatio,
                  right: 190 * widthRatio,
                  child: Text(
                    '02',
                    style: AppTextStyles.pretendard_bold.copyWith(
                      color: AppColors.plumu_black,
                      fontSize: 12.48 * widthRatio,
                      height: 2.92,
                      letterSpacing: -0.32 * widthRatio,
                    ),
                  ),
                ),
            ],
          );
        },
      );
    }

    // 꽃 탭일 때는 페이지 번호와 잠금 장치 추가
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        final widthRatio = screenWidth / 430;
        final heightRatio = screenHeight / 932;
        
        return Stack(
          children: [
            baseBookImage,
            // 잠금 장치/꽃들 (6x2 그리드) - 반응형 위치, 높이 증가에 맞춰 조정
            if (pageIndex == 0) // 01페이지
              Positioned(
                top: 118 * heightRatio, // 높이 비율에 맞춰 조정 (110 * 1.0705)
                left: 190 * widthRatio,
                child: Builder(
                  builder: (context) => _buildLockGrid(context, pageIndex),
                ),
              ),
            if (pageIndex == 1) // 02페이지
              Positioned(
                top: 118 * heightRatio, // 높이 비율에 맞춰 조정 (110 * 1.0705)
                right: 190 * widthRatio,
                child: Builder(
                  builder: (context) => _buildLockGrid(context, pageIndex),
                ),
              ),
            // 페이지 번호 01 (왼쪽 책 아이콘의 왼쪽 끝으로부터 190) - 높이 비율에 맞춰 조정
            if (pageIndex == 0)
              Positioned(
                top: 300 * heightRatio, // 높이 비율에 맞춰 조정 (280 * 1.0705)
                left: 190 * widthRatio,
                child: Text(
                  '01',
                  style: AppTextStyles.pretendard_bold.copyWith(
                    color: AppColors.plumu_black,
                    fontSize: 12.48 * widthRatio,
                    height: 2.92,
                    letterSpacing: -0.32 * widthRatio,
                  ),
                ),
              ),
            // 페이지 번호 02 (오른쪽 책 아이콘의 오른쪽 끝으로부터 190) - 높이 비율에 맞춰 조정
            if (pageIndex == 1)
              Positioned(
                top: 300 * heightRatio, // 높이 비율에 맞춰 조정 (280 * 1.0705)
                right: 190 * widthRatio,
                child: Text(
                  '02',
                  style: AppTextStyles.pretendard_bold.copyWith(
                    color: AppColors.plumu_black,
                    fontSize: 12.48 * widthRatio,
                    height: 2.92,
                    letterSpacing: -0.32 * widthRatio,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  /// 잠금 장치/꽃 그리드 (6x2)
  Widget _buildLockGrid(BuildContext context, int pageIndex) {
    final screenWidth = MediaQuery.of(context).size.width;
    final widthRatio = screenWidth / 430;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(2, (rowIndex) => 
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(6, (colIndex) => 
            Padding(
              padding: EdgeInsets.only(
                right: colIndex < 5 ? 25 * widthRatio : 0,
                bottom: rowIndex < 1 ? 25 * widthRatio : 0,
              ),
              child: _buildFlowerOrLock(context, pageIndex, rowIndex, colIndex),
            ),
          ),
        ),
      ),
    );
  }

  /// 꽃 또는 잠금 장치 위젯
  Widget _buildFlowerOrLock(BuildContext context, int pageIndex, int rowIndex, int colIndex) {
    final flowerIndex = rowIndex * 6 + colIndex; // 0-11 인덱스
    
    // 해금 상태 확인 (기본값: 잠금)
    final isUnlocked = flowerIndex < flowerUnlockedStates.length 
        ? flowerUnlockedStates[flowerIndex] 
        : false;
    
    if (isUnlocked) {
      return GestureDetector(
        onTap: () => _onFlowerTap(context, flowerIndex),
        child: _buildFlowerIcon(context, flowerIndex),
      );
    } else {
      return _buildLockIcon(context, pageIndex: pageIndex, rowIndex: rowIndex, colIndex: colIndex);
    }
  }


  /// 꽃 아이콘 위젯
  Widget _buildFlowerIcon(BuildContext context, int flowerIndex) {
    String flowerAsset;
    
    // 꽃 인덱스에 따른 아이콘 매핑 (책 배치 기준)
    // 1행: 동백꽃, 아카시아, 매화, 팥배꽃, 벚꽃, 목련 (인덱스 0-5)
    // 2행: 장미, 수국, 튤립, 제비꽃, 코스모스, 해바라기 (인덱스 6-11)
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
    
    final screenWidth = MediaQuery.of(context).size.width;
    final widthRatio = screenWidth / 430;
    
    return Image.asset(
      flowerAsset,
      width: 60 * widthRatio,
      height: 60 * widthRatio,
    );
  }

  /// 꽃 클릭 처리
  void _onFlowerTap(BuildContext context, int flowerIndex) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GuidebookFlowerDetailPage(
          flowerIndex: flowerIndex,
        ),
      ),
    );
  }

  /// 잠금 아이콘 위젯 (커스텀 툴팁 포함)
  Widget _buildLockIcon(BuildContext context, {required int pageIndex, required int rowIndex, required int colIndex}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final widthRatio = screenWidth / 430;
    final lockKey = GlobalKey();
    
    return GestureDetector(
      onTap: () {
        final renderObject = lockKey.currentContext?.findRenderObject();
        if (renderObject is RenderBox) {
          final offset = renderObject.localToGlobal(Offset.zero);
          final size = renderObject.size;
          final targetRect = Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height);
          _showLockTooltip(
            context,
            targetRect: targetRect,
            isLeftPage: pageIndex == 0,
            rowIndex: rowIndex,
            colIndex: colIndex,
          );
        } else {
          _showLockTooltip(
            context,
            targetRect: null,
            isLeftPage: pageIndex == 0,
            rowIndex: rowIndex,
            colIndex: colIndex,
          );
        }
      },
      child: Container(
        key: lockKey,
        child: Image.asset(
          AppAssets.lock,
          width: 60 * widthRatio,
          height: 60 * widthRatio,
        ),
      ),
    );
  }

  /// 잠금장치 툴팁 표시 (잠금장치에 딱 붙어서 표시)
  void _showLockTooltip(BuildContext context, {required Rect? targetRect, required bool isLeftPage, required int rowIndex, required int colIndex}) {
    final message = selectedTab == 0 
        ? "소통을 하고\n잠겨있는 꽃을\n획득해보세요!" 
        : "퍼즐을 풀고\n잠겨있는 열매를\n획득해보세요!";
    
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (BuildContext dialogContext) {
        final screenSize = MediaQuery.of(dialogContext).size;
        const double gap = 8; // 잠금장치와 툴팁 사이 간격

        // 기본 위치(중앙) - targetRect 없을 때 폴백
        double top = screenSize.height * 0.4;
        double? left;
        double? right;

        if (targetRect != null) {
          // 수직 위치를 잠금장치 중앙에 맞춤
          top = targetRect.top + targetRect.height / 2 - 30; // 툴팁 높이의 절반만큼 위로

          if (isLeftPage) {
            // 왼쪽 페이지: 잠금장치 왼쪽에 표시
            right = screenSize.width - targetRect.left + gap;
          } else {
            // 오른쪽 페이지: 잠금장치 오른쪽에 표시
            left = targetRect.right + gap;
          }
        } else {
          // targetRect가 없을 때는 rowIndex, colIndex로 대략적 위치 계산
          final screenWidth = MediaQuery.of(context).size.width;
          final widthRatio = screenWidth / 430;
          final itemSize = 60 * widthRatio;
          final spacing = 25 * widthRatio;
          
          // 대략적인 위치 계산
          final estimatedX = (colIndex * (itemSize + spacing)) + (isLeftPage ? 0 : screenWidth / 2);
          final estimatedY = (rowIndex * (itemSize + spacing)) + 200; // 상단 여백 고려
          
          top = estimatedY;
          if (isLeftPage) {
            right = screenSize.width - estimatedX + gap;
          } else {
            left = estimatedX + gap;
          }
        }

        // 화면 밖으로 나가지 않도록 보정
        top = top.clamp(10.0, screenSize.height - 80.0);
        if (left != null && left > screenSize.width - 200) left = screenSize.width - 200;
        if (right != null && right > screenSize.width - 200) right = screenSize.width - 200;

        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              // 배경 탭 시 닫힘
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => Navigator.of(dialogContext).pop(),
                  child: Container(color: Colors.transparent),
                ),
              ),
              // 툴팁 메시지 (잠금장치 바로 옆에 붙여서 표시)
              Positioned(
                top: top,
                left: left,
                right: right,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 200),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.plumu_black.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Text(
                      message,
                      textAlign: TextAlign.left,
                      style: AppTextStyles.pretendard_medium.copyWith(
                        color: Colors.white,
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 열매용 자물쇠 그리드 (5개) - 위 3개, 아래 2개
  Widget _buildFruitLockGrid(BuildContext context, int pageIndex) {
    final screenWidth = MediaQuery.of(context).size.width;
    final widthRatio = screenWidth / 430;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 위 3개 자물쇠
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) => 
            Padding(
              padding: EdgeInsets.only(
                right: index < 2 ? 25 * widthRatio : 0,
                bottom: 25 * widthRatio,
              ),
              child: _buildLockIcon(context, pageIndex: pageIndex, rowIndex: 0, colIndex: index),
            ),
          ),
        ),
        // 아래 2개 자물쇠 (중앙 정렬)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(2, (index) => 
            Padding(
              padding: EdgeInsets.only(
                right: index < 1 ? 25 * widthRatio : 0,
              ),
              child: _buildLockIcon(context, pageIndex: pageIndex, rowIndex: 1, colIndex: index + 1), // 중앙 정렬을 위해 colIndex + 1
            ),
          ),
        ),
      ],
    );
  }
}

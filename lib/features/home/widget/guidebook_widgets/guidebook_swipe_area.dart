import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';

/// 가이드북 책 스와이프 영역 위젯
class GuidebookSwipeArea extends StatelessWidget {
  final PageController pageController;
  final int currentPage;
  final int selectedTab;
  final ValueChanged<int> onPageChanged;

  const GuidebookSwipeArea({
    super.key,
    required this.pageController,
    required this.currentPage,
    required this.selectedTab,
    required this.onPageChanged,
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
  /// - 꽃 탭(0): guidebook_1, guidebook_2
  /// - 열매 탭(1): guidebook_1, guidebook_2 (동일한 책)
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

    return Image.asset(
      imagePath,
      fit: BoxFit.contain,
      alignment: alignment,
      width: double.infinity,
      height: double.infinity,
      filterQuality: FilterQuality.high,
    );
  }
}

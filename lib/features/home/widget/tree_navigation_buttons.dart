import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';

/// 트리 페이지 네비게이션 버튼 위젯
/// - 좌우 화살표 버튼으로 트리 페이지 간 이동
/// - 현재 페이지에 따라 버튼 활성/비활성 상태 표시
/// - 터치 시 PageController를 통해 페이지 전환
class TreeNavigationButtons extends StatelessWidget {
  /// 페이지 전환을 제어하는 컨트롤러
  final PageController pageController;
  /// 현재 페이지 인덱스
  final int currentPage;
  /// 전체 페이지 수
  final int totalPages;

  const TreeNavigationButtons({
    super.key,
    required this.pageController,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // 화살표 아이콘이 잘리지 않도록 설정
      children: [
        // 왼쪽 화살표 버튼 (이전 페이지로 이동)
        Positioned(
          top: 190,
          left: -10,
          child: GestureDetector(
            onTap: currentPage > 0 ? () {
              pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            } : null,
            child: Container(
              width: 28,
              height: 28,
              decoration: const ShapeDecoration(
                color: Color(0x335CBD56),
                shape: OvalBorder(),
              ),
              child: Icon(
                Icons.arrow_back_ios,
                size: 16,
                color: currentPage > 0 ? AppColors.plumu_green_main : Colors.grey,
              ),
            ),
          ),
        ),

        // 오른쪽 화살표 버튼 (다음 페이지로 이동)
        Positioned(
          top: 190,
          right: -10,
          child: GestureDetector(
            onTap: currentPage < totalPages - 1 ? () {
              pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            } : null,
            child: Container(
              width: 28,
              height: 28,
              decoration: const ShapeDecoration(
                color: Color(0x335CBD56),
                shape: OvalBorder(),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: currentPage < totalPages - 1 ? AppColors.plumu_green_main : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

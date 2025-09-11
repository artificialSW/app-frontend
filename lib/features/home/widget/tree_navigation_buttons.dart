import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';

class TreeNavigationButtons extends StatelessWidget {
  final PageController pageController;
  final int currentPage;
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
      clipBehavior: Clip.none, // 아이콘 안 잘리게
      children: [
        // 왼쪽 아이콘
        Positioned(
          top: 150,
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

        // 오른쪽 아이콘
        Positioned(
          top: 150,
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

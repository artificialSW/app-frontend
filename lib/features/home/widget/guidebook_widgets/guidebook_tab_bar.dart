import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';

/// 가이드북 꽃/열매 탭 바 위젯
class GuidebookTabBar extends StatelessWidget {
  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  const GuidebookTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
      child: Container(
        height: 48,
        padding: const EdgeInsets.all(2),
        decoration: ShapeDecoration(
          color: AppColors.plumu_gray_1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => onTabChanged(0),
                child: Container(
                  height: 40,
                  decoration: ShapeDecoration(
                    color: selectedTab == 0 ? AppColors.plumu_green_main : Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Center(
                    child: Text(
                      '꽃',
                      style: AppTextStyles.pretendard_medium.copyWith(
                        fontSize: (14 * MediaQuery.of(context).size.width / 430).clamp(12, 16),
                        color: selectedTab == 0 ? AppColors.plumu_gray_1 : AppColors.plumu_gray_7,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => onTabChanged(1),
                child: Container(
                  height: 40,
                  decoration: ShapeDecoration(
                    color: selectedTab == 1 ? AppColors.plumu_green_main : Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Center(
                    child: Text(
                      '열매',
                      style: AppTextStyles.pretendard_medium.copyWith(
                        fontSize: (14 * MediaQuery.of(context).size.width / 430).clamp(12, 16),
                        color: selectedTab == 1 ? AppColors.plumu_gray_1 : AppColors.plumu_gray_7,
                      ),
                    ),
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

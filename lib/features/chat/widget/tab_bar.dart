import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';

// 탭바 위젯
class ChatTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const ChatTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ChatTabItem(
            text: '개인질문',
            isSelected: selectedIndex == 0,
            onTap: () => onTabChanged(0),
          ),
        ),
        Expanded(
          child: ChatTabItem(
            text: '공통질문',
            isSelected: selectedIndex == 1,
            onTap: () => onTabChanged(1),
          ),
        ),
      ],
    );
  }
}

// 개별 탭 아이템 위젯
class ChatTabItem extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const ChatTabItem({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          border: isSelected 
            ? Border(bottom: BorderSide(color: AppColors.plumu_gray_7, width: 1))
            : null,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTextStyles.pretendard_medium.copyWith(
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? AppColors.plumu_gray_7 : AppColors.plumu_gray_5,
          ),
        ),
      ),
    );
  }
}

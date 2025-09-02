import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:flutter/material.dart';
import '../constants/tabs.dart'; // TabItem(icon, label)과 TABS 제공한다고 가정

class AppBottomBar extends StatelessWidget {
  const AppBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.tabs = TABS,
    this.backgroundColor,
    this.activeColor,
    this.inactiveColor,
    this.elevation = 12,
  });

  final int currentIndex;                 // 현재 선택된 인덱스
  final ValueChanged<int> onTap;          // 탭 눌렀을 때 콜백
  final List<TabItem> tabs;               // 아이콘/라벨 데이터
  final Color? backgroundColor;
  final Color? activeColor;
  final Color? inactiveColor;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final active = activeColor ?? AppColors.activeColor;
    final inactive = inactiveColor ?? AppColors.inactiveColor;

    return Material(
      elevation: elevation,
      color: backgroundColor ?? theme.colorScheme.surface,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              for (int i = 0; i < tabs.length; i++)
                _BottomItem(
                  iconPath: tabs[i].icon,
                  label: tabs[i].label,
                  selected: i == currentIndex,
                  activeColor: active,
                  inactiveColor: inactive,
                  onTap: () => onTap(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  const _BottomItem({
    required this.iconPath,
    required this.label,
    required this.selected,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  final String iconPath;
  final String label;
  final bool selected;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.plumu_white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                iconPath,
                width: 19, //이렇게 직접 지정할수도 있고, 주석처리해서 기본 이미지대로 할수도 있음.
                height: 19,
                color: selected ? activeColor : inactiveColor,
              ),
              const SizedBox(height: 3),
              SizedBox(
                width: 29.42,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected ? activeColor : inactiveColor,
                    fontSize: 9,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

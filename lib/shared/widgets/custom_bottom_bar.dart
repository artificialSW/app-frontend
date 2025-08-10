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
    final active = activeColor ?? theme.colorScheme.primary;
    final inactive = inactiveColor ?? theme.colorScheme.onSurface.withOpacity(0.6);

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
                  icon: tabs[i].icon,
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
    required this.icon,
    required this.label,
    required this.selected,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  final IconData icon;
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
            borderRadius: BorderRadius.circular(16),
            color: selected ? activeColor.withOpacity(0.12) : Colors.transparent,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: selected ? activeColor : inactiveColor),
              const SizedBox(height: 4),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected ? activeColor : inactiveColor,
                ),
                child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

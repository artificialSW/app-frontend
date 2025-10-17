import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import '../state/personal_question_send.dart';
import '../../widget/send_step_widgets.dart';

class StepVisibility extends StatelessWidget {
  final VisibilityType? selected;
  final ValueChanged<VisibilityType> onSelect;

  const StepVisibility({
    super.key,
    this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final widthRatio = screenWidth / 412.0;
    final heightRatio = screenHeight / 917.0;

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          // 제목: 좌측패딩 33, 하단패딩 702 (화면 맨 아래부터)
          Positioned(
            left: 33 * widthRatio,
            bottom: 702 * heightRatio,
            child: Text(
              '공개 여부를\n선택해주세요',
              style: TextStyle(
                color: const Color(0xFF1B1D1B),
                fontSize: 27 * widthRatio,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w700,
                height: 1.33,
                letterSpacing: -0.32 * widthRatio,
              ),
            ),
          ),
          
          // 버튼들: 공개 버튼 좌측패딩32, 비공개버튼 좌측패딩 123, 하단패딩 602 (화면 맨 아래부터)
          Positioned(
            left: 32 * widthRatio,
            bottom: 602 * heightRatio,
            child: Row(
              children: [
                _VisibilityButton(
                  text: '공개',
                  isSelected: selected == VisibilityType.public,
                  onTap: () => onSelect(VisibilityType.public),
                ),
                SizedBox(width: 22 * widthRatio), // 공개 비공개 버튼 간격 22px
                _VisibilityButton(
                  text: '비공개',
                  isSelected: selected == VisibilityType.private,
                  onTap: () => onSelect(VisibilityType.private),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VisibilityButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _VisibilityButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final widthRatio = screenWidth / 412.0;
    final heightRatio = screenHeight / 917.0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48 * heightRatio, // height는 48로 고정
        padding: EdgeInsets.symmetric(
          horizontal: 20 * widthRatio, // 좌우측패딩 20
          vertical: 12 * heightRatio, // 위아래패딩 12
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.plumu_green_main : AppColors.plumu_white,
          border: isSelected ? null : Border.all(color: AppColors.plumu_gray_3, width: 1),
          borderRadius: BorderRadius.circular(12 * widthRatio),
        ),
        child: IntrinsicWidth(
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? AppColors.plumu_white : const Color(0xFF35353F),
                fontSize: 17 * widthRatio,
                fontFamily: 'SF Pro Text',
                fontWeight: FontWeight.w600,
                height: 1.29,
                letterSpacing: -0.41 * widthRatio,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

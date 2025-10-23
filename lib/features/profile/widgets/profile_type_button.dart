import 'package:flutter/material.dart';
import '../../../shared/constants/app_colors.dart';
import '../../../shared/constants/app_text_styles.dart';

class ProfileTypeButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const ProfileTypeButton({
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
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        decoration: ShapeDecoration(
          color: isSelected ? AppColors.plumu_green_main : const Color(0xFFF3F3F3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: AppTextStyles.pretendard_medium.copyWith(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 14,
                height: 1.43,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

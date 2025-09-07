import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/models/usermodel.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';

class StepFamily extends StatelessWidget {
  final List<User> members;
  final User? selected;
  final ValueChanged<User> onSelect;
  const StepFamily({super.key, required this.members, this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 안내 문구
        Text(
          '가족 구성원을 선택해주세요',
          style: AppTextStyles.pretendard_bold.copyWith(
            fontSize: 20,
            color: AppColors.plumu_gray_7,
          ),
        ),
        const SizedBox(height: 32),
        
        // 가족 구성원 버튼들
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: members.map((member) {
            final isSelected = selected?.id == member.id;
            return GestureDetector(
              onTap: () => onSelect(member),
              child: Container(
                width: 100,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.plumu_green_main : AppColors.plumu_white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.plumu_green_main : AppColors.plumu_gray_2,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    member.name,
                    style: AppTextStyles.pretendard_medium.copyWith(
                      fontSize: 16,
                      color: isSelected ? AppColors.plumu_white : AppColors.plumu_gray_7,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

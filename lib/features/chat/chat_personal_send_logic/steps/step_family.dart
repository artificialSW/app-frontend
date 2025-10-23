import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/models/usermodel.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import '../../widget/send_step_widgets.dart';

class StepFamily extends StatelessWidget {
  final List<User> members;
  final User? selected;
  final ValueChanged<User> onSelect;

  const StepFamily({
    super.key,
    required this.members,
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
          // 제목: 좌측패딩32, 하단패딩 700 (화면 맨 아래부터)
          Positioned(
            left: 32 * widthRatio,
            bottom: 700 * heightRatio,
            child: Text(
              '가족 구성원을 \n선택해주세요',
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
          
          // 버튼들: 첫 번째 줄 (앞쪽 버튼들)
          Positioned(
            left: 31 * widthRatio,
            bottom: 600 * heightRatio,
            right: 0,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: members.take(3).map((m) { // 처음 3개만 첫 번째 줄에
                  final isSelected = selected?.id == m.id;
                  return Padding(
                    padding: EdgeInsets.only(right: 20 * widthRatio),
                    child: _FamilyMemberButton(
                      text: m.name,
                      isSelected: isSelected,
                      onTap: () => onSelect(m),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          // 버튼들: 두 번째 줄 (밀리는 버튼들) - 위 박스에서 29px 아래
          if (members.length > 3)
            Positioned(
              left: 31 * widthRatio,
              bottom: 600 * heightRatio - 29 * heightRatio - 48 * heightRatio, // 위 박스에서 29px + 버튼 높이만큼 아래
              right: 0,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: members.skip(3).map((m) { // 4번째부터는 두 번째 줄에
                    final isSelected = selected?.id == m.id;
                    return Padding(
                      padding: EdgeInsets.only(right: 20 * widthRatio),
                      child: _FamilyMemberButton(
                        text: m.name,
                        isSelected: isSelected,
                        onTap: () => onSelect(m),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FamilyMemberButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _FamilyMemberButton({
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

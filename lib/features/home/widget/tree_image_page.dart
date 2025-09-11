import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';

class TreeImagePage extends StatelessWidget {
  final String namingDate;
  final String treeName;

  const TreeImagePage({
    super.key,
    required this.namingDate,
    required this.treeName,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 20,
          child: Image.asset(
            AppAssets.tree,
            width: 300,
            height: 300,
            fit: BoxFit.contain,
          )
        ),
        Positioned(
          top: 200,
          left: 250,
          child: Stack(
            children: [
              Image.asset(AppAssets.wooden_sign),
              // 날짜 표시
              Positioned(
                top: 8,
                left: 0,
                right: 0,
                child: Text(
                  namingDate.isNotEmpty ? namingDate : '2025.06.06',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.pretendard_bold.copyWith(
                    fontSize: 7,
                    color: AppColors.plumu_black,
                  ),
                ),
              ),
              // 나무 이름 표시
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Text(
                  treeName.isNotEmpty ? treeName : '나무이름',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.pretendard_bold.copyWith(
                    fontSize: 11,
                    color: AppColors.plumu_black,
                  ),
                ),
              ),
            ],
          )
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';

/// 트리 이미지 페이지 위젯
/// - 나무 이미지와 나무 이름 표지판을 표시
/// - 나무 이름 설정 날짜와 이름을 표지판에 표시
/// - 3개 페이지 모두 동일한 구조로 표시
class TreeImagePage extends StatelessWidget {
  /// 나무 이름을 설정한 날짜
  final String namingDate;
  /// 설정된 나무 이름
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
        // 나무 이미지
        Positioned(
          top: 40, // 상단 여백
          left: 20, // 좌측 여백
          child: Image.asset(
            AppAssets.tree,
            width: 300,
            height: 300,
            fit: BoxFit.contain,
          )
        ),
        // 나무 이름 표지판
        Positioned(
          top: 240, // 나무 이미지 아래쪽에 배치
          left: 250, // 나무 이미지 오른쪽에 배치
          child: Stack(
            children: [
              // 표지판 배경 이미지
              Image.asset(AppAssets.wooden_sign),
              // 나무 이름 설정 날짜 표시
              Positioned(
                top: 8,
                left: 0,
                right: 0,
                child: Text(
                  namingDate.isNotEmpty ? namingDate : '2025.06.06', // 기본값 설정
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
                  treeName.isNotEmpty ? treeName : '나무이름', // 기본값 설정
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

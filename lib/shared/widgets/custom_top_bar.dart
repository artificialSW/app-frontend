import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';

AppBar CustomTopBar() => AppBar(
    automaticallyImplyLeading: false,   // 뒤로가기 자동 삽입 방지(중앙 정렬 깨짐 방지)
    centerTitle: true,                  // 로고 중앙
    toolbarHeight: 56,                  // 와이어프레임 높이 맞춤
    titleSpacing: 0,                    // 양옆 여백 제어
    leadingWidth: 56,                   // 좌우 균형(우측 actions 없을 때)
    title: SizedBox(
      width: 60,
      height: 24.08,
      child: Text(
        'plumu',
        textAlign: TextAlign.center,
        style: AppTextStyles.plumu
      ),
    ),
  );

import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'package:artificialsw_frontend/features/chat/presentation/pages/chat_page.dart';

AppBar HomeTopBar() => AppBar(
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
    actions: [
      IconButton(onPressed: null, icon: Image.asset(AppAssets.dogaam)),
    ],
  );

AppBar PuzzlRootTopBar() => AppBar(
  automaticallyImplyLeading: false,   // 뒤로가기 자동 삽입 방지(중앙 정렬 깨짐 방지)
  centerTitle: true,
  title: const Text(
    '퍼즐',
    style: TextStyle(
      color: Colors.black,
      fontSize: 17,
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w700,
      height: 1.50,
      letterSpacing: -0.46,
    ),
  ),
);

AppBar ProfileRootTopBar() => AppBar(
  automaticallyImplyLeading: false,   // 뒤로가기 자동 삽입 방지(중앙 정렬 깨짐 방지)
  centerTitle: true,
  title: const Text(
    '마이페이지',
    style: TextStyle(
      color: Colors.black,
      fontSize: 17,
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w700,
      height: 1.50,
      letterSpacing: -0.46,
    ),
  ),
);

const chatTopBarStyle = TextStyle(
  color: Colors.black,
  fontSize: 17,
  fontFamily: 'Pretendard',
  fontWeight: FontWeight.w700,
  height: 1.5,
  letterSpacing: -0.46,
);

AppBar ChatRootTopBar() => AppBar(
  elevation: 0,
  backgroundColor: Colors.white,
  centerTitle: true,
  title: const Text('소통방', style: chatTopBarStyle),
  iconTheme: const IconThemeData(color: Colors.black87),
  actions: const [HeaderSendIcon()],
);
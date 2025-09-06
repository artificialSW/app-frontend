import 'package:artificialsw_frontend/features/chat/presentation/pages/chat_page.dart';
import 'package:artificialsw_frontend/features/home/home_mainpage.dart';
import 'package:artificialsw_frontend/features/Profile/profile_page.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/features/puzzle/puzzle_mainpage.dart';

class TabItem {
  final String icon;
  final String label;
  final Widget page;

  const TabItem({
    required this.icon,
    required this.label,
    required this.page,
  });
}

const TABS = [
  TabItem(icon: AppAssets.home, label: '홈', page: HomeRoot()),
  TabItem(icon: AppAssets.puzzle, label: '퍼즐', page: PuzzleRoot()),
  TabItem(icon: AppAssets.chat, label: '소통방', page: ChatRoot()),
  TabItem(icon: AppAssets.mypage, label: '마이페이지', page: ProfileRoot())
];

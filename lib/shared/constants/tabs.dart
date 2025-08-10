import 'package:artificialsw_frontend/features/chat/chat_page.dart';
import 'package:artificialsw_frontend/features/home/home_page.dart';
import 'package:artificialsw_frontend/features/Profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/features/puzzle/puzzle_page.dart';

class TabItem {
  final IconData icon;
  final String label;
  final Widget page;

  const TabItem({
    required this.icon,
    required this.label,
    required this.page,
  });
}

const TABS = [
  TabItem(icon: Icons.home, label: 'Home', page: HomeRoot()),
  TabItem(icon: Icons.extension, label: 'Puzzle', page: PuzzleRoot()),
  TabItem(icon: Icons.chat, label: 'Chat', page: ChatRoot()),
  TabItem(icon: Icons.person, label: 'profile', page: ProfileRoot())
];

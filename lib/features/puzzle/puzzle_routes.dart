import 'package:artificialsw_frontend/features/puzzle/puzzle_edit.dart';
import 'package:artificialsw_frontend/features/puzzle/puzzle_page.dart';
import 'package:flutter/material.dart';

Route<dynamic> puzzleRoutes(RouteSettings s) {
  switch (s.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const PuzzleRoot());
    case '/editor':
      return MaterialPageRoute(builder: (_) => const PuzzleEditPage());
    default:
      return MaterialPageRoute(builder: (_) => const PuzzleRoot());
  }
}

import 'package:artificialsw_frontend/features/puzzle/ongoing_puzzles_page.dart';
import 'package:artificialsw_frontend/features/puzzle/play_puzzle_page.dart';
import 'package:artificialsw_frontend/features/puzzle/puzzle_completed.dart';
import 'package:artificialsw_frontend/features/puzzle/puzzle_page.dart';
import 'package:flutter/material.dart';

Route<dynamic> puzzleRoutes(RouteSettings s) {
  switch (s.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const PuzzleRoot());
    case '/puzzle/in-progress':  
      return MaterialPageRoute(builder: (_) => const OngoingPuzzlesPage());
    case '/puzzle/play':
      return MaterialPageRoute(builder: (_) => PlayPuzzle());
    case '/puzzle/completed':
      return MaterialPageRoute(builder: (_) => PuzzleCompleted());
    default:
      return MaterialPageRoute(builder: (_) => const PuzzleRoot());
  }
}

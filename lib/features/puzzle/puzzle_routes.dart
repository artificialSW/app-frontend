import 'package:artificialsw_frontend/features/puzzle/puzzle_completed.dart';
import 'package:artificialsw_frontend/features/puzzle/puzzle_completedlist.dart';
import 'package:artificialsw_frontend/features/puzzle/puzzle_ongoinglist.dart';
import 'package:artificialsw_frontend/features/puzzle/puzzle_playing.dart';
import 'package:artificialsw_frontend/features/puzzle/puzzle_mainpage.dart';
import 'package:artificialsw_frontend/features/puzzle/model/puzzlegame.dart';
import 'package:artificialsw_frontend/features/puzzle/write_puzzle_info_page.dart';
import 'package:flutter/material.dart';

Route<dynamic> puzzleRoutes(RouteSettings s) {
  switch (s.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const PuzzleRoot());
    case '/puzzle/ongoing-list':
      return MaterialPageRoute(builder: (_) => const OngoingPuzzlesPage());
    case '/puzzle/completed-list':
      return MaterialPageRoute(builder: (_) => CompletedPuzzlesPage());

    case '/puzzle/write-puzzle-info':
      final args = s.arguments as Map<String, dynamic>;
      final puzzleGame = args['gameInstance'] as PuzzleGame;
      return MaterialPageRoute(builder: (_) => WritePuzzleInfoPage(puzzle: puzzleGame));
    case '/puzzle/play':
      final args = s.arguments as Map<String, dynamic>;
      final puzzleGame = args['gameInstance'] as PuzzleGame;
      return MaterialPageRoute(builder: (_) => PlayPuzzle(puzzle: puzzleGame));
    case '/puzzle/completed':
      return MaterialPageRoute(builder: (_) => PuzzleCompleted());

    default:
      return MaterialPageRoute(builder: (_) => const PuzzleRoot());
  }
}

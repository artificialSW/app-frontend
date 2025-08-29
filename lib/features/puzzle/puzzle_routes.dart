import 'package:artificialsw_frontend/features/puzzle/relay_puzzle_logic/puzzle_completed.dart';
import 'package:artificialsw_frontend/features/puzzle/replay_completed_puzzle_logic/puzzle_completedlist.dart';
import 'package:artificialsw_frontend/features/puzzle/relay_puzzle_logic/puzzle_ongoinglist.dart';
import 'package:artificialsw_frontend/features/puzzle/relay_puzzle_logic/puzzle_playing.dart';
import 'package:artificialsw_frontend/features/puzzle/puzzle_mainpage.dart';
import 'package:artificialsw_frontend/features/puzzle/model/puzzlegame.dart';
import 'package:artificialsw_frontend/features/puzzle/replay_completed_puzzle_logic/puzzle_replaying.dart';
import 'package:artificialsw_frontend/features/puzzle/newly_play_puzzle_logic/write_puzzle_info_page.dart';
import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/features/puzzle/replay_completed_puzzle_logic/puzzle_recompleted.dart';
import 'package:artificialsw_frontend/features/puzzle/newly_play_puzzle_logic/write_puzzle_info_page.dart';

Route<dynamic> puzzleRoutes(RouteSettings s) {
  switch (s.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const PuzzleRoot());
    case '/puzzle/write-puzzle-info':
      final args = s.arguments as Map<String, dynamic>;
      final puzzleGame = args['gameInstance'] as PuzzleGame;
      return MaterialPageRoute(builder: (_) => WritePuzzleInfoPage(puzzle: puzzleGame));
    case '/puzzle/ongoing-list':
      return MaterialPageRoute(builder: (_) => const OngoingPuzzlesPage());
    case '/puzzle/completed-list':
      return MaterialPageRoute(builder: (_) => CompletedPuzzlesPage());

    case '/puzzle/play':
      final args = s.arguments as Map<String, dynamic>;
      final puzzleGame = args['gameInstance'] as PuzzleGame;
      return MaterialPageRoute(builder: (_) => PlayPuzzle(puzzle: puzzleGame));
    case '/puzzle/completed':
      return MaterialPageRoute(builder: (_) => PuzzleCompleted());
    case '/puzzle/re-play':
      final args = s.arguments as Map<String, dynamic>;
      final original = args['gameInstance'] as PuzzleGame;
      final puzzleInstance = original.copyForReplaying();
      return MaterialPageRoute(builder: (_) => ReplayPuzzle(puzzle: puzzleInstance));
    case '/puzzle/re-completed':
      return MaterialPageRoute(builder: (_) => PuzzleRecompleted());

    default:
      return MaterialPageRoute(builder: (_) => const PuzzleRoot());
  }
}

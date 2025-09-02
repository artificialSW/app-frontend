import 'package:artificialsw_frontend/features/puzzle/asset_view.dart';
import 'package:artificialsw_frontend/features/puzzle/newly_play_puzzle_logic/play_puzzle.dart';
import 'package:artificialsw_frontend/features/puzzle/newly_play_puzzle_logic/puzzle_archive.dart';
import 'package:artificialsw_frontend/features/puzzle/newly_play_puzzle_logic/puzzle_completed.dart';
import 'package:artificialsw_frontend/features/puzzle/replay_completed_puzzle_logic/puzzle_completedlist.dart';
import 'package:artificialsw_frontend/features/puzzle/relay_puzzle_logic/puzzle_ongoinglist.dart';
import 'package:artificialsw_frontend/features/puzzle/puzzle_mainpage.dart';
import 'package:artificialsw_frontend/features/puzzle/model/puzzlegame.dart';
import 'package:artificialsw_frontend/features/puzzle/newly_play_puzzle_logic/write_puzzle_info_page.dart';
import 'package:artificialsw_frontend/features/puzzle/weekly_upload/add_comment_page.dart';
import 'package:artificialsw_frontend/features/puzzle/weekly_upload/image_upload_page.dart';
import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/features/puzzle/replay_completed_puzzle_logic/puzzle_recompleted.dart';

Route<dynamic> puzzleRoutes(RouteSettings s) {
  switch (s.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const PuzzleRoot());
    case '/puzzle/image-upload-test':
      return MaterialPageRoute(builder: (_) => const ImageUploadPage());
    case '/puzzle/add-comment':
      return MaterialPageRoute(builder: (_) => const AddCommentPage());

    case '/puzzle/write-puzzle-info':
      return MaterialPageRoute(builder: (_) => const WritePuzzleInfoPage());
    case '/puzzle/play':
      final args = s.arguments as Map<String, dynamic>;
      final puzzleGame = args['gameInstance'] as PuzzleGame;
      return MaterialPageRoute(builder: (_) => PlayPuzzle(puzzle: puzzleGame));

    case '/puzzle/ongoing-list':
      return MaterialPageRoute(builder: (_) => const OngoingPuzzlesPage());
    case '/puzzle/completed-list':
      return MaterialPageRoute(builder: (_) => CompletedPuzzlesPage());

    case '/puzzle/completed':
      return MaterialPageRoute(builder: (_) => PuzzleCompleted());
    case '/puzzle/re-play':
      final args = s.arguments as Map<String, dynamic>;
      final original = args['gameInstance'] as PuzzleGame;
      final puzzleInstance = original.copyForReplaying();
      return MaterialPageRoute(builder: (_) => PlayPuzzle(puzzle: puzzleInstance));
    case '/puzzle/re-completed':
      return MaterialPageRoute(builder: (_) => PuzzleRecompleted());
    case '/puzzle/archive':
      return MaterialPageRoute(builder: (_) => PuzzleArchive());
    case '/puzzle/assetView':
      return MaterialPageRoute(builder: (_) => AssetView());

    default:
      return MaterialPageRoute(builder: (_) => const PuzzleRoot());
  }
}

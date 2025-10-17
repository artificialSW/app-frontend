import 'package:artificialsw_frontend/features/puzzle/newly_play_puzzle_logic/play_puzzle.dart';
import 'package:artificialsw_frontend/features/puzzle/newly_play_puzzle_logic/puzzle_archive.dart';
import 'package:artificialsw_frontend/features/puzzle/newly_play_puzzle_logic/puzzle_completed.dart';
import 'package:artificialsw_frontend/features/puzzle/replay_completed_puzzle_logic/puzzle_completedlist.dart';
import 'package:artificialsw_frontend/features/puzzle/relay_puzzle_logic/puzzle_ongoinglist.dart';
import 'package:artificialsw_frontend/features/puzzle/puzzle_mainpage.dart';
import 'package:artificialsw_frontend/features/puzzle/model/puzzlegame.dart';
import 'package:artificialsw_frontend/features/puzzle/newly_play_puzzle_logic/write_puzzle_info_page.dart';
import 'package:artificialsw_frontend/features/puzzle/weekly_upload/image_upload_page.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/puzzle_complete/puzzle_complete_response_dto.dart';
import 'package:artificialsw_frontend/shared/models/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/features/puzzle/replay_completed_puzzle_logic/puzzle_recompleted.dart';

Route<dynamic> puzzleRoutes(RouteSettings s) {
  switch (s.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const PuzzleRoot());
    case '/puzzle/image-upload':
      return MaterialPageRoute(
        builder: (context) {
          final args = s.arguments as Map<String, dynamic>;
          final categoryList = args['category'] as List<String>;
          return ImageUploadPage(category: categoryList);
        },
      );
    case '/puzzle/write-puzzle-info':
      return MaterialPageRoute(builder: (_) => const WritePuzzleInfoPage());
    case '/puzzle/play':
      final args = s.arguments as Map<String, dynamic>;
      final puzzleGame = args['gameInstance'] as PuzzleGame;
      return MaterialPageRoute(builder: (_) => PlayPuzzle(puzzle: puzzleGame, user: User(id: 123, name: 'Jaewook',role: '아빠')));

    case '/puzzle/ongoing-list':
      return MaterialPageRoute(builder: (_) => const OngoingPuzzlesPage());
    case '/puzzle/completed-list':
      return MaterialPageRoute(builder: (_) => CompletedPuzzlesPage());

    case '/puzzle/completed':
      final args = s.arguments as Map<String, dynamic>;
      final message = args['message'] as String;
      final fruitName = args['fruitName'] as String;
      final fruitMessage = args['fruitMessage'] as String;
      final contributors = args['contributors'] as List<String>;
      return MaterialPageRoute(builder: (_) => PuzzleCompleted(
          message: message,
          fruitName: fruitName,
          fruitMessage: fruitMessage,
          contributors: contributors)
      );
    case '/puzzle/re-play':
      final args = s.arguments as Map<String, dynamic>;
      final original = args['gameInstance'] as PuzzleGame;
      final puzzleInstance = original.copyForReplaying();
      return MaterialPageRoute(builder: (_) => PlayPuzzle(puzzle: puzzleInstance, user: User(id: 123, name: 'Jaewook', role: '아빠')));
    case '/puzzle/re-completed':
      return MaterialPageRoute(builder: (_) => PuzzleRecompleted());
    case '/puzzle/archive':
      return MaterialPageRoute(builder: (_) => PuzzleArchive());

    default:
      return MaterialPageRoute(builder: (_) => const PuzzleRoot());
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:artificialsw_frontend/features/puzzle/viewmodel/puzzle_view_model.dart';
import 'package:artificialsw_frontend/features/puzzle/puzzle_main.dart';
import 'package:artificialsw_frontend/features/puzzle/view/puzzle_board_view.dart';

Route<dynamic> puzzleRoutes(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const PuzzleRoot());

    case '/puzzle/play':
    // 라우트 인자(arguments)를 추출합니다.
      final args = settings.arguments as Map<String, dynamic>;
      final Image image = args['image'];
      final int maxRow = args['maxRow'];
      final int maxCol = args['maxCol'];

      // 추출한 인자로 PuzzleViewModel을 생성하여 제공합니다.
      return MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => PuzzleViewModel(
            fullImage: image,
            maxRow: maxRow,
            maxCol: maxCol,
            onGameComplete: (completedGame) {
              print('게임이 완료되었습니다!'); //퍼즐 종료 페이지 여기서 관리
            },
          ),
          child: const PuzzleBoardView(),
        ),
      );

    default:
      return MaterialPageRoute(builder: (_) => const PuzzleRoot());
  }
}
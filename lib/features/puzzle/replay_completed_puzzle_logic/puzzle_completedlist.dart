//completed_puzzles_page.dart

import 'package:artificialsw_frontend/features/puzzle/model/puzzlegame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:artificialsw_frontend/features/puzzle/puzzlelist_provider.dart';

/// 완료된 퍼즐 목록 페이지
class CompletedPuzzlesPage extends StatelessWidget {
  const CompletedPuzzlesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '완료된 퍼즐 목록',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<PuzzleProvider>(
        builder: (context, puzzleProvider, child) {
          if (puzzleProvider.completedPuzzles.isEmpty) {
            return const Center(
              child: Text(
                '완료된 퍼즐이 없습니다.',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              itemCount: puzzleProvider.completedPuzzles.length,
              itemBuilder: (context, index) {
                final puzzle = puzzleProvider.completedPuzzles[index];
                return PuzzleListItem(
                  puzzle: puzzle,
                  onDelete: () {}, // 완료된 퍼즐은 삭제 기능 없음
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/puzzle/re-play',
                      arguments: {'gameInstance': puzzle},
                    );
                  },
                  gameState: GameState.Completed, // 완료된 퍼즐임을 표시
                );
              },
            ),
          );
        },
      ),
    );
  }
}
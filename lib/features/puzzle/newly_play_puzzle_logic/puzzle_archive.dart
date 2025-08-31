import 'package:artificialsw_frontend/features/puzzle/model/puzzlegame.dart';
import 'package:artificialsw_frontend/features/puzzle/puzzlelist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PuzzleArchive extends StatelessWidget {
  const PuzzleArchive({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '퍼즐 아카이브',
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
          if (puzzleProvider.archivedPuzzles.isEmpty) {
            return const Center(
              child: Text(
                '아카이빙이 비었어요. 어서 퍼즐을 풀어보세요!',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              itemCount: puzzleProvider.archivedPuzzles.length,
              itemBuilder: (context, index) {
                final puzzle = puzzleProvider.archivedPuzzles[index];
                return PuzzleListItem(
                  puzzle: puzzle,
                  onDelete: () {}, //TODO: 아카이빙에서 삭제하는 로직 구현
                  onPressed: () {},
                  onSave: () {}, //TODO: 핸드폰에 저장하는 기능 구현하기
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

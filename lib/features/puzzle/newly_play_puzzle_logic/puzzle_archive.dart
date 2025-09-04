import 'package:artificialsw_frontend/features/puzzle/model/puzzlegame.dart';
import 'package:artificialsw_frontend/features/puzzle/puzzlelist_provider.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PuzzleArchive extends StatelessWidget {
  const PuzzleArchive({super.key});

  void _showDeleteConfirmationDialog(BuildContext context, PuzzleGame puzzle) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('퍼즐 삭제'),
          content: const Text('퍼즐을 아카이브에서 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('아니오'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<PuzzleProvider>(
                  context,
                  listen: false,
                ).undoArchivePuzzle(puzzle);
                Navigator.of(context).pop();
              },
              child: const Text('예'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CanGoBackTopBar('퍼즐 아카이브', context),
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
                  onDelete: () => _showDeleteConfirmationDialog(context, puzzle),
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

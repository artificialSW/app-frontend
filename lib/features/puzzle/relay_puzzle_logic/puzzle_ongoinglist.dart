import 'package:artificialsw_frontend/features/puzzle/model/puzzlegame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:artificialsw_frontend/features/puzzle/puzzlelist_provider.dart';

class OngoingPuzzlesPage extends StatelessWidget {
  const OngoingPuzzlesPage({Key? key}) : super(key: key);

  void _showDeleteConfirmationDialog(BuildContext context, int puzzleId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('퍼즐 삭제'),
          content: const Text('진행하신 퍼즐을 삭제하시겠습니까?'),
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
                ).deletePuzzle(puzzleId);
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
      appBar: AppBar(
        title: const Text(
          '진행중인 퍼즐 목록',
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
          if (puzzleProvider.ongoingPuzzles.isEmpty) {
            return const Center(
              child: Text(
                '진행중인 퍼즐이 없습니다.',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              itemCount: puzzleProvider.ongoingPuzzles.length,
              itemBuilder: (context, index) {
                final puzzle = puzzleProvider.ongoingPuzzles[index];
                return PuzzleListItem(
                  puzzle: puzzle,
                  onDelete:
                      () => _showDeleteConfirmationDialog(context, puzzle.puzzleId),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                        '/puzzle/play',
                        arguments: {'gameInstance': puzzle},
                    );
                  },
                  onSave: () {},
                  gameState: GameState.Ongoing,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
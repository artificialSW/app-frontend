import 'package:artificialsw_frontend/features/puzzle/model/puzzlegame.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_deleteConfirmationDialog.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:artificialsw_frontend/features/puzzle/puzzlelist_provider.dart';

class OngoingPuzzlesPage extends StatelessWidget {
  const OngoingPuzzlesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CanGoBackTopBar('진행중인 퍼즐 목록', context),
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
                      () => showDialog(
                        context: context,
                        builder: (context) {
                          return DeleteConfirm(
                            title: '진행중인 퍼즐을 삭제하시겠습니까?',
                            content: '퍼즐 진행상황이 모두 삭제됩니다.',
                            puzzleId: puzzle.puzzleId, // 삭제할 퍼즐 id
                          );
                        },
                      ),
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
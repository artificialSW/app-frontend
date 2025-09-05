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

  // void _showDeleteConfirmationDialog(BuildContext context, int puzzleId) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(12), // 모서리 둥글게
  //         ),
  //         backgroundColor: AppColors.alart_background,
  //         child: SizedBox(
  //           width: 280,   // 원하는 너비 지정
  //           height: 150,  // 원하는 높이 지정 (AlertDialog보다 줄임)
  //           child: Padding(
  //             padding: const EdgeInsets.all(16),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 SizedBox(height: 15),
  //                 const Text(
  //                   '진행중인 퍼즐을 삭제하시겠습니까?',
  //                   style: TextStyle(
  //                     color: AppColors.plumu_gray_7,
  //                     fontSize: 16,
  //                     fontFamily: 'Pretendard',
  //                     fontWeight: FontWeight.w700,
  //                     height: 1.41,
  //                   ),
  //                 ),
  //                 const Text(
  //                   '퍼즐 진행상황이 모두 삭제됩니다.',
  //                   style: TextStyle(
  //                     color: AppColors.plumu_gray_7,
  //                     fontSize: 14,
  //                     fontFamily: 'Pretendard',
  //                     fontWeight: FontWeight.w500,
  //                     height: 1.71,
  //                   ),
  //                 ),
  //                 SizedBox(height: 15),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   children: [
  //                     CustomButton(
  //                       text: '아니오',
  //                       onPressed: () => Navigator.of(context).pop(),
  //                       height: 40,
  //                       width: 111,
  //                       backgroundColor: AppColors.plumu_white,
  //                       textColor: AppColors.plumu_gray_7,
  //                     ),
  //                     CustomButton(
  //                       text: '예',
  //                       onPressed: () {
  //                         Provider.of<PuzzleProvider>(
  //                           context,
  //                           listen: false,
  //                         ).deletePuzzle(puzzleId);
  //                         Navigator.of(context).pop();
  //                       },
  //                       height: 40,
  //                       width: 111,
  //                       backgroundColor: AppColors.plumu_white,
  //                       textColor: AppColors.plumu_gray_7,
  //                     ),
  //                   ],
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

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
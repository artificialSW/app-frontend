import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:artificialsw_frontend/features/puzzle/viewmodel/puzzle_view_model.dart';
import 'puzzle_piece_view.dart';

class PuzzleBoardView extends StatelessWidget {
  const PuzzleBoardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PuzzleViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('퍼즐 플레이')),
      body: Consumer<PuzzleViewModel>(
        builder: (context, viewModel, child) {
          // LayoutBuilder를 사용하여 부모 위젯이 허용하는 크기를 얻습니다.
          return LayoutBuilder(
            builder: (context, constraints) {
              if (viewModel.isLoading) {
                // 초기화가 되지 않았다면, constraints를 전달하여 초기화 시작
                viewModel.initializePuzzle(constraints);
                return const Center(child: CircularProgressIndicator());
              }

              final double puzzleWidth = constraints.maxWidth;
              final double puzzleHeight = puzzleWidth * viewModel.fullUiImage!.height / viewModel.fullUiImage!.width;

              return Container(
                width: puzzleWidth,
                height: puzzleHeight,
                decoration: BoxDecoration(
                  color: Colors.lightGreen[100], // 연한 연두색 배경
                  border: Border.all(
                    color: Colors.green, // 초록색 테두리
                    width: 4.0, // 테두리 두께
                  ),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: viewModel.puzzlePieces
                      .map((piece) => PuzzlePieceView(piece: piece))
                      .toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
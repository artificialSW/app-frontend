import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:artificialsw_frontend/features/puzzle/viewmodel/puzzle_view_model.dart';
import 'puzzle_piece_view.dart';

class PuzzleBoardView extends StatelessWidget {
  const PuzzleBoardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PuzzleViewModel>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (viewModel.fullUiImage == null) {
        viewModel.initializePuzzle(MediaQuery.of(context).size.width);
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('퍼즐 플레이')),
      body: Consumer<PuzzleViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading || viewModel.fullUiImage == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final double puzzleWidth = viewModel.fullUiImage!.width.toDouble();
          final double puzzleHeight = viewModel.fullUiImage!.height.toDouble();

          return FittedBox(
            fit: BoxFit.contain, // 퍼즐을 화면에 맞게 확대/축소
            child: Container(
              width: puzzleWidth, // 원본 이미지의 픽셀 크기
              height: puzzleHeight, // 원본 이미지의 픽셀 크기
              decoration: BoxDecoration(
                color: Colors.lightGreen[100],
                border: Border.all(
                  color: Colors.green,
                  width: 4.0,
                ),
              ),
              child: Stack(
                children: viewModel.puzzlePieces
                    .map((piece) => PuzzlePieceView(piece: piece))
                    .toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
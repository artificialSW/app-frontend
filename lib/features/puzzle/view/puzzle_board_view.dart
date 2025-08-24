import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:artificialsw_frontend/features/puzzle/viewmodel/puzzle_view_model.dart';
import 'puzzle_piece_view.dart';

class PuzzleBoardView extends StatelessWidget {
  const PuzzleBoardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('퍼즐 플레이')),
      body: Consumer<PuzzleViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Stack(
            children: viewModel.puzzlePieces
                .map((piece) => PuzzlePieceView(piece: piece))
                .toList(),
          );
        },
      ),
    );
  }
}
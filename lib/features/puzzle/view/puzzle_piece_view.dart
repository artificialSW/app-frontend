// lib/views/puzzle_piece_view.dart

import 'package:artificialsw_frontend/features/puzzle/view/puzzle_piece_painter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:artificialsw_frontend/features/puzzle/model/puzzle_piece.dart';
import 'package:artificialsw_frontend/features/puzzle/viewmodel/puzzle_view_model.dart';

class PuzzlePieceView extends StatelessWidget {
  final PuzzlePieceModel piece;

  const PuzzlePieceView({Key? key, required this.piece}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PuzzleViewModel>(context);

    //final bumpSize = piece.pieceHeight / 4;

    return Positioned(
      left: piece.currentPosition.dx,
      top: piece.currentPosition.dy,
      width: piece.imageSize.width / piece.maxCol.toDouble(),
      height: piece.imageSize.height / piece.maxRow.toDouble(),
      child: GestureDetector(
        onPanUpdate: (details) {
          viewModel.onPiecePanUpdate(piece, details);
        },
        child: ClipPath( //이 ClipPath()를 통해 얻은 결과물이 🧩모양 퍼즐이어야 함.(튀어나온 부분 있는)
          clipper: PuzzlePieceClipper(piece.row, piece.col, piece.maxRow, piece.maxCol),
          child: CustomPaint(
            // 이제 이미지와 테두리를 한 번에 그립니다.
            painter: PuzzleImagePainter(
              image: viewModel.fullUiImage!,
              row: piece.row,
              col: piece.col,
              maxRow: piece.maxRow,
              maxCol: piece.maxCol,
            ),
            foregroundPainter: PuzzlePiecePainter(
              piece.row, piece.col, piece.maxRow, piece.maxCol,
            ),
          ),
        ),
      ),
    );
  }
}
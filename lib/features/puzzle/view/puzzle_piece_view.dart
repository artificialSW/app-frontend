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

    // PuzzlePieceModel에서 크기 정보를 가져와 사용
    final double pieceWidth = viewModel.fullUiImage!.width / piece.maxCol;
    final double pieceHeight = viewModel.fullUiImage!.height / piece.maxRow;

    final bump = pieceHeight / 4;

    return Positioned(
      left: piece.currentPosition.dx,
      top: piece.currentPosition.dy,
      width: piece.pieceWidth, // 모델의 pieceWidth 사용
      height: piece.pieceHeight, // 모델의 pieceHeight 사용
      child: GestureDetector(
        onPanUpdate: (details) {
          viewModel.onPiecePanUpdate(piece, details);
        },
        child: ClipPath(
          clipper: PuzzlePieceClipper(piece.row, piece.col, piece.maxRow, piece.maxCol),
          child: OverflowBox(
            maxWidth: piece.pieceWidth,
            maxHeight: piece.pieceHeight,
            child: CustomPaint(
              //size: Size(pieceWidth + bump*2, pieceHeight + bump*2),
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
      ),
    );
  }
}
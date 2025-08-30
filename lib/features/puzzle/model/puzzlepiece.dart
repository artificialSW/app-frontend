import 'dart:math';

import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/features/puzzle/model/puzzlepiece_maker.dart';
import 'package:artificialsw_frontend/features/puzzle/model/puzzlepiece_position.dart';

class PuzzlePiece extends StatefulWidget {
  final Image image;
  final Size imageSize;
  final int row;
  final int col;
  final int id;
  final int maxRow;
  final int maxCol;
  PiecePosition? position; ///얘는 PuzzleGame의 piecesPosition[idx] 와 다르게 nullable함.
  ///그래야 null인 걸 알고(위치 안 부여된 걸 알고) 랜덤 값 지정해 주지. 안되면 뭐 어쩔수없이 구석탱이에 넣어야겠지만
  final Function bringToTop;
  final Function sendToBack;
  final Function onCompleted;

  PuzzlePiece({
    super.key, // Key is now nullable
    required this.image,
    required this.imageSize,
    required this.row,
    required this.col,
    required this.id,
    required this.maxRow,
    required this.maxCol,
    this.position,
    required this.bringToTop,
    required this.sendToBack,
    required this.onCompleted,
  });

  @override
  PuzzlePieceState createState() {
    return PuzzlePieceState(); // 'new' keyword is optional and can be removed
  }
}

class PuzzlePieceState extends State<PuzzlePiece> {
  bool isMovable = true;

  @override
  Widget build(BuildContext context) {
    final imageWidth = MediaQuery.of(context).size.width;
    final imageHeight = MediaQuery.of(context).size.height *
        MediaQuery.of(context).size.width /
        widget.imageSize.width;
    final pieceWidth = imageWidth / widget.maxCol;
    final pieceHeight = imageHeight / widget.maxRow;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final maxX = screenWidth - pieceWidth - pieceWidth/2;
    final maxY = screenHeight - pieceHeight - pieceHeight/2;

    // Initialize top and left if they are null (퍼즐 시작하면 조각들을 랜덤 위치에 흩뿌리기)
    if(widget.position == null){
      print("퍼즐 조각의 위치를 초기화합니다.");
      widget.position = PiecePosition(
        y: Random().nextDouble() * maxY,
        x: Random().nextDouble() * maxX,
      );
    }

    return Positioned(
      top: widget.position?.y,
      left: widget.position?.x,
      width: imageWidth,
      child: GestureDetector(
        onTap: () { // 퍼즐 tap하기
          if (isMovable) {
            widget.bringToTop(widget);
          }
        },
        onPanStart: (_) { // 퍼즐 드래그(?)
          if (isMovable) {
            widget.bringToTop(widget);
          }
        },
        onPanUpdate: (dragUpdateDetails) {
          if (isMovable) {
            setState(() {
              // 드래그 방향에 따라 top과 left 값을 업데이트합니다.
              widget.position?.y = (widget.position?.y ?? 0) + dragUpdateDetails.delta.dy;
              widget.position?.x = (widget.position?.x ?? 0) + dragUpdateDetails.delta.dx;

              // 현재 위치가 정답 위치에 충분히 가까워지면 스냅합니다.
              if ((widget.position?.y)!.abs() < 10 && (widget.position?.x)!.abs() < 10) {
                widget.position?.y = 0;
                widget.position?.x = 0;
                isMovable = false;
                widget.sendToBack(widget);
                widget.onCompleted(widget.row * widget.maxCol + widget.col, widget.position);
              }
            });
          }
        },
        child: ClipPath(
          child: CustomPaint(
              foregroundPainter: PuzzlePiecePainter(
                  widget.row, widget.col, widget.maxRow, widget.maxCol),
              child: widget.image),
          clipper: PuzzlePieceClipper(
              widget.row, widget.col, widget.maxRow, widget.maxCol),
        ),
      ),
    );
  }
}
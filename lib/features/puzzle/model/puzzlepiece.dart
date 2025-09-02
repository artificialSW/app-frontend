import 'dart:math';

import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/features/puzzle/model/puzzlepiece_maker.dart';
import 'package:artificialsw_frontend/features/puzzle/model/puzzlepiece_position.dart';
import 'package:artificialsw_frontend/features/puzzle/model/puzzle_board_scope.dart';


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
    final scope = PuzzleBoardScope.of(context);
    final double imageWidth  = scope.boardWidth;   // 보드 전체 폭
    final double imageHeight = scope.boardHeight;  // 보드 전체 높이
    final double trayTop     = scope.trayTop;      // 트레이 시작 y
    final double trayHeight  = scope.trayHeight;   // 트레이 높이

    // 조각 크기/오프셋(보드 기준 절대 좌표)
    final double pieceWidth  = imageWidth  / widget.maxCol;
    final double pieceHeight = imageHeight / widget.maxRow;
    final double offsetX     = widget.col * pieceWidth;
    final double offsetY     = widget.row * pieceHeight;

    // 수평 이동 허용 범위 (보드+트레이 공통 좌표계에서, 조각 모양이 영역을 벗어나지 않게)
    final double minX = -offsetX;
    final double maxX = imageWidth - (offsetX + pieceWidth);

    // 수직 이동 허용 범위: 위로는 보드 상단(=0)까지, 아래로는 트레이 하단까지
    final double minY = -offsetY;
    final double maxY = trayTop + trayHeight - (offsetY + pieceHeight);

    // Initialize top and left if they are null (퍼즐 시작하면 조각들을 랜덤 위치에 흩뿌리기)
    if(widget.position == null){
      final double trayMinY = trayTop - offsetY;
      final double trayMaxY = maxY;
      widget.position = PiecePosition(
        x: (minX == maxX) ? 0 : (minX + Random().nextDouble() * (maxX - minX)),
        y: (trayMinY >= trayMaxY)
            ? trayMinY
            : trayMinY + Random().nextDouble() * (trayMaxY - trayMinY),
      );
    }

    return Positioned(
      top: widget.position?.y,
      left: widget.position?.x,
      width: imageWidth,
      height: imageHeight,
      child: GestureDetector(
        onTap: () { // 퍼즐 tap하기
          if (isMovable) { widget.bringToTop(widget); }
        },
        onPanStart: (_) { // 퍼즐 드래그(?)
          if (isMovable) { widget.bringToTop(widget); }
        },
        onPanUpdate: (drag) {
          if (isMovable) {
            setState(() {
              // 드래그 방향에 따라 top과 left 값을 업데이트합니다.
              double nextX = (widget.position?.x ?? 0) + drag.delta.dx;
              double nextY = (widget.position?.y ?? 0) + drag.delta.dy;

              // 보드 상단 ~ 트레이 하단 사이로만 이동 허용 (조각 모양이 영역 밖으로 나가지 않게)
              nextX = nextX.clamp(minX, maxX);
              nextY = nextY.clamp(minY, maxY);
              widget.position!.x = nextX;
              widget.position!.y = nextY;

              // 정답 위치 스냅(조각 경로가 보드 절대좌표이므로 0,0이 정답)
              const snap = 10.0;
              if (nextX.abs() < snap && nextY.abs() < snap) {
                widget.position!
                  ..x = 0
                  ..y = 0;
                isMovable = false;
                widget.sendToBack(widget);
                widget.onCompleted(
                  widget.row * widget.maxCol + widget.col,
                  widget.position!,
                );
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
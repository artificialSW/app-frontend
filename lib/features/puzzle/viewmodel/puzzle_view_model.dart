import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:artificialsw_frontend/features/puzzle/model/puzzle_piece.dart';

class PuzzleViewModel with ChangeNotifier {
  late List<PuzzlePieceModel> puzzlePieces;
  ui.Image? fullUiImage; // 원본 이미지를 ui.Image로 저장
  bool isLoading = true;
  final Image fullImage;
  final int maxRow;
  final int maxCol;
  final Function(PuzzleViewModel) onGameComplete;

  PuzzleViewModel({
    required this.fullImage,
    required this.maxRow,
    required this.maxCol,
    required this.onGameComplete,
  });

  Future<void> initializePuzzle(BoxConstraints constraints) async {
    isLoading = true;
    notifyListeners();

    fullUiImage = await _loadImage(fullImage);
    final imageSize = Size(fullUiImage!.width.toDouble(), fullUiImage!.height.toDouble());

    // 퍼즐 보드의 최종 크기를 계산합니다.
    final puzzleWidth = constraints.maxWidth;
    final puzzleHeight = puzzleWidth * (imageSize.height / imageSize.width);

    // 조각 하나의 크기를 퍼즐 보드 전체 크기에 맞춰 계산
    final pieceWidth = puzzleWidth / maxCol;
    final pieceHeight = puzzleHeight / maxRow;

    puzzlePieces = [];

    // 퍼즐이 흩어지는 범위도 최종 퍼즐 크기를 기준으로 계산
    final double randomSpreadFactor = 0.5;
    final double randomSpreadWidth = puzzleWidth * randomSpreadFactor;
    final double randomSpreadHeight = puzzleHeight * randomSpreadFactor;

    final double startX = (puzzleWidth - randomSpreadWidth) / 2;
    final double startY = (puzzleHeight - randomSpreadHeight) / 2;

    for (int i = 0; i < maxRow; i++) {
      for (int j = 0; j < maxCol; j++) {
        final id = i * maxCol + j;
        final correctPosition = Offset(j * pieceWidth, i * pieceHeight);
        final randomPosition =
        Offset(
          startX + Random().nextDouble() * randomSpreadWidth,
          startY + Random().nextDouble() * randomSpreadHeight,
        );
        puzzlePieces.add(PuzzlePieceModel(
          id: id,
          imageSize: imageSize,
          row: i,
          col: j,
          maxRow: maxRow,
          maxCol: maxCol,
          pieceWidth: pieceWidth,
          pieceHeight: pieceHeight,
          currentPosition: randomPosition,
          correctPosition: correctPosition,
        ));
      }
    }

    isLoading = false;
    notifyListeners();
  }

  Future<ui.Image> _loadImage(Image image) {
    final completer = Completer<ui.Image>();
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
            (ImageInfo info, bool _) {
          completer.complete(info.image);
        },
        onError: (Object error, StackTrace? stackTrace) {
          completer.completeError(error, stackTrace);
        },
      ),
    );
    return completer.future;
  }

  void onPiecePanUpdate(PuzzlePieceModel piece, DragUpdateDetails dragDetails) {
    if (!piece.isPlaced) {
      piece.currentPosition += dragDetails.delta;

      final snapDistance = 20.0;
      if ((piece.currentPosition.dx - piece.correctPosition.dx).abs() < snapDistance &&
          (piece.currentPosition.dy - piece.correctPosition.dy).abs() < snapDistance) {

        piece.currentPosition = piece.correctPosition;
        piece.isPlaced = true;

        // checkGameCompletion()만 호출합니다.
        checkGameCompletion();
      }
      notifyListeners();
    }
  }

  void checkGameCompletion() {
    bool allPiecesPlaced = puzzlePieces.every((piece) => piece.isPlaced);
    if (allPiecesPlaced) {
      onGameComplete(this);
    }
  }
}
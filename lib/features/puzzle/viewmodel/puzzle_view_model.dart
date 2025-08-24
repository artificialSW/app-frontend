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
  }) {
    _initializePuzzlePieces();
  }

  Future<void> _initializePuzzlePieces() async {
    isLoading = true;
    notifyListeners();

    // 원본 이미지를 ui.Image로 로드
    fullUiImage = await _loadImage(fullImage);
    final imageSize = Size(fullUiImage!.width.toDouble(), fullUiImage!.height.toDouble());


    final screenWidth = MediaQueryData.fromView(ui.window).size.width;
    final pieceWidth = screenWidth / maxCol;
    final pieceHeight = pieceWidth * (imageSize.height / imageSize.width);
    puzzlePieces = [];

    // 퍼즐 조각이 흩어질 범위를 지정합니다. 0.5는 화면 너비의 50%를 의미합니다.
    final double randomSpreadFactor = 0.5;
    final double randomSpreadWidth = screenWidth * randomSpreadFactor;
    final double randomSpreadHeight = pieceHeight * randomSpreadFactor;

    // 무작위 위치의 기준점을 화면 중앙으로 설정합니다.
    final double startX = (screenWidth - randomSpreadWidth) / 2;
    final double startY = (pieceHeight - randomSpreadHeight) / 2;

    for (int i = 0; i < maxRow; i++) {
      for (int j = 0; j < maxCol; j++) {
        final id = i * maxCol + j;
        final correctPosition = Offset(j * pieceWidth, i * pieceHeight);
        final randomPosition = Offset(
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

        // **이전의 문제성 로직을 제거했습니다.**
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
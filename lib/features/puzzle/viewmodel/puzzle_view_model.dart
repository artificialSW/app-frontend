import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:artificialsw_frontend/features/puzzle/model/puzzle_piece.dart';

class PuzzleViewModel with ChangeNotifier { // 클래스기 때문에 한 퍼즐 게임당 뷰모델이 하나씩 배정됨
  late List<PuzzlePieceModel> puzzlePieces;
  ui.Image? fullUiImage; // 원본 이미지를 ui.Image로 저장??
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

  Future<void> initializePuzzle(double screenWidth) async {
    isLoading = true;
    notifyListeners();

    fullUiImage = await _loadImage(fullImage);
    final imageSize = Size(fullUiImage!.width.toDouble(), fullUiImage!.height.toDouble());

    final double puzzleWidth = imageSize.width;
    final double puzzleHeight = imageSize.height;

    final pieceWidth = puzzleWidth / maxCol;
    final pieceHeight = puzzleHeight / maxRow;

    puzzlePieces = [];

    final double randomSpreadFactor = 0.5;
    final double randomSpreadWidth = puzzleWidth * randomSpreadFactor;
    final double randomSpreadHeight = puzzleHeight * randomSpreadFactor;

    final double startX = (puzzleWidth - randomSpreadWidth) / 2; //랜덤 x시작점
    final double startY = (puzzleHeight - randomSpreadHeight) / 2; //랜덤 y시작점
    print("imageSize is $imageSize");
    print("puzzleWidth is $puzzleWidth");
    print("puzzleHeight is $puzzleHeight");
    print("pieceWidth is $pieceWidth");
    print("maxRow is $maxRow");
    print("maxCol is $maxCol");

    for (int i = 0; i < maxRow; i++) {
      for (int j = 0; j < maxCol; j++) {
        final id = i * maxCol + j;
        final correctPosition = Offset(j * pieceWidth, i * pieceHeight);
        print("$j * $pieceWidth is ${j * pieceWidth}");
        final randomPosition = correctPosition;
        //Offset(
          //startX + Random().nextDouble() * randomSpreadWidth,
          //startY + Random().nextDouble() * randomSpreadHeight,
        //);
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
    //이 함수를 puzzle_piece_view 안의 gesturedetector에 담아서 사용
    if (!piece.isPlaced) {
      piece.currentPosition += dragDetails.delta;

      final snapDistance = 20.0;
      if ((piece.currentPosition.dx - piece.correctPosition.dx).abs() < snapDistance &&
          (piece.currentPosition.dy - piece.correctPosition.dy).abs() < snapDistance) {

        piece.currentPosition = piece.correctPosition;
        piece.isPlaced = true;

        // checkGameCompletion()만 호출
        checkGameCompletion();
      }
      notifyListeners();
    }
  }

  void checkGameCompletion() { //이것도 크게 보면 puzzle_piece_view 안의 gesturedetector에 있으므로 -> 터치 시마다 호출됨
    bool allPiecesPlaced = puzzlePieces.every((piece) => piece.isPlaced);
    if (allPiecesPlaced) {
      onGameComplete(this);
    }
  }
}
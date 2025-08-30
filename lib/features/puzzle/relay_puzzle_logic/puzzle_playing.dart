import 'dart:async';

import 'package:artificialsw_frontend/features/puzzle/model/puzzlepiece_position.dart';
import 'package:artificialsw_frontend/services/image_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // rootBundle을 사용하기 위한 import
import 'package:artificialsw_frontend/features/puzzle/model/puzzlepiece.dart';
import 'package:artificialsw_frontend/features/puzzle/model/puzzlegame.dart';
import 'package:provider/provider.dart';
import 'package:artificialsw_frontend/features/puzzle/puzzlelist_provider.dart';

class PlayPuzzle extends StatefulWidget {
  final PuzzleGame puzzle;

  const PlayPuzzle({
    Key? key,
    required this.puzzle,
  }) : super(key: key);

  @override
  _PlayPuzzleState createState() => _PlayPuzzleState();
}

class _PlayPuzzleState extends State<PlayPuzzle> {

  int get rows { //개발 단계 디버깅용 로직
    final size = widget.puzzle.size;
    if (size == null) {
      throw Exception("Puzzle size cannot be null");
    }
    return size;
  }
  int get cols { //실제 앱일때 기본값을 주는 로직(배포 시 이걸로 rows도 수정하기)
    if (widget.puzzle.size == null) {
      debugPrint("Puzzle size is null, fallback to 2");
      return 2;
    }
    return widget.puzzle.size!;
  }

  Image? _image; // Image 위젯 자체를 저장
  List<PuzzlePiece> pieces = [];
  List<int> completedPiecesId = [];

  @override
  void initState() {
    super.initState();
    final imageWidget = widget.puzzle.imageWidget;
    _loadImage(imageWidget);
  }

  // 에셋 이미지를 로드하고 퍼즐 조각을 생성하는 함수
  void _loadImage(Image image) {
    setState(() {
      _image = image; //PlayPuzzle 인스턴스에 저장
    });

    _splitImage(image); // 퍼즐 조각 생성 함수
  }

  Future<Size> _getImageSize(Image image) async {
    final Completer<Size> completer = Completer<Size>();
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
            (ImageInfo info, bool _) {
          completer.complete(Size(
            info.image.width.toDouble(),
            info.image.height.toDouble(),
          ));
        },
      ),
    );
    final Size imageSize = await completer.future;
    return imageSize;
  }

  void _splitImage(Image image) async {
    Size imageSize = await _getImageSize(image);

    for (int x = 0; x < rows; x++) {
      for (int y = 0; y < cols; y++) {
        setState(() {
          pieces.add(PuzzlePiece(
            key: GlobalKey(),
            image: image,
            imageSize: imageSize,
            row: x,
            col: y,
            id: x * cols + y, // 지금 당장은 팔요 없는 것 같긴 함
            maxRow: rows,
            maxCol: cols,
            position: widget.puzzle.piecesPosition[x * cols + y],
            bringToTop: _bringToTop,
            sendToBack: _sendToBack,
            onCompleted: (id, position) {
              _onCompleted(id, position);
            },
          ));
        });
      }
    }
  }

  void _bringToTop(PuzzlePiece piece) {
    setState(() {
      pieces.remove(piece);
      pieces.add(piece); //list에 add했으므로 맨 끝으로 감
    });
  }

  void _sendToBack(PuzzlePiece piece) {
    setState(() {
      pieces.remove(piece);
      pieces.insert(0, piece); //맨 앞으로 감
    });
  }

  void _onCompleted(int id, PiecePosition pos) { //퍼즐 piece 하나가 맞춰졌을 떄
    setState(() {
      if(!completedPiecesId.contains(id)){
        completedPiecesId.add(id);
      }
      print("num of completedPieces: ${completedPiecesId.length}");
      if (completedPiecesId.length == rows * cols) { //모든 Piece가 다 맞춰졌을 때
        widget.puzzle.gameState = GameState.Completed;
        Provider.of<PuzzleProvider>(
          context,
          listen: false,
        ).completePuzzle(widget.puzzle);
        _navigateToNextPage();
      }
    });
  }

  void _navigateToNextPage() async {
    print("퍼즐 완성! 다음 페이지로 이동합니다.");

    // 1초 기다리기
    await Future.delayed(const Duration(seconds: 1));

    // '/puzzle/in-progress' 대신 이동할 페이지의 라우트 이름을 사용
    Navigator.of(context).pushReplacementNamed('/puzzle/completed-list');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('퍼즐 플레이', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: _image == null
              ? const Text('이미지를 로드하는 중입니다...')
              : Stack(children: pieces),
        ),
      ),
      // 이미지가 고정되었으므로 FloatingActionButton은 제거
    );
  }
}
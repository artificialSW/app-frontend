import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // rootBundle을 사용하기 위한 import
import 'package:artificialsw_frontend/features/puzzle/model/puzzlepiece.dart';
import 'package:artificialsw_frontend/features/puzzle/model/puzzlegame.dart';
import 'package:artificialsw_frontend/features/puzzle/puzzle_completedlist.dart';
import 'package:provider/provider.dart';
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
  int get rows => widget.puzzle.size;
  int get cols => widget.puzzle.size;
  Image? _image; // Image 위젯 자체를 저장하도록 변경
  List<Widget> pieces = [];
  List<int> completedPiecesId = [];

  @override
  void initState() {
    super.initState();
    final imagePath = widget.puzzle.imagePath;
    _loadAssetImage(imagePath);
  }

  // 에셋 이미지를 로드하고 퍼즐 조각을 생성하는 함수
  Future<void> _loadAssetImage(String imagePath) async {
    String assetPath = imagePath;
    // 에셋 파일이 실제로 존재하는지 확인 (선택 사항)
    try {
      await rootBundle.load(assetPath);
    } catch (e) {
      // 에셋 파일이 없으면 오류 메시지를 출력하고 함수를 종료합니다.
      print('Error: Asset image not found at $assetPath');
      return;
    }

    final imageWidget = Image.asset(assetPath);
    setState(() {
      _image = imageWidget;
    });

    _splitImage(imageWidget);
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
            onCompleted: (id) {
              _onCompleted(id);
            },
          ));
        });
      }
    }
  }

  void _bringToTop(Widget widget) {
    setState(() {
      pieces.remove(widget);
      pieces.add(widget); //list에 add했으므로 맨 끝으로 감
    });
  }

  void _sendToBack(Widget widget) {
    setState(() {
      pieces.remove(widget);
      pieces.insert(0, widget); //맨 앞으로 감
    });
  }

  void _onCompleted(int id) { //퍼즐 piece 하나가 맞춰졌을 떄
    setState(() {
      if(!completedPiecesId.contains(id)){
        completedPiecesId.add(id);
      }
      if (completedPiecesId.length == rows * cols) { //모든 Piece가 다 맞춰졌을 때
        widget.puzzle.isCompleted = true;
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
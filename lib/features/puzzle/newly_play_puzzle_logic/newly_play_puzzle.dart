import 'dart:async';
import 'package:artificialsw_frontend/features/puzzle/model/puzzlepiece_position.dart';
import 'package:artificialsw_frontend/services/image_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // rootBundle을 사용하기 위한 import
import 'package:artificialsw_frontend/features/puzzle/model/puzzlepiece.dart';
import 'package:artificialsw_frontend/features/puzzle/model/puzzlegame.dart';
import 'package:provider/provider.dart';
import 'package:artificialsw_frontend/features/puzzle/puzzlelist_provider.dart';
class NewlyPlayPuzzle extends StatefulWidget {
  final PuzzleGame puzzle;

  const NewlyPlayPuzzle({
    Key? key,
    required this.puzzle,
  }) : super(key: key);

  @override
  _NewlyPlayPuzzleState createState() => _NewlyPlayPuzzleState();
}

class _NewlyPlayPuzzleState extends State<NewlyPlayPuzzle> {
  int get rows => widget.puzzle.size!;
  int get cols => widget.puzzle.size!;
  Image? _image;
  List<PuzzlePiece> pieces = [];
  List<int> get completedPiecesId => widget.puzzle.completedPiecesId; ///게임 플레이 인스턴스에서도 다시 불러와야 쭉 하던게 이어짐.

  @override
  void initState() {
    super.initState();
    final imageWidget = widget.puzzle.imageWidget;
    // 처리용 함수 호출 (예: 퍼즐 생성 등)
    _loadImage(imageWidget);
  }

  // 에셋 이미지를 로드하고 퍼즐 조각을 생성하는 함수
  void _loadImage(Image image) {
    setState(() {
      _image = image; // 또는 퍼즐 생성용 변수에 저장
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
        //if (!mounted) return; // ✅ 추가
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
            position: widget.puzzle.gameState == GameState.Unplayed
                ? null
                : widget.puzzle.piecesPosition[x * cols + y],
            bringToTop: _bringToTop,
            sendToBack: _sendToBack,
            onCompleted: (id, position) {
              _onCompleted(id, position);
            },
          ));
        });
        await Future.delayed(const Duration(milliseconds: 200));
        if(pieces[x * cols + y].position == null) print("${x * cols + y}번째 조각의 위치를 불러오지 못해 초기화합니다.");
        widget.puzzle.piecesPosition[x * cols + y] = pieces[x * cols + y].position;
      }
    }
    if(widget.puzzle.gameState == GameState.Unplayed){
      widget.puzzle.gameState = GameState.Ongoing;

      Provider.of<PuzzleProvider>( //TODO: 나중에 에러 안뜨는 선에서 위치 변경하기
        context,
        listen: false, ///이건 Provider 내부 리스트를 변화시키므로 재빌드 true...라고할랬는데 에러떠서 false
      ).startPuzzle(widget.puzzle);
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
        widget.puzzle.completedPiecesId.add(id); //맞춰진 조각 목록에 추가
        print("num of completedPieces: ${completedPiecesId.length}");
      }
      //widget.puzzle.piecesPosition[id] = pos; //게임 범위에서 조각의 위치를 업데이트(이건 이렇게 코드로 써 줘야 함)
      for (final piece in pieces) {
        widget.puzzle.piecesPosition[piece.id] = piece.position;
      }

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
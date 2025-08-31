import 'dart:async';
import 'dart:math';
import 'package:artificialsw_frontend/features/puzzle/model/puzzle_board_scope.dart';
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
        if(pieces[x * cols + y].position == null) print("${x * cols + y}번째 조각의 위치가 null 입니다.");
        widget.puzzle.piecesPosition.add(pieces[x * cols + y].position ?? PiecePosition(x: 0, y: 0)); ///bulid time에 랜덤 값을 어떻게든 부여받기에
        ///null이 아닐 확률이 높지만 비동기 함수임을 감안해서 안전하게 로직을 짜기
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
        widget.puzzle.piecesPosition[piece.id] = piece.position!; //위치로 판별해서 oncompleted가 실행되는데 null일수 없음
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
    final media = MediaQuery.of(context);
    final innerHeight = media.size.height - media.padding.vertical; // SafeArea 내부 높이
    final screenWidth = media.size.width;

    // 보드 폭: 화면 2/3
    final boardWidth = screenWidth * (2 / 3);

    // 보드 높이: 이미지 비율 유지 (이미지 정보를 아직 못 얻었으면 정사각으로 대체)
    // _image는 setState로 이미 들어왔고, _getImageSize로 계산한 imageSize를 pieces 생성 시에 알고 있음
    // 가장 안전하게는 pieces.first.imageSize를 참조(없으면 대체)
    Size? imgSize;
    if (pieces.isNotEmpty) {
      imgSize = pieces.first.imageSize;
    }
    final double boardHeight = (imgSize != null && imgSize.width > 0)
        ? boardWidth * (imgSize.height / imgSize.width)
        : boardWidth; // fallback: 정사각

    const double gap = 12.0; // 보드-트레이 간 간격(시각적 구분용)
    final double trayHeight = (innerHeight - kToolbarHeight - gap - 24.0 - boardHeight)
        .clamp(140.0, innerHeight * 0.5); // 최소 140 보장

    final double trayTop = boardHeight + gap;
    final double gameAreaHeight = trayTop + trayHeight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('주제 이름', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: _image == null
              ? const Text('이미지를 로드하는 중입니다...')
              : PuzzleBoardScope(
            boardWidth: boardWidth,
            boardHeight: boardHeight,
            trayTop: trayTop,
            trayHeight: trayHeight,
            child: SizedBox(
              width: boardWidth,
              height: gameAreaHeight,
              child: Stack(
                clipBehavior: Clip.none, // 조각이 보드 영역을 넘어 트레이까지 보이게
                children: [
                  // 보드(상단)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      width: boardWidth,
                      height: boardHeight,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black12),
                      ),
                    ),
                  ),

                  // 트레이(하단)
                  Positioned(
                    top: trayTop,
                    left: 0,
                    child: Container(
                      width: boardWidth,
                      height: trayHeight,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black12),
                      ),
                    ),
                  ),

                  // 퍼즐 조각들 (보드/트레이를 오가며 드래그)
                  ...pieces,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
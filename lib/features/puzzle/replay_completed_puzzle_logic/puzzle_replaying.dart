import 'package:artificialsw_frontend/features/puzzle/model/puzzlegame.dart';
import 'package:artificialsw_frontend/features/puzzle/model/puzzlepiece.dart';
import 'package:artificialsw_frontend/features/puzzle/model/puzzlepiece_position.dart';
import 'package:artificialsw_frontend/services/image_store.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // rootBundle을 사용하기 위한 import

///로직:
///1. 완료 목록에 있는 퍼즐 인스턴스를 바로가 아닌 복사해서 이 페이지로 들고 온다.
///2. 퍼즐 인스턴스 자체는 책임 분리를 해놓았기 때문에 백엔드 연동 로직에 관여를 안 하는데, playing함수 자체는 콜백 함수도 있고
///어쨌든 수정해야 하므로 puzzlepiece.dart는 import로 가져오고 replaying 클래스는 여기서 만들어야겠다.
///3. 어쨌든 DB에 있는 puzzlegame 인스턴스를 가져와서 복사해서 쓰는 것이므로 뭘 가져와야 할까 생각해보니
///{size, image(puzzlepiece인스턴스 생성시 필요)}
///4. 퍼즐 위치 랜덤으로 흝뿌리는건 Puzzlepiece 인스턴스 생성시 위치값을 안 주기만 하면 자동으로 해줌
///5. 결론은 PlayPuzzle 갖고와서 oncompleted 함수만 좀 수정함(몇 가지 코드 삭제)

class ReplayPuzzle extends StatefulWidget {
  final PuzzleGame puzzle;

  const ReplayPuzzle({
    Key? key,
    required this.puzzle,
  }) : super(key: key);

  @override
  _ReplayPuzzleState createState() => _ReplayPuzzleState();
}

class _ReplayPuzzleState extends State<ReplayPuzzle> {
  int get rows => widget.puzzle.size!;
  int get cols => widget.puzzle.size!;
  Image? _image; // Image 위젯 자체를 저장
  List<Widget> pieces = [];
  List<int> completedPiecesId = [];

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
            position: null, //얘는 위치가 있음에도 불구하고 다시 풀기 위해 null로 짱박아둠.
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

  void _onCompleted(int id, PiecePosition pos) { //퍼즐 piece 하나가 맞춰졌을 떄
    setState(() {
      if(!completedPiecesId.contains(id)){
        completedPiecesId.add(id);
      }
      if (completedPiecesId.length == rows * cols) { //모든 Piece가 다 맞춰졌을 때
        _navigateToNextPage(); //별다른 로직 없이 이동만
      }
    });
  }

  void _navigateToNextPage() async {
    print("퍼즐 완성! 다음 페이지로 이동합니다.");

    // 1초 기다리기
    await Future.delayed(const Duration(seconds: 1));

    // '/puzzle/in-progress' 대신 이동할 페이지의 라우트 이름을 사용
    Navigator.of(context).pushReplacementNamed('/puzzle/re-completed');
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
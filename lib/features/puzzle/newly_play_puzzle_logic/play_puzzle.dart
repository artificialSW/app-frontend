import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;
import 'package:artificialsw_frontend/features/puzzle/model/puzzle_board_scope.dart';
import 'package:artificialsw_frontend/features/puzzle/model/puzzlepiece_position.dart';
import 'package:artificialsw_frontend/services/old_image_store.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/puzzle_complete/puzzle_complete_request_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/puzzle_save_progress/puzzlepiece_position.dart';
import 'package:artificialsw_frontend/services/puzzle/puzzle_service.dart';
import 'package:artificialsw_frontend/shared/models/usermodel.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // rootBundle을 사용하기 위한 import
import 'package:artificialsw_frontend/features/puzzle/model/puzzlepiece.dart';
import 'package:artificialsw_frontend/features/puzzle/model/puzzlegame.dart';
import 'package:provider/provider.dart';
import 'package:artificialsw_frontend/features/puzzle/puzzlelist_provider.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/rendering.dart'; // RenderRepaintBoundary 정의되어 있음
import 'package:path_provider/path_provider.dart';
import 'dart:io'; // File, Directory 클래스 등 포함



class PlayPuzzle extends StatefulWidget {
  final PuzzleGame puzzle; //여기 선언된 것들은, 이 페이지를 불러올때 인자값을 줘야 하는 것
  final User user;

  const PlayPuzzle({
    Key? key,
    required this.puzzle,
    required this.user,
  }) : super(key: key);

  @override
  _PlayPuzzleState createState() => _PlayPuzzleState();
}

class _PlayPuzzleState extends State<PlayPuzzle> {
  int get rows => sqrt(widget.puzzle.size).toInt(); //여기 선언된 것들은, 그냥 이 페이지 내부에서만 쓰이는 것
  int get cols => sqrt(widget.puzzle.size).toInt();
  Image? _image;
  List<PuzzlePiece> pieces = [];
  List<int> get completedPiecesId => widget.puzzle.completedPiecesId; ///게임 플레이 인스턴스에서도 다시 불러와야 쭉 하던게 이어짐.
  final GlobalKey _captureKey = GlobalKey(); // 캡쳐 대상 위젯을 식별하기 위한 키

  @override
  void initState() {
    super.initState();
    final imageWidget = Image.network(widget.puzzle.imageUrl);

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
            id: (x * cols + y).toString(), // 지금 당장은 팔요 없는 것 같긴 함
            maxRow: rows,
            maxCol: cols,
            position: widget.puzzle.gameState != GameState.Ongoing
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
        widget.puzzle.piecesPosition.add(
            pieces[x * cols + y].position ?? PiecePosition(x: 0, y: 0)
        ); ///bulid time에 랜덤 값을 어떻게든 부여받기에 null이 아닐 확률이 높지만 비동기 함수임을 감안해서 안전하게 로직을 짜기
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
        completedPiecesId.add(id); //맞춰진 조각 목록에 추가
        print("num of completedPieces: ${completedPiecesId.length}");
      }
      //widget.puzzle.piecesPosition[id] = pos; //게임 범위에서 조각의 위치를 업데이트(이건 이렇게 코드로 써 줘야 함)
      for (final piece in pieces) {
        widget.puzzle.piecesPosition[int.parse(piece.id)] = piece.position!; //위치로 판별해서 oncompleted가 실행되는데 null일수 없음
      }

      if (completedPiecesId.length == rows * cols) { //모든 Piece가 다 맞춰졌을 때
        print("now state is ${widget.puzzle.gameState}");
        if (widget.puzzle.gameState != GameState.Completed){
          widget.puzzle.gameState = GameState.Completed;

          Provider.of<PuzzleProvider>(
            context,
            listen: false,
          ).completePuzzle(widget.puzzle);

          _navigateToAwardPage();
        }
        else {
          _navigateToNonAwardPage();
        }
      }
    });
  }

  void _captureAndSaveProgress(double boardHeight) async {

    late final base64String;

    try {
      RenderRepaintBoundary boundary =
      _captureKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      // 원본 이미지 전체
      ui.Image fullImage = await boundary.toImage(pixelRatio: 3.0);

      // 캡쳐 영역만큼 잘라내기 (좌상단 기준)
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      // 자를 영역 크기 설정
      final width = fullImage.width.toDouble();
      final height = boardHeight * 3.0; // pixelRatio가 3.0이었으므로 스케일 반영

      // 이미지 그리기 (0, 0) 위치에 그리되 자를 높이만큼만
      final paint = Paint();
      canvas.drawImageRect(
        fullImage,
        Rect.fromLTWH(0, 0, width, height), // 원본에서 자를 부분
        Rect.fromLTWH(0, 0, width, height), // 새 이미지 캔버스 크기
        paint,
      );

      // 잘라낸 이미지 생성
      final croppedImage = await recorder
          .endRecording()
          .toImage(width.toInt(), height.toInt());

      final byteData = await croppedImage.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      // base64 저장
      base64String = base64Encode(pngBytes);
      // 테스트 로직 final directory = await getTemporaryDirectory();
      // final filePath = '${directory.path}/captured_image_base64.txt';
      // final file = File(filePath);
      //
      // await file.writeAsString(base64String);
      // print("캡쳐 완료: $filePath");
    } catch (e) {
      print("캡쳐 실패: $e");
    }



    ///save logic
    completedPiecesId.sort();

    final map = SplayTreeMap<String, PuzzlePiecePosition>((a, b) {  //자동 정렬을 위해 SplayTreeMap 사용
      final ai = int.tryParse(a);
      final bi = int.tryParse(b);
      if (ai != null && bi != null) return ai.compareTo(bi);
      if (ai != null) return -1;  // 숫자인 쪽을 먼저
      if (bi != null) return 1;
      return a.compareTo(b);      // 둘 다 숫자 아니면 문자열 비교
    });

    for (var i = 0; i < widget.puzzle.size && i < pieces.length; i++) {
      map[pieces[i].id] = PuzzlePiecePosition(
          x: pieces[i].position!.x,
          y: pieces[i].position!.y
      );
    }

    await PuzzleService().savePuzzleProgress(
        puzzleId: int.parse(widget.puzzle.puzzleId),
        imageFile: base64String,
        //puzzleSize: widget.puzzle.size,
        pieces: map,
        completedPiecesId: completedPiecesId,
        completed: false,
        isPlayingPuzzle: false,
    );
    // final piecesStr = map.entries
    //     .map((e) => '${e.key}: (row=${e.value.row}, col=${e.value.col})')
    //     .join(', ');
    //
    // debugPrint('서버에 풀던 퍼즐 데이터 전송 완료: \n'
    //     ' ├─ puzzleId: ${widget.puzzle.puzzleId}\n'
    //     ' ├─ imageFile: ${base64String}\n'
    //     ' ├─ pieces: {$piecesStr}\n'
    //     ' ├─ completedPiecesId: $completedPiecesId\n'
    //     ' └─ contributorId: ${widget.user.id}');
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/');
  }

  void _navigateToAwardPage() async {
    print("퍼즐 완성! 다음 페이지로 이동합니다.");

    final puzzleDto = await PuzzleService().completePuzzle(
      PuzzleCompleteRequestDto(month: DateTime.now().month),
      widget.puzzle.puzzleId,
    );
    final message = puzzleDto.message;
    final fruitName = puzzleDto.fruitName;
    final fruitMessage = puzzleDto.fruitMessage;
    final contributors = puzzleDto.contributors;

    // 1초 기다리기
    await Future.delayed(const Duration(seconds: 1));

    Navigator.of(context).pushReplacementNamed(
        '/puzzle/completed',
        arguments: {
          'message': message,
          'fruitName': fruitName,
          'fruitMessage': fruitMessage,
          'contributors': contributors,
        }
    );
  }

  void _navigateToNonAwardPage() async {
    print("퍼즐 완성! 다음 페이지로 이동합니다.");

    // 1초 기다리기
    await Future.delayed(const Duration(seconds: 1));
    Navigator.of(context).pushReplacementNamed('/puzzle/re-completed');
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final innerHeight = media.size.height - media.padding.vertical; // SafeArea 내부 높이
    final screenWidth = media.size.width;

    // 보드 폭: 화면 2/3
    final boardWidth = screenWidth * (2 / 3);
    final trayWidth = boardWidth;

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
    final double trayHeight = (innerHeight - kToolbarHeight - gap - 24.0 - boardHeight - 116)
        .clamp(80.0, innerHeight * 0.5); // 최소 80 보장

    final double trayTop = boardHeight + gap;
    final double gameAreaHeight = trayTop + trayHeight;

    return Scaffold(
      appBar: CanGoBackTopBar('퍼즐ID: ${widget.puzzle.puzzleId.toString()}', context),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Scrollbar(
          thumbVisibility: true, // 항상 보이게 (필요없으면 false)
          interactive: true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 16),
            child: Center(
              child: _image == null
                  ? const Text('이미지를 로드하는 중입니다...')
                  :
              PuzzleBoardScope(
                boardWidth: boardWidth,
                boardHeight: boardHeight,
                trayTop: trayTop,
                trayHeight: trayHeight,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: boardWidth,
                      height: gameAreaHeight,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          /// ❌ 캡처 대상 아님
                          // 트레이
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
                          /// ✅ 캡쳐할 영역만 감싸기
                          RepaintBoundary(
                            key: _captureKey, // 전역 키
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                // 보드
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
                                // 퍼즐 조각들
                                ...pieces,
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: boardWidth,
                      child: CustomButton(
                        text: '저장하기',
                        onPressed: () {
                          _captureAndSaveProgress(boardHeight);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

  }

}
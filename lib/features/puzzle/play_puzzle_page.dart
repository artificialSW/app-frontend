import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // rootBundle을 사용하기 위한 import

class PlayPuzzle extends StatefulWidget {
  const PlayPuzzle({Key? key}) : super(key: key);

  @override
  _PlayPuzzleState createState() => _PlayPuzzleState();
}

class _PlayPuzzleState extends State<PlayPuzzle> {
  final int rows = 3;
  final int cols = 3;
  Image? _image; // Image 위젯 자체를 저장하도록 변경
  List<Widget> pieces = [];

  @override
  void initState() {
    super.initState();
    _loadAssetImage();
  }

  // 에셋 이미지를 로드하고 퍼즐 조각을 생성하는 함수
  Future<void> _loadAssetImage() async {
    const String assetPath = 'assets/images/mert34.jpeg';

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
          pieces.add(_PuzzlePiece(
            key: GlobalKey(),
            image: image,
            imageSize: imageSize,
            row: x,
            col: y,
            maxRow: rows,
            maxCol: cols,
            bringToTop: _bringToTop,
            sendToBack: _sendToBack,
          ));
        });
      }
    }
  }

  void _bringToTop(Widget widget) {
    setState(() {
      pieces.remove(widget);
      pieces.add(widget);
    });
  }

  void _sendToBack(Widget widget) {
    setState(() {
      pieces.remove(widget);
      pieces.insert(0, widget);
    });
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

// ------------------- 퍼즐 조각 관련 클래스들 (이전과 동일) -------------------

class _PuzzlePiece extends StatefulWidget {
  final Image image;
  final Size imageSize;
  final int row;
  final int col;
  final int maxRow;
  final int maxCol;
  final Function bringToTop;
  final Function sendToBack;

  const _PuzzlePiece({
    Key? key,
    required this.image,
    required this.imageSize,
    required this.row,
    required this.col,
    required this.maxRow,
    required this.maxCol,
    required this.bringToTop,
    required this.sendToBack,
  }) : super(key: key);

  @override
  _PuzzlePieceState createState() => _PuzzlePieceState();
}

class _PuzzlePieceState extends State<_PuzzlePiece> {
  double? top;
  double? left;
  bool isMovable = true;

  @override
  Widget build(BuildContext context) {
    final imageWidth = MediaQuery.of(context).size.width;
    final imageHeight = MediaQuery.of(context).size.height *
        MediaQuery.of(context).size.width /
        widget.imageSize.width;
    final pieceWidth = imageWidth / widget.maxCol;
    final pieceHeight = imageHeight / widget.maxRow;

    if (top == null) {
      top = Random().nextInt((imageHeight - pieceHeight).ceil()).toDouble();
      top = top! - widget.row * pieceHeight;
    }
    if (left == null) {
      left = Random().nextInt((imageWidth - pieceWidth).ceil()).toDouble();
      left = left! - widget.col * pieceWidth;
    }

    return Positioned(
      top: top,
      left: left,
      width: imageWidth,
      child: GestureDetector(
        onTap: () {
          if (isMovable) {
            widget.bringToTop(widget);
          }
        },
        onPanStart: (_) {
          if (isMovable) {
            widget.bringToTop(widget);
          }
        },
        onPanUpdate: (dragUpdateDetails) {
          if (isMovable) {
            setState(() {
              top = (top ?? 0) + dragUpdateDetails.delta.dy;
              left = (left ?? 0) + dragUpdateDetails.delta.dx;

              final targetTop = widget.row * pieceHeight;
              final targetLeft = widget.col * pieceWidth;

              if ((top! - targetTop).abs() < 10 && (left! - targetLeft).abs() < 10) {
                top = targetTop;
                left = targetLeft;
                isMovable = false;
                widget.sendToBack(widget);
              }
            });
          }
        },
        child: ClipPath(
          child: CustomPaint(
              foregroundPainter: _PuzzlePiecePainter(
                  widget.row, widget.col, widget.maxRow, widget.maxCol),
              child: widget.image),
          clipper: _PuzzlePieceClipper(
              widget.row, widget.col, widget.maxRow, widget.maxCol),
        ),
      ),
    );
  }
}

class _PuzzlePieceClipper extends CustomClipper<Path> {
  final int row;
  final int col;
  final int maxRow;
  final int maxCol;

  _PuzzlePieceClipper(this.row, this.col, this.maxRow, this.maxCol);

  @override
  Path getClip(Size size) {
    return _getPiecePath(size, row, col, maxRow, maxCol);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _PuzzlePiecePainter extends CustomPainter {
  final int row;
  final int col;
  final int maxRow;
  final int maxCol;

  _PuzzlePiecePainter(this.row, this.col, this.maxRow, this.maxCol);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0x80FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawPath(_getPiecePath(size, row, col, maxRow, maxCol), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

Path _getPiecePath(Size size, int row, int col, int maxRow, int maxCol) {
  final width = size.width / maxCol;
  final height = size.height / maxRow;
  final offsetX = col * width;
  final offsetY = row * height;
  final bumpSize = height / 4;

  var path = Path();
  path.moveTo(offsetX, offsetY);

  if (row == 0) {
    path.lineTo(offsetX + width, offsetY);
  } else {
    path.lineTo(offsetX + width / 3, offsetY);
    path.cubicTo(
        offsetX + width / 6,
        offsetY - bumpSize,
        offsetX + width / 6 * 5,
        offsetY - bumpSize,
        offsetX + width / 3 * 2,
        offsetY);
    path.lineTo(offsetX + width, offsetY);
  }

  if (col == maxCol - 1) {
    path.lineTo(offsetX + width, offsetY + height);
  } else {
    path.lineTo(offsetX + width, offsetY + height / 3);
    path.cubicTo(
        offsetX + width - bumpSize,
        offsetY + height / 6,
        offsetX + width - bumpSize,
        offsetY + height / 6 * 5,
        offsetX + width,
        offsetY + height / 3 * 2);
    path.lineTo(offsetX + width, offsetY + height);
  }

  if (row == maxRow - 1) {
    path.lineTo(offsetX, offsetY + height);
  } else {
    path.lineTo(offsetX + width / 3 * 2, offsetY + height);
    path.cubicTo(
        offsetX + width / 6 * 5,
        offsetY + height - bumpSize,
        offsetX + width / 6,
        offsetY + height - bumpSize,
        offsetX + width / 3,
        offsetY + height);
    path.lineTo(offsetX, offsetY + height);
  }

  if (col == 0) {
    path.close();
  } else {
    path.lineTo(offsetX, offsetY + height / 3 * 2);
    path.cubicTo(
        offsetX - bumpSize,
        offsetY + height / 6 * 5,
        offsetX - bumpSize,
        offsetY + height / 6,
        offsetX,
        offsetY + height / 3);
    path.close();
  }

  return path;
}
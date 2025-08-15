import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 이 파일에는 존재하지 않는 PlayPuzzle 클래스를 임시로 정의합니다.
/// 실제로는 퍼즐 플레이 페이지로 이동하는 클래스여야 합니다.
class PlayPuzzle extends StatelessWidget {
  const PlayPuzzle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('퍼즐 플레이 페이지'),
      ),
      body: const Center(
        child: Text('퍼즐을 푸는 화면입니다.'),
      ),
    );
  }
}
import 'package:artificialsw_frontend/services/image_store.dart';
import 'package:flutter/material.dart';

class PuzzleRoot extends StatelessWidget {
  const PuzzleRoot({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold( // 이 Scaffold를 추가합니다.
      appBar: AppBar(title: const Text('Puzzle')),
      body: Column(
        children: [
          ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('/puzzle/write-puzzle-info'),
              child: const Text("이번 주 퍼즐 풀기")
          ),
          ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('/puzzle/ongoing-list'),
              child: const Text("진행중인 퍼즐 리스트")
          ),
          ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('/puzzle/completed-list'),
              child: const Text("완료된 퍼즐 목록")
          ),
          ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('/puzzle/image-upload-test'),
              child: const Text("이미지 업로드 테스팅")
          ),
        ],
      ),
    );
  }
}
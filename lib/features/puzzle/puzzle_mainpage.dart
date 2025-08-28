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
              onPressed: () => Navigator.of(context).pushNamed('/puzzle/play'),
              child: const Text("이번 주 퍼즐 풀기")
          ),
          ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('/puzzle/in-progress'),
              child: const Text("진행중인 퍼즐 리스트")
          )
        ],
      ),
    );
  }
}
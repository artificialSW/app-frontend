import 'package:flutter/material.dart';

class PuzzleRecompleted extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Puzzle 재 완성 페이지')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("축하해요 퍼즐이 완성되었어요"),
            SizedBox(height: 30,),
            Text("다시 풀어진 퍼즐은 열매가 열리지 않아요 ㅜㅜ"),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class PuzzleRecompleted extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Puzzle 재 완성 페이지')),
      body: Center(
          child: Text("퍼즐 재 완성 시 페이지")
      ),
    );
  }
}
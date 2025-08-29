import 'package:flutter/material.dart';

class PuzzleCompleted extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Puzzle 완료 페이지')),
      body: Center(
          child: Text("퍼즐 완료 시 페이지")
      ),
    );
  }
}
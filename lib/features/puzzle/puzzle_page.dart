import 'package:flutter/material.dart';

class PuzzleRoot extends StatelessWidget {
  const PuzzleRoot({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Puzzle')),
      body: Center(
        child: ElevatedButton(
            onPressed: () => Navigator.of(context).pushNamed('/puzzle/in-progress'),
            child: const Text("진행중인 퍼즐 리스트")
        )
      ),
    );
  }
}
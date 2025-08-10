import 'package:flutter/material.dart';

class PuzzleRoot extends StatelessWidget {
  const PuzzleRoot({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Puzzle')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const DetailPage(title: 'Puzzle detail')),
            );
          },
          child: const Text('Go detail'),
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        children: [
          const Center(child: Text('detail')),
          SizedBox(),
          ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('/editor'),
              child: const Text("퍼즐 편집하기")
          )
        ],
      )
    );
  }
}
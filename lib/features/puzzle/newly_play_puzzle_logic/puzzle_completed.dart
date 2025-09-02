import 'package:flutter/material.dart';

class PuzzleCompleted extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Puzzle 완료 페이지')),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("사랑스러운 봄의 딸기 획득!"),
              SizedBox(height: 30),
              Text("~~, ~~ 덕분에 ~~ 열매가 자라났어요!"),
              SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () => null,
                  child: const Text("퍼즐 아카이브에 저장")
              ),
              SizedBox(height: 300),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () => Navigator.of(context).pushNamed('/'),
                      child: const Text("퍼즐 홈으로")
                  ),
                  ElevatedButton(
                      onPressed: () => null,
                      child: const Text("열매 보러가기")
                  ),
                ],
              )
            ],
          )
      ),
    );
  }
}
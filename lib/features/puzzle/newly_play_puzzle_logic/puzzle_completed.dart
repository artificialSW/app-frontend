import 'package:artificialsw_frontend/services/puzzle/dto/puzzle_complete/puzzle_complete_response_dto.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class PuzzleCompleted extends StatelessWidget {
  final PuzzleCompleteResponseDto result;

  const PuzzleCompleted({
    Key? key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Puzzle 완료 페이지')),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(result.fruitMessage),
              SizedBox(height: 30),
              Text("${result.contributors} 덕분에 ${result.fruitName} 열매가 자라났어요!"),
              SizedBox(height: 30),
              Text("메세지: ${result.message}"),
              SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () => null,
                  child: const Text("퍼즐 아카이브에 저장")
              ),
              SizedBox(height: 300),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                      text: '퍼즐 홈으로',
                      onPressed: () => Navigator.of(context).pushNamed('/'),
                      width: 150,
                      fontSize: 15,
                  ),
                  SizedBox(width: 30),
                  CustomButton(
                    text: '열매 보러가기',
                    onPressed: null, /// onPressed: () => null 이거랑 다른 것 주의.
                    width: 150,
                    fontSize: 15,
                  ),
                ],
              )
            ],
          )
      ),
    );
  }
}
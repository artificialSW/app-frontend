import 'package:artificialsw_frontend/services/puzzle/dto/puzzle_complete/puzzle_complete_response_dto.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/features/puzzle/newly_play_puzzle_logic/fruit.dart';

class PuzzleCompleted extends StatelessWidget {
  final String message;
  final String fruitName;
  final String fruitMessage;
  final List<String> contributors;

  const PuzzleCompleted({
    Key? key,
    required this.message,
    required this.fruitName,
    required this.fruitMessage,
    required this.contributors,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Puzzle 완료 페이지')),
      body: Container(
        decoration: ShapeDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.50, -0.00),
            end: Alignment(0.50, 1.00),
            colors: [const Color(0xFFFFF5F9), const Color(0xFFFED4E2)],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/fruit/spring/cherry.png"),
                Text(fruitMessage),
                SizedBox(height: 30),
                Text("${contributors} 덕분에 ${fruitName} 열매가 자라났어요!"),
                SizedBox(height: 30),
                Text("메세지: ${message}"),
                SizedBox(height: 230),
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
      ),
    );
  }
}
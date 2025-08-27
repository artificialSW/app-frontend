import 'package:flutter/material.dart';

class PuzzleRoot extends StatelessWidget {
  const PuzzleRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('퍼즐')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // 새 게임 이미지와 난이도 설정
                const Image image = Image(image: AssetImage('assets/images/4x4_grid_image_numbered.png'));
                const int maxRow = 2;
                const int maxCol = 2;

                // Navigator.push 대신 pushNamed를 사용하고 인자를 전달합니다.
                Navigator.of(context).pushNamed(
                  '/puzzle/play',
                  arguments: {'image': image, 'maxRow': maxRow, 'maxCol': maxCol},
                );
              },
              child: const Text("이번주 퍼즐 풀기"),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: null, // 기능이 없으므로 비활성화
              child: const Text("진행중인 퍼즐 리스트"),
            ),
          ],
        ),
      ),
    );
  }
}
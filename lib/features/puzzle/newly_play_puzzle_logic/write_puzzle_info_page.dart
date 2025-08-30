import 'package:artificialsw_frontend/features/puzzle/puzzlelist_provider.dart';
import 'package:artificialsw_frontend/services/image_store.dart';
import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/features/puzzle/model/puzzlegame.dart';
import 'package:provider/provider.dart';

class WritePuzzleInfoPage extends StatefulWidget {

  const WritePuzzleInfoPage({
    super.key,
  });

  @override
  State<WritePuzzleInfoPage> createState() => _WritePuzzleInfoPageState();
}

class _WritePuzzleInfoPageState extends State<WritePuzzleInfoPage> {

  String selectedSize = "3 x 3";
  int unplayedPuzzleIndex = 0;

  final List<String> sizeOptions = [
    "3 x 3",
    "4 x 4",
    "5 x 5",
  ];

  PuzzleGame getPuzzle(int idx, String size){ ///여기선 '퍼즐 풀겠다!'선언했을때 일어나야 할 로직들이 담김.
    final puzzle = Provider.of<PuzzleProvider>(
      context,
      listen: false, //이건 그냥 복사해서 가져오기만 하므로 재빌드 할 필요 없어서 false
    ).unplayedPuzzles[idx];
    unplayedPuzzleIndex++;

    puzzle.size = int.parse(size.split(" ")[0]); //"3 x 3" 이면 size = 3 됨.

    ImageStore().removeImageWidgetAt(0); //이미지 저장 리스트의 첫 번째 이미지를 지움(지금 쓸거니까)

    return puzzle;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 300),
        DropdownButtonFormField<String>(
          value: selectedSize,
          decoration: InputDecoration(
            labelText: "퍼즐 사이즈 선택",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: sizeOptions.map((size) {
            return DropdownMenuItem(
              value: size,
              child: Text(size),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedSize = value!;
            });
          },
        ),
        SizedBox(height: 300,),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                '/puzzle/newly-play', ///일단은 라우팅 경로 re-play로 해놓고 나중에 이름 리팩터링 ㄱㄱ
                arguments: {'gameInstance': getPuzzle(unplayedPuzzleIndex, selectedSize)},
              );
            },
            child: const Text("입력한 정보대로 퍼즐 풀기")
        ),
      ],
    );
  }
}

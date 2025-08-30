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

  String? selectedSize;
  int unplayedPuzzleIndex = 0;

  final List<String> sizeOptions = [
    "3 x 3 (9조각)",
    "4 x 4 (16조각)",
    "5 x 5 (25조각)",
  ];

  PuzzleGame getPuzzle(int idx){
    final puzzle = Provider.of<PuzzleProvider>(
      context,
      listen: false, //이건 그냥 복사해서 가져오기만 하므로 재빌드 할 필요 없어서 false
    ).unplayedPuzzles[idx];
    unplayedPuzzleIndex++;
    return puzzle;
  }

  @override
  Widget build(BuildContext context) {

    final images = ImageStore().imageWidgetList;
    print(ImageStore().imageWidgetList.length);

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
              selectedSize = value;
            });
          },
        ),
        SizedBox(height: 300,),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                '/puzzle/newly-play', ///일단은 라우팅 경로 re-play로 해놓고 나중에 이름 리팩터링 ㄱㄱ
                arguments: {'gameInstance': getPuzzle(unplayedPuzzleIndex)},
              );
            },
            child: const Text("입력한 정보대로 퍼즐 풀기")
        ),
      ],
    );
  }
}

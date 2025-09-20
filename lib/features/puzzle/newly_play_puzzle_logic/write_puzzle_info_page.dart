import 'dart:convert';

import 'package:artificialsw_frontend/features/puzzle/puzzlelist_provider.dart';
import 'package:artificialsw_frontend/services/old_image_store.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/puzzle_create/puzzle_create_request_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/puzzle_create/puzzle_create_response_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/puzzle_service.dart';
import 'package:artificialsw_frontend/shared/models/usermodel.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_top_bar.dart';
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
  User userInfo = User(name: 'Jaewook', id: '123');

  final List<String> sizeOptions = [
    "3 x 3",
    "4 x 4",
    "5 x 5",
  ];

  PuzzleGame getPuzzle(PuzzleCreateResponseDto dto){ ///여기선 '퍼즐 풀겠다!'선언했을때 일어나야 할 로직들이 담김.

    final puzzle = PuzzleGame(
      puzzleId: dto.puzzleId,
      imageWidget: ImageStore().imageWidgetList[0],
      imageUrl: dto.imageUrl,
      category: dto.category,
      AIKeyword: dto.AIKeyword,
      size: int.parse(selectedSize.split(" ")[0]) * int.parse(selectedSize.split(" ")[0]),
      piecesPosition: [],
      gameState: GameState.Unplayed, //어짜피 서버 연동하면 필요없어서 걍 냅둠
      contributors: [userInfo],
      isArchived: false, //어짜피 서버 연동하면 필요없어서 걍 냅둠
    );

    return puzzle;
  }

  Future<void> _createPuzzle() async {
    final puzzleDto = await PuzzleService().createPuzzle(
      PuzzleCreateRequestDto(
        userId: "123",
        size: int.parse(selectedSize.split(" ")[0]) * int.parse(selectedSize.split(" ")[0]),
      )
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('✅ 퍼즐 생성 완료!')),
    );

    const encoder = JsonEncoder.withIndent('  ');
    final prettyJson = encoder.convert(puzzleDto.toJson());
    print('📤 퍼즐 생성 결과:\n$prettyJson');

    Navigator.of(context).pushNamed(
      '/puzzle/play',
      arguments: {'gameInstance': getPuzzle(puzzleDto)},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CanGoBackTopBar('퍼즐 정보 입력', context),
      body: Column(
        children: [
          Text("퍼즐 크기를 선택해주세요."),
          SizedBox(height: 100),
          Text("[퍼즐 정보]"),
          Text("AI 선정 키워드: ~~~"),
          Text("주제: ~~~"),
          SizedBox(height: 100),
          DropdownButtonFormField<String>(
            value: selectedSize,
            decoration: InputDecoration(
              labelText: "퍼즐 크기 선택",
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
          SizedBox(height: 100,),
          CustomButton(
              text: '완료하기',
              onPressed: () {
                _createPuzzle();
              },
          )
        ],
      )
    );
  }
}

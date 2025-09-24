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
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';

class WritePuzzleInfoPage extends StatefulWidget {
  const WritePuzzleInfoPage({super.key});

  @override
  State<WritePuzzleInfoPage> createState() => _WritePuzzleInfoPageState();
}

class _WritePuzzleInfoPageState extends State<WritePuzzleInfoPage> {
  String? selectedSize; // ← 힌트 표시/버튼 비활성화를 위해 nullable
  int unplayedPuzzleIndex = 0;
  User userInfo = User(name: 'Jaewook', id: '123', role: '아빠');

  final List<String> sizeOptions = [
    "3 x 3",
    "4 x 4",
    "5 x 5",
  ];

  PuzzleGame getPuzzle(PuzzleCreateResponseDto dto) {
    // 안전가드: null일 리 없지만 혹시 몰라 fallback
    final sizeToken = (selectedSize ?? "3 x 3").split(" ")[0];
    final side = int.tryParse(sizeToken) ?? 3;
    final total = side * side;

    return PuzzleGame(
      puzzleId: dto.puzzleId,
      imageWidget: ImageStore().imageWidgetList[0],
      imageUrl: dto.imageUrl,
      category: dto.category,
      AIKeyword: dto.AIKeyword,
      size: total,
      piecesPosition: [],
      gameState: GameState.Unplayed,
      contributors: [userInfo],
      isArchived: false,
    );
  }

  Future<void> _createPuzzle() async {
    if (selectedSize == null) return; // 버튼 비활성이라 보통 안 옴. 2중 방어.

    final side = int.parse(selectedSize!.split(" ")[0]);
    final total = side * side;

    final puzzleDto = await PuzzleService().createPuzzle(
      PuzzleCreateRequestDto(
        userId: "123",
        size: total,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ 퍼즐 생성 완료!')),
    );

    const encoder = JsonEncoder.withIndent('  ');
    final prettyJson = encoder.convert(puzzleDto.toJson());
    // ignore: avoid_print
    print('📤 퍼즐 생성 결과:\n$prettyJson');

    Navigator.of(context).pushNamed(
      '/puzzle/play',
      arguments: {'gameInstance': getPuzzle(puzzleDto)},
    );
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = selectedSize != null;

    return Scaffold(
      appBar: CanGoBackTopBar('퍼즐 맞추기', context), // 화면 타이틀만 변경
      backgroundColor: AppColors.plumu_white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤드라인 (두 줄로 보이도록 줄바꿈 가능)
              Text(
                '퍼즐 크기를\n선택해주세요',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 28),

              // 섹션 라벨
              Text(
                '퍼즐 크기 선택',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),

              // 드롭다운 (힌트 표시, 둥근 모서리)
              DropdownButtonFormField<String>(
                value: selectedSize,
                decoration: InputDecoration(
                  hintText: '퍼즐 크기 선택',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                items: sizeOptions
                    .map(
                      (size) => DropdownMenuItem(
                    value: size,
                    child: Text(size),
                  ),
                )
                    .toList(),
                onChanged: (value) {
                  setState(() => selectedSize = value);
                },
              ),

              // 여백은 Flexible로 하단 버튼 띄우기
              const Spacer(),
            ],
          ),
        ),
      ),

      // 하단 고정 버튼
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: CustomButton(
            text: '완료하기',
            onPressed: canSubmit ? _createPuzzle : null,
            width: double.infinity,
            height: 52,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

import 'package:artificialsw_frontend/services/image_store.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/puzzle_home/puzzle_home_completed_preview_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/puzzle_home/puzzle_home_get_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/puzzle_home/puzzle_home_ongoing_preview_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/puzzle_service.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PuzzleRoot extends StatefulWidget {
  const PuzzleRoot({super.key});

  @override
  State<PuzzleRoot> createState() => _PuzzleRootState();
}

class _PuzzleRootState extends State<PuzzleRoot> {
  late Future<PuzzleHomeGetDto> _puzzleFuture;

  @override
  void initState() {
    super.initState();
    _puzzleFuture = _loadPuzzleData();
  }

  Future<PuzzleHomeGetDto> _loadPuzzleData() async {
    try {
      return await PuzzleService().getPuzzleHome(); // 실제 서버 호출
    } catch (e) {
      print('⚠️ 서버 응답 실패, 목데이터 사용: $e');
      // ✅ 목데이터 리턴
      return PuzzleHomeGetDto(
        subject: ["복숭아 사진 자랑", "아보카도 사진 자랑", "딸기 사진 자랑"],
        inProgress: [PuzzleHomeOngoingPreviewDto(
          puzzleId: 1,
          imageUrl:
              'https://picsum.photos/600/400',
          size: 4,
          completedPiecesId: [1, 2],
          lastSavedAt: "03:33",
        ),
          PuzzleHomeOngoingPreviewDto(
            puzzleId: 1,
            imageUrl:
            'https://picsum.photos/600/400',
            size: 4,
            completedPiecesId: [1, 2],
            lastSavedAt: "03:33",
          ),
        ],
        completedThisWeek: [PuzzleHomeCompletedPreviewDto(
          puzzleId: 1,
          imageUrl:
              'https://picsum.photos/600/400',
          size: 9,
          title: "목데이터 title",
          completedAt: "04:44",
        ),
          PuzzleHomeCompletedPreviewDto(
            puzzleId: 1,
            imageUrl:
            'https://picsum.photos/600/400',
            size: 9,
            title: "목데이터 title",
            completedAt: "04:44",
          ),
        ],
        isFull: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 이 Scaffold를 추가합니다.
      appBar: PuzzlRootTopBar(),
      body: FutureBuilder<PuzzleHomeGetDto>(
        future: _puzzleFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('에러 발생'));
          }
          final puzzle = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 300,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFC0D6E6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text("이번주의 퍼즐 키워드: ${puzzle.subject}"),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("진행중"),
                  ElevatedButton(
                    onPressed:
                        () => Navigator.of(
                          context,
                        ).pushNamed('/puzzle/ongoing-list'),
                    child: const Text(">"),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      puzzle.inProgress[0].imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      puzzle.inProgress[1].imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("이번 주 풀어진 퍼즐"),
                  ElevatedButton(
                    onPressed:
                        () => Navigator.of(
                          context,
                        ).pushNamed('/puzzle/completed-list'),
                    child: const Text(">"),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      puzzle.completedThisWeek[0].imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.network(
                      puzzle.completedThisWeek[1].imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    text: '사진 업로드',
                    onPressed: puzzle.isFull
                        ? null
                        : () {
                      Navigator.of(context).pushNamed(
                        '/puzzle/image-upload',
                        arguments: {'category': puzzle.subject},
                      );
                    },
                    width: 150,
                    fontSize: 13,
                  ),
                  SizedBox(width: 20),
                  CustomButton(
                    text: '퍼즐 아카이브',
                    onPressed:
                        () =>
                            Navigator.of(context).pushNamed('/puzzle/archive'),
                    width: 150,
                    fontSize: 13,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Consumer<ImageStore>(
                    builder: (context, imageStore, child) {
                      return CustomButton(
                        text: '퍼즐 맞추기',
                        onPressed:
                            imageStore.isNotEmpty
                                ? () => Navigator.of(
                                  context,
                                ).pushNamed('/puzzle/write-puzzle-info')
                                : null,
                        width: 150,
                        fontSize: 13,
                      );
                    },
                  ),
                  SizedBox(width: 20),
                  CustomButton(
                    text: 'Plumu Asset 구경하기',
                    onPressed:
                        () => Navigator.of(
                          context,
                        ).pushNamed('/puzzle/assetView'),
                    width: 150,
                    fontSize: 13,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

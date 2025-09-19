import 'package:artificialsw_frontend/features/puzzle/model/puzzlegame.dart';
import 'package:artificialsw_frontend/features/puzzle/puzzlelist_provider.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/get_archived_puzzle_list/puzzle_get_archived_data_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/get_archived_puzzle_list/puzzle_get_archived_list_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/puzzle_service.dart';
import 'package:artificialsw_frontend/shared/models/usermodel.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_top_bar.dart';
import 'package:flutter/material.dart';

class PuzzleArchive extends StatefulWidget {
  const PuzzleArchive({super.key});

  @override
  State<PuzzleArchive> createState() => _PuzzleArchiveState();
}

class _PuzzleArchiveState extends State<PuzzleArchive> {
  final _user = User(name: 'MockUser', id: '123');

  late Future<PuzzleGetArchivedListDto> _archivedPuzzlesFuture;

  Future<PuzzleGetArchivedListDto> _fetchArchivedPuzzles() async {
    try{
      return await PuzzleService().getArchivedList();
    } catch (e){
      print('⚠️ 서버 응답 실패, 목데이터 사용: $e');
      // ✅ 목데이터 리턴
      return PuzzleGetArchivedListDto(
          archivedList: [
            PuzzleGetArchivedDataDto(
                puzzleId: '1',
                imageUrl: 'https://picsum.photos/600/400',
                contributors: ['아카이브의mock1', 'mock', 'mock'],
                archivedAt: 'mock 시간 데이터1',
                AIKeyword: ['아카이브의mock1', 'AI', 'keyword'],
                category: 'mock 카테고리1'
            ),
            PuzzleGetArchivedDataDto(
                puzzleId: '2',
                imageUrl: 'https://picsum.photos/600/400',
                contributors: ['mock2', 'mock', 'mock'],
                archivedAt: 'mock2 시간 데이터2',
                AIKeyword: ['mock2', 'AI', 'keyword'],
                category: 'mock 카테고리2'
            ),
            PuzzleGetArchivedDataDto(
                puzzleId: '3',
                imageUrl: 'https://picsum.photos/600/400',
                contributors: ['mock3', 'mock', 'mock'],
                archivedAt: 'mock3 시간 데이터3',
                AIKeyword: ['mock3', 'AI', 'keyword'],
                category: 'mock 카테고리3'
            ),
          ]
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _archivedPuzzlesFuture = _fetchArchivedPuzzles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CanGoBackTopBar('퍼즐 아카이브', context),
      body: FutureBuilder<PuzzleGetArchivedListDto>(
        future: _fetchArchivedPuzzles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('데이터 불러오기 실패'));
          }

          final puzzles = snapshot.data!.archivedList;

          if (puzzles.isEmpty) {
            return const Center(child: Text('아카이브에 퍼즐이 없습니다.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: puzzles.length,
            itemBuilder: (context, index) {
              final puzzleDto = puzzles[index];
              return PuzzleListItem(
                puzzleDto: puzzleDto,
                onDelete: () {
                  PuzzleService().deletePuzzle(puzzleDto.puzzleId);
                },
                onPressed: () {

                },
                onSave: () {
                  // 저장 로직
                },
                gameState: GameState.Completed,
                isArchived: true,
              );
            },
          );
        },
      ),
    );
  }
}

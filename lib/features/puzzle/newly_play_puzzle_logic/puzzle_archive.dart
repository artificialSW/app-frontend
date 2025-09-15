import 'package:artificialsw_frontend/features/puzzle/model/puzzlegame.dart';
import 'package:artificialsw_frontend/features/puzzle/puzzlelist_provider.dart';
import 'package:artificialsw_frontend/features/puzzle/relay_puzzle_logic/puzzle_ongoinglist.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/get_archived_puzzle_list/puzzle_get_archived_data_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/get_archived_puzzle_list/puzzle_get_archived_list_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/puzzle_service.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/models/usermodel.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_deleteConfirmationDialog.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PuzzleArchive extends StatefulWidget {
  const PuzzleArchive({super.key});

  @override
  State<PuzzleArchive> createState() => _PuzzleArchiveState();
}

class _PuzzleArchiveState extends State<PuzzleArchive> {
  final _user = User(name: 'MockUser', id: '123');

  late Future<PuzzleGetArchivedListDto> _completedPuzzlesFuture;

  Future<PuzzleGetArchivedListDto> _fetchCompletedPuzzles() async {
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
                contributors: ['mock1', 'mock', 'mock'],
                archivedAt: 'mock 시간 데이터1',
                AIKeyword: ['mock1', 'AI', 'keyword'],
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
    _completedPuzzlesFuture = _fetchCompletedPuzzles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CanGoBackTopBar('퍼즐 아카이브', context),
      body: Consumer<PuzzleProvider>(
        builder: (context, puzzleProvider, child) {
          if (puzzleProvider.archivedPuzzles.isEmpty) {
            return const Center(
              child: Text(
                '아카이빙이 비었어요. 어서 퍼즐을 풀어보세요!',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              itemCount: puzzleProvider.archivedPuzzles.length,
              itemBuilder: (context, index) {
                final puzzle = puzzleProvider.archivedPuzzles[index];
                return PuzzleListItem(
                  puzzleDto: puzzle,
                  onDelete: () => showDialog(
                    context: context,
                    builder: (context) {
                      return DeleteConfirm(
                        title: '퍼즐을 삭제하시겠습니까?',
                        content: '퍼즐 관련 데이터가 모두 삭제됩니다.',
                        puzzleId: puzzle.puzzleId, // 삭제할 퍼즐 id
                      );
                    },
                  ),
                  onPressed: () {},
                  onSave: () {}, //TODO: 핸드폰에 저장하는 기능 구현하기
                  gameState: GameState.Completed, // 완료된 퍼즐임을 표시
                  isArchived: true,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

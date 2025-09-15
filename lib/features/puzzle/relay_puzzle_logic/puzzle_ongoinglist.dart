import 'package:artificialsw_frontend/features/puzzle/model/puzzlegame.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/get_in_progress_puzzle_list/puzzle_get_in_progress_data_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/get_in_progress_puzzle_list/puzzle_get_in_progress_list_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/puzzle_service.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/models/usermodel.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_deleteConfirmationDialog.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:artificialsw_frontend/features/puzzle/puzzlelist_provider.dart';

class OngoingPuzzlesPage extends StatefulWidget {
  const OngoingPuzzlesPage({Key? key}) : super(key: key);

  @override
  State<OngoingPuzzlesPage> createState() => _OngoingPuzzlesPageState();
}

class _OngoingPuzzlesPageState extends State<OngoingPuzzlesPage> {

  final _user = User(name: 'MockUser', id: '123');
  late Future<PuzzleGetInProgressListDto> _ongoingPuzzlesFuture;

  Future<PuzzleGetInProgressListDto> _fetchOngoingPuzzles() async {
    try{
      return await PuzzleService().getInProgressList();
    } catch (e){
      print('⚠️ 서버 응답 실패, 목데이터 사용: $e');
      // ✅ 목데이터 리턴
      return PuzzleGetInProgressListDto(
        inProgressList: [
          PuzzleGetInProgressDataDto(
            puzzleId: '1',
            imageUrl: 'https://picsum.photos/600/400',
            contributors: ['mock1', 'mock', 'mock'],
            lastSavedAt: 'mock 시간 데이터1',
            AIKeyword: ['mock1', 'AI', 'keyword'],
            category: 'mock 카테고리1'
          ),
          PuzzleGetInProgressDataDto(
              puzzleId: '2',
              imageUrl: 'https://picsum.photos/600/400',
              contributors: ['mock2', 'mock', 'mock'],
              lastSavedAt: 'mock2 시간 데이터2',
              AIKeyword: ['mock2', 'AI', 'keyword'],
              category: 'mock 카테고리2'
          ),
          PuzzleGetInProgressDataDto(
              puzzleId: '3',
              imageUrl: 'https://picsum.photos/600/400',
              contributors: ['mock3', 'mock', 'mock'],
              lastSavedAt: 'mock3 시간 데이터3',
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
    _ongoingPuzzlesFuture = _fetchOngoingPuzzles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CanGoBackTopBar('진행중인 퍼즐 목록', context),
      body: FutureBuilder<PuzzleGetInProgressListDto>(
        future: _fetchOngoingPuzzles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('데이터 불러오기 실패'));
          }

          final puzzles = snapshot.data!.inProgressList;

          if (puzzles.isEmpty) {
            return const Center(child: Text('진행중인 퍼즐이 없습니다.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: puzzles.length,
            itemBuilder: (context, index) {
              final puzzleDto = puzzles[index];
              return PuzzleListItem(
                puzzleDto: puzzleDto,
                onDelete: () {
                  // 삭제 로직
                },
                onPressed: () async {
                  ///api 호출하여 dto 받아옴( puzzleId => puzzle dto )
                  final response = PuzzleService().playInProgressPuzzle(puzzleDto.puzzleId);
                  //일단 목데이터 처리는 나중에..
                  ///받아온 puzzle dto를 puzzlegame의 fromDto에 넣어서 퍼즐 인스턴스 받아옴
                  final puzzleGame = PuzzleGame.fromDto(
                      await response, //이거 왜 await으로 해야 하는지 몰겠다 오류나면 빼자
                      _user,
                      puzzleDto.puzzleId,
                      puzzleDto.AIKeyword,
                      puzzleDto.category
                  );
                  ///받아온 퍼즐 인스턴스를 네비게이터에 넣기
                  Navigator.of(context).pushNamed(
                    '/puzzle/play',
                    arguments: {'gameInstance': puzzleGame},
                  );
                },
                onSave: () {
                  // 저장 로직
                },
                gameState: GameState.Ongoing,
                isArchived: false,
              );
            },
          );
        },
      ),
    );
  }
}
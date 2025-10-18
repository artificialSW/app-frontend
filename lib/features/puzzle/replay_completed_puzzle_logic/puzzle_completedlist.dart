//completed_puzzles_page.dart

import 'package:artificialsw_frontend/features/puzzle/model/puzzlegame.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/play_completed_puzzle/play_puzzle_completed_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/get_completed_puzzle_list/puzzle_get_completed_data_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/get_completed_puzzle_list/puzzle_get_completed_list_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/puzzle_service.dart';
import 'package:artificialsw_frontend/shared/models/usermodel.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:artificialsw_frontend/features/puzzle/puzzlelist_provider.dart';

/// 완료된 퍼즐 목록 페이지
class CompletedPuzzlesPage extends StatefulWidget {
  const CompletedPuzzlesPage({Key? key}) : super(key: key);

  @override
  State<CompletedPuzzlesPage> createState() => _CompletedPuzzlesPageState();
}

class _CompletedPuzzlesPageState extends State<CompletedPuzzlesPage> {
  final _user = User(name: 'MockUser', id: 123, role: '아빠');

  late Future<List<PuzzleGetCompletedListDto>> _completedPuzzlesFuture;

  Future<List<PuzzleGetCompletedListDto>> _fetchCompletedPuzzles() async {
    try{
      return await PuzzleService().getCompletedList();
    } catch (e){
      print('⚠️ 서버 응답 실패, 목데이터 사용: $e');
      // ✅ 목데이터 리턴
      throw Exception('error!!!!!!!!!!');
      // return PuzzleGetCompletedListDto(
      //     completedList: [
      //       PuzzleGetCompletedDataDto(
      //           puzzleId: 1,
      //           imageUrl: 'https://picsum.photos/400/400',
      //           contributors: ['완료-mock1', 'mock', 'mock'],
      //           category: 'mock 카테고리1',
      //         message: 'mock1 우리 할아버지 신나셨던거 기억나?'
      //       ),
      //       PuzzleGetCompletedDataDto(
      //           puzzleId: 2,
      //           imageUrl: 'https://picsum.photos/400/400',
      //           contributors: ['mock2', 'mock', 'mock'],
      //           category: 'mock 카테고리2',
      //           message: 'mock1 우리 할아버지 신나셨던거 기억나?'
      //       ),
      //       PuzzleGetCompletedDataDto(
      //           puzzleId: 3,
      //           imageUrl: 'https://picsum.photos/400/400',
      //           contributors: ['mock3', 'mock', 'mock'],
      //           category: 'mock 카테고리3',
      //           message: 'mock1 우리 할아버지 신나셨던거 기억나?'
      //       ),
      //     ]
      // );
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
      backgroundColor: Colors.white,
      appBar: CanGoBackTopBar('완료된 퍼즐 목록', context),
      body: FutureBuilder<List<PuzzleGetCompletedListDto>>(
        future: _fetchCompletedPuzzles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('데이터 불러오기 실패'));
          }

          final puzzles = snapshot.data!;

          if (puzzles.isEmpty) {
            return const Center(child: Text('완료된 퍼즐이 없습니다.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: puzzles.length,
            itemBuilder: (context, index) {
              final puzzleDto = puzzles[index];
              return PuzzleListItem(
                puzzleDto: puzzleDto,
                onDelete: () {
                  null; //삭제 기능 없음
                },
                onPressed: () async {
                  PlayPuzzleCompletedDto response;
                  ///api 호출하여 dto 받아옴( puzzleId => puzzle dto )
                  try{
                    response = await PuzzleService().playCompletedPuzzle(puzzleDto.puzzleId.toString());
                  } catch(e){
                    print('⚠️ 서버 응답 실패, 목데이터 사용: $e');
                    response = PlayPuzzleCompletedDto(
                      imageUrl: 'https://picsum.photos/400/400',
                      size: 9,
                      message: '풀어진 퍼즐 목데이터 메세지',
                    );
                  }
                  ///받아온 puzzle dto를 puzzlegame의 fromDto에 넣어서 퍼즐 인스턴스 받아옴
                  final puzzleGame = PuzzleGame.completedFromDto(
                      response, //이거 왜 await으로 해야 하는지 몰겠다 오류나면 빼자
                      _user,
                      puzzleDto.puzzleId.toString(),
                      puzzleDto.category,
                  );
                  ///받아온 퍼즐 인스턴스를 네비게이터에 넣기
                  Navigator.of(context).pushNamed(
                    '/puzzle/play',
                    arguments: {'gameInstance': puzzleGame, 'message': puzzleDto.message},
                  );
                },
                onSave: () async {
                  await PuzzleService().archiveCompletedPuzzle(puzzleDto.puzzleId.toString());
                  setState(() {
                    _completedPuzzlesFuture = _fetchCompletedPuzzles(); //새로운 future로 업데이트
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('아카이브 요청 완료 (성공 여부는 콘솔 참고)')),
                  );
                },
                gameState: GameState.Completed,
                isArchived: false,
              );
            },
          );
        },
      ),
    );
  }
}
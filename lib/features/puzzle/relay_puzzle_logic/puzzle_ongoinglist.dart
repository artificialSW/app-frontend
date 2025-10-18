import 'package:artificialsw_frontend/features/puzzle/model/puzzlegame.dart';
import 'package:artificialsw_frontend/features/puzzle/model/puzzlepiece_position.dart';
import 'package:artificialsw_frontend/services/api_client.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/play_in_progress_puzzle/play_puzzle_in_progress_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/get_in_progress_puzzle_list/puzzle_get_in_progress_list_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/puzzle_service.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/models/usermodel.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_deleteConfirmationDialog.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_top_bar.dart';
import 'package:dio/dio.dart';
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

  final _user = User(name: 'MockUser', id: 123, role: '아빠');
  late Future<List<PuzzleGetInProgressListDto>> _ongoingPuzzlesFuture;

  Future<List<PuzzleGetInProgressListDto>> _fetchOngoingPuzzles() async {
    try{
      return await PuzzleService().getInProgressList();
    } catch (e){
      print('⚠️ 서버 응답 실패, 목데이터 사용: $e');
      // ✅ 목데이터 리턴
      throw Exception('서버 응답 실패!!!!');
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
      backgroundColor: Colors.white,
      appBar: CanGoBackTopBar('진행중인 퍼즐 목록', context),
      body: FutureBuilder<List<PuzzleGetInProgressListDto>>(
        future: _fetchOngoingPuzzles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('데이터 불러오기 실패'));
          }

          final puzzles = snapshot.data!;

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
                onDelete: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: const Text(
                          '퍼즐 삭제',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        content: const Text('정말로 이 퍼즐을 삭제하시겠습니까?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false), // 취소
                            child: const Text('취소'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true), // 확인
                            child: const Text(
                              '삭제',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirm == true) {
                    // ✅ 사용자가 '삭제' 눌렀을 때만 실행
                    setState(() {
                      PuzzleService().deletePuzzle(puzzleDto.puzzleId.toString());
                    });
                  }
                },

                onPressed: () async {
                  PlayPuzzleInProgressDto response;
                  ///api 호출하여 dto 받아옴( puzzleId => puzzle dto )
                  try{
                    response = await PuzzleService().playInProgressPuzzle(puzzleDto.puzzleId.toString());
                  } catch(e) {
                    print('⚠️ 서버 응답 실패, 목데이터 사용: $e');
                    throw Exception('error!!');
                  }

                  ///받아온 puzzle dto를 puzzlegame의 fromDto에 넣어서 퍼즐 인스턴스 받아옴
                  final puzzleGame = PuzzleGame.fromDto(
                      await response, //이거 왜 await으로 해야 하는지 몰겠다 오류나면 빼자
                      _user,
                      puzzleDto.puzzleId.toString(),
                      puzzleDto.category,
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
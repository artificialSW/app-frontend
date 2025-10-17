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
      // return PuzzleGetInProgressListDto(
      //   inProgressList: [
      //     PuzzleGetInProgressDataDto(
      //       puzzleId: '1',
      //       imageUrl: 'https://picsum.photos/400/400',
      //       contributors: ['진행중-mock1', 'mock', 'mock'],
      //       //lastSavedAt: 'mock 시간 데이터1',
      //       //AIKeyword: ['진행중인mock1', 'AI', 'keyword'],
      //       category: 'mock 카테고리1',
      //       completedPiecesCount: 3,
      //       size: 9,
      //     ),
      //     PuzzleGetInProgressDataDto(
      //         puzzleId: '2',
      //         imageUrl: 'https://picsum.photos/400/400',
      //         contributors: ['mock2', 'mock', 'mock'],
      //         //lastSavedAt: 'mock2 시간 데이터2',
      //         //AIKeyword: ['mock2', 'AI', 'keyword'],
      //         category: 'mock 카테고리2',
      //       completedPiecesCount: 3,
      //       size: 9,
      //     ),
      //     PuzzleGetInProgressDataDto(
      //         puzzleId: '3',
      //         imageUrl: 'https://picsum.photos/400/400',
      //         contributors: ['mock3', 'mock', 'mock'],
      //         //lastSavedAt: 'mock3 시간 데이터3',
      //         //AIKeyword: ['mock3', 'AI', 'keyword'],
      //         category: 'mock 카테고리3',
      //       completedPiecesCount: 3,
      //       size: 9,
      //     ),
      //   ]
      // );
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
                onDelete: () {
                  PuzzleService().deletePuzzle(puzzleDto.puzzleId.toString());
                },
                onPressed: () async {
                  PlayPuzzleInProgressDto response;
                  ///api 호출하여 dto 받아옴( puzzleId => puzzle dto )
                  try{
                    response = await PuzzleService().playInProgressPuzzle(puzzleDto.puzzleId.toString());
                  } catch(e) {
                    print('⚠️ 서버 응답 실패, 목데이터 사용: $e');
                    throw Exception('error!!');
                    // response = PlayPuzzleInProgressDto(
                    //   imageUrl: 'https://picsum.photos/600/400',
                    //   size: 9,
                    //   youCanPlayPuzzle: true,
                    //   piecesPosition: {
                    //       '0': PiecePosition(x: 0.0, y: 0.0),
                    //       '1': PiecePosition(x: 0.0, y: 0.0),
                    //       '2': PiecePosition(x: 371.9866817679033, y: -78.11811366169445),
                    //       '3': PiecePosition(x: 412.19363719162334, y: 129.82030758795253),
                    //       '4': PiecePosition(x: 336.10010644817953, y: -66.03152805582121),
                    //       '5': PiecePosition(x: 403.20028666529834, y: -79.03794413986476),
                    //       '6': PiecePosition(x: 348.9157830790029, y: 75.53067899585587),
                    //       '7': PiecePosition(x: 281.8794948201076, y: 36.361730600130926),
                    //       '8': PiecePosition(x: 328.8932872972411, y: -66.43651951182676),
                    //     }
                    // );
                  }

                  ///받아온 puzzle dto를 puzzlegame의 fromDto에 넣어서 퍼즐 인스턴스 받아옴
                  final puzzleGame = PuzzleGame.fromDto(
                      await response, //이거 왜 await으로 해야 하는지 몰겠다 오류나면 빼자
                      _user,
                      puzzleDto.puzzleId.toString(),
                      //puzzleDto.AIKeyword,
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
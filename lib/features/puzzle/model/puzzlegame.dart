import 'package:artificialsw_frontend/services/puzzle/dto/play_in_progress_puzzle/play_puzzle_in_progress_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/puzzle_create/puzzle_create_response_dto.dart';
import 'package:artificialsw_frontend/shared/models/usermodel.dart';
import 'package:artificialsw_frontend/features/puzzle/model/puzzlepiece_position.dart';
import 'package:flutter/material.dart';

enum GameState {Unplayed, Ongoing, Completed}

/// 퍼즐 데이터 모델
class PuzzleGame {
  final String puzzleId;
  final String imageUrl;
  final Image? imageWidget; //JSON 직렬화 대상에서 제외. api통신용이 아니라 puzzleplay에서만 쓸거라
  int size;
  final String category;
  //final List<String> AIKeyword;
  List<PiecePosition> piecesPosition;
  List<int> completedPiecesId;
  GameState gameState;
  List<User> contributors; // 기본값을 생성자에서 초기화합니다.
  bool isArchived;

  //선언 시점은 꼭 사용자가 '퍼즐 풀기' 버튼을 눌렀을 때로!! 왜냐면 size도 선언할때 같이 적어야한다고 선언했기 때문
  PuzzleGame({
    required this.puzzleId,
    required this.imageUrl,
    this.imageWidget,
    required this.size, //어쨌든 null 입력한것도 입력한거니까 에러 안 뜨는듯
    required this.category,
    //required this.AIKeyword,
    List<PiecePosition>? piecesPosition, // completedPiecesId를 옵셔널로 선언합니다.
    GameState? gameState, // gameState를 옵셔널로 선언합니다.
    List<int>? completedPiecesId,
    isArchived = false,
    List<User>? contributors, // contributors를 옵셔널로 선언합니다.
  })  : this.piecesPosition = piecesPosition ?? [],
        this.gameState = gameState ?? GameState.Unplayed,
        this.completedPiecesId = completedPiecesId ?? [],
        this.contributors = contributors ?? [],
        this.isArchived  = isArchived ?? false;

  PuzzleGame copyForReplaying(){
    return PuzzleGame(
      puzzleId: puzzleId, //유지
      imageUrl: imageUrl,
      imageWidget: imageWidget, //유지
      category: category,
      //AIKeyword: AIKeyword,
      size: size,           //유지
      gameState: gameState,    //유지
      contributors: contributors //유지
    );
  }

  //"imageUrl" : "url",
  // 	"size" : 9,
  // 	"youCanPlayPuzzle" : true
  //   "pieces": { //map의 key값이 pieceId를 의미함
  // 		0: (0.0, 0.0),// "String: (double, double)" 형식임
  // 		1: (276.7342359654034, 2.5206910903800974),
  // 		2: (0.0, 0.0),
  // 		3: (0.0, 0.0),
  // 		4: (0.0, 0.0),
  // 		5: (0.0, 0.0),
  // 		6: (0.0, 0.0),
  // 		7: (0.0, 0.0),
  // 		8: (0.0, 0.0)
  // 	},
  //
  // static PuzzleGame fromDto(
  //     dynamic dto, //PlayPuzzleInProgressDto or PlayPuzzleCompletedDto
  //     User user,
  //     String puzzleId,
  //     String category) {
  //   return PuzzleGame(
  //     puzzleId: puzzleId,
  //     imageUrl: dto.imageUrl,
  //     size: dto.size,
  //     category: category,
  //   );
  // }

  static PuzzleGame fromDto(
      dynamic dto, // PlayPuzzleInProgressDto or PlayPuzzleCompletedDto
      User user,
      String puzzleId,
      String category,
      GameState gameState,
      ) {
    final rawPieces = dto.pieces;

    // pieces가 이미 PiecePosition인 경우와 Map<String, dynamic>인 경우 모두 처리
    final List<PiecePosition> positions = List.generate(dto.size, (i) {
      final pieceData = rawPieces['$i'];

      if (pieceData == null) {
        return PiecePosition(x: 0.0, y: 0.0);
      }

      if (pieceData is PiecePosition) {
        // 이미 DTO 내부에서 fromJson으로 변환된 상태
        return pieceData;
      } else if (pieceData is Map<String, dynamic>) {
        // 아직 단순 Map일 경우
        return PiecePosition(
          x: (pieceData['x'] ?? 0.0).toDouble(),
          y: (pieceData['y'] ?? 0.0).toDouble(),
        );
      } else {
        // 예상치 못한 타입 fallback
        print('⚠️ Unexpected type for pieceData[$i]: ${pieceData.runtimeType}');
        return PiecePosition(x: 0.0, y: 0.0);
      }
    });

    // final List<int> completed = [];
    // if (dto.completedPiecesId != null && gameState == GameState.Ongoing) {
    //   completed.addAll(List<int>.from(dto.completedPiecesId));
    // } ///만약에 완료된 퍼즐 다시풀기라면 이거 실행 안되도록

    // ✅ 1순위: 서버가 준 completedPiecesId 사용 (Ongoing일 때만)
    List<int> completed = [];
    if (gameState == GameState.Ongoing && dto.completedPiecesId is List) {
      completed = List<int>.from(dto.completedPiecesId);
    } else {
      // ✅ 2순위: 서버가 안 줬으면 좌표로 계산 (0,0 이면 맞춘 조각)
      completed = [
        for (var i = 0; i < positions.length; i++)
          if (positions[i].x == 0.0 && positions[i].y == 0.0) i
      ];
    }

    return PuzzleGame(
      puzzleId: puzzleId,
      imageUrl: dto.imageUrl,
      size: dto.size,
      category: category,
      completedPiecesId: completed,
      piecesPosition: positions,
      gameState: gameState,
    );
  }
}
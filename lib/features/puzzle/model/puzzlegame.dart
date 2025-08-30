import 'package:artificialsw_frontend/shared/models/usermodel.dart';
import 'package:artificialsw_frontend/features/puzzle/model/puzzlepiece_position.dart';
import 'package:flutter/material.dart';


enum GameState {Unplayed, Ongoing, Completed}
/// 퍼즐 데이터 모델
class PuzzleGame {
  final int puzzleId;
  final Image imageWidget;
  final int? size;
  List<PiecePosition?> piecesPosition; ///얘를 일단 nullable로 하지 않으면 에러가 떠..
  List<int> completedPiecesId;
  GameState gameState;
  List<User> contributors; // 기본값을 생성자에서 초기화합니다.

  //선언 시점은 꼭 사용자가 '퍼즐 풀기' 버튼을 눌렀을 때로!! 왜냐면 size도 선언할때 같이 적어야한다고 선언했기 때문
  PuzzleGame({
    required this.puzzleId,
    required this.imageWidget,
    required this.size,
    List<PiecePosition?>? piecesPosition, // completedPiecesId를 옵셔널로 선언합니다.
    GameState? gameState, // gameState를 옵셔널로 선언합니다.
    List<User>? contributors, // contributors를 옵셔널로 선언합니다.
  })  : this.piecesPosition = piecesPosition ?? [],
        this.completedPiecesId = [],
        this.gameState = gameState ?? GameState.Unplayed,
        this.contributors = contributors ?? [];

  PuzzleGame copyForReplaying(){
    return PuzzleGame(
      puzzleId: puzzleId, //유지
      imageWidget: imageWidget, //유지
      size: size,           //유지
    );
  }
}
//다시 풀기 할때 DB에서 가져와서 퍼즐 다시 생성해야할수도 있으니까.
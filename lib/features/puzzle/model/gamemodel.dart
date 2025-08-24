import 'package:artificialsw_frontend/models/user_model.dart';

class GameModel {
  // 퍼즐 생성 시 만들어지는 것
  final String puzzleId; // 퍼즐 식별 고유번호
  final String imagePath; // 이미지 경로
  final String message; // 하고 싶은 말 적는거

  // 퍼즐 플레이 시점에 정해지는 것
  int? size; //퍼즐 크기
  bool isCompleted; //퍼즐 완료 여부(true/false)
  List<int> completedPiecesId; //완료된 조각의 식별 번호
  List<UserModel> contributors; //참여자 정보 ex: 재욱, 정환

  GameModel({
    required this.puzzleId,
    required this.imagePath,
    required this.message,
    this.size,
    this.isCompleted = false,
    this.completedPiecesId = const [],
    this.contributors = const [],
  });
}
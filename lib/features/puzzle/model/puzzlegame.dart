/// 퍼즐 데이터 모델
class PuzzleGame {
  final String id;
  final String title;
  final String keyword;
  final int progress;
  final int totalPieces;

  PuzzleGame({
    required this.id,
    required this.title,
    required this.keyword,
    required this.progress,
    required this.totalPieces,
  });
}
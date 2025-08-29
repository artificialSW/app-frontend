import 'package:artificialsw_frontend/shared/models/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:artificialsw_frontend/features/puzzle/model/puzzlegame.dart';
import 'package:artificialsw_frontend/features/puzzle/model/puzzlepiece_position.dart';

/// 퍼즐 리스트 상태 관리
/// 진행중인 퍼즐과 완료된 퍼즐을 모두 관리
class PuzzleProvider with ChangeNotifier {

  List<PuzzleGame> _unplayedPuzzles = [
    PuzzleGame(
      puzzleId: 5,
      imagePath: 'assets/images/mert34.jpeg',
      size: 3, //TODO: 일단은 2로 해놨다가 작동 정상적으로 되면 사이즈도 사용자가 정한거 넘겨받아서 하는거로
      piecesPosition: [
        PiecePosition(x: 10.0, y: 10.0),
        PiecePosition(x: 10.0, y: 50.0),
        PiecePosition(x: 10.0, y: 90.0),
        PiecePosition(x: 50.0, y: 10.0),
        PiecePosition(x: 50.0, y: 50.0),
        PiecePosition(x: 50.0, y: 90.0),
        PiecePosition(x: 90.0, y: 10.0),
        PiecePosition(x: 90.0, y: 50.0),
        PiecePosition(x: 90.0, y: 90.0),
      ],
      gameState: GameState.Unplayed,
      contributors: [User(name: 'Jaewook', id: 1)],
    ),
    PuzzleGame(
      puzzleId: 6,
      imagePath: 'assets/images/mert34.jpeg',
      size: 3,
      piecesPosition: [
        PiecePosition(x: 10.0, y: 10.0),
        PiecePosition(x: 10.0, y: 50.0),
        PiecePosition(x: 10.0, y: 90.0),
        PiecePosition(x: 50.0, y: 10.0),
        PiecePosition(x: 50.0, y: 50.0),
        PiecePosition(x: 50.0, y: 90.0),
        PiecePosition(x: 90.0, y: 10.0),
        PiecePosition(x: 90.0, y: 50.0),
        PiecePosition(x: 90.0, y: 90.0),
      ],
      gameState: GameState.Unplayed,
      contributors: [User(name: 'JungHwan', id: 2)],
    ),
  ];

  // 진행중인 퍼즐 목록
  List<PuzzleGame> _ongoingPuzzles = [
    PuzzleGame(
      puzzleId: 1,
      imagePath: 'assets/images/mert34.jpeg',
      size: 3,
      piecesPosition: [
        PiecePosition(x: 10.0, y: 10.0),
        PiecePosition(x: 10.0, y: 50.0),
        PiecePosition(x: 10.0, y: 90.0),
        PiecePosition(x: 50.0, y: 10.0),
        PiecePosition(x: 50.0, y: 50.0),
        PiecePosition(x: 50.0, y: 90.0),
        PiecePosition(x: 90.0, y: 10.0),
        PiecePosition(x: 90.0, y: 50.0),
        PiecePosition(x: 90.0, y: 90.0),
      ],
      gameState: GameState.Ongoing,
      contributors: [User(name: 'Jaewook', id: 1), User(name: 'JungHwan', id: 2)],
    ),
    PuzzleGame(
      puzzleId: 2,
      imagePath: 'assets/images/mert34.jpeg',
      size: 3,
      piecesPosition: [
        PiecePosition(x: 10.0, y: 10.0),
        PiecePosition(x: 10.0, y: 50.0),
        PiecePosition(x: 10.0, y: 90.0),
        PiecePosition(x: 50.0, y: 10.0),
        PiecePosition(x: 50.0, y: 50.0),
        PiecePosition(x: 50.0, y: 90.0),
        PiecePosition(x: 90.0, y: 10.0),
        PiecePosition(x: 90.0, y: 50.0),
        PiecePosition(x: 90.0, y: 90.0),
      ],
      gameState: GameState.Ongoing,
      contributors: [User(name: 'JungHwan', id: 2)],
    ),
  ];

  // 완료된 퍼즐 목록을 추가합니다.
  List<PuzzleGame> _completedPuzzles = [
    PuzzleGame(
      puzzleId: 3,
      imagePath: 'assets/images/mert34.jpeg',
      size: 3,
      piecesPosition: [
        PiecePosition(x: 10.0, y: 10.0),
        PiecePosition(x: 10.0, y: 50.0),
        PiecePosition(x: 10.0, y: 90.0),
        PiecePosition(x: 50.0, y: 10.0),
        PiecePosition(x: 50.0, y: 50.0),
        PiecePosition(x: 50.0, y: 90.0),
        PiecePosition(x: 90.0, y: 10.0),
        PiecePosition(x: 90.0, y: 50.0),
        PiecePosition(x: 90.0, y: 90.0),
      ],
      gameState: GameState.Completed,
      contributors: [User(name: 'Jaewook', id: 1)],
    ),
    PuzzleGame(
      puzzleId: 4,
      imagePath: 'assets/images/mert34.jpeg',
      size: 3,
      piecesPosition: [
        PiecePosition(x: 10.0, y: 10.0),
        PiecePosition(x: 10.0, y: 50.0),
        PiecePosition(x: 10.0, y: 90.0),
        PiecePosition(x: 50.0, y: 10.0),
        PiecePosition(x: 50.0, y: 50.0),
        PiecePosition(x: 50.0, y: 90.0),
        PiecePosition(x: 90.0, y: 10.0),
        PiecePosition(x: 90.0, y: 50.0),
        PiecePosition(x: 90.0, y: 90.0),
      ],
      gameState: GameState.Completed,
      contributors: [User(name: 'JungHwan', id: 2)],
    ),
  ];

  List<PuzzleGame> get ongoingPuzzles => _ongoingPuzzles;
  List<PuzzleGame> get completedPuzzles => _completedPuzzles;
  List<PuzzleGame> get unplayedPuzzles => _unplayedPuzzles;

  void startPuzzle(PuzzleGame puzzle) { //TODO: 나중에 이런식이 아니라 상태만 바꿔주는 식으로 수정하기
    _unplayedPuzzles.removeWhere((p) => p.puzzleId == puzzle.puzzleId);///걍 _unplayedPuzzles.remove(puzzle); 하면 안되나?
    _ongoingPuzzles.add(puzzle);
    notifyListeners();
  }

  // 퍼즐 삭제
  void deletePuzzle(int id) {
    _ongoingPuzzles.removeWhere((p) => p.puzzleId == id);
    notifyListeners();
  }

  // 퍼즐 완료
  void completePuzzle(PuzzleGame puzzle) { //TODO: 나중에 이런식이 아니라 상태만 바꿔주는 식으로 수정하기
    // 진행중인 목록에서 퍼즐을 제거
    _ongoingPuzzles.removeWhere((p) => p.puzzleId == puzzle.puzzleId);
    // 완료된 목록에 퍼즐을 추가
    _completedPuzzles.add(puzzle);
    notifyListeners();
  }
}

/// 퍼즐 목록의 개별 항목 위젯
class PuzzleListItem extends StatelessWidget {
  final PuzzleGame puzzle;
  final VoidCallback onDelete;
  final VoidCallback onPressed;
  final GameState gameState;

  const PuzzleListItem({
    Key? key,
    required this.puzzle,
    required this.onDelete,
    required this.onPressed,
    required this.gameState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFC0D6E6),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '주제(퍼즐id): ${puzzle.puzzleId}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '크기: ${puzzle.size}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  '퍼즐 생성자: ${puzzle.contributors[0].name}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 12),
                if (gameState == GameState.Ongoing) // 진행중인 퍼즐일 때만 버튼을 표시
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onDelete,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey,
                            side: const BorderSide(color: Colors.grey),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          child:
                          const Text('삭제', style: TextStyle(fontSize: 12)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: const Text(
                            '진행하기',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                if (gameState == GameState.Completed) // 완료된 퍼즐일 때만 완료 표시
                  Row(
                    children: [
                      const Text(
                        '완료',
                        style: TextStyle(color: Colors.green, fontSize: 12),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: const Text(
                            '진행하기',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                    ]
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
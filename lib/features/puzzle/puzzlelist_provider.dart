import 'dart:io';
import 'dart:ui';

import 'package:artificialsw_frontend/services/image_store.dart';
import 'package:artificialsw_frontend/shared/models/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:artificialsw_frontend/features/puzzle/model/puzzlegame.dart';
import 'package:artificialsw_frontend/features/puzzle/model/puzzlepiece_position.dart';

/// 퍼즐 리스트 상태 관리
/// 진행중인 퍼즐과 완료된 퍼즐을 모두 관리
class PuzzleProvider with ChangeNotifier {

  List<PuzzleGame> _puzzles = [
    PuzzleGame(
      puzzleId: 1,
      imageWidget: ImageStore().imageWidgetList[0],
      size: null,
      piecesPosition: [],
      gameState: GameState.Unplayed,
      contributors: [User(name: 'Jaewook', id: 1)],
      isArchived: false,
    ),
    PuzzleGame(
      puzzleId: 2,
      imageWidget: ImageStore().imageWidgetList[1],
      size: null,
      piecesPosition: [],
      gameState: GameState.Unplayed,
      contributors: [User(name: 'JungHwan', id: 2)],
      isArchived: false,
    ),

    PuzzleGame(
      puzzleId: 3,
      imageWidget: ImageStore().imageWidgetList[2],
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
      isArchived: false,
    ),
    PuzzleGame(
      puzzleId: 4,
      imageWidget: ImageStore().imageWidgetList[2],
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
      isArchived: false,
    ),

    PuzzleGame(
      puzzleId: 5,
      imageWidget: ImageStore().imageWidgetList[2],
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
      isArchived: false,
    ),
    PuzzleGame(
      puzzleId: 6,
      imageWidget: ImageStore().imageWidgetList[2],
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
      isArchived: true,
    ),
  ];

  List<PuzzleGame> get puzzles => _puzzles;
  List<PuzzleGame> get ongoingPuzzles =>
      _puzzles.where((p) => p.gameState == GameState.Ongoing).toList();
  List<PuzzleGame> get completedPuzzles =>
      _puzzles.where((p) => p.gameState == GameState.Completed && !p.isArchived).toList();
  List<PuzzleGame> get unplayedPuzzles =>
      _puzzles.where((p) => p.gameState == GameState.Unplayed).toList();
  List<PuzzleGame> get archivedPuzzles =>
      _puzzles.where((p) => p.gameState == GameState.Completed && p.isArchived).toList();


  void startPuzzle(PuzzleGame puzzle) {
    puzzle.gameState = GameState.Ongoing;
    notifyListeners();
  }

  // 퍼즐 삭제
  void deletePuzzle(int id) {
    puzzles.removeWhere((p) => p.puzzleId == id);
    notifyListeners();
  }

  // 퍼즐 완료
  void completePuzzle(PuzzleGame puzzle) {
    puzzle.gameState = GameState.Completed;
    notifyListeners();
  }

  void archivePuzzle(PuzzleGame puzzle) {
    puzzle.isArchived = true;
    notifyListeners();
  }

  void undoArchivePuzzle(PuzzleGame puzzle) {
    puzzle.isArchived = false;
    notifyListeners();
  }
}

/// 퍼즐 목록의 개별 항목 위젯
class PuzzleListItem extends StatelessWidget {
  final PuzzleGame puzzle;
  final VoidCallback onDelete;
  final VoidCallback onPressed;
  final VoidCallback onSave;
  final GameState gameState;

  const PuzzleListItem({
    Key? key,
    required this.puzzle,
    required this.onDelete,
    required this.onPressed,
    required this.onSave,
    required this.gameState,
  }) : super(key: key);

  // 진행중 퍼즐 카드
  Widget OngoingPuzzleCard({
    required VoidCallback onDelete,
    required VoidCallback onPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '주제: ${puzzle.puzzleId}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 4),
        const Text('ai선정 키워드: ~~',
            style: TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 8),
        const Text('진행도: ~~',
            style: TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 12),
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
                child: const Text('삭제하기', style: TextStyle(fontSize: 12)),
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
                child: const Text('진행하기',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ),
          ],
        ),
      ],
    );
  }

// 완료 퍼즐 카드
  Widget CompletedPuzzleCard({
    required VoidCallback onDelete,
    required VoidCallback onPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '주제: ${puzzle.puzzleId}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 4),
        const Text('퍼즐 푼 사람: ~~',
            style: TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 8),
        const Text('메세지: ~~',
            style: TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onSave,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey,
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                child: const Text('아카이빙', style: TextStyle(fontSize: 12)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                child: const Text('다시풀기',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget ArchivedPuzzleCard({
    required VoidCallback onDelete,
    required VoidCallback onSave,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '주제: ${puzzle.puzzleId}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 4),
        const Text('퍼즐 푼 사람: ~~',
            style: TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 8),
        const Text('메세지: ~~',
            style: TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 12),
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
                child: const Text('삭제하기', style: TextStyle(fontSize: 12)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                child: const Text('갤러리에 저장',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ),
          ],
        ),
      ],
    );
  }


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
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 130,
              height: 130,
              child: FittedBox(
                fit: BoxFit.contain,
                child: puzzle.imageWidget,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (gameState == GameState.Ongoing)
                    OngoingPuzzleCard(onDelete: onDelete, onPressed: onPressed),
                  if (gameState == GameState.Completed && puzzle.isArchived == false)
                    CompletedPuzzleCard(onDelete: onDelete, onPressed: onPressed),
                  if (gameState == GameState.Completed && puzzle.isArchived == true)
                    ArchivedPuzzleCard(onDelete: onDelete, onSave: onSave),
                ]
            ),
          ),
        ],
      ),
    );
  }
}
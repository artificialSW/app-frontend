import 'package:artificialsw_frontend/shared/models/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:artificialsw_frontend/features/puzzle/model/puzzlegame.dart';

/// 퍼즐 리스트 상태 관리
class PuzzleProvider with ChangeNotifier {

  List<PuzzleGame> _puzzles = [
    PuzzleGame(
      puzzleId: '1',
      imagePath: 'imagePath_1',
      size: 3,
      completedPiecesId: [1,2,3],
      isCompleted: false,
      contributors: [User(name: 'Jaewook', id: 1), User(name: 'JungHwan', id: 2)],
    ),
    PuzzleGame(
      puzzleId: '2',
      imagePath: 'imagePath_2',
      size: 3,
      completedPiecesId: [1,2,3],
      isCompleted: false,
      contributors: [User(name: 'Jaewook', id: 1)],
    ),
    PuzzleGame(
      puzzleId: '3',
      imagePath: 'imagePath_3',
      size: 3,
      completedPiecesId: [1,2,3],
      isCompleted: false,
      contributors: [],
    ),
    PuzzleGame(
      puzzleId: '4',
      imagePath: 'imagePath_4',
      size: 3,
      completedPiecesId: [1,2,3],
      isCompleted: false,
      contributors: [User(name: 'JungHwan', id: 2)],
    ),
  ];

  List<PuzzleGame> get puzzles => _puzzles;

  void deletePuzzle(String id) {
    _puzzles.removeWhere((puzzle) => puzzle.puzzleId == id);
    notifyListeners();
  }
}

/// 진행중인 퍼즐 목록 페이지
class OngoingPuzzlesPage extends StatelessWidget {
  const OngoingPuzzlesPage({Key? key}) : super(key: key);

  void _showDeleteConfirmationDialog(BuildContext context, String puzzleId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('퍼즐 삭제'),
          content: const Text('진행하신 퍼즐을 삭제하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('아니오'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<PuzzleProvider>(
                  context,
                  listen: false,
                ).deletePuzzle(puzzleId);
                Navigator.of(context).pop();
              },
              child: const Text('예'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '진행중인 퍼즐 목록',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<PuzzleProvider>(
        builder: (context, puzzleProvider, child) {
          if (puzzleProvider.puzzles.isEmpty) {
            return const Center(
              child: Text(
                '진행중인 퍼즐이 없습니다.',
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              itemCount: puzzleProvider.puzzles.length,
              itemBuilder: (context, index) {
                final puzzle = puzzleProvider.puzzles[index];
                return PuzzleListItem(
                  puzzle: puzzle,
                  onDelete:
                      () => _showDeleteConfirmationDialog(context, puzzle.puzzleId),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/puzzle/play');
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class PuzzleListItem extends StatelessWidget {
  final PuzzleGame puzzle;
  final VoidCallback onDelete;
  final VoidCallback onPressed; // onContinue 대신 onPressed로 변경

  const PuzzleListItem({
    Key? key,
    required this.puzzle,
    required this.onDelete,
    required this.onPressed,
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
          // 퍼즐 이미지 영역 (와이어프레임 참고)
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFC0D6E6), // 연한 파란색
              borderRadius: BorderRadius.circular(8),
            ),

            // 퍼즐 그림은 무시했으므로 단순한 색상 박스로 대체
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
                  'AI 선정 키워드(이미지path): ${puzzle.imagePath}',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  '진행도: ${puzzle.completedPiecesId} / ${puzzle.size*puzzle.size}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // 삭제 버튼
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
                        child: const Text('삭제', style: TextStyle(fontSize: 12)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 진행하기 버튼
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

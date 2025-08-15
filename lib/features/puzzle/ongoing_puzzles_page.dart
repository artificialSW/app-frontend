import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// 퍼즐 데이터 모델
class PuzzleItem {
  final String id;
  final String title;
  final String keyword;
  final int progress;
  final int totalPieces;

  PuzzleItem({
    required this.id,
    required this.title,
    required this.keyword,
    required this.progress,
    required this.totalPieces,
  });
}

/// 퍼즐 리스트 상태 관리
class PuzzleProvider with ChangeNotifier {
  List<PuzzleItem> _puzzles = [
    PuzzleItem(
      id: '1',
      title: '우리 가족의 행복한 추억',
      keyword: '겨울',
      progress: 5,
      totalPieces: 25,
    ),
    PuzzleItem(
      id: '2',
      title: '우리 가족의 행복한 추억',
      keyword: '여름',
      progress: 4,
      totalPieces: 16,
    ),
    PuzzleItem(
      id: '3',
      title: '우리 가족의 행복한 추억',
      keyword: '일상',
      progress: 5,
      totalPieces: 25,
    ),
    PuzzleItem(
      id: '4',
      title: '우리 가족의 행복한 추억',
      keyword: '여름',
      progress: 1,
      totalPieces: 25,
    ),
  ];

  List<PuzzleItem> get puzzles => _puzzles;

  void deletePuzzle(String id) {
    _puzzles.removeWhere((puzzle) => puzzle.id == id);
    notifyListeners(); // 리스너(UI)에 상태 변경 알림
  }
}

/// 진행중인 퍼즐 목록 페이지
class OngoingPuzzlesPage extends StatelessWidget {
  const OngoingPuzzlesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Provider를 통해 PuzzleProvider 인스턴스를 제공
    return ChangeNotifierProvider(
      create: (context) => PuzzleProvider(),
      child: Scaffold(
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
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView.builder(
                itemCount: puzzleProvider.puzzles.length,
                itemBuilder: (context, index) {
                  final puzzle = puzzleProvider.puzzles[index];
                  return PuzzleListItem(
                    puzzle: puzzle,
                    onDelete: () => _showDeleteConfirmationDialog(context, puzzle.id),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/puzzle/play');
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  /// 삭제 확인 팝업 메시지를 띄우는 함수
  void _showDeleteConfirmationDialog(BuildContext context, String puzzleId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('퍼즐 삭제'),
          content: const Text('진행하신 퍼즐을 삭제하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: const Text('아니오'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('예'),
              onPressed: () {
                // Provider를 통해 퍼즐 삭제
                Provider.of<PuzzleProvider>(context, listen: false).deletePuzzle(puzzleId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

/// 퍼즐 목록의 개별 항목 위젯
class PuzzleListItem extends StatelessWidget {
  final PuzzleItem puzzle;
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
                Text('주제: ${puzzle.title}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text('AI 선정 키워드: ${puzzle.keyword}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 8),
                Text('진행도: ${puzzle.progress} / ${puzzle.totalPieces}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: const Text('진행하기', style: TextStyle(color: Colors.white, fontSize: 12)),
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
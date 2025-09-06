import 'package:flutter/material.dart';
import '../model/common_question.dart';

/// 공통질문 카드 (하트 토글 + 선택 하이라이트)
class CommonQuestionCard extends StatefulWidget {
  final CommonQuestion question;
  final bool selected;      // 선택 시 하이라이트
  final VoidCallback? onTap;

  const CommonQuestionCard({
    super.key,
    required this.question,
    this.selected = false,
    this.onTap,
  });

  @override
  State<CommonQuestionCard> createState() => _CommonQuestionCardState();
}

class _CommonQuestionCardState extends State<CommonQuestionCard> {
  late int _likes;
  bool _liked = false;

  @override
  void initState() {
    super.initState();
    _likes = widget.question.likes; // 초기 좋아요
  }

  void _toggleLike() {
    setState(() {
      _liked = !_liked;
      _likes = _liked ? _likes + 1 : (_likes > 0 ? _likes - 1 : 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: widget.selected ? Colors.green.withOpacity(0.15) : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: widget.onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 좌: 제목 + 설명
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.question.title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(widget.question.description,
                      style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
            // 우: 좋아요/댓글
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(_liked ? Icons.favorite : Icons.favorite_border, size: 18),
                      onPressed: _toggleLike,
                    ),
                    const SizedBox(width: 4),
                    Text('$_likes'),
                  ],
                ),
                const SizedBox(width: 12),
                Row(
                  children: [
                    const Icon(Icons.chat_bubble_outline, size: 18),
                    const SizedBox(width: 4),
                    Text('${widget.question.comments}'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

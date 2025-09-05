import 'package:flutter/material.dart';
import '../model/personal_question.dart';
import '../chat_personal_send_logic/state/personal_question_send.dart';

class PersonalQuestionCard extends StatefulWidget {
  final PersonalQuestionEntity question;
  final int initialLikes;
  final int commentsCount;
  final bool selected;
  final VoidCallback? onTap;

  const PersonalQuestionCard({
    super.key,
    required this.question,
    required this.initialLikes,
    required this.commentsCount,
    this.selected = false,
    this.onTap,
  });

  @override
  State<PersonalQuestionCard> createState() => _PersonalQuestionCardState();
}

class _PersonalQuestionCardState extends State<PersonalQuestionCard> {
  late int _likes;
  bool _liked = false;

  @override
  void initState() {
    super.initState();
    _likes = widget.initialLikes;
  }

  void _toggleLike() {
    setState(() {
      _liked = !_liked;
      _likes = _liked ? _likes + 1 : (_likes > 0 ? _likes - 1 : 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPrivate = widget.question.visibility == VisibilityType.private;

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
            // 좌측: 제목 + 아이콘(항상 2개)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.question.text,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(2, (i) => const Padding(
                      padding: EdgeInsets.only(right: 6),
                      child: Icon(Icons.person, size: 18),
                    )),
                  ),
                ],
              ),
            ),
            // 우측: 잠금 + 좋아요/댓글
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isPrivate) ...[
                  const Icon(Icons.lock, size: 18),
                  const SizedBox(width: 12),
                ],
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
                    Text('${widget.commentsCount}'),
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

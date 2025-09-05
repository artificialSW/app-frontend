// lib/features/chat/widget/thread_widgets.dart
import 'package:flutter/material.dart';
import 'package:characters/characters.dart';

/// 화면용 최소 대댓글 뷰모델
class ThreadReplyView {
  final String author;
  final String text;
  final int likes;
  final bool liked;
  const ThreadReplyView({
    required this.author,
    required this.text,
    this.likes = 0,
    this.liked = false,
  });
}

/// 댓글 1건 렌더(좋아요/대댓글/펼치기 + 대댓글목록 + 작성자 아바타 최대 2개)
class ThreadCommentTile extends StatelessWidget {
  final String author;
  final String text;
  final int likes;
  final bool liked;
  final List<ThreadReplyView> replies;
  final bool expanded;

  final VoidCallback onToggleLike;
  final VoidCallback onToggleExpand;
  final VoidCallback onTapReply;
  final ValueChanged<int> onToggleReplyLike;

  const ThreadCommentTile({
    super.key,
    required this.author,
    required this.text,
    required this.likes,
    required this.liked,
    required this.replies,
    required this.expanded,
    required this.onToggleLike,
    required this.onToggleExpand,
    required this.onTapReply,
    required this.onToggleReplyLike,
  });

  @override
  Widget build(BuildContext context) {
    final repliers = replies.map((e) => e.author).toSet().toList();
    final avatar2 = repliers.take(2).toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.person, size: 20),
            const SizedBox(width: 8),
            Text(author, style: const TextStyle(fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 6),
          Text(text),
          const SizedBox(height: 6),
          Row(children: [
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: Icon(liked ? Icons.favorite : Icons.favorite_border, size: 18),
              onPressed: onToggleLike,
            ),
            Text('$likes'),
            const SizedBox(width: 12),
            const Icon(Icons.chat_bubble_outline, size: 18),
            const SizedBox(width: 4),
            Text('${replies.length}'),
            const SizedBox(width: 12),
            Row(children: [
              _TinyAvatars(names: avatar2),
              TextButton(
                onPressed: onToggleExpand,
                child: Text(expanded ? 'hide replies' : 'show replies'),
              ),
            ]),
            const SizedBox(width: 8),
            TextButton(onPressed: onTapReply, child: const Text('reply')),
          ]),
          if (expanded && replies.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 4, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(replies.length, (i) {
                  final r = replies[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const Icon(Icons.person, size: 18),
                          const SizedBox(width: 8),
                          Text(r.author, style: const TextStyle(fontWeight: FontWeight.w600)),
                        ]),
                        const SizedBox(height: 4),
                        Text(r.text),
                        Row(children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(r.liked ? Icons.favorite : Icons.favorite_border, size: 18),
                            onPressed: () => onToggleReplyLike(i),
                          ),
                          Text('${r.likes}'),
                        ]),
                      ],
                    ),
                  );
                }),
              ),
            ),
          const Divider(height: 1),
        ],
      ),
    );
  }
}

/// 하단 입력 바
class ThreadInputBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback onSubmit;

  const ThreadInputBar({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
        child: Row(children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onSubmitted: (_) => onSubmit(),
            ),
          ),
          IconButton(icon: const Icon(Icons.send), onPressed: onSubmit),
        ]),
      ),
    );
  }
}

class _TinyAvatars extends StatelessWidget {
  final List<String> names;
  const _TinyAvatars({required this.names});

  @override
  Widget build(BuildContext context) {
    if (names.isEmpty) return const SizedBox.shrink();
    String firstGrapheme(String s) => s.characters.isEmpty ? '?' : s.characters.first;
    return Row(
      children: names.take(2).map((n) {
        return Container(
          margin: const EdgeInsets.only(right: 4),
          width: 18,
          height: 18,
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black12)),
          alignment: Alignment.center,
          child: Text(firstGrapheme(n), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
        );
      }).toList(),
    );
  }
}

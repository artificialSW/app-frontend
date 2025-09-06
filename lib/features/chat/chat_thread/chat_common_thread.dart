// lib/features/chat/chat_thread/chat_common_thread.dart
import 'package:flutter/material.dart';
import '../widget/thread_widgets.dart';   // 공용 위젯
import '../model/common_question.dart';  // CommonQuestion 모델

class ChatCommonThreadPage extends StatefulWidget {
  final CommonQuestion question; // 상단 제목 표시
  final int order;               // N번째 질문
  const ChatCommonThreadPage({super.key, required this.question, required this.order});

  @override
  State<ChatCommonThreadPage> createState() => _ChatCommonThreadPageState();
}

// 페이지 내부 전용 최소 모델
class _Reply { _Reply(this.author, this.text, {this.likes = 0, this.liked = false});
String author, text; int likes; bool liked; }
class _Comment { _Comment(this.id, this.author, this.text,
    {this.likes = 0, this.liked = false, this.expanded = false, List<_Reply>? replies})
    : replies = replies ?? [];
String id, author, text; int likes; bool liked, expanded; List<_Reply> replies; }

class _ChatCommonThreadPageState extends State<ChatCommonThreadPage> {
  final _controller = TextEditingController();
  final List<_Comment> _comments = [
    _Comment('c1', '아빠', '낚시, 골프', likes: 0, replies: [ _Reply('나', '그건 좀...') ]),
    _Comment('c2', '엄마', '뜨개질, 커피', likes: 0, replies: [ _Reply('나', '나도 그렇게 생각해요') ]),
  ];
  String? _replyToId, _replyToAuthor;

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateTime.now().toIso8601String().split('T').first; // YYYY-MM-DD

    return Scaffold(
      appBar: AppBar(title: const Text('공통질문')),
      body: Column(
        children: [
          // 헤더(몇번째/제목/날짜)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${widget.order}번째 질문', style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(widget.question.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(dateStr, style: const TextStyle(fontSize: 12)),
            ]),
          ),
          const Divider(height: 1),

          // 댓글 리스트
          Expanded(
            child: ListView.builder(
              itemCount: _comments.length,
              itemBuilder: (_, i) {
                final c = _comments[i];
                final replies = c.replies
                    .map((r) => ThreadReplyView(author: r.author, text: r.text, likes: r.likes, liked: r.liked))
                    .toList();

                return ThreadCommentTile(
                  author: c.author,
                  text: c.text,
                  likes: c.likes,
                  liked: c.liked,
                  replies: replies,
                  expanded: c.expanded,
                  onToggleLike: () => setState(() { c.liked = !c.liked; c.likes += c.liked ? 1 : (c.likes > 0 ? -1 : 0); }),
                  onToggleExpand: () => setState(() { c.expanded = !c.expanded; }),
                  onTapReply: () => setState(() { _replyToId = c.id; _replyToAuthor = c.author; }),
                  onToggleReplyLike: (rIdx) => setState(() {
                    final r = c.replies[rIdx]; r.liked = !r.liked; r.likes += r.liked ? 1 : (r.likes > 0 ? -1 : 0);
                  }),
                );
              },
            ),
          ),

          // 입력
          ThreadInputBar(
            controller: _controller,
            hintText: _replyToAuthor == null ? '댓글을 입력하세요' : '$_replyToAuthor 님에게 답글',
            onSubmit: () {
              final t = _controller.text.trim();
              if (t.isEmpty) return;
              setState(() {
                if (_replyToId == null) {
                  _comments.add(_Comment(DateTime.now().millisecondsSinceEpoch.toString(), '나', t));
                } else {
                  final i = _comments.indexWhere((e) => e.id == _replyToId);
                  if (i != -1) { _comments[i].replies.add(_Reply('나', t)); _comments[i].expanded = true; }
                }
                _controller.clear(); _replyToId = null; _replyToAuthor = null;
              });
            },
          ),
        ],
      ),
    );
  }
}

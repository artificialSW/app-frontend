import 'package:flutter/material.dart';
import '../widget/thread_widgets.dart';     // ThreadCommentTile, ThreadInputBar, ThreadReplyView
import '../model/personal_question.dart';   // PersonalQuestionEntity
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_top_bar.dart';

class ChatPersonalThreadPage extends StatefulWidget {
  final PersonalQuestionEntity question; // 질문 엔티티(텍스트/작성시각 등)
  final String askerName;                // 질문 작성자 표시용(간단히 문자열)

  const ChatPersonalThreadPage({
    super.key,
    required this.question,
    required this.askerName,
  });

  @override
  State<ChatPersonalThreadPage> createState() => _ChatPersonalThreadPageState();
}

// 페이지 내부 전용 최소 모델 (화면 상태)
class _Reply { _Reply(this.author, this.text, {this.likes = 0, this.liked = false});
String author, text; int likes; bool liked; }

class _Answer { _Answer(this.id, this.author, this.text,
    {this.likes = 0, this.liked = false, this.expanded = false, List<_Reply>? replies})
    : replies = replies ?? [];
String id, author, text; int likes; bool liked, expanded; List<_Reply> replies; }

class _ChatPersonalThreadPageState extends State<ChatPersonalThreadPage> {
  final _controller = TextEditingController();

  // 1차 답변(=상위 댓글) 더미
  final List<_Answer> _answers = [
    _Answer('a1', '할아버지', '날아다녔지', likes: 0),
    _Answer('a2', '동생', '아빠는 21살 때 어땠어요?', likes: 0,
        replies: [ _Reply('나', '그건 좀...') ]),
  ];

  String? _replyToId, _replyToAuthor; // null이면 새 1차답변, 값 있으면 해당 답변에 대댓글

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final dateStr = widget.question.createdAt.toIso8601String().split('T').first; // YYYY-MM-DD

    return Scaffold(
      appBar: CanGoBackTopBar('개인질문', context),
      body: Column(
        children: [
          // 헤더: 내가 작성 태그/큰 제목/날짜
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // 내가 작성 태그
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.plumu_green_main,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '내가 작성',
                  style: AppTextStyles.pretendard_medium.copyWith(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // 질문 텍스트
              Text(
                widget.question.text, 
                style: AppTextStyles.pretendard_bold.copyWith(
                  fontSize: 20,
                  color: AppColors.plumu_black,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              // 날짜
              Text(
                'Jul 24. 2025', // 더미 날짜로 이미지와 맞춤
                style: AppTextStyles.pretendard_regular.copyWith(
                  fontSize: 12,
                  color: AppColors.plumu_gray_5,
                ),
              ),
            ]),
          ),
          const Divider(height: 1, color: AppColors.plumu_gray_2),

          // 1차답변(상위 댓글) 리스트
          Expanded(
            child: ListView.builder(
              itemCount: _answers.length,
              itemBuilder: (_, i) {
                final a = _answers[i];
                final replies = a.replies
                    .map((r) => ThreadReplyView(author: r.author, text: r.text, likes: r.likes, liked: r.liked))
                    .toList();

                return ThreadCommentTile(
                  author: a.author,
                  text: a.text,
                  likes: a.likes,
                  liked: a.liked,
                  replies: replies,
                  expanded: a.expanded,
                  onToggleLike: () => setState(() {
                    a.liked = !a.liked; a.likes += a.liked ? 1 : (a.likes > 0 ? -1 : 0);
                  }),
                  onToggleExpand: () => setState(() => a.expanded = !a.expanded),
                  onTapReply: () => setState(() { _replyToId = a.id; _replyToAuthor = a.author; }),
                  onToggleReplyLike: (rIdx) => setState(() {
                    final r = a.replies[rIdx]; r.liked = !r.liked; r.likes += r.liked ? 1 : (r.likes > 0 ? -1 : 0);
                  }),
                );
              },
            ),
          ),

          // 입력 바 (새 1차답변 or 대댓글)
          ThreadInputBar(
            controller: _controller,
            hintText: _replyToAuthor == null ? '답변을 입력하세요' : '$_replyToAuthor 님에게 답글',
            onSubmit: () {
              final t = _controller.text.trim();
              if (t.isEmpty) return;
              setState(() {
                if (_replyToId == null) {
                  _answers.add(
                      _Answer(DateTime.now().millisecondsSinceEpoch.toString(), '나', t));
                } else {
                  final i = _answers.indexWhere((e) => e.id == _replyToId);
                  if (i != -1) { _answers[i].replies.add(_Reply('나', t)); _answers[i].expanded = true; }
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

import 'package:flutter/material.dart';

/// 쓰레드 화면
/// arguments(Map) 예시: {
///   'id': '...',
///   'question': '할아버지의 21살은 어땠나요?',
///   'members': ['할아버지', '아빠', '동생'],
///   'isPublic': false,
///   'createdAt': 1719300000000,
/// }
class QuestionThreadPage extends StatefulWidget {
  const QuestionThreadPage({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  State<QuestionThreadPage> createState() => _QuestionThreadPageState();
}

class _QuestionThreadPageState extends State<QuestionThreadPage> {
  static const Color _green = Color(0xFF5CBD56);
  final TextEditingController _text = TextEditingController();

  // 어떤 댓글에 답글 쓰는지 (null이면 최상위 댓글)
  _Comment? _replyTarget;

  // 데모용 더미 데이터 구성
  late final List<_Comment> _comments = [
    _Comment(
      id: 'c1',
      author: '할아버지',
      text: '날아다녔지',
      likes: 10,
      children: [],
    ),
    _Comment(
      id: 'c2',
      author: '아빠',
      text: '참 정정하셨죠',
      likes: 10,
      children: [],
    ),
    _Comment(
      id: 'c3',
      author: '할아버지',
      text: '옛날 생각 많이 나네',
      likes: 10,
      children: [
        _Comment(id: 'c3-1', author: '나', text: '맞아요!', likes: 1),
        _Comment(id: 'c3-2', author: '동생', text: '멋져요!', likes: 2),
      ],
    ),
    _Comment(
      id: 'c4',
      author: '동생',
      text: '아빠는 21살 때 어땠어요?',
      likes: 10,
      children: [
        _Comment(id: 'c4-1', author: '나', text: '궁금!', likes: 0),
      ],
    ),
  ];

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _toggleLike(_Comment c) {
    setState(() {
      c.isLiked = !c.isLiked;
      if (c.isLiked) {
        c.likes += 1;
      } else {
        c.likes = (c.likes - 1).clamp(0, 1 << 31);
      }
    });
  }

  void _toggleReplies(_Comment c) {
    setState(() => c.expanded = !c.expanded);
  }

  // 댓글/대댓글 추가
  void _submit() {
    final content = _text.text.trim();
    if (content.isEmpty) return;
    setState(() {
      if (_replyTarget == null) {
        _comments.add(_Comment(
          id: 'c${DateTime.now().microsecondsSinceEpoch}',
          author: '나',
          text: content,
          likes: 0,
        ));
      } else {
        _replyTarget!.children.add(_Comment(
          id: '${_replyTarget!.id}-${DateTime.now().microsecondsSinceEpoch}',
          author: '나',
          text: content,
          likes: 0,
        ));
        _replyTarget!.expanded = true; // 답글 추가 시 자동 펼침
      }
      _text.clear();
      _replyTarget = null;
    });
  }

  // 상단(제목영역) 날짜 포맷
  String _fmtDate(DateTime dt) {
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}. ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final createdAtMs = (widget.data['createdAt'] as int?) ??
        DateTime.now().millisecondsSinceEpoch;
    final createdAt = DateTime.fromMillisecondsSinceEpoch(createdAtMs);
    final question = (widget.data['question'] as String?) ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          '개인질문',
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w700,
            height: 1.5,
            letterSpacing: -0.46,
          ),
        ),
      ),
      body: Column(
        children: [
          // 헤더: "내가 작성" 칩, 제목, 날짜
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                  decoration: BoxDecoration(
                    color: _green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      '내가 작성',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        height: 1.43,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  question,
                  style: const TextStyle(
                    color: Color(0xFF1B1D1B),
                    fontSize: 27,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                    height: 1.33,
                    letterSpacing: -0.32,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _fmtDate(createdAt),
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 15,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                    letterSpacing: -0.46,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // 댓글 리스트
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              itemCount: _comments.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, i) => _CommentTile(
                comment: _comments[i],
                onLike: _toggleLike,
                onToggleReplies: _toggleReplies,
                onReply: (c) => setState(() => _replyTarget = c),
              ),
            ),
          ),

          // 입력 바
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(999),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x14000000),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          )
                        ],
                        border: Border.all(color: Color(0xFFE6E6E6)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _text,
                              textInputAction: TextInputAction.send,
                              onSubmitted: (_) => _submit(),
                              decoration: InputDecoration(
                                hintText: _replyTarget == null
                                    ? 'Reply to zoeyle_'
                                    : 'Reply to ${_replyTarget!.author}',
                                hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          if (_replyTarget != null)
                            IconButton(
                              tooltip: '취소',
                              onPressed: () => setState(() => _replyTarget = null),
                              icon: const Icon(Icons.close_rounded),
                            ),
                          IconButton(onPressed: () {}, icon: const Icon(Icons.image_outlined)),
                          IconButton(onPressed: () {}, icon: const Icon(Icons.gif_box_outlined)),
                          IconButton(onPressed: _submit, icon: const Icon(Icons.send_rounded)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ===================== 댓글 모델/위젯 ===================== */

class _Comment {
  _Comment({
    required this.id,
    required this.author,
    required this.text,
    required this.likes,
    this.children = const [],
  });

  final String id;
  final String author;
  final String text;
  int likes;
  bool isLiked = false;
  bool expanded = false;
  final List<_Comment> children;
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({
    super.key,
    required this.comment,
    required this.onLike,
    required this.onToggleReplies,
    required this.onReply,
    this.depth = 0,
  });

  final _Comment comment;
  final void Function(_Comment) onLike;
  final void Function(_Comment) onToggleReplies;
  final void Function(_Comment) onReply;
  final int depth;

  static const Color _green = Color(0xFF5CBD56);

  @override
  Widget build(BuildContext context) {
    // 깊이에 따라 들여쓰기/세로 라인
    final leftIndent = depth == 0 ? 0.0 : 20.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 아바타
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: _green, width: 2),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Icon(Icons.person, size: 18, color: _green),
            ),
            const SizedBox(width: 8),

            // 본문
            Expanded(
              child: Stack(
                children: [
                  // 세로 라인 (대댓글일 때 보여주기)
                  if (depth > 0)
                    Positioned(
                      left: 0,
                      top: 18,
                      bottom: 0,
                      child: Container(width: 1, color: const Color(0xFFE0E0E0)),
                    ),
                  Padding(
                    padding: EdgeInsets.only(left: leftIndent),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 작성자
                        Text(
                          comment.author,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // 내용
                        Text(
                          comment.text,
                          style: const TextStyle(
                            color: Color(0xFF282828),
                            fontSize: 14,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            height: 1.43,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // 하단 액션(좋아요/댓글/답글)
                        Row(
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(6),
                              onTap: () => onLike(comment),
                              child: Row(
                                children: [
                                  Icon(
                                    comment.isLiked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    size: 16,
                                    color: comment.isLiked
                                        ? _green
                                        : const Color(0xFF1C1C1C),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${comment.likes}',
                                    style: const TextStyle(
                                      color: Color(0xFF1C1C1C),
                                      fontSize: 12,
                                      fontFamily: 'SF Pro',
                                      fontWeight: FontWeight.w400,
                                      height: 1.33,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Icon(Icons.mode_comment_outlined,
                                size: 16, color: Color(0xFF1C1C1C)),
                            const SizedBox(width: 6),
                            Text(
                              '${comment.children.length}',
                              style: const TextStyle(
                                color: Color(0xFF1C1C1C),
                                fontSize: 12,
                                fontFamily: 'SF Pro',
                                fontWeight: FontWeight.w400,
                                height: 1.33,
                              ),
                            ),
                            const SizedBox(width: 12),
                            TextButton(
                              onPressed: () => onReply(comment),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                                minimumSize: const Size(0, 32),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                '답글',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),

                        // show replies / hide replies
                        if (comment.children.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () => onToggleReplies(comment),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // 작은 겹친 아바타 2개
                                  SizedBox(
                                    width: 36,
                                    height: 18,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        _miniAvatar(left: 0),
                                        _miniAvatar(left: 14),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    comment.expanded ? 'hide replies' : 'show replies',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        // 대댓글들
                        if (comment.expanded)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Column(
                              children: [
                                for (final r in comment.children)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 14),
                                    child: _CommentTile(
                                      comment: r,
                                      onLike: onLike,
                                      onToggleReplies: onToggleReplies,
                                      onReply: onReply,
                                      depth: depth + 1,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Divider(height: 24),
      ],
    );
  }

  // 겹쳐 보이는 작은 아바타
  Widget _miniAvatar({required double left}) {
    return Positioned(
      left: left,
      top: 0,
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: _green, width: 1.5),
        ),
        child: const Icon(Icons.person, size: 12, color: _green),
      ),
    );
  }
}

import 'package:flutter/material.dart';

// ✅ ChatStore & 도메인
import '../../../application/chat_store.dart';
import '../../../domain/thread_key.dart';
import '../../../domain/reply.dart';
import '../../../domain/enums.dart';

/// 쓰레드 화면
/// arguments(Map) 예시: {
///   'id': '...',
///   'question': '할아버지의 21살은 어땠나요?',
///   'members': ['할아버지', '아빠', '동생'],
///   'isPublic': false,              // true면 공통, false면 개인
///   'createdAt': 1719300000000,    // ms
/// }
class QuestionThreadPage extends StatefulWidget {
  const QuestionThreadPage({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  State<QuestionThreadPage> createState() => _QuestionThreadPageState();
}

class _QuestionThreadPageState extends State<QuestionThreadPage>
    with AutomaticKeepAliveClientMixin {
  static const Color _green = Color(0xFF5CBD56);
  final TextEditingController _text = TextEditingController();

  // 대댓글 모드 대상
  Reply? _replyTarget;

  // 펼침 상태(id 집합)
  final Set<String> _expanded = <String>{};

  // 현재 사용자(예시)
  final String _me = 'me';

  late final ThreadKey _keyInfo;

  @override
  void initState() {
    super.initState();
    final id = (widget.data['id'] as String?) ?? 'me';
    final isPublic = (widget.data['isPublic'] as bool?) ?? false;
    _keyInfo = ThreadKey(isPublic ? ThreadKind.common : ThreadKind.personal, id);

    // 최초 1회만 로드(이미 캐시 있으면 no-op)
    ChatStore.I.hydrateIfNeeded(_keyInfo).then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  void _toggleLike(Reply r) {
    ChatStore.I.toggleLike(_keyInfo, r.id, _me);
    setState(() {}); // 낙관적 업데이트 즉시 반영
  }

  void _toggleReplies(String id) {
    setState(() {
      if (_expanded.contains(id)) {
        _expanded.remove(id);
      } else {
        _expanded.add(id);
      }
    });
  }

  void _enterReplyMode(Reply parent) {
    setState(() => _replyTarget = parent);
  }

  void _exitReplyMode() {
    setState(() => _replyTarget = null);
  }

  // 댓글/대댓글 추가
  void _submit() {
    final content = _text.text.trim();
    if (content.isEmpty) return;

    final reply = Reply(
      id: UniqueKey().toString(),
      threadId: _keyInfo.id,
      parentId: _replyTarget?.id,
      content: content,
      createdAt: DateTime.now(),
      authorId: _me,
    );

    ChatStore.I.addReply(_keyInfo, reply);
    _text.clear();

    if (_replyTarget != null) {
      // 부모를 자동으로 펼침
      _expanded.add(_replyTarget!.id);
      _exitReplyMode();
    }
    setState(() {});
  }

  String _fmtDate(DateTime dt) {
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}. ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final createdAtMs = (widget.data['createdAt'] as int?) ??
        DateTime.now().millisecondsSinceEpoch;
    final createdAt = DateTime.fromMillisecondsSinceEpoch(createdAtMs);
    final question = (widget.data['question'] as String?) ?? '';
    final isPublic = (widget.data['isPublic'] as bool?) ?? false;

    final thread = ChatStore.I.getThread(_keyInfo);

    // parentId -> children 맵 구축
    final Map<String?, List<Reply>> byParent = <String?, List<Reply>>{};
    for (final r in thread.replies) {
      byParent.putIfAbsent(r.parentId, () => <Reply>[]).add(r);
    }
    // (선택) 정렬 원하면 여기서 byParent[parent]?.sort(...);

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
        title: Text(
          isPublic ? '공통질문' : '개인질문',
          style: const TextStyle(
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
          // 헤더
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
                  child: Center(
                    child: Text(
                      isPublic ? '공통' : '내가 작성',
                      style: const TextStyle(
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

          // 댓글 리스트(트리)
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              itemCount: (byParent[null] ?? const <Reply>[]).length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, i) {
                final top = (byParent[null] ?? const <Reply>[])[i];
                return _ReplyTile(
                  reply: top,
                  depth: 0,
                  byParent: byParent,
                  me: _me,
                  expanded: _expanded.contains(top.id),
                  onToggleExpand: () => _toggleReplies(top.id),
                  onLike: _toggleLike,
                  onReply: _enterReplyMode,
                );
              },
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
                                    ? '댓글을 입력하세요'
                                    : 'Reply to ${_replyTarget!.authorId}',
                                hintStyle: const TextStyle(color: Color(0xFF9E9E9E)),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          if (_replyTarget != null)
                            IconButton(
                              tooltip: '취소',
                              onPressed: _exitReplyMode,
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

/* ===================== 렌더 위젯 ===================== */

class _ReplyTile extends StatelessWidget {
  const _ReplyTile({
    super.key,
    required this.reply,
    required this.depth,
    required this.byParent,
    required this.me,
    required this.expanded,
    required this.onToggleExpand,
    required this.onLike,
    required this.onReply,
  });

  final Reply reply;
  final int depth;
  final Map<String?, List<Reply>> byParent;
  final String me;
  final bool expanded;
  final VoidCallback onToggleExpand;
  final void Function(Reply) onLike;
  final void Function(Reply) onReply;

  static const Color _green = Color(0xFF5CBD56);

  @override
  Widget build(BuildContext context) {
    final children = byParent[reply.id] ?? const <Reply>[];
    final leftIndent = depth == 0 ? 0.0 : 20.0;
    final isLiked = reply.likedBy.contains(me);

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
                          reply.authorId, // authorId를 표기(필요시 닉네임 매핑)
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
                          reply.content,
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
                              onTap: () => onLike(reply),
                              child: Row(
                                children: [
                                  Icon(
                                    isLiked ? Icons.favorite : Icons.favorite_border,
                                    size: 16,
                                    color: isLiked ? _green : const Color(0xFF1C1C1C),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${reply.likedBy.length}',
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
                              '${children.length}',
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
                              onPressed: () => onReply(reply),
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

                        // show/hide replies 토글
                        if (children.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: onToggleExpand,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
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
                                    expanded ? 'hide replies' : 'show replies',
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

                        // 대댓글(재귀)
                        if (expanded)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Column(
                              children: [
                                for (final r in children)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 14),
                                    child: _ReplyTile(
                                      reply: r,
                                      depth: depth + 1,
                                      byParent: byParent,
                                      me: me,
                                      expanded: byParent[r.id]?.isNotEmpty == true,
                                      onToggleExpand: () {}, // 자식의 토글은 상위에서 처리
                                      onLike: onLike,
                                      onReply: onReply,
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

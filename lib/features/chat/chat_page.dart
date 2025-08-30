// lib/features/chat/chat_page.dart
import 'package:flutter/material.dart';

class ChatRoot extends StatefulWidget {
  const ChatRoot({super.key});
  @override
  State<ChatRoot> createState() => _ChatRootState();
}

class _ChatRootState extends State<ChatRoot> with SingleTickerProviderStateMixin {
  late final TabController _tab;

  // ---------------- 개인질문(기존) ----------------
  final List<_QuestionItem> _items = [];
  String? _selectedId; // 탭 순간 하이라이트용

  // ---------------- 공통질문(신규) ----------------
  // 최신이 0번: 0번이 "이번주", 나머지는 과거
  final List<_CommonQuestion> _common = <_CommonQuestion>[
    _CommonQuestion(
      id: 'c5',
      title: '공통질문5',
      subtitle: '이번주 질문: 질문 내용을 적어주세요',
      likes: 10,
      comments: 10,
    ),
    _CommonQuestion(
      id: 'c4',
      title: '공통질문4',
      subtitle: '함께 시작하고 싶은 취미활동이 있나요?',
      likes: 10,
      comments: 10,
    ),
    _CommonQuestion(id: 'c3', title: '공통질문3', subtitle: '질문 내용을 적어주세요', likes: 10, comments: 10),
    _CommonQuestion(id: 'c2', title: '공통질문2', subtitle: '질문 내용을 적어주세요', likes: 10, comments: 10),
    _CommonQuestion(id: 'c1', title: '공통질문1', subtitle: '질문 내용을 적어주세요', likes: 10, comments: 10),
  ];

  bool _weeklyExpanded = false;
  _CommonQuestion? get _weekly => _common.isNotEmpty ? _common.first : null;
  List<_CommonQuestion> get _pastCommon =>
      _common.length <= 1 ? const [] : _common.sublist(1);

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  // ------ 개인: + 버튼 → 생성 플로우 ------
  Future<void> _goCreate() async {
    final result = await Navigator.of(context).pushNamed('/chat/create');
    if (!mounted) return;

    if (result is Map) {
      final members = (result['members'] as List?)?.cast<String>() ?? const [];
      final privacy = (result['privacy'] as String?) ?? 'public';
      final question = (result['question'] as String?) ?? '';

      final item = _QuestionItem(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        question: question.trim().isEmpty ? '개인 질문' : question.trim(),
        members: members,
        isPublic: privacy == 'public',
        likes: 10,
        comments: 10,
        createdAt: DateTime.now(),
      );

      setState(() {
        _items.insert(0, item);
        _tab.index = 0; // 항상 개인질문 탭으로
      });
    }
  }

  // ------ 개인: 쓰레드 열기 ------
  Future<void> _openPersonalThread(_QuestionItem item) async {
    setState(() => _selectedId = item.id);
    await Future.delayed(const Duration(milliseconds: 130));
    if (!mounted) return;

    await Navigator.of(context).pushNamed(
      '/chat/thread',
      arguments: {
        'type': 'personal',
        'id': item.id,
        'title': item.question,
      },
    );

    if (!mounted) return;
    setState(() => _selectedId = null);
  }

  // ------ 공통: 쓰레드 열기 ------
  void _openCommonThread(_CommonQuestion q) {
    Navigator.of(context).pushNamed(
      '/chat/thread',
      arguments: {
        'type': 'common',
        'id': q.id,
        'title': q.title,
        'subtitle': q.subtitle ?? '',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const appBarTitleStyle = TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w700,
      color: Colors.black,
      fontFamily: 'Pretendard',
      height: 1.5,
      letterSpacing: -0.46,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('소통방', style: appBarTitleStyle),
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: const [_HeaderSendIcon()], // DM 아이콘 → /chat/inbox
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),

          // ── 🔽 배너 자체가 "커지는" UI ─────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _WeeklyExpandableBanner(
              collapsedTitle: '🎉 이번주의 공동질문',
              weeklyTitle: _weekly?.title ?? '이번주 공통질문',
              weeklySubtitle: _weekly?.subtitle ?? '',
              expanded: _weeklyExpanded,
              onTap: () => setState(() => _weeklyExpanded = !_weeklyExpanded),
              onReply: (_weekly == null) ? null : () => _openCommonThread(_weekly!),
            ),
          ),

          const SizedBox(height: 14),

          // 탭바
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: TabBar(
                controller: _tab,
                tabs: const [Tab(text: '개인질문'), Tab(text: '공통질문')],
                labelStyle: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Pretendard'),
                unselectedLabelStyle: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Pretendard'),
                labelColor: const Color(0xFF35353F),
                unselectedLabelColor: const Color(0xFF80818B),
                indicatorColor: Colors.black87,
                indicatorWeight: 2,
                indicatorSize: TabBarIndicatorSize.label,
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE6E6E6)),

          // 탭 컨텐츠
          Expanded(
            child: TabBarView(
              controller: _tab,
              physics: const BouncingScrollPhysics(),
              children: [
                // 개인질문 탭
                _QuestionList(
                  items: _items,
                  selectedId: _selectedId,
                  onTap: _openPersonalThread,
                ),
                // 공통질문 탭 (이번주 제외한 과거만 목록)
                _CommonTab(
                  weekly: _weekly,
                  history: _pastCommon,
                  onOpen: _openCommonThread,
                ),
              ],
            ),
          ),
        ],
      ),

      // + 버튼
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFCDCDCD),
        elevation: 4,
        onPressed: _goCreate,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

/* ===================== 개인 질문: 모델/목록/카드 ===================== */

class _QuestionItem {
  _QuestionItem({
    required this.id,
    required this.question,
    required this.members,
    required this.isPublic,
    required this.likes,
    required this.comments,
    required this.createdAt,
  });

  final String id;
  final String question;
  final List<String> members;
  final bool isPublic;
  final int likes;
  final int comments;
  final DateTime createdAt;

  Map<String, dynamic> toMap() => {
    'id': id,
    'question': question,
    'members': members,
    'isPublic': isPublic,
    'likes': likes,
    'comments': comments,
    'createdAt': createdAt.millisecondsSinceEpoch,
  };
}

class _QuestionList extends StatelessWidget {
  const _QuestionList({
    required this.items,
    required this.selectedId,
    required this.onTap,
  });

  final List<_QuestionItem> items;
  final String? selectedId;
  final void Function(_QuestionItem) onTap;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const _EmptyState();

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _QuestionCard(
        item: items[i],
        selected: items[i].id == selectedId,
        onTap: () => onTap(items[i]),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({required this.item, required this.selected, required this.onTap});

  final _QuestionItem item;
  final bool selected;
  final VoidCallback onTap;

  static const _green = Color(0xFF5CBD56);
  static const _title = Color(0xFF282828);

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      color: selected ? Colors.white : _title,
      fontSize: 17,
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w700,
      height: 1.5,
      letterSpacing: -0.46,
    );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: selected ? null : const Color(0xFFF3F3F3),
        gradient: selected
            ? const LinearGradient(
          colors: [Color(0xFFA3E09F), _green],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : null,
        boxShadow: selected
            ? [BoxShadow(color: _green.withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 4))]
            : null,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.question, maxLines: 2, overflow: TextOverflow.ellipsis, style: titleStyle),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _MemberIcons(members: item.members, selected: selected),
                    const Spacer(),
                    _CounterPill(likes: item.likes, comments: item.comments),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MemberIcons extends StatelessWidget {
  const _MemberIcons({required this.members, required this.selected});
  final List<String> members;
  final bool selected;

  static const _green = Color(0xFF5CBD56);

  @override
  Widget build(BuildContext context) {
    final shown = members.take(2).toList();

    return Row(
      children: [
        for (final _ in shown)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: selected ? Colors.white.withOpacity(0.85) : Colors.white,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: _green, width: 2),
              ),
              child: Icon(Icons.person,
                  size: 18, color: selected ? _green.withOpacity(0.95) : _green),
            ),
          ),
      ],
    );
  }
}

class _CounterPill extends StatelessWidget {
  const _CounterPill({required this.likes, required this.comments});
  final int likes;
  final int comments;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 31,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.60),
        borderRadius: BorderRadius.circular(15.5),
      ),
      child: Row(
        children: [
          const Icon(Icons.favorite_border, size: 16, color: Color(0xFF1C1C1C)),
          const SizedBox(width: 4),
          Text('$likes', style: _counterStyle),
          const SizedBox(width: 10),
          const Icon(Icons.mode_comment_outlined, size: 16, color: Color(0xFF1C1C1C)),
          const SizedBox(width: 4),
          Text('$comments', style: _counterStyle),
        ],
      ),
    );
  }

  static const _counterStyle = TextStyle(
    color: Color(0xFF1C1C1C),
    fontSize: 12,
    fontFamily: 'SF Pro',
    fontWeight: FontWeight.w400,
    height: 1.33,
  );
}

/* ===================== 공통 질문: 모델/배너/목록 ===================== */

class _CommonQuestion {
  _CommonQuestion({
    required this.id,
    required this.title,
    this.subtitle,
    this.likes = 0,
    this.comments = 0,
  });

  final String id;
  final String title;      // 카드 상단 굵은 제목 (공통질문5, 4…)
  final String? subtitle;  // 회색 보조 텍스트
  final int likes;
  final int comments;
}

/// 배너가 "그 자리에서" 커지며 이번주 질문 + 답변하기 표시
class _WeeklyExpandableBanner extends StatelessWidget {
  const _WeeklyExpandableBanner({
    required this.collapsedTitle,
    required this.weeklyTitle,
    required this.weeklySubtitle,
    required this.expanded,
    required this.onTap,
    this.onReply,
  });

  final String collapsedTitle; // 접힌 상태: "🎉 이번주의 공동질문"
  final String weeklyTitle;    // 펼친 상태 제목: "공통질문5"
  final String weeklySubtitle; // 펼친 상태 보조 텍스트
  final bool expanded;
  final VoidCallback onTap;
  final VoidCallback? onReply;

  static const _green = const Color(0x4C5CBD56);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _green.withOpacity(0.30),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _green, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: 1,
          )
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: AnimatedCrossFade(
          duration: const Duration(milliseconds: 220),
          crossFadeState:
          expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          firstChild: SizedBox(
            height: 24,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                collapsedTitle,
                style: const TextStyle(
                  color: _green,
                  fontSize: 17,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  height: 1.29,
                ),
              ),
            ),
          ),
          secondChild: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '이번주의 공통질문',
                style: TextStyle(
                  color: _green,
                  fontSize: 13,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                weeklyTitle,
                style: const TextStyle(
                  color: Color(0xFF282828),
                  fontSize: 16,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (weeklySubtitle.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  weeklySubtitle,
                  style: const TextStyle(
                    color: Color(0xFF80818B),
                    fontSize: 13,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: onReply,
                  child: Container(
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _green, width: 1),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      '답변하기',
                      style: TextStyle(
                        color: _green,
                        fontSize: 14,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommonTab extends StatelessWidget {
  const _CommonTab({
    required this.weekly,
    required this.history,
    required this.onOpen,
  });

  final _CommonQuestion? weekly;              // 시그니처 유지 (확장성)
  final List<_CommonQuestion> history;        // 이번주 제외한 리스트
  final void Function(_CommonQuestion q) onOpen;

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) return const _EmptyState();
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: history.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _CommonCard(
        q: history[i],
        onTap: () => onOpen(history[i]),
      ),
    );
  }
}

class _CommonCard extends StatelessWidget {
  const _CommonCard({required this.q, required this.onTap});
  final _CommonQuestion q;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF3F3F3),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                q.title,
                style: const TextStyle(
                  color: Color(0xFF282828),
                  fontSize: 17,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  height: 1.5,
                  letterSpacing: -0.46,
                ),
              ),
              if (q.subtitle != null && q.subtitle!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  q.subtitle!,
                  style: const TextStyle(
                    color: Color(0xFF80818B),
                    fontSize: 13,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 31,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.60),
                    borderRadius: BorderRadius.circular(15.5),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.favorite_border, size: 16, color: Color(0xFF1C1C1C)),
                      SizedBox(width: 4),
                      Text('10', style: _CounterPill._counterStyle),
                      SizedBox(width: 10),
                      Icon(Icons.mode_comment_outlined, size: 16, color: Color(0xFF1C1C1C)),
                      SizedBox(width: 4),
                      Text('10', style: _CounterPill._counterStyle),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ===================== 상단 요소 / 빈 상태 ===================== */

class _HeaderSendIcon extends StatelessWidget {
  const _HeaderSendIcon();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            icon: const Icon(Icons.send_rounded),
            onPressed: () => Navigator.of(context).pushNamed('/chat/inbox'),
          ),
          Positioned(
            right: 4,
            top: 6,
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(color: Color(0xFF5CBD56), shape: BoxShape.circle),
              alignment: Alignment.center,
              child: const Text(
                '5',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    const grayText = Color(0xFF5D5D5D);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            '(빈 페이지 문구)',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: grayText,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1.35,
              fontFamily: 'Pretendard',
            ),
          ),
          SizedBox(height: 8),
          Text(
            '질문이 없어요. 가족에게 궁금했던 점\n을 질문해보세요~',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: grayText,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1.35,
              fontFamily: 'Pretendard',
            ),
          ),
        ],
      ),
    );
  }
}

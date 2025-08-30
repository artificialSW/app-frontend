import 'package:flutter/material.dart';

import 'package:artificialsw_frontend/features/chat/di/di.dart';
import '../../application/chat_store.dart';
import '../../domain/models.dart';

class ChatRoot extends StatefulWidget {
  const ChatRoot({super.key});

  @override
  State<ChatRoot> createState() => _ChatRootState();
}

class _ChatRootState extends State<ChatRoot> with SingleTickerProviderStateMixin {
  late final TabController _tab;
  bool _weeklyExpanded = false;

  String? _selectedPersonalId; // 탭 순간 하이라이트
  String? _selectedCommonId;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);

    // DI + Store 초기화
    ChatDI.ensureInitialized();
    ChatStore.I.init(ChatDI.repo);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  // 개인질문 생성 플로우(기존 라우트 재사용)
  Future<void> _goCreate() async {
    final result = await Navigator.of(context).pushNamed('/chat/create');
    if (!mounted || result is! Map) return;

    final title   = (result['question'] as String? ?? '').trim();
    final privacy = (result['privacy'] as String?) == 'private'
        ? Privacy.private
        : Privacy.public;
    final members = (result['members'] as List?)?.cast<String>() ?? const <String>[];

    final created = await ChatStore.I.createPersonal(
      title: title.isEmpty ? '개인 질문' : title,
      privacy: privacy,
      members: members,
    );

    setState(() {
      _tab.index = 0;
      _selectedPersonalId = created.id;
    });
    await Future<void>.delayed(const Duration(milliseconds: 140));
    if (!mounted) return;
    setState(() => _selectedPersonalId = null);
  }

  // 쓰레드 열기
  Future<void> _openPersonalThread(PersonalQuestion q) async {
    setState(() => _selectedPersonalId = q.id);
    await Future.delayed(const Duration(milliseconds: 130));
    if (!mounted) return;
    await Navigator.of(context).pushNamed('/chat/thread', arguments: {
      'type': 'personal',
      'id': q.id,
      'title': q.title,
    });
    if (!mounted) return;
    setState(() => _selectedPersonalId = null);
  }

  Future<void> _openCommonThread(CommonQuestion q) async {
    setState(() => _selectedCommonId = q.id);
    await Future.delayed(const Duration(milliseconds: 130));
    if (!mounted) return;
    await Navigator.of(context).pushNamed('/chat/thread', arguments: {
      'type': 'common',
      'id': q.id,
      'title': q.title,
    });
    if (!mounted) return;
    setState(() => _selectedCommonId = null);
  }

  // 이번주 공통질문 배너 토글
  void _toggleWeekly() => setState(() => _weeklyExpanded = !_weeklyExpanded);

  @override
  Widget build(BuildContext context) {
    const appBarTitleStyle = TextStyle(
      color: Colors.black,
      fontSize: 17,
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w700,
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
        actions: const [_HeaderSendIcon()],
      ),

      body: Column(
        children: [
          const SizedBox(height: 8),

          // 🎉 이번주 공통질문 - 배너 자체가 커지는 UI
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ValueListenableBuilder<CommonQuestion?>(
              valueListenable: ChatStore.I.weekly,
              builder: (_, weekly, __) {
                return _WeeklyBanner(
                  expanded: _weeklyExpanded,
                  title: '🎉 이번주의 공통질문',
                  question: weekly?.title ?? '이번 주 질문을 불러오는 중...',
                  onTapHeader: _toggleWeekly,
                  onReply: (weekly == null)
                      ? null
                      : () => _openCommonThread(weekly),
                );
              },
            ),
          ),

          const SizedBox(height: 14),

          // 탭
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
                  fontSize: 14,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                ),
                labelColor: const Color(0xFF35353F),
                unselectedLabelColor: const Color(0xFF80818B),
                indicatorColor: Colors.black87,
                indicatorWeight: 2,
                indicatorSize: TabBarIndicatorSize.label,
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE6E6E6)),

          // 탭 바디
          Expanded(
            child: TabBarView(
              controller: _tab,
              physics: const BouncingScrollPhysics(),
              children: [
                // 개인질문 탭
                ValueListenableBuilder<List<PersonalQuestion>>(
                  valueListenable: ChatStore.I.personal,
                  builder: (_, items, __) {
                    if (items.isEmpty) return const _EmptyState();
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) => _PersonalCard(
                        item: items[i],
                        selected: _selectedPersonalId == items[i].id ||
                            ChatStore.I.lastAddedPersonalId == items[i].id,
                        onTap: () => _openPersonalThread(items[i]),
                      ),
                    );
                  },
                ),

                // 공통질문 탭 (지난 주들만, 이번 주 제외)
                ValueListenableBuilder<List<CommonQuestion>>(
                  valueListenable: ChatStore.I.commonHistory,
                  builder: (_, items, __) {
                    if (items.isEmpty) {
                      return const _EmptyState();
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        final q = items[i];
                        return _CommonCard(
                          item: q,
                          selected: _selectedCommonId == q.id,
                          onTap: () => _openCommonThread(q),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFCDCDCD),
        elevation: 4,
        onPressed: _goCreate,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

/* ---------------------- 위젯들 ---------------------- */

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
          // 배지: 실제 인박스 수
          Positioned(
            right: 4,
            top: 6,
            child: ValueListenableBuilder<List<InboxItem>>(
              valueListenable: ChatStore.I.inbox,
              builder: (_, items, __) => Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: Color(0xFF5CBD56),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '${items.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    height: 1.50,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 배너가 ‘자체적으로’ 커지며 내용/버튼이 보이는 UI
class _WeeklyBanner extends StatelessWidget {
  const _WeeklyBanner({
    required this.expanded,
    required this.title,
    required this.question,
    required this.onTapHeader,
    this.onReply,
  });

  final bool expanded;
  final String title;
  final String question;
  final VoidCallback onTapHeader;
  final VoidCallback? onReply;

  static const _green = Color(0xFF5CBD56);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      padding: EdgeInsets.fromLTRB(16, 12, 16, expanded ? 12 : 12),
      decoration: BoxDecoration(
        color: _green.withOpacity(0.30),
        border: Border.all(color: _green, width: 1),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Color(0x19000000), blurRadius: 2, offset: Offset(0, 1), spreadRadius: 1),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더 (타이틀)
          InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: onTapHeader,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: const Text(
                '🎉 이번주의 공통질문',
                style: TextStyle(
                  color: _green,
                  fontSize: 17,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  height: 1.29,
                ),
              ),
            ),
          ),
          // 확장 내용
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  // 질문 텍스트
                  Expanded(
                    child: Text(
                      question,
                      style: const TextStyle(
                        color: _green,
                        fontSize: 14,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        height: 1.45,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // 답변하기 버튼
                  if (onReply != null)
                    Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      child: InkWell(
                        onTap: onReply,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          height: 32,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(color: Color(0x11000000), blurRadius: 2, offset: Offset(0, 1)),
                            ],
                          ),
                          child: const Text(
                            '답변하기',
                            style: TextStyle(
                              color: Color(0xFF1B1D1B),
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
            crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 180),
          ),
        ],
      ),
    );
  }
}

class _PersonalCard extends StatelessWidget {
  const _PersonalCard({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final PersonalQuestion item;
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
                Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: titleStyle),
                const SizedBox(height: 10),
                Row(
                  children: [
                    // 멤버 아이콘(최대 2)
                    Row(
                      children: [
                        for (int i = 0; i < (item.members.length.clamp(0, 2)); i++)
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
                              child: Icon(
                                Icons.person,
                                size: 18,
                                color: selected ? _green.withOpacity(0.95) : _green,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const Spacer(),
                    _CounterPill(likes: item.likes, comments: item.comments, whiteText: selected),
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

class _CommonCard extends StatelessWidget {
  const _CommonCard({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final CommonQuestion item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: selected ? const Color(0xFFADDEAA) : const Color(0xFFF3F3F3),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 텍스트
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 2),
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 17,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                          height: 1.5,
                          letterSpacing: -0.46,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '질문 내용을 적어주세요',
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 12,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          letterSpacing: -0.46,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _CounterPill(likes: item.likes, comments: item.comments),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CounterPill extends StatelessWidget {
  const _CounterPill({
    required this.likes,
    required this.comments,
    this.whiteText = false,
  });
  final int likes;
  final int comments;
  final bool whiteText;

  @override
  Widget build(BuildContext context) {
    final color = whiteText ? Colors.white : const Color(0xFF1C1C1C);
    return Container(
      height: 31,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: whiteText ? Colors.white.withOpacity(0.35) : Colors.white.withOpacity(0.60),
        borderRadius: BorderRadius.circular(15.5),
      ),
      child: Row(
        children: [
          Icon(Icons.favorite_border, size: 16, color: color),
          const SizedBox(width: 4),
          Text('$likes', style: _counterStyle(color)),
          const SizedBox(width: 10),
          Icon(Icons.mode_comment_outlined, size: 16, color: color),
          const SizedBox(width: 4),
          Text('$comments', style: _counterStyle(color)),
        ],
      ),
    );
  }

  TextStyle _counterStyle(Color c) => TextStyle(
    color: c,
    fontSize: 12,
    fontFamily: 'SF Pro',
    fontWeight: FontWeight.w400,
    height: 1.33,
  );
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
          Text('(빈 페이지 문구)',
              textAlign: TextAlign.center,
              style: TextStyle(color: grayText, fontSize: 13, fontWeight: FontWeight.w700, height: 1.35, fontFamily: 'Pretendard')),
          SizedBox(height: 8),
          Text('질문이 없어요. 가족에게 궁금했던 점\n을 질문해보세요~',
              textAlign: TextAlign.center,
              style: TextStyle(color: grayText, fontSize: 13, fontWeight: FontWeight.w700, height: 1.35, fontFamily: 'Pretendard')),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/features/chat/chat_store.dart';

class ChatRoot extends StatefulWidget {
  const ChatRoot({super.key});
  @override
  State<ChatRoot> createState() => _ChatRootState();
}

class _ChatRootState extends State<ChatRoot>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  // 탭 클릭 하이라이트용
  String? _selectedId;

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

  /// + 버튼으로 질문 생성 플로우
  Future<void> _goCreate() async {
    final result = await Navigator.of(context).pushNamed('/chat/create');
    if (!mounted) return;

    if (result is Map) {
      final privacy = (result['privacy'] as String?) ?? 'public';
      final question = (result['question'] as String?)?.trim() ?? '';

      final newItem = QuestionItem(
        id: 'q_${DateTime.now().microsecondsSinceEpoch}',
        title: question.isEmpty ? '개인 질문' : question,
        isPublic: privacy == 'public',
        createdAt: DateTime.now(),
        likes: 10,
        comments: 10,
      );

      // ✅ ChatStore에 추가 (DM으로 온 항목과 동일한 소스)
      final list = [...ChatStore.I.personal.value];
      list.insert(0, newItem);
      ChatStore.I.personal.value = list;
      ChatStore.I.lastAddedId = newItem.id;

      // 항상 개인질문 탭으로 포커스
      _tab.index = 0;
    }
  }

  void _openThread(QuestionItem item) async {
    setState(() => _selectedId = item.id);
    await Future.delayed(const Duration(milliseconds: 130));
    if (!mounted) return;

    await Navigator.of(context).pushNamed('/chat/thread', arguments: {
      'id': item.id,
      'question': item.title,
      'members': const ['나', '가족'], // 데모용
      'isPublic': item.isPublic,
      'likes': item.likes,
      'comments': item.comments,
      'createdAt': item.createdAt.millisecondsSinceEpoch,
    });

    if (!mounted) return;
    setState(() => _selectedId = null);
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
        actions: const [_HeaderSendIcon()],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: _WeeklyQuestionBanner(text: '🎉 이번주의 공동질문'),
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
                tabs: const [Tab(text: '개인질문'), Tab(text: '공동질문')],
                labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Pretendard'),
                unselectedLabelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Pretendard'),
                labelColor: const Color(0xFF35353F),
                unselectedLabelColor: const Color(0xFF80818B),
                indicatorColor: Colors.black87,
                indicatorWeight: 2,
                indicatorSize: TabBarIndicatorSize.label,
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE6E6E6)),

          // 탭 내용
          Expanded(
            child: TabBarView(
              controller: _tab,
              physics: const BouncingScrollPhysics(),
              children: [
                // ✅ 개인질문 = ChatStore 구독
                ValueListenableBuilder<List<QuestionItem>>(
                  valueListenable: ChatStore.I.personal,
                  builder: (_, items, __) {
                    if (items.isEmpty) return const _EmptyState();
                    return ListView.separated(
                      padding:
                      const EdgeInsets.fromLTRB(16, 12, 16, 100),
                      itemCount: items.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(height: 12),
                      itemBuilder: (_, i) => _QuestionCard(
                        item: items[i],
                        selected: items[i].id == _selectedId,
                        isNew:
                        items[i].id == ChatStore.I.lastAddedId,
                        onTap: () => _openThread(items[i]),
                      ),
                    );
                  },
                ),

                // 공동질문 탭(임시)
                const _EmptyState(),
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

/* ===================== 카드 UI ===================== */

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({
    required this.item,
    required this.selected,
    required this.isNew,
    required this.onTap,
  });

  final QuestionItem item;
  final bool selected;
  final bool isNew;
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
        boxShadow: isNew
            ? [const BoxShadow(color: Color(0x225CBD56), blurRadius: 10, offset: Offset(0, 4))]
            : null,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 좌측 녹색 원형 아이콘 (피그마 느낌)
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color:
                    selected ? Colors.white.withOpacity(0.85) : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: _green, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.person,
                      size: 18,
                      color: selected
                          ? _green.withOpacity(0.95)
                          : _green),
                ),
                const SizedBox(width: 10),

                // 제목
                Expanded(
                  child: Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: titleStyle,
                  ),
                ),

                const SizedBox(width: 12),

                // 우측 카운터
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
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.favorite_border, size: 16, color: Color(0xFF1C1C1C)),
          SizedBox(width: 4),
        ],
      ),
    )._withCounts(likes: likes, comments: comments);
  }
}

// 작은 헬퍼 위젯 확장(카운트 텍스트 추가)
extension on Widget {
  Widget _withCounts({required int likes, required int comments}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        this,
        Text('$likes',
            style: const TextStyle(
                color: Color(0xFF1C1C1C),
                fontSize: 12,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w400,
                height: 1.33)),
        const SizedBox(width: 10),
        const Icon(Icons.mode_comment_outlined,
            size: 16, color: Color(0xFF1C1C1C)),
        const SizedBox(width: 4),
        Text('$comments',
            style: const TextStyle(
                color: Color(0xFF1C1C1C),
                fontSize: 12,
                fontFamily: 'SF Pro',
                fontWeight: FontWeight.w400,
                height: 1.33)),
      ],
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
              decoration: const BoxDecoration(
                color: Color(0xFF5CBD56),
                shape: BoxShape.circle,
              ),
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

class _WeeklyQuestionBanner extends StatelessWidget {
  const _WeeklyQuestionBanner({required this.text, this.onTap});
  final String text;
  final VoidCallback? onTap;

  static const _green = Color(0xFF5CBD56);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _green.withOpacity(0.30),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
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
          alignment: Alignment.centerLeft,
          child: Text(
            text,
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

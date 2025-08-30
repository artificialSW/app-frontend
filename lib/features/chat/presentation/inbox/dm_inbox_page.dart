// lib/features/chat/inbox/dm_inbox_page.dart
import 'package:artificialsw_frontend/features/chat/application/chat_store.dart';
import 'package:artificialsw_frontend/features/chat/domain/models.dart';
import 'package:flutter/material.dart';

class DmInboxPage extends StatelessWidget {
  const DmInboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '나에게 온 질문',
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w700,
                height: 1.5,
                letterSpacing: -0.46,
              ),
            ),
            const SizedBox(width: 6),
            ValueListenableBuilder<List<InboxItem>>(
              valueListenable: ChatStore.I.inbox,
              builder: (_, items, __) => _Badge(count: items.length),
            ),
          ],
        ),
      ),
      body: ValueListenableBuilder<List<InboxItem>>(
        valueListenable: ChatStore.I.inbox,
        builder: (context, items, __) {
          if (items.isEmpty) {
            return const _EmptyState();
          }
          return RefreshIndicator(
            onRefresh: ChatStore.I.refreshInbox,
            child: ListView.separated(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) {
                final it = items[i];
                return _InboxCard(
                  key: ValueKey(it.id),
                  item: it,
                  onReply: () {
                    Navigator.of(context).pushNamed(
                      '/chat/inbox/reply',
                      arguments: it, // 모델 그대로 전달
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF5CBD56),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$count',
        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _InboxCard extends StatelessWidget {
  const _InboxCard({super.key, required this.item, required this.onReply});
  final InboxItem item;
  final VoidCallback onReply;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onReply,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 텍스트 영역
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '‘${item.senderName}’가 보냈어요!', // ← 수정: sender → senderName
                        style: const TextStyle(
                          color: Color(0xFF282828),
                          fontSize: 17,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                          height: 1.5,
                          letterSpacing: -0.46,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.preview,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF80818B),
                          fontSize: 14,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                if (item.isPrivate)
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: Icon(Icons.lock_outline, color: Color(0xFFB7B7B7), size: 20),
                  )
                else
                  const SizedBox(width: 20),
                const SizedBox(width: 10),
                _ReplyButton(onTap: onReply),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReplyButton extends StatelessWidget {
  const _ReplyButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
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
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        '새 질문이 없어요',
        style: TextStyle(
          color: Color(0xFF5D5D5D),
          fontSize: 13,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w700,
          height: 1.35,
        ),
      ),
    );
  }
}

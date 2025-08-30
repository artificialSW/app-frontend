// lib/features/chat/inbox/dm_reply_page.dart
import 'package:artificialsw_frontend/features/chat/application/chat_store.dart';
import 'package:artificialsw_frontend/features/chat/domain/models.dart';
import 'package:flutter/material.dart';

class DmReplyPage extends StatefulWidget {
  const DmReplyPage({super.key, required this.item});
  final InboxItem item;

  @override
  State<DmReplyPage> createState() => _DmReplyPageState();
}

class _DmReplyPageState extends State<DmReplyPage> {
  final _c = TextEditingController();
  bool get _enabled => _c.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _c.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final reply = _c.text.trim();
    if (reply.isEmpty) return;

    // 1) 실제 답변 처리 (인박스 제거 + 개인질문 생성)
    await ChatStore.I.answerDm(dmId: widget.item.id, answerText: reply);

    // 2) 완료 화면으로 (초록 화면)
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(
      '/chat/inbox/sent',
      arguments: {'sender': widget.item.senderName}, // ✅ 값은 senderName 사용
    );
  }

  @override
  Widget build(BuildContext context) {
    final sender = widget.item.senderName; // ✅ sender → senderName
    final preview = widget.item.preview;

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
        title: const Text(
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
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '‘$sender’가 보냈어요!',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w800,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              preview,
              style: const TextStyle(
                color: Color(0xFF80818B),
                fontSize: 15,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 240,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFAAAAAA), width: 1),
              ),
              child: TextField(
                controller: _c,
                maxLines: null,
                expands: true,
                textInputAction: TextInputAction.newline,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(16, 14, 16, 14),
                  hintText: '답변을 작성해주세요',
                  hintStyle: TextStyle(
                    color: Color(0xFFAAAAAA),
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const Spacer(),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _enabled ? _submit : null,
                  style: ElevatedButton.styleFrom(
                    disabledBackgroundColor: const Color(0xFFF3F3F3),
                    backgroundColor: const Color(0xFFF3F3F3),
                    foregroundColor: const Color(0xFF282828),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    '답변하기',
                    style: TextStyle(
                      color: Color(0xFF282828),
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                    ),
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

// lib/features/chat/inbox/dm_sent_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/features/chat/chat_store.dart'; // ✅ 스토어 임포트

class DmSentPage extends StatefulWidget {
  const DmSentPage({super.key, required this.payload});
  final Map<String, dynamic> payload;

  @override
  State<DmSentPage> createState() => _DmSentPageState();
}

class _DmSentPageState extends State<DmSentPage> {
  static const _green = Color(0xFF5CBD56);
  Timer? _t;

  @override
  void initState() {
    super.initState();
    // 0.9초 후 자동 이동
    _t = Timer(const Duration(milliseconds: 900), _goThread);
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  void _goThread() {
    // 두 번 호출 방지
    _t?.cancel();

    final sender   = (widget.payload['sender']  as String?) ?? '가족';
    final preview  = (widget.payload['preview'] as String?) ?? '';
    final isPrivate = widget.payload['private'] == true;

    // ✅ 1) 목록에 아이템 추가 (정확한 호출명: ChatStore.I)
    ChatStore.I.addFromDm(sender: sender, preview: preview, isPrivate: isPrivate);

    // ✅ 2) 현재 chat 브랜치 내 네비게이터의 루트로 복귀 (개인질문 탭에서 바로 보임)
    if (!mounted) return;
    Navigator.of(context).popUntil((r) => r.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final sender = (widget.payload['sender'] as String?) ?? '가족';
    return GestureDetector(
      onTap: _goThread, // 탭해도 즉시 이동
      child: Scaffold(
        backgroundColor: _green,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: _green, size: 36),
              ),
              const SizedBox(height: 32),
              Text(
                '‘$sender’에게 답변을\n보냈어요!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  height: 1.33,
                  letterSpacing: -0.05,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

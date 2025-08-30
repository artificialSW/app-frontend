// lib/features/chat/presentation/inbox/dm_sent_page.dart
import 'dart:async';
import 'package:flutter/material.dart';

class DmSentPage extends StatefulWidget {
  const DmSentPage({super.key, required this.payload});
  final Map<String, dynamic> payload;

  @override
  State<DmSentPage> createState() => _DmSentPageState();
}

class _DmSentPageState extends State<DmSentPage> {
  static const _green = Color(0xFF5CBD56);
  Timer? _t;
  bool _done = false;

  @override
  void initState() {
    super.initState();
    _t = Timer(const Duration(milliseconds: 900), _goBackToChat);
  }

  @override
  void dispose() {
    _t?.cancel();
    super.dispose();
  }

  void _goBackToChat() {
    if (_done) return;
    _done = true;
    _t?.cancel();
    if (!mounted) return;

    // 1) 현재 네비게이터 스택에서 첫 라우트까지 pop
    final nav = Navigator.of(context);
    var popped = false;
    nav.popUntil((route) {
      final isFirst = route.isFirst;
      if (isFirst) popped = true;
      return isFirst;
    });
    if (popped) return;

    // 2) (중첩 네비게이터 대비) 루트 네비게이터 기준으로 pop
    final rootNav = Navigator.of(context, rootNavigator: true);
    var rootPopped = false;
    rootNav.popUntil((route) {
      final isRoot = route.isFirst || route.settings.name == '/';
      if (isRoot) rootPopped = true;
      return isRoot;
    });
    if (rootPopped) return;

    // 3) 마지막 안전장치: 루트로 재진입 (앱에서 '/' 라우트가 등록되어 있어야 함)
    rootNav.pushNamedAndRemoveUntil('/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final sender = (widget.payload['sender'] as String?) ?? '가족';
    return GestureDetector(
      onTap: _goBackToChat,
      child: Scaffold(
        backgroundColor: _green,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              _CheckIcon(),
              SizedBox(height: 32),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          top: false,
          minimum: const EdgeInsets.only(bottom: 48),
          child: Text(
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
        ),
      ),
    );
  }
}

class _CheckIcon extends StatelessWidget {
  const _CheckIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: const Icon(Icons.check, color: Color(0xFF5CBD56), size: 36),
    );
  }
}

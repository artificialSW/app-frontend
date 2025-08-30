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

    final navigator = Navigator.of(context);
    var popped = false;

    navigator.popUntil((r) {
      final isRoot = r.settings.name == '/';
      if (isRoot) popped = true;
      return isRoot;
    });

    if (!popped) {
      // 만약 이름이 없는 루트만 남았거나, 중첩 네비게이터인 경우 대비
      navigator.maybePop();
    }
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

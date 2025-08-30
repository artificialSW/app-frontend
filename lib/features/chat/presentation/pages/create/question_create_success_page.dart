// lib/features/chat/question_create_success_page.dart
import 'package:flutter/material.dart';

const _green = Color(0xFF5CBD56); // 배경/체크 컬러

class QuestionCreateSuccessPage extends StatefulWidget {
  const QuestionCreateSuccessPage({super.key, required this.result});
  final Map<String, dynamic> result; // 이전 단계에서 넘겨받은 최종 결과

  @override
  State<QuestionCreateSuccessPage> createState() => _QuestionCreateSuccessPageState();
}

class _QuestionCreateSuccessPageState extends State<QuestionCreateSuccessPage> {
  @override
  void initState() {
    super.initState();
    // 1.2초 후 자동 종료(탭해도 즉시 종료)
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      Navigator.of(context).pop(widget.result); // 결과를 상위로 전달
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(widget.result),
      child: const Scaffold(
        backgroundColor: _green,
        body: SafeArea(
          child: Center(
            child: _SuccessBody(),
          ),
        ),
      ),
    );
  }
}

class _SuccessBody extends StatelessWidget {
  const _SuccessBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 흰색 원 + 초록 체크
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          child: const Center(child: Icon(Icons.check, size: 36, color: _green)),
        ),
        const SizedBox(height: 24),
        const Text(
          '질문을 성공적으로\n보냈어요!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 27,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w700,
            height: 1.33,
            letterSpacing: -0.05,
          ),
        ),
      ],
    );
  }
}

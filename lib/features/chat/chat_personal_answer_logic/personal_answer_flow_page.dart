import 'package:flutter/material.dart';
import 'steps/step_list.dart';
import 'steps/step_write.dart';
import 'steps/step_success.dart';

enum _Step { list, write, success }

class PersonalAnswerFlowPage extends StatefulWidget {
  const PersonalAnswerFlowPage({super.key});

  @override
  State<PersonalAnswerFlowPage> createState() => _PersonalAnswerFlowPageState();
}

class _PersonalAnswerFlowPageState extends State<PersonalAnswerFlowPage> {
  _Step step = _Step.list;
  Map<String, String>? selected;
  String answer = '';

  // 샘플 데이터
  final questions = [
    {'from': '아빠', 'text': '아들 요즘 뭐하고 지내니?'},
    {'from': '엄마', 'text': '오랜만에 같이 영화 볼까?'},
  ];
  void _scheduleReturnToChat() {
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (step == _Step.list) {
      body = StepAnswerList(
        questions: questions,
        onSelect: (q) => setState(() {
          selected = q;
          step = _Step.write;
        }),
      );
    } else if (step == _Step.write) {
      body = StepAnswerWrite(
        question: selected?['text'] ?? '',
        answer: answer,
        onChanged: (v) => setState(() => answer = v),
      );
    } else {
      body = StepAnswerSuccess(to: selected?['from'] ?? '');
      _scheduleReturnToChat(); // 성공 단계 들어오면 복귀 예약
    }

    final canNext = switch (step) {
      _Step.list => false,
      _Step.write => answer.trim().isNotEmpty,
      _Step.success => false,
    };

    return Scaffold(
      appBar: AppBar(title: const Text("나에게 온 질문")),
      body: Padding(padding: const EdgeInsets.all(16), child: body),
      bottomNavigationBar: step == _Step.list
          ? null
          : SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: canNext
                ? () => setState(() => step = _Step.success)
                : null,
            child: Text(step == _Step.write ? "답변하기" : ""),
          ),
        ),
      ),
    );
  }
}

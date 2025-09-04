import 'package:flutter/material.dart';
import '../model/family_member_model.dart';
import 'state/personal_question_send.dart';
import 'steps/step_family.dart';
import 'steps/step_visibility.dart';
import 'steps/step_write.dart';
import 'steps/step_success.dart';

enum _Step { family, visibility, write, success }

class PersonalQuestionFlowPage extends StatefulWidget {
  const PersonalQuestionFlowPage({super.key});

  @override
  State<PersonalQuestionFlowPage> createState() => _FlowState();
}

class _FlowState extends State<PersonalQuestionFlowPage> {
  final _state = PersonalQuestionState();
  int step = 0;

  final members = const [
    FamilyMember(id: '1', name: '아빠'),
    FamilyMember(id: '2', name: '엄마'),
    FamilyMember(id: '3', name: '할아버지'),
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
    if (step == 0) {
      body = StepFamily(
        members: members,
        selected: _state.target,
        onSelect: (m) => setState(() => _state.target = m),
      );
    } else if (step == 1) {
      body = StepVisibility(
        selected: _state.visibility,
        onSelect: (v) => setState(() => _state.visibility = v),
      );
    } else if (step == 2) {
      body = StepWrite(
        text: _state.question,
        onChanged: (t) => setState(() => _state.question = t),
      );
    } else {
      body = const StepSuccess();
      _scheduleReturnToChat(); // 성공 화면일 때 자동 복귀 예약
    }

    final canNext = switch (step) {
      0 => _state.target != null,
      1 => _state.visibility != null,
      2 => _state.question.trim().isNotEmpty,
      _ => false,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('질문 생성')),
      body: Padding(padding: const EdgeInsets.all(16), child: body),
      bottomNavigationBar: step == 3
          ? null
          : SafeArea(
        child: ElevatedButton(
          onPressed: canNext ? () => setState(() => step++) : null,
          child: Text(step == 2 ? '보내기' : '다음'),
        ),
      ),
    );
  }
}

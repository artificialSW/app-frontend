import 'package:flutter/material.dart';
import '../../widget/answer_step_widgets.dart';

class StepAnswerList extends StatelessWidget {
  final List<Map<String, String>> questions;
  final ValueChanged<Map<String, String>> onSelect;

  const StepAnswerList({super.key, required this.questions, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final q = questions[index];
        return PersonalAnswerCard(
          sender: q['from'] ?? '',
          question: q['text'] ?? '',
          isActive: false,
          onReply: () => onSelect(q),
        );
      },
    );
  }
}

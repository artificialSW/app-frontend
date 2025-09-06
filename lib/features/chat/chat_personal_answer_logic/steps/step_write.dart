// lib/features/chat/chat_personal_answer_logic/steps/step_write.dart
import 'package:flutter/material.dart';

class StepAnswerWrite extends StatelessWidget {
  final String question;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const StepAnswerWrite({
    super.key,
    required this.question,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Expanded(
          child: TextField(
            controller: controller,
            maxLines: null,
            expands: true,
            decoration: const InputDecoration(
              hintText: '답변을 작성해주세요',
              border: OutlineInputBorder(),
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

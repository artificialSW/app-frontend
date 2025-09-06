// lib/features/chat/chat_personal_send_logic/steps/step_write.dart
import 'package:flutter/material.dart';

class StepWrite extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const StepWrite({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLength: 150,
      maxLines: null,
      decoration: const InputDecoration(hintText: '질문을 작성해주세요'),
      onChanged: onChanged,
    );
  }
}

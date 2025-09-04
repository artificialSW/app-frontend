import 'package:flutter/material.dart';

class StepWrite extends StatelessWidget {
  final String text;
  final ValueChanged<String> onChanged;
  const StepWrite({super.key, required this.text, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final c = TextEditingController(text: text);
    c.selection = TextSelection.fromPosition(TextPosition(offset: c.text.length));
    return TextField(
      controller: c,
      maxLength: 150,
      maxLines: null,
      decoration: const InputDecoration(hintText: '질문을 작성해주세요'),
      onChanged: onChanged,
    );
  }
}

import 'package:flutter/material.dart';
import '../../widget/send_step_widgets.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const QuestionStepTitle(title: '질문을 작성해주세요'),
        const SizedBox(height: 16),
        QuestionTextInput(
          controller: controller,
          onChanged: onChanged,
          hintText: '질문을 작성해주세요',
          maxLength: 150,
        ),
      ],
    );
  }
}

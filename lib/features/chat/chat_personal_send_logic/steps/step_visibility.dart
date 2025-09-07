import 'package:flutter/material.dart';
import '../state/personal_question_send.dart';
import '../../widget/send_step_widgets.dart';

class StepVisibility extends StatelessWidget {
  final VisibilityType? selected;
  final ValueChanged<VisibilityType> onSelect;

  const StepVisibility({
    super.key,
    this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const QuestionStepTitle(title: '공개 여부를\n선택해주세요'),
        const SizedBox(height: 24),
        Row(
          children: [
            QuestionSelectButton(
              text: '공개',
              isSelected: selected == VisibilityType.public,
              onTap: () => onSelect(VisibilityType.public),
              width: 100,
              height: 48,
            ),
            const SizedBox(width: 12),
            QuestionSelectButton(
              text: '비공개',
              isSelected: selected == VisibilityType.private,
              onTap: () => onSelect(VisibilityType.private),
              width: 100,
              height: 48,
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/models/usermodel.dart';
import '../../widget/send_step_widgets.dart';

class StepFamily extends StatelessWidget {
  final List<User> members;
  final User? selected;
  final ValueChanged<User> onSelect;

  const StepFamily({
    super.key,
    required this.members,
    this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const QuestionStepTitle(title: '가족 구성원을\n선택해주세요'),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: members.map((m) {
            final isSelected = selected?.id == m.id;
            return QuestionSelectButton(
              text: m.name,
              isSelected: isSelected,
              onTap: () => onSelect(m),
              width: 100,
              height: 48,
            );
          }).toList(),
        ),
      ],
    );
  }
}

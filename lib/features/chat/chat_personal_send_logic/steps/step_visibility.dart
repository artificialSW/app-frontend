import 'package:flutter/material.dart';
import '../state/personal_question_send.dart';

class StepVisibility extends StatelessWidget {
  final VisibilityType? selected;
  final ValueChanged<VisibilityType> onSelect;
  const StepVisibility({super.key, this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    children: VisibilityType.values.map((v) {
      return ChoiceChip(
        label: Text(v == VisibilityType.public ? '공개' : '비공개'),
        selected: selected == v,
        onSelected: (_) => onSelect(v),
      );
    }).toList(),
  );
}

import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/models/usermodel.dart';

class StepFamily extends StatelessWidget {
  final List<User> members;
  final User? selected;
  final ValueChanged<User> onSelect;
  const StepFamily({super.key, required this.members, this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: members.map((m) {
      final sel = selected?.id == m.id;
      return ChoiceChip(label: Text(m.name), selected: sel, onSelected: (_) => onSelect(m));
    }).toList(),
  );
}

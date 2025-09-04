import 'package:flutter/material.dart';
import '../../model/family_member_model.dart';

class StepFamily extends StatelessWidget {
  final List<FamilyMember> members;
  final FamilyMember? selected;
  final ValueChanged<FamilyMember> onSelect;
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

import 'package:flutter/material.dart';

class StepAnswerList extends StatelessWidget {
  final List<Map<String, String>> questions;
  final ValueChanged<Map<String, String>> onSelect;

  const StepAnswerList({super.key, required this.questions, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: questions.length,
      itemBuilder: (context, i) {
        final q = questions[i];
        return Card(
          child: ListTile(
            title: Text("${q['from']}가 보냈어요!"),
            subtitle: Text(q['text'] ?? ''),
            trailing: ElevatedButton(
              onPressed: () => onSelect(q),
              child: const Text("답변하기"),
            ),
          ),
        );
      },
    );
  }
}

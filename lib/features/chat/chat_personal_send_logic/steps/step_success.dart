import 'package:flutter/material.dart';

class StepSuccess extends StatelessWidget {
  const StepSuccess({super.key});

  @override
  Widget build(BuildContext context) => const Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle, size: 72),
        SizedBox(height: 12),
        Text('질문을 성공적으로 보냈어요!'),
      ],
    ),
  );
}

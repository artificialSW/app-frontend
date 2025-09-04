import 'package:flutter/material.dart';

class StepAnswerSuccess extends StatelessWidget {
  final String to;

  const StepAnswerSuccess({super.key, required this.to});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("'$to'에게 답변을 보냈어요!", textAlign: TextAlign.center),
    );
  }
}

import 'package:flutter/material.dart';
import '../../widget/answer_step_widgets.dart';

class StepAnswerSuccess extends StatelessWidget {
  final String to;

  const StepAnswerSuccess({super.key, required this.to});

  @override
  Widget build(BuildContext context) {
    return AnswerSuccessScreen(
      message: "'$to'에게 답변을 보냈어요!",
    );
  }
}

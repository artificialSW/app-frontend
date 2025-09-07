import 'package:flutter/material.dart';
import '../../widget/send_step_widgets.dart';

class StepSuccess extends StatelessWidget {
  const StepSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return const QuestionSuccessScreen(
      message: '질문을 성공적으로\n보냈어요!',
    );
  }
}

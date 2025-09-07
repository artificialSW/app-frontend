import 'package:flutter/material.dart';
import '../../widget/answer_step_widgets.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';

class StepAnswerWrite extends StatelessWidget {
  final String question;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const StepAnswerWrite({
    super.key,
    required this.question,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: AppTextStyles.pretendard_bold.copyWith(
            fontSize: 17,
            color: AppColors.plumu_gray_7,
          ),
        ),
        const SizedBox(height: 24),
        AnswerTextInput(
          controller: controller,
          onChanged: onChanged,
          hintText: '답변을 작성해주세요',
        ),
      ],
    );
  }
}

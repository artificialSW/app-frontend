import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import '../model/common_question.dart';
import '../chat_thread/chat_common_thread.dart';

// 이번주 공통질문 배너 위젯
class WeeklyQuestionBanner extends StatelessWidget {
  final CommonQuestion question;
  final int order;

  const WeeklyQuestionBanner({
    super.key,
    required this.question,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatCommonThreadPage(
                  questionId: question.id,
                  order: order,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.plumu_green_30per,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Text('🎉', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Text(
                  '이번주의 공통질문',
                  style: AppTextStyles.pretendard_medium.copyWith(
                    fontSize: 16,
                    color: AppColors.plumu_green_main,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/models/usermodel.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'state/personal_question_send.dart';
import 'steps/step_family.dart';
import 'steps/step_visibility.dart';
import 'steps/step_write.dart';
import 'steps/step_success.dart';

class PersonalQuestionFlowPage extends StatefulWidget {
  const PersonalQuestionFlowPage({super.key});

  @override
  State<PersonalQuestionFlowPage> createState() => _FlowState();
}

class _FlowState extends State<PersonalQuestionFlowPage> {
  final _state = PersonalQuestionState();
  int step = 0;

  late final TextEditingController _questionController;

  final members = [
    User(id: '1', name: '아빠'),
    User(id: '2', name: '엄마'),
    User(id: '3', name: '할아버지'),
    User(id: '4', name: '할머니'),
    User(id: '5', name: '동생'),
  ];

  @override
  void initState() {
    super.initState();
    _questionController = TextEditingController(text: _state.question);
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  void _scheduleReturnToChat() {
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 단계별 본문
    Widget body;
    if (step == 0) {
      body = StepFamily(
        members: members,
        selected: _state.target,
        onSelect: (m) => setState(() => _state.target = m),
      );
    } else if (step == 1) {
      body = StepVisibility(
        selected: _state.visibility,
        onSelect: (v) => setState(() => _state.visibility = v),
      );
    } else if (step == 2) {
      body = StepWrite(
        controller: _questionController,
        onChanged: (t) => setState(() => _state.question = t),
      );
    } else {
      body = const StepSuccess();
      _scheduleReturnToChat();
    }

    // 다음 버튼 활성 조건
    final canNext = switch (step) {
      0 => _state.target != null,
      1 => _state.visibility != null,
      2 => _state.question.trim().isNotEmpty,
      _ => false,
    };

    // 상단바 + 프로그레스 (피그마 간격 맞춤)
    final appBar = AppBar(
      elevation: 0,
      backgroundColor: AppColors.plumu_white,
      centerTitle: true,
      iconTheme: const IconThemeData(color: AppColors.plumu_gray_7),
      title: Text(
        '질문생성',
        style: AppTextStyles.pretendard_bold.copyWith(
          fontSize: 17,
          color: AppColors.plumu_gray_7,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: SizedBox(
            height: 4,
            child: Row(
              children: [
                Expanded(
                  flex: step.clamp(0, 3),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.plumu_green_main,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Expanded(
                  flex: (3 - step).clamp(0, 3),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.plumu_gray_2,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: body,
      ),
      // 성공 단계는 하단 버튼 없음
      bottomNavigationBar: step == 3
          ? null
          : SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: CustomButton(
            text: step == 2 ? '다음' : '다음',
            onPressed: canNext ? () => setState(() => step++) : null,
            width: double.infinity,
            height: 52,
            fontSize: 16,
            textColor: AppColors.plumu_white,
            backgroundColor: AppColors.plumu_green_main,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

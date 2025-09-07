import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'steps/step_list.dart';
import 'steps/step_write.dart';
import 'steps/step_success.dart';

enum _Step { list, write, success }

class PersonalAnswerFlowPage extends StatefulWidget {
  const PersonalAnswerFlowPage({super.key});

  @override
  State<PersonalAnswerFlowPage> createState() => _PersonalAnswerFlowPageState();
}

class _PersonalAnswerFlowPageState extends State<PersonalAnswerFlowPage> {
  _Step step = _Step.list;
  Map<String, String>? selected;
  String answer = '';

  late final TextEditingController _answerController;

  final questions = [
    {'from': '아빠', 'text': '아들 요즘 뭐하고 지내니?'},
    {'from': '엄마', 'text': '오랜만에 같이 영화 볼까?'},
  ];

  @override
  void initState() {
    super.initState();
    _answerController = TextEditingController(text: answer);
  }

  @override
  void dispose() {
    _answerController.dispose();
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
    Widget body;
    if (step == _Step.list) {
      body = StepAnswerList(
        questions: questions,
        onSelect: (q) => setState(() {
          selected = q;
          answer = '';
          _answerController.text = '';
          step = _Step.write;
        }),
      );
    } else if (step == _Step.write) {
      body = StepAnswerWrite(
        question: selected?['text'] ?? '',
        controller: _answerController,
        onChanged: (v) => setState(() => answer = v),
      );
    } else {
      body = StepAnswerSuccess(to: selected?['from'] ?? '');
      _scheduleReturnToChat();
    }

    final canNext = switch (step) {
      _Step.list => false,
      _Step.write => answer.trim().isNotEmpty,
      _Step.success => false,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '나에게 온 질문',
          style: AppTextStyles.pretendard_bold.copyWith(
            fontSize: 17,
            color: AppColors.plumu_gray_7,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.plumu_white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.plumu_gray_7),
        actions: [
          Container(
            width: 16,
            height: 16,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: AppColors.plumu_green_main,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '2',
                style: AppTextStyles.pretendard_medium.copyWith(
                  fontSize: 9,
                  color: AppColors.plumu_white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: body,
      ),
      bottomNavigationBar: step == _Step.list || step == _Step.success
          ? null
          : SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: CustomButton(
            text: '답변하기',
            onPressed: canNext ? () => setState(() => step = _Step.success) : null,
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

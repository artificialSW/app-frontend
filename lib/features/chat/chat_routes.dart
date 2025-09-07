import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/features/chat/chat_mainpage.dart';
import 'package:artificialsw_frontend/features/chat/chat_personal_send_logic/personal_question_flow_page.dart';

import 'chat_personal_answer_logic/personal_answer_flow_page.dart';

Route<dynamic> chatRoutes(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const ChatRoot());

    case '/personal-question': //  개인질문 작성 페이지
      return MaterialPageRoute(builder: (_) => const PersonalQuestionFlowPage());

    case '/personal-answer': // 답변 플로우 추가
      return MaterialPageRoute(builder: (_) => const PersonalAnswerFlowPage());

    default:
      return MaterialPageRoute(builder: (_) => const ChatRoot());
  }
}


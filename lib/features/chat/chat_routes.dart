import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/features/chat/chat_mainpage.dart';
import 'package:artificialsw_frontend/features/chat/chat_personal_send_logic/personal_question_flow_page.dart';

Route<dynamic> chatRoutes(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const ChatRoot());

    case '/personal-question': //  개인질문 작성 페이지
      return MaterialPageRoute(builder: (_) => const PersonalQuestionFlowPage());

    default:
      return MaterialPageRoute(builder: (_) => const ChatRoot());
  }
}


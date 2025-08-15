import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/features/chat/chat_page.dart';
import 'package:artificialsw_frontend/features/chat/question_create_page.dart';

Route<dynamic> chatRoutes(RouteSettings s) {
  // 연결 확인용 로그
  debugPrint('[chat_routes] name=${s.name}, args=${s.arguments}');
  switch (s.name) {
    case '/': // Chat 브랜치 루트
      return MaterialPageRoute(builder: (_) => const ChatRoot());

    case '/chat/create': // 새 채팅 작성
      return MaterialPageRoute(builder: (_) => const QuestionCreatePage());

    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text('존재하지 않는 /chat 라우트')),
        ),
      );
  }
}

//라우팅 경로 추가하는 법 모르겠음 puzzle/puzzle_routes.dart 보고 참고하슈
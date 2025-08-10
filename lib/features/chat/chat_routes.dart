import 'package:artificialsw_frontend/features/chat/chat_page.dart';
import 'package:flutter/material.dart';

Route<dynamic> chatRoutes(RouteSettings s) {
  switch (s.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const ChatRoot());
    default:
      return MaterialPageRoute(builder: (_) => const ChatRoot());
  }
}
//라우팅 경로 추가하는 법 모르겠음 puzzle/puzzle_routes.dart 보고 참고하슈
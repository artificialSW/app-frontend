import 'package:artificialsw_frontend/features/chat/chat_mainpage.dart';
import 'package:flutter/material.dart';

Route<dynamic> chatRoutes(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const ChatRoot());
    default:
      return MaterialPageRoute(builder: (_) => const ChatRoot());
  }
}

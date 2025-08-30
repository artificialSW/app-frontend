// lib/features/chat/chat_routes.dart
import 'package:flutter/material.dart';

// pages
import 'pages/chat_page.dart';
import 'pages/create/question_create_page.dart';
import 'pages/create/question_create_privacy_page.dart';
import 'pages/create/question_create_write_page.dart';
import 'pages/create/question_create_success_page.dart';
import 'pages/thread/question_thread_page.dart';

// inbox
import 'inbox/dm_inbox_page.dart';
import 'inbox/dm_reply_page.dart';
import 'inbox/dm_sent_page.dart';

// domain
import '../domain/models.dart';


Route<dynamic> chatRoutes(RouteSettings s) {
  debugPrint('[chat_routes] name=${s.name}, args=${s.arguments}');
  switch (s.name) {
  // ---------------- 질문 관련 ----------------
    case '/':
      return MaterialPageRoute(builder: (_) => const ChatRoot());

    case '/chat/create':
      return MaterialPageRoute(builder: (_) => const QuestionCreatePage());

    case '/chat/create/privacy': {
      final args = (s.arguments as Map?) ?? const {};
      final members = (args['members'] as List?)?.cast<String>() ?? const [];
      return MaterialPageRoute(
        builder: (_) => QuestionCreatePrivacyPage(selectedMembers: members),
      );
    }

    case '/chat/create/write': {
      final args = (s.arguments as Map?) ?? const {};
      return MaterialPageRoute(
        builder: (_) => QuestionCreateWritePage(
          members: (args['members'] as List?)?.cast<String>() ?? const [],
          privacy: args['privacy'] as String? ?? 'public',
          // TODO: Page 위젯에서 Privacy enum 받도록 고치면 여기서 enum 변환해주기
        ),
      );
    }

    case '/chat/create/success': {
      final result = (s.arguments as Map?)?.cast<String, dynamic>() ?? const {};
      return MaterialPageRoute(
        builder: (_) => QuestionCreateSuccessPage(result: result),
      );
    }

    case '/chat/thread': {
      final args = (s.arguments as Map?)?.cast<String, dynamic>() ?? const {};
      return MaterialPageRoute(builder: (_) => QuestionThreadPage(data: args));
    }

  // ---------------- DM 관련 ----------------
    case '/chat/inbox':
      return MaterialPageRoute(builder: (_) => const DmInboxPage());

    case '/chat/inbox/reply': {
      final item = s.arguments as InboxItem;
      return MaterialPageRoute(builder: (_) => DmReplyPage(item: item));
    }

    case '/chat/inbox/sent': {
      final payload = (s.arguments as Map<String, dynamic>?) ?? const {};
      return MaterialPageRoute(builder: (_) => DmSentPage(payload: payload));
    }

  // ---------------- fallback ----------------
    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text('존재하지 않는 /chat 라우트')),
        ),
      );
  }
}
import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/features/chat/chat_page.dart';
import 'package:artificialsw_frontend/features/chat/question_create_page.dart';
import 'package:artificialsw_frontend/features/chat/question_create_privacy_page.dart'; // ✅ 추가
import 'package:artificialsw_frontend/features/chat/question_create_write_page.dart';
import 'package:artificialsw_frontend/features/chat/question_create_success_page.dart';
import 'package:artificialsw_frontend/features/chat/question_thread_page.dart';

import 'package:artificialsw_frontend/features/chat/inbox/dm_inbox_page.dart';
import 'package:artificialsw_frontend/features/chat/inbox/dm_reply_page.dart';
import 'package:artificialsw_frontend/features/chat/inbox/dm_sent_page.dart';

Route<dynamic> chatRoutes(RouteSettings s) {
  debugPrint('[chat_routes] name=${s.name}, args=${s.arguments}');
  switch (s.name) {
    case '/chat/thread': {
      final args = (s.arguments as Map?)?.cast<String, dynamic>() ?? const {};
      return MaterialPageRoute(builder: (_) => QuestionThreadPage(data: args));
    }

    case '/chat/create/success': {
      final result = (s.arguments as Map?)?.cast<String, dynamic>() ?? const {};
      return MaterialPageRoute(
        builder: (_) => QuestionCreateSuccessPage(result: result),
      );
    }

    case '/chat/create/write': {
      final args = (s.arguments as Map?) ?? const {};
      return MaterialPageRoute(
        builder: (_) => QuestionCreateWritePage(
          members: (args['members'] as List?)?.cast<String>() ?? const [],
          privacy: args['privacy'] as String? ?? 'public',
        ),
      );
    }
    case '/':
      return MaterialPageRoute(builder: (_) => const ChatRoot());

    case '/chat/create':
      return MaterialPageRoute(builder: (_) => const QuestionCreatePage());

    case '/chat/create/privacy': // ✅ 추가
      final args = (s.arguments as Map?) ?? const {};
      final members = (args['members'] as List?)?.cast<String>() ?? const [];
      return MaterialPageRoute(
        builder: (_) => QuestionCreatePrivacyPage(selectedMembers: members),
      );

  // ✅ 쓰레드(기존)
    case '/chat/thread': {
      final args = (s.arguments as Map?)?.cast<String, dynamic>() ?? const {};
      return MaterialPageRoute(builder: (_) => QuestionThreadPage(data: args));
    }

  // ✅ DM 목록
    case '/chat/inbox':
      return MaterialPageRoute(builder: (_) => const DmInboxPage());

  // ✅ DM 답변 작성
    case '/chat/inbox/reply': {
      final q = (s.arguments as Map?)?.cast<String, dynamic>() ?? const {};
      return MaterialPageRoute(builder: (_) => DmReplyPage(question: q));
    }

  // ✅ DM 답변 완료(초록 화면)
    case '/chat/inbox/sent': {
      final args = (s.arguments as Map?)?.cast<String, dynamic>() ?? const {};
      return MaterialPageRoute(builder: (_) => DmSentPage(payload: args));
    }

    default:
      return MaterialPageRoute(
        builder: (_) => const Scaffold(
          body: Center(child: Text('존재하지 않는 /chat 라우트')),
        ),
      );
  }
}

//라우팅 경로 추가하는 법 모르겠음 puzzle/puzzle_routes.dart 보고 참고하슈
// lib/main.dart
import 'package:flutter/material.dart';

// ✅ Shell은 lib/shared/shell.dart
import 'package:artificialsw_frontend/shell.dart';

// ✅ Chat 초기화 (Store + MockRepo)
import 'package:artificialsw_frontend/features/chat/application/chat_store.dart';
import 'package:artificialsw_frontend/features/chat/data/mock_chat_repository.dart';

// ✅ Chat 라우트 테이블 (파일명: chat_routes.dart)
import 'package:artificialsw_frontend/features/chat/presentation/chat_routes.dart';

// 앱 전역 라우터: '/'는 Shell, 나머지는 chatRoutes로 위임
Route<dynamic> appRoutes(RouteSettings s) {
  switch (s.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const Shell());
    default:
    // '/chat/...' 포함한 나머지 라우트는 chatRoutes가 처리
      return chatRoutes(s);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // DI/Store 초기화
  await ChatStore.I.init(MockChatRepository());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // ✅ 네임드 라우트 사용
      onGenerateRoute: appRoutes,
      initialRoute: '/', // 루트는 Shell

      // onGenerateRoute를 쓰므로 home은 지정하지 않아요.
      // home: const Shell(),
    );
  }
}

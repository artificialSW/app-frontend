// lib/main.dart
import 'package:artificialsw_frontend/services/image_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:artificialsw_frontend/features/puzzle/puzzlelist_provider.dart';
import 'package:artificialsw_frontend/shell.dart';
import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/features/chat/application/chat_store.dart';
import 'package:artificialsw_frontend/features/chat/data/mock_chat_repository.dart';
import 'package:artificialsw_frontend/features/chat/presentation/chat_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ChatStore.I.init(MockChatRepository());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageStore()), // 이미지스토어 등록
        ChangeNotifierProvider(create: (_) => PuzzleProvider()), // 이미 쓰고 있는 퍼즐 프로바이더
        // 다른 provider도 여기에 추가 가능
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Shell(),
    );
  }
}

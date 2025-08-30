// lib/main.dart
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
    ChangeNotifierProvider(
      create: (context) => PuzzleProvider(),
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

import 'package:artificialsw_frontend/shell.dart';
import 'package:flutter/material.dart';

import 'features/chat/application/chat_store.dart';
import 'features/chat/data/mock_chat_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ChatStore.I.init(MockChatRepository());
  runApp(const MyApp());
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
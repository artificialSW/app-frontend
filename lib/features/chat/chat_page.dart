import 'package:flutter/material.dart';

class ChatRoot extends StatelessWidget {
  const ChatRoot({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Center(
        child: Text("소통방 페이지")
      ),
    );
  }
}
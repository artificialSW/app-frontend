import 'package:artificialsw_frontend/shell.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:artificialsw_frontend/features/puzzle/puzzlelist_ongoing.dart';

void main() {
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
import 'package:artificialsw_frontend/shared/widgets/custom_top_bar.dart';
import 'package:flutter/material.dart';

class HomeRoot extends StatelessWidget {
  const HomeRoot({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomTopBar(),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const DetailPage(title: 'Home detail')),
            );
          },
          child: const Text('Go detail'),
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(child: Text('detail')),
    );
  }
}
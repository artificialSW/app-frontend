import 'package:artificialsw_frontend/services/image_store.dart';
import 'package:flutter/material.dart';


class AddCommentPage extends StatelessWidget {
  const AddCommentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Comment Page")),
      body: Center(
        child: Column(
          children: [
            Text("맛있었던 과일"),
            ImageStore().imageWidgetList[0],
            TextField(
              decoration: InputDecoration(
                labelText: '코멘트를 남겨주세요.',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30,),
            Text("좋았던 식사"),
            ImageStore().imageWidgetList[1],
            TextField(
              decoration: InputDecoration(
                labelText: '코멘트를 남겨주세요.',
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('/'),
                child: const Text("코멘트 저장하기")
            ),
          ]
        )
      ),
    );
  }
}

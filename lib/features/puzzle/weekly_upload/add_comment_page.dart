import 'package:artificialsw_frontend/services/image_store.dart';
import 'package:artificialsw_frontend/services/puzzle/puzzle_service.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


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
            CustomButton(
                text: '코멘트 저장하기',
                onPressed: () async {
                  final imageStore = Provider.of<ImageStore>(context, listen: false); // 예시: 이미지들 저장된 상태관리
                  try {
                    // 배열에 저장된 이미지들 서버에 순차 업로드
                    for (final imageData in imageStore.imageFileList) {
                      await PuzzleService().uploadPuzzleImageWithMetadata(
                        imageFile: imageData,
                        comment: ,
                        userId: ,
                        category: ,
                      );
                    }

                    // ✅ 모두 업로드 성공 시 홈으로 이동
                    Navigator.of(context).pushNamed('/');
                  } catch (e) {
                    print('❌ 업로드 실패: $e');
                    // TODO: 실패 시 사용자에게 토스트나 SnackBar 등 알림 가능
                  }
                },
            )
          ]
        )
      ),
    );
  }
}

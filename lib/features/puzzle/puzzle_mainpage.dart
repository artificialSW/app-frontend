import 'package:artificialsw_frontend/services/image_store.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PuzzleRoot extends StatefulWidget {
  const PuzzleRoot({super.key});

  @override
  State<PuzzleRoot> createState() => _PuzzleRootState();
}

class _PuzzleRootState extends State<PuzzleRoot> {
  @override
  Widget build(BuildContext context) {

    return Scaffold( // 이 Scaffold를 추가합니다.
      appBar: PuzzlRootTopBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 300,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFC0D6E6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text("이번주의 퍼즐 키워드: ~~~")
          ),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("진행중"),
              ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed('/puzzle/ongoing-list'),
                  child: const Text(">")
              ),
            ]
          ),
          Container(
            width: 400,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFC0D6E6),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          SizedBox(height: 30,),
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("이번 주 풀어진 퍼즐"),
                ElevatedButton(
                    onPressed: () => Navigator.of(context).pushNamed('/puzzle/completed-list'),
                    child: const Text(">")
                ),
              ]
          ),
          Container(
            width: 400,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFC0D6E6),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                text: '사진 업로드',
                onPressed: () => Navigator.of(context).pushNamed('/puzzle/image-upload-test'),
                width: 150,
                fontSize: 13,
              ),
              SizedBox(width: 20),
              CustomButton(
                text: '퍼즐 아카이브',
                onPressed: () => Navigator.of(context).pushNamed('/puzzle/archive'),
                width: 150,
                fontSize: 13,
              )

            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer<ImageStore>(
                builder: (context, imageStore, child) {
                  return CustomButton(
                    text: '퍼즐 맞추기',
                    onPressed: imageStore.isNotEmpty
                        ? () => Navigator.of(context).pushNamed('/puzzle/write-puzzle-info')
                        : null,
                    width: 150,
                    fontSize: 13,
                  );
                },
              ),
              SizedBox(width: 20),
              CustomButton(
                text: 'Plumu Asset 구경하기',
                onPressed: () => Navigator.of(context).pushNamed('/puzzle/assetView'),
                width: 150,
                fontSize: 13,
              )
            ],
          ),
        ],
      ),
    );
  }
}
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_top_bar.dart';
import 'package:flutter/material.dart';

class HomeRoot extends StatelessWidget {
  const HomeRoot({super.key});
  @override
  Widget build(BuildContext context) {
    final double chat_percent = 0.1;
    final double puzzle_percent = 0.2;
    final double tree_percent = 0.3;

    //TODO(서버에 현재 열매랑 꽃 종류와 개수 아마 맵 형태로..? 요청하기)

    return Scaffold(
      appBar: HomeTopBar(),
      body: Column(
        children: [
          Container(
            height: 30,
            child: LinearProgressIndicator(value: chat_percent),
          ),
          SizedBox(height: 15),
          Container(
            height: 30,
            child: LinearProgressIndicator(value: puzzle_percent),
          ),
          SizedBox(height: 15),

          //말풍선
          Stack(
            children: [
              DecoratedBox(
                  decoration: BoxDecoration(color: AppColors.plumu_green_main),
                  child: Text('간단한 메세지를 남겨봐요!')
              ),
            ]
          ),
          SizedBox(height: 30),
          SizedBox(
            width: 350, height: 350,
            child: Stack(
              children: [
                Positioned(
                    top: 0,
                    left: 20,
                    child: Image.asset(
                      AppAssets.tree,
                      width: 300,
                      height: 300,
                      fit: BoxFit.contain,
                    )
                ),
                Positioned(
                    top: 200,
                    left: 250,
                    child: Image.asset(AppAssets.wooden_sign)
                )
              ],
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.plumu_gray_4,
            ),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  Container(
                    height: 20,
                    child: LinearProgressIndicator(value: tree_percent),
                  ),
                  SizedBox(height: 10),
                  CustomButton(text: '나무 아카이브', onPressed: null)
                ],
              ),
            )
          )

        ],
      )
    );
  }
}
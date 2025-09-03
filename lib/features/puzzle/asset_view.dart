import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:flutter/material.dart';


class AssetView extends StatelessWidget {
  const AssetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plumu Asset'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Image.asset(AppAssets.logo),
              Image.asset(AppAssets.logo),
              Image.asset(AppAssets.logo),
              Image.asset(AppAssets.logo),
              Image.asset(AppAssets.logo),
              Text("------------"),
            ],
          ),
          Image.asset(AppAssets.logo_withTypo1),
          Image.asset(AppAssets.logo_withTypo2),
          Image.asset(AppAssets.appicon_whiteBackground),
          Image.asset(AppAssets.appicon_greenBackground),
          Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 60,
                    height: 30,
                    color: AppColors.plumu_black,
                  ),
                  Text("plumu black | "),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: 60,
                    height: 30,
                    color: AppColors.plumu_gray_1,
                  ),
                  Text("plumu gray1 | "),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: 60,
                    height: 30,
                    color: AppColors.plumu_gray_5,
                  ),
                  Text("plumu gray5 | "),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: 60,
                    height: 30,
                    color: AppColors.plumu_gray_8,
                  ),
                  Text("plumu gray8"),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 60,
                    height: 30,
                    color: AppColors.plumu_green_30per,
                  ),
                  Text("green 30% | "),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: 60,
                    height: 30,
                    color: AppColors.plumu_green_50per,
                  ),
                  Text("green 50% | "),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: 60,
                    height: 30,
                    color: AppColors.plumu_green_main,
                  ),
                  Text("green_main"),
                ],
              ),
            ],
          ),
          Text(
            'font: null(기본값)',
            style: TextStyle(fontSize: 18.95),
            textAlign: TextAlign.center,
          ),
          Text(
            'font: plumu AvantGarde',
            textAlign: TextAlign.center,
            style: AppTextStyles.plumu,
          ),
          Text(
            'font: pretendard',
            style: AppTextStyles.pretendard_bold.copyWith(fontSize: 18.95),
            textAlign: TextAlign.center,
          ),
        ],
      )
    );
  }
}

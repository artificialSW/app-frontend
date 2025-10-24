import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';

class FruitCardDialog extends StatelessWidget {
  final String imageUrl;
  final String category;
  final String message;

  const FruitCardDialog({
    super.key,
    required this.imageUrl,
    required this.category,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter, // 👈 하단 기준
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      imageUrl,
                      width: 260,
                      height: 260,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 20,),
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.plumu_green_main,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$category',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    '$message',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: const Divider(
                  color: Color(0x66FFFFFF),
                  thickness: 1,
                  height: 18, // 위아래 여백 약간
                ),
              ),
            ),
            const SizedBox(height: 20), // 더 줄여서 병아리 위쪽 공간 최대한 확보
            ClipRect(
              child: Align(
                alignment: Alignment.topCenter, // 위쪽 기준으로 맞춤
                heightFactor: 0.7, // 0.65에서 0.7로 더 늘려서 모자 위쪽이 완전히 보이도록
                child: Image.asset(
                  'assets/images/app_character.png',
                  width: 280,
                  height: 280,
                  fit: BoxFit.contain, // cover에서 contain으로 변경하여 이미지 전체가 보이도록
                ),
              ),
            ),
            
            // 돌아가기 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: CustomButton(
                text: '돌아가기',
                onPressed: () => Navigator.pop(context),
                width: MediaQuery.of(context).size.width - 56, // 좌우 패딩 28씩 제외
                height: 52,
                fontSize: 16,
                backgroundColor: const Color(0xFFF3F3F3),
                textColor: const Color(0xFF5CBD56),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            
            const SizedBox(height: 28), // 하단 패딩
          ],
        ),
      ),
    );
  }
}
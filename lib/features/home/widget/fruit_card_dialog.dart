import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';

// class FruitCardDialog extends StatelessWidget {
//   final String imageUrl;
//   final String category;
//   final String message;
//
//   const FruitCardDialog({
//     super.key,
//     required this.imageUrl,
//     required this.category,
//     required this.message,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       // showDialog()의 child로 직접 들어가기 때문에 Center로 감쌉니다.
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.85,
//         decoration: BoxDecoration(
//           color: const Color(0xFF1E1E1E), // 어두운 톤 배경
//           borderRadius: BorderRadius.circular(24),
//         ),
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // 🖼️ 상단 이미지
//             ClipRRect(
//               borderRadius: BorderRadius.circular(16),
//               child: Image.network(
//                 imageUrl,
//                 width: double.infinity,
//                 height: 280,
//                 fit: BoxFit.cover,
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             // 💬 카테고리 (작은 초록 말풍선)
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF4CAF50),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 category,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 13,
//                 ),
//               ),
//             ),
//
//             const SizedBox(height: 10),
//
//             // 📝 메시지
//             Text(
//               message,
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


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
            const SizedBox(height: 56),
            ClipRect(
              child: Align(
                alignment: Alignment.topCenter, // 위쪽 기준으로 맞춤
                heightFactor: 0.6, // 👈 0.0~1.0 (1.0 = 전체, 0.5면 상단 절반만 보임)
                child: Image.asset(
                  'assets/images/app_character.png',
                  width: 280,
                  height: 280,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
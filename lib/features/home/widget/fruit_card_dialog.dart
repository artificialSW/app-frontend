import 'package:flutter/material.dart';

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
    return Center(
      // showDialog()의 child로 직접 들어가기 때문에 Center로 감쌉니다.
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E), // 어두운 톤 배경
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🖼️ 상단 이미지
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 280,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            // 💬 카테고리 (작은 초록 말풍선)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                category,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 📝 메시지
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

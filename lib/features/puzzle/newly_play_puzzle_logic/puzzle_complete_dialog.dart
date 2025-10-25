import 'package:flutter/material.dart';

class PuzzleCompleteDialog extends StatelessWidget {
  final String imageUrl; // 퍼즐 이미지 (asset 경로)
  final String message;  // 상단 축하 메시지

  const PuzzleCompleteDialog({
    super.key,
    required this.imageUrl,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter, // 👈 하단 기준
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '🎉 퍼즐 완성! 메세지: $message',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                imageUrl,
                width: 260,
                height: 260,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            ClipRect(
              child: Align(
                alignment: Alignment.topCenter, // 위쪽 기준으로 맞춤
                heightFactor: 0.6, // 👈 0.0~1.0 (1.0 = 전체, 0.5면 상단 절반만 보임)
                child: Image.asset(
                  'assets/images/dogaam_and_archive_button/chick_big.png',
                  width: 280,
                  height: 280,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
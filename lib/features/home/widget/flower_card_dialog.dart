import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';

class FlowerCardDialog extends StatelessWidget {
  final dynamic flowerCardData;

  const FlowerCardDialog({
    super.key,
    required this.flowerCardData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.indigo,
      child: Text("빈 화면!!!!!!1"),
    );
  }
}
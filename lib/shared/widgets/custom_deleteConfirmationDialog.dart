import 'package:artificialsw_frontend/features/puzzle/puzzlelist_provider.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteConfirm extends StatelessWidget {

  final String title;
  final String content;
  final String no_Button;
  final String yes_Button;
  final String puzzleId;

  const DeleteConfirm({
    required this.title,
    required this.content,
    this.no_Button = '아니오',
    this.yes_Button = '예',
    required this.puzzleId,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false), // 취소
          child: Text(no_Button),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true), // 확인
          child: Text(
            yes_Button,
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}

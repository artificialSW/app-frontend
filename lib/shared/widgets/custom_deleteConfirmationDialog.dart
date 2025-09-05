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
  final int puzzleId;

  const DeleteConfirm({
    required this.title,
    required this.content,
    this.no_Button = '아니오',
    this.yes_Button = '예',
    required this.puzzleId,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // 모서리 둥글게
      ),
      backgroundColor: AppColors.alart_background,
      child: SizedBox(
        width: 280,   // 원하는 너비 지정
        height: 150,  // 원하는 높이 지정 (AlertDialog보다 줄임)
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              Text(
                title,
                style: TextStyle(
                  color: AppColors.plumu_gray_7,
                  fontSize: 16,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  height: 1.41,
                ),
              ),
              Text(
                content,
                style: TextStyle(
                  color: AppColors.plumu_gray_7,
                  fontSize: 14,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  height: 1.71,
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomButton(
                    text: no_Button,
                    onPressed: () => Navigator.of(context).pop(),
                    height: 40,
                    width: 111,
                    backgroundColor: AppColors.plumu_white,
                    textColor: AppColors.plumu_gray_7,
                  ),
                  CustomButton(
                    text: yes_Button,
                    onPressed: () {
                      Provider.of<PuzzleProvider>(
                        context,
                        listen: false,
                      ).deletePuzzle(puzzleId);
                      Navigator.of(context).pop();
                    },
                    height: 40,
                    width: 111,
                    backgroundColor: AppColors.plumu_white,
                    textColor: AppColors.plumu_gray_7,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

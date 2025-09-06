// lib/features/chat/widget/common_question_card.dart
import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import '../model/common_question.dart';

class CommonQuestionCard extends StatefulWidget {
  final CommonQuestion question;
  final bool selected;      // 외부에서 쓰면 유지(이번 구현은 press 효과 중심)
  final VoidCallback? onTap;

  const CommonQuestionCard({
    super.key,
    required this.question,
    this.selected = false,
    this.onTap,
  });

  @override
  State<CommonQuestionCard> createState() => _CommonQuestionCardState();
}

class _CommonQuestionCardState extends State<CommonQuestionCard> {
  late int _likes = widget.question.likes;
  bool _liked = false;
  bool _pressed = false; // 누르는 동안만 true

  void _toggleLike() {
    setState(() {
      _liked = !_liked;
      _likes = _liked ? _likes + 1 : (_likes > 0 ? _likes - 1 : 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    // 배경: 기본 회색 / 프레스 시 초록 그라데이션
    final BoxDecoration bg = _pressed
        ? BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment(1.20, -0.20),
        end: Alignment(-0.00, 0.37),
        colors: [Colors.white, AppColors.plumu_green_main],
      ),
      borderRadius: BorderRadius.circular(8),
    )
        : BoxDecoration(
      color: AppColors.plumu_gray_1,
      borderRadius: BorderRadius.circular(8),
    );

    // 프레스 시 색 반전
    final Color titleColor = _pressed ? AppColors.plumu_white : AppColors.plumu_gray_7;
    final Color descColor  = _pressed ? AppColors.plumu_white : AppColors.plumu_gray_6;
    final Color statText   = _pressed ? AppColors.plumu_white : const Color(0xFF1C1C1C);
    final Color statIcon   = _pressed ? AppColors.plumu_white : Colors.black87;
    final Color statBg     = _pressed ? AppColors.plumu_white.withOpacity(0.30)
        : AppColors.plumu_white.withOpacity(0.60);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(8),
          onHighlightChanged: (v) => setState(() => _pressed = v), // 누를 때만 효과
          splashColor: AppColors.plumu_green_main.withOpacity(0.10),
          highlightColor: Colors.transparent,
          child: Ink(
            decoration: bg,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Stack(
              children: [
                // 좌측: 제목 + 설명
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.question.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.pretendard_bold.copyWith(
                        fontSize: 16,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.question.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.pretendard_regular.copyWith(
                        fontSize: 12,
                        height: 1.33,
                        color: descColor,
                      ),
                    ),
                  ],
                ),

                // 우하단 캡슐(105x31, r=15.5) : 하트/댓글
                Positioned(
                  right: 10,
                  bottom: 9,
                  child: Container(
                    width: 105,
                    height: 31,
                    decoration: BoxDecoration(
                      color: statBg,
                      borderRadius: BorderRadius.circular(15.5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        // 좋아요
                        GestureDetector(
                          onTap: _toggleLike,
                          behavior: HitTestBehavior.opaque,
                          child: Row(
                            children: [
                              Icon(
                                _liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                size: 18,
                                color: statIcon,
                              ),
                              const SizedBox(width: 4),
                              Text('$_likes', style: TextStyle(fontSize: 14, color: statText)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // 댓글
                        Row(
                          children: [
                            Icon(Icons.chat_bubble_outline_rounded, size: 18, color: statIcon),
                            const SizedBox(width: 4),
                            Text('${widget.question.comments}', style: TextStyle(fontSize: 14, color: statText)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
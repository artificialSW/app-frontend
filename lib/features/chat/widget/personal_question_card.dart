// lib/features/chat/widget/personal_question_card.dart
import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import '../model/personal_question.dart';
import '../chat_personal_send_logic/state/personal_question_send.dart';

class PersonalQuestionCard extends StatefulWidget {
  final PersonalQuestionEntity question;
  final int initialLikes;
  final int commentsCount;
  final bool selected;
  final VoidCallback? onTap;

  const PersonalQuestionCard({
    super.key,
    required this.question,
    required this.initialLikes,
    required this.commentsCount,
    this.selected = false,
    this.onTap,
  });

  @override
  State<PersonalQuestionCard> createState() => _PersonalQuestionCardState();
}

class _PersonalQuestionCardState extends State<PersonalQuestionCard> {
  late int _likes = widget.initialLikes;
  bool _liked = false;
  bool _pressed = false;

  void _toggleLike() {
    setState(() {
      _liked = !_liked;
      _likes = _liked ? _likes + 1 : (_likes > 0 ? _likes - 1 : 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPrivate = widget.question.visibility == VisibilityType.private;

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
      color: const Color(0xFFF3F3F3),
      borderRadius: BorderRadius.circular(8),
    );

    final Color titleColor = _pressed ? Colors.white : const Color(0xFF282828);
    final Color circleStroke = _pressed ? Colors.white : AppColors.plumu_green_main;
    final Color statText = _pressed ? Colors.white : const Color(0xFF1C1C1C);
    final Color statIcon = _pressed ? Colors.white : Colors.black87;
    final Color statBg   = _pressed ? Colors.white.withOpacity(0.30) : Colors.white.withOpacity(0.60);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(8),
          onHighlightChanged: (v) => setState(() => _pressed = v),
          splashColor: AppColors.plumu_green_main.withOpacity(0.10),
          highlightColor: Colors.transparent,
          child: Ink(
            decoration: bg,
            width: 380,  // Figma W
            height: 94,  // Figma H
            child: Stack(
              children: [
                // 제목: X=24, Y=16
                Positioned(
                  left: 24, top: 16,
                  child: SizedBox(
                    width: 350, // 텍스트 줄바꿈 여유(피그마 레드 마크 350)
                    child: Text(
                      widget.question.text,
                      style: AppTextStyles.pretendard_bold.copyWith(
                        fontSize: 17, height: 1.5, letterSpacing: -0.46, color: titleColor,
                      ),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

                // 참여자 아이콘 그룹: X=23, Y=48, W=74, H=36 (28지름, 간격 10)
                Positioned(
                  left: 23, top: 48,
                  child: Row(
                    children: List.generate(2, (_) => Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: circleStroke, width: 2),
                        color: _pressed ? Colors.white.withOpacity(0.15) : Colors.transparent,
                      ),
                      child: Icon(Icons.person, size: 18, color: circleStroke),
                    )),
                  ),
                ),

                // 잠금: right=12, top=10, size=21
                if (isPrivate)
                  const Positioned(
                    right: 12, top: 10,
                    child: Icon(Icons.lock, size: 21, color: AppColors.plumu_green_50per),
                  ),

                // 좋아요/댓글 캡슐: right=10, bottom=9, 105x31, r=15.5
                Positioned(
                  right: 10, bottom: 9,
                  child: Container(
                    width: 105, height: 31,
                    decoration: BoxDecoration(
                      color: statBg,
                      borderRadius: BorderRadius.circular(15.5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: _toggleLike, behavior: HitTestBehavior.opaque,
                          child: Row(children: [
                            Icon(_liked ? Icons.favorite : Icons.favorite_border, size: 18, color: statIcon),
                            const SizedBox(width: 4),
                            Text('$_likes', style: TextStyle(fontSize: 14, color: statText)),
                          ]),
                        ),
                        const SizedBox(width: 12),
                        Row(children: [
                          Icon(Icons.chat_bubble_outline, size: 18, color: statIcon),
                          const SizedBox(width: 4),
                          Text('${widget.commentsCount}', style: TextStyle(fontSize: 14, color: statText)),
                        ]),
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
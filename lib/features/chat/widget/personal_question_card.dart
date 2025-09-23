// lib/features/chat/widget/personal_question_card.dart
import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
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
                      style: TextStyle(
                        color: _pressed ? Colors.white : const Color(0xFF282828),
                        fontSize: 17,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w700,
                        height: 1.50,
                        letterSpacing: -0.46,
                      ),
                      maxLines: 1, overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

                // 참여자 아이콘 그룹: X=23, Y=48, size ~35x36, 간격 10
                Positioned(
                  left: 23, top: 48,
                  child: Row(children: [
                    _ParticipantIcon(pressed: _pressed, color: circleStroke),
                    const SizedBox(width: 0),
                    _ParticipantIcon(pressed: _pressed, color: circleStroke),
                  ]),
                ),

                // 잠금: right=12, top=10, size=20x25, filled icon asset
                if (isPrivate)
                  Positioned(
                    right: 12, top: 10,
                    child: Image.asset(AppAssets.lock_fill, width: 20, height: 25, color: const Color(0x7F5CBD56)),
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
                          Image.asset(AppAssets.message, width: 18, height: 18, color: statIcon),
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

class _ParticipantIcon extends StatelessWidget {
  final bool pressed;
  final Color color;
  const _ParticipantIcon({required this.pressed, required this.color});

  @override
  Widget build(BuildContext context) {
    if (pressed) {
      return Container(
        width: 35,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Icon(Icons.person, size: 20, color: Colors.white),
      );
    }
    return Image.asset(AppAssets.person_circle, width: 35, height: 36);
  }
}
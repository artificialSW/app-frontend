// lib/features/chat/widget/personal_question_card.dart

// Flutter/Dart 기본 라이브러리
import 'package:flutter/material.dart';

// 프로젝트 내부 (절대 경로)
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'package:artificialsw_frontend/services/chat/chat_service.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_like/chat_like_request_dto.dart';
import 'package:artificialsw_frontend/services/chat/mock_data_manager.dart';

// 프로젝트 내부 (상대 경로)
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
  late bool _liked = false; // 초기 상태를 빈 하트로 설정
  bool _pressed = false;
  bool _isLiking = false; // 좋아요 요청 중 상태

  // API 호출을 위한 ChatService 인스턴스
  final ChatService _chatService = ChatService();

  /// 개인질문에 좋아요를 토글하는 메서드
  /// API 호출 후 성공하면 UI를 업데이트하고, 실패하면 원래 상태로 복원
  Future<void> _toggleLike() async {
    if (_isLiking) return; // 이미 요청 중이면 무시

    // UI를 먼저 업데이트 (낙관적 업데이트)
    final previousLiked = _liked;
    final previousLikes = _likes;
    
    setState(() {
      _isLiking = true;
      _liked = !_liked;
      _likes = _liked ? _likes + 1 : (_likes > 0 ? _likes - 1 : 0);
    });

    try {
      // API 호출
      final request = ChatLikeRequestDto(
        what: ChatLikeType.personalQuestion,
        id: int.parse(widget.question.id),
      );
      
      final response = await _chatService.postChatLike(request);
      
      // 서버 응답으로 실제 상태 업데이트
      setState(() {
        _isLiking = false;
        _liked = response.isLiked;
        _likes = response.totalLikes;
      });
      
      // MockDataManager 캐시도 함께 업데이트
      MockDataManager.togglePersonalQuestionLike(int.parse(widget.question.id));
      
    } catch (e) {
      // 실패 시 원래 상태로 복원
      setState(() {
        _isLiking = false;
        _liked = previousLiked;
        _likes = previousLikes;
      });
      
      // 에러 메시지 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('좋아요 요청에 실패했습니다. 다시 시도해주세요.')),
        );
      }
    }
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
                      maxLines: 1, 
                      overflow: TextOverflow.ellipsis,
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
                          onTap: _isLiking ? null : _toggleLike, // 로딩 중이면 비활성화
                          behavior: HitTestBehavior.opaque,
                          child: Row(children: [
                            // 로딩 중이면 스피너, 아니면 하트 아이콘
                            _isLiking 
                              ? SizedBox(
                                  width: 18, height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(statIcon),
                                  ),
                                )
                              : Icon(_liked ? Icons.favorite : Icons.favorite_border, size: 18, color: _liked ? Colors.red : statIcon),
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
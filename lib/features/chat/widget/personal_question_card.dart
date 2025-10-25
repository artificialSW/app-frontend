// lib/features/chat/widget/personal_question_card.dart

// Flutter/Dart 기본 라이브러리
import 'package:flutter/material.dart';

// 프로젝트 내부 (절대 경로)
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'package:artificialsw_frontend/shared/utils/family_utils.dart';
import 'package:artificialsw_frontend/services/chat/chat_service.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_like/chat_like_request_dto.dart';
import 'package:artificialsw_frontend/services/chat/mock_data_manager.dart';
import 'package:artificialsw_frontend/services/chat/offline_like_queue.dart';

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
  late bool _liked = widget.question.isLiked; // 초기 상태를 API에서 받은 값으로 설정
  bool _pressed = false;
  bool _isLiking = false; // 좋아요 요청 중 상태

  // 오프라인 좋아요 큐
  final OfflineLikeQueue _likeQueue = OfflineLikeQueue();

  /// 개인질문에 좋아요를 토글하는 메서드 (오프라인 큐 방식)
  /// 인스타그램처럼 즉시 UI 업데이트 후, 백그라운드에서 서버 동기화
  void _toggleLike() {
    if (_isLiking) return; // 이미 요청 중이면 무시

    setState(() {
      _isLiking = true;
    });

    // 1단계: 즉시 UI 업데이트 (사용자는 바로 결과를 봄)
    final newLikedState = !_liked;
    setState(() {
      _liked = newLikedState;
      _likes = newLikedState ? _likes + 1 : (_likes > 0 ? _likes - 1 : 0);
    });

    // 2단계: 오프라인 큐에 추가 (백그라운드에서 서버 동기화)
    _likeQueue.addToQueue(
      id: widget.question.id,
      type: ChatLikeType.question,
      action: newLikedState ? LikeAction.like : LikeAction.unlike,
    );

    // 3단계: MockDataManager 캐시도 즉시 업데이트 (API 실패 시에만)
    // MockDataManager.togglePersonalQuestionLike(int.parse(widget.question.id));

    setState(() {
      _isLiking = false;
    });

    // UI는 절대 롤백되지 않음! (인스타그램 방식)
  }

  @override
  Widget build(BuildContext context) {
    final isPrivate = widget.question.visibility == VisibilityType.private;
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth - 32; // 좌우 margin 16씩

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
            width: cardWidth,  // 적응형
            height: 94,
            child: Stack(
              children: [
                // 제목: X=24, Y=16
                Positioned(
                  left: 24, top: 16,
                  child: SizedBox(
                    width: cardWidth - 48, // 좌우 패딩 24씩 제외
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
                  child: Builder(
                    builder: (context) {
                      final randomMembers = FamilyUtils.getRandomFamilyMembers();
                      return Row(children: [
                        _ParticipantIcon(pressed: _pressed, color: circleStroke, role: randomMembers[0]), // 보낸사람
                        const SizedBox(width: 0),
                        _ParticipantIcon(pressed: _pressed, color: circleStroke, role: randomMembers[1]), // 받는사람
                      ]);
                    },
                  ),
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
  final String role;
  const _ParticipantIcon({required this.pressed, required this.color, required this.role});

  @override
  Widget build(BuildContext context) {
    if (pressed) {
      return Container(
        width: 35,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          image: DecorationImage(
            image: AssetImage(FamilyUtils.getProfileImageByFamilyType(role)),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.15),
          ),
        ),
      );
    }
    return Container(
      width: 35,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage(FamilyUtils.getProfileImageByFamilyType(role)),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
// lib/features/chat/widget/common_question_card.dart

// Flutter/Dart 기본 라이브러리
import 'package:flutter/material.dart';

// 프로젝트 내부 (절대 경로)
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/services/chat/chat_service.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_like/chat_like_request_dto.dart';
import 'package:artificialsw_frontend/services/chat/mock_data_manager.dart';
import 'package:artificialsw_frontend/services/chat/offline_like_queue.dart';

// 프로젝트 내부 (상대 경로)
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
  late bool _liked = widget.question.isLiked; // 초기 상태를 API에서 받은 값으로 설정
  bool _pressed = false; // 누르는 동안만 true
  bool _isLiking = false; // 좋아요 요청 중 상태

  // 오프라인 좋아요 큐
  final OfflineLikeQueue _likeQueue = OfflineLikeQueue();

  /// 공통질문에 좋아요를 토글하는 메서드 (오프라인 큐 방식)
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
    // MockDataManager.toggleCommonQuestionLike(int.parse(widget.question.id));

    setState(() {
      _isLiking = false;
    });

    // UI는 절대 롤백되지 않음! (인스타그램 방식)
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
                          onTap: _isLiking ? null : _toggleLike, // 로딩 중이면 비활성화
                          behavior: HitTestBehavior.opaque,
                          child: Row(
                            children: [
                              // 로딩 중이면 스피너, 아니면 하트 아이콘
                              _isLiking 
                                ? SizedBox(
                                    width: 18, height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(statIcon),
                                    ),
                                  )
                                : Icon(
                                    _liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                    size: 18,
                                    color: _liked ? Colors.red : statIcon,
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
// lib/features/chat/widget/common_question_card.dart

// Flutter/Dart 기본 라이브러리
import 'package:flutter/material.dart';

// 프로젝트 내부 (절대 경로)
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/services/chat/chat_service.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_like/chat_like_request_dto.dart';
import 'package:artificialsw_frontend/services/chat/mock_data_manager.dart';

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
  late bool _liked = false; // 초기 상태를 빈 하트로 설정
  bool _pressed = false; // 누르는 동안만 true
  bool _isLiking = false; // 좋아요 요청 중 상태

  // API 호출을 위한 ChatService 인스턴스
  final ChatService _chatService = ChatService();

  /// 공통질문에 좋아요를 토글하는 메서드
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
        what: ChatLikeType.question, // 공통질문은 'question' 타입
        id: int.parse(widget.question.id),
      );
      
      await _chatService.postChatLike(request);
      
      // MockDataManager 캐시도 함께 업데이트
      MockDataManager.toggleCommonQuestionLike(int.parse(widget.question.id));
      
      // 성공 시 로딩 상태 해제
      setState(() {
        _isLiking = false;
      });
      
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
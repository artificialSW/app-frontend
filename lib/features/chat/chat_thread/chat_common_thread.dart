// lib/features/chat/chat_thread/chat_common_thread.dart

// Flutter/Dart 기본 라이브러리
import 'package:flutter/material.dart';

// 프로젝트 내부 (절대 경로)
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_top_bar.dart';
import 'package:artificialsw_frontend/services/chat/chat_service.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_common_detail/chat_common_detail_question_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_common_detail/chat_common_detail_comment_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_like/chat_like_request_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_reply/chat_reply_request_dto.dart';

// 프로젝트 내부 (상대 경로)
import '../widget/thread_widgets.dart';
import '../model/common_question.dart';

class ChatCommonThreadPage extends StatefulWidget {
  final String questionId;
  final int order; /// N번째 질문 -> 이건 필요할듯
  const ChatCommonThreadPage({
    super.key,
    required this.questionId,
    required this.order,
  });

  @override
  State<ChatCommonThreadPage> createState() => _ChatCommonThreadPageState();
}

class _ChatCommonThreadPageState extends State<ChatCommonThreadPage> {
  final _controller = TextEditingController();
  final ChatService _chatService = ChatService();

  ChatCommonDetailQuestionDto? _questionData;
  List<_Comment> _comments = [];
  bool _isLoading = true;
  String? _replyToId, _replyToAuthor;

  @override
  void initState() {
    super.initState();
    _loadDetailData();
  }

  Future<void> _loadDetailData() async {
    try {
      final data = await _chatService.getChatCommonDetail(widget.questionId);
      setState(() {
        _questionData = data.question;
        
        // DTO를 _Comment 리스트로 변환
        _comments = data.comments.map((comment) {
          return _Comment(
            comment.commentId.toString(),
            comment.writer.toString(), // int를 String으로 변환
            comment.content,
            likes: comment.likes,
            liked: comment.isLiked,
            replies: comment.reply.map((r) => _Reply(r.writer.toString(), r.content, likes: r.likes, liked: r.isLiked)).toList(),
          );
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('공통질문 상세 로드 실패: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// 댓글 좋아요를 토글하는 메서드
  /// API 호출 후 성공하면 UI를 업데이트하고, 실패하면 원래 상태로 복원
  Future<void> _toggleCommentLike(_Comment comment) async {
    // UI를 먼저 업데이트 (낙관적 업데이트)
    final previousLiked = comment.liked;
    final previousLikes = comment.likes;
    
    setState(() {
      comment.liked = !comment.liked;
      comment.likes = comment.liked ? comment.likes + 1 : (comment.likes > 0 ? comment.likes - 1 : 0);
    });

    try {
      // API 호출
      final request = ChatLikeRequestDto(
        what: ChatLikeType.comment,
        id: int.parse(comment.id),
      );
      
      final response = await _chatService.postChatLike(request);
      
      // 서버 응답으로 실제 상태 업데이트
      setState(() {
        comment.liked = response.isLiked;
        comment.likes = response.totalLikes;
      });
      
    } catch (e) {
      // 실패 시 원래 상태로 복원
      setState(() {
        comment.liked = previousLiked;
        comment.likes = previousLikes;
      });
      
      // 에러 메시지 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('댓글 좋아요 요청에 실패했습니다. 다시 시도해주세요.')),
        );
      }
    }
  }

  /// 댓글/대댓글을 작성하는 메서드
  /// API 호출 후 성공하면 UI를 업데이트하고, 실패하면 에러 메시지 표시
  Future<void> _submitComment() async {
    final content = _controller.text.trim();
    if (content.isEmpty) return;

    // UI를 먼저 업데이트 (낙관적 업데이트)
    final tempId = DateTime.now().millisecondsSinceEpoch.toString();
    final tempAuthor = '나';
    
    setState(() {
      if (_replyToId == null) {
        // 새 댓글 추가
        _comments.add(
          _Comment(
            tempId,
            tempAuthor,
            content,
          ),
        );
      } else {
        // 대댓글 추가
        final i = _comments.indexWhere((e) => e.id == _replyToId);
        if (i != -1) {
          _comments[i].replies.add(_Reply(tempAuthor, content));
          _comments[i].expanded = true;
        }
      }
      _controller.clear();
      _replyToId = null;
      _replyToAuthor = null;
    });

    try {
      // API 호출
      final request = ChatReplyRequestDto(
        questionRefId: int.parse(widget.questionId),
        content: content,
        replyTo: _replyToId != null ? int.parse(_replyToId!) : null,
      );
      
      await _chatService.postChatReply(request);
      
    } catch (e) {
      // 실패 시 추가된 댓글/대댓글 제거
      setState(() {
        if (_replyToId == null) {
          // 새 댓글 제거
          _comments.removeWhere((comment) => comment.id == tempId);
        } else {
          // 대댓글 제거
          final i = _comments.indexWhere((e) => e.id == _replyToId);
          if (i != -1) {
            _comments[i].replies.removeWhere((reply) => reply.text == content);
          }
        }
      });
      
      // 에러 메시지 표시
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('댓글 작성에 실패했습니다. 다시 시도해주세요.')),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: CanGoBackTopBar('공통질문', context),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_questionData == null) {
      return Scaffold(
        appBar: CanGoBackTopBar('공통질문', context),
        body: const Center(child: Text('질문을 불러올 수 없습니다.')),
      );
    }

    // 날짜 포맷팅
    final createdAt = DateTime.parse(_questionData!.createdAt);
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dateStr = '${months[createdAt.month - 1]} ${createdAt.day}. ${createdAt.year}';

    return Scaffold(
      appBar: CanGoBackTopBar('공통질문', context),
      body: Column(
        children: [
          // 헤더: N번째 질문 태그/큰 제목/날짜
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // N번째 질문 태그
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.plumu_green_main,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${widget.order}번째 질문',
                    style: AppTextStyles.pretendard_medium.copyWith(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // 질문 텍스트
                Text(
                  _questionData!.content,
                  style: AppTextStyles.pretendard_bold.copyWith(
                    fontSize: 20,
                    color: AppColors.plumu_black,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
                // 날짜
                Text(
                  dateStr,
                  style: AppTextStyles.pretendard_regular.copyWith(
                    fontSize: 12,
                    color: AppColors.plumu_gray_5,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.plumu_gray_2),

          // 댓글 리스트
          Expanded(
            child: ListView.builder(
              itemCount: _comments.length,
              itemBuilder: (_, i) {
                final c = _comments[i];
                final replies = c.replies
                    .map(
                      (r) => ThreadReplyView(
                        author: r.author,
                        text: r.text,
                        likes: r.likes,
                        liked: r.liked,
                      ),
                    )
                    .toList();

                return ThreadCommentTile(
                  author: c.author,
                  text: c.text,
                  likes: c.likes,
                  liked: c.liked,
                  replies: replies,
                  expanded: c.expanded,
                  onToggleLike: () => _toggleCommentLike(c),
                  onToggleExpand: () => setState(() {
                    c.expanded = !c.expanded;
                  }),
                  onTapReply: () => setState(() {
                    _replyToId = c.id;
                    _replyToAuthor = c.author;
                  }),
                  onToggleReplyLike: (rIdx) => setState(() {
                    final r = c.replies[rIdx];
                    r.liked = !r.liked;
                    r.likes += r.liked ? 1 : (r.likes > 0 ? -1 : 0);
                  }),
                );
              },
            ),
          ),

          // 입력
          ThreadInputBar(
            controller: _controller,
            hintText: _replyToAuthor == null
                ? '답변을 입력하세요'
                : '$_replyToAuthor 님에게 답글',
            onSubmit: () => _submitComment(),
          ),
        ],
      ),
    );
  }
}


// 페이지 내부 전용 최소 모델
class _Reply {
  _Reply(this.author, this.text, {this.likes = 0, this.liked = false});
  String author, text;
  int likes;
  bool liked; //이건 likes랑 뭐가 다른거지? 심지어 bool인데
}

class _Comment {
  _Comment(
      this.id,
      this.author,
      this.text, {
        this.likes = 0,
        this.liked = false,
        this.expanded = false,
        List<_Reply>? replies,
      }) : replies = replies ?? [];
  String id, author, text;
  int likes;
  bool liked, expanded;
  List<_Reply> replies;
}

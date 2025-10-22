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
import 'package:artificialsw_frontend/services/chat/offline_like_queue.dart';

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
            comment.writerRole, // 한국어 role 사용
            comment.content,
            likes: comment.likes,
            liked: comment.isLiked,
            replies: comment.reply.map((r) => _Reply(r.commentId.toString(), r.writerRole, r.content, likes: r.likes, liked: r.isLiked)).toList(),
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

  // 오프라인 좋아요 큐
  final OfflineLikeQueue _likeQueue = OfflineLikeQueue();

  /// 댓글 좋아요를 토글하는 메서드 (오프라인 큐 방식)
  /// 인스타그램처럼 즉시 UI 업데이트 후, 백그라운드에서 서버 동기화
  void _toggleCommentLike(_Comment comment) {
    // 즉시 UI 업데이트
    final newLikedState = !comment.liked;
    setState(() {
      comment.liked = newLikedState;
      comment.likes = newLikedState ? comment.likes + 1 : (comment.likes > 0 ? comment.likes - 1 : 0);
    });

    // 오프라인 큐에 추가 (백그라운드에서 서버 동기화)
    _likeQueue.addToQueue(
      id: comment.id,
      type: ChatLikeType.comment,
      action: newLikedState ? LikeAction.like : LikeAction.unlike,
    );

    // UI는 절대 롤백되지 않음! (인스타그램 방식)
  }

  /// 댓글/대댓글을 작성하는 메서드
  /// API 호출 후 성공하면 UI를 업데이트하고, 실패하면 에러 메시지 표시
  Future<void> _submitComment() async {
    final content = _controller.text.trim();
    if (content.isEmpty) return;

    // UI를 먼저 업데이트 (낙관적 업데이트)
    final tempId = DateTime.now().millisecondsSinceEpoch.toString();
    final tempAuthor = '나';
    
    // replyToId를 먼저 저장 (스코프 문제 해결)
    final replyToId = _replyToId;
    
    setState(() {
      if (replyToId == null) {
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
        final i = _comments.indexWhere((e) => e.id == replyToId);
        if (i != -1) {
          _comments[i].replies.add(_Reply(tempId, tempAuthor, content));
          _comments[i].expanded = true;
        }
      }
      _controller.clear();
    });

    try {
      // API 호출
      final request = ChatReplyRequestDto(
        questionRefId: int.parse(widget.questionId),
        content: content,
        replyTo: replyToId != null ? int.parse(replyToId) : null,
      );
      
      await _chatService.postChatReply(request);
      
      // API 성공 후 replyToId 초기화
      setState(() {
        _replyToId = null;
        _replyToAuthor = null;
      });
      
    } catch (e) {
      // 실패 시 추가된 댓글/대댓글 제거
      setState(() {
        if (replyToId == null) {
          // 새 댓글 제거
          _comments.removeWhere((comment) => comment.id == tempId);
        } else {
          // 대댓글 제거
          final i = _comments.indexWhere((e) => e.id == replyToId);
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
        backgroundColor: Colors.white,
        appBar: CanGoBackTopBar('공통질문', context),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_questionData == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: CanGoBackTopBar('공통질문', context),
        body: const Center(child: Text('질문을 불러올 수 없습니다.')),
      );
    }

    // 날짜 포맷팅
    final createdAt = DateTime.parse(_questionData!.createdAt);
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final dateStr = '${months[createdAt.month - 1]} ${createdAt.day}. ${createdAt.year}';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CanGoBackTopBar('공통질문', context),
      body: Column(
        children: [
          // 스크롤 가능한 전체 콘텐츠
          Expanded(
            child: SingleChildScrollView(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final screenWidth = MediaQuery.of(context).size.width;
                  final screenHeight = MediaQuery.of(context).size.height;
                  final widthRatio = screenWidth / 412.0;
                  final heightRatio = screenHeight / 917.0;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 헤더 영역
                      Container(
                        padding: EdgeInsets.fromLTRB(
                          32 * widthRatio,
                          15 * heightRatio,
                          16 * widthRatio,
                          16 * heightRatio,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // N번째 질문 태그: topbar로부터 15px
                            Container(
                              height: 32 * heightRatio,
                              padding: EdgeInsets.symmetric(horizontal: 15 * widthRatio, vertical: 6 * heightRatio),
                              decoration: ShapeDecoration(
                                color: const Color(0xFF5CBD56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20 * widthRatio),
                                ),
                              ),
                              child: IntrinsicWidth(
                                child: Center(
                                  child: Text(
                                    '${widget.order}번째 질문',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14 * widthRatio,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w500,
                                      height: 1.43,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 13 * heightRatio), // 60 - 15 - 32 = 13

                            // 질문 텍스트: topbar로부터 60px
                            SizedBox(
                              width: screenWidth * 0.5, // 화면 절반 너비
                              child: Text(
                                _questionData!.content,
                                style: TextStyle(
                                  color: const Color(0xFF1B1D1B),
                                  fontSize: 27 * widthRatio,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w700,
                                  height: 1.33,
                                  letterSpacing: -0.32 * widthRatio,
                                ),
                                maxLines: null,
                                overflow: TextOverflow.visible,
                                softWrap: true,
                                textAlign: TextAlign.left,
                              ),
                            ),

                            SizedBox(height: 8 * heightRatio), // 100 - 60 - 32 = 8

                            // 날짜: topbar로부터 100px
                            SizedBox(
                              width: 265 * widthRatio,
                              height: 25 * heightRatio,
                              child: Text(
                                dateStr,
                                style: TextStyle(
                                  color: const Color(0xFF333333),
                                  fontSize: 15 * widthRatio,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                  height: 1.50,
                                  letterSpacing: -0.46 * widthRatio,
                                ),
                              ),
                            ),

                            SizedBox(height: 17 * heightRatio), // 142 - 100 - 25 = 17

                            // 구분선: topbar로부터 142px, width 380
                            Center(
                              child: Container(
                                width: 380 * widthRatio,
                                height: 1,
                                color: AppColors.plumu_gray_4,
                              ),
                            ),

                            SizedBox(height: 0), // 첫 댓글과의 간격 제거
                          ],
                        ),
                      ),

                      // 댓글 리스트
                      if (_comments.isNotEmpty)
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _comments.length,
                          separatorBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 0),
                              child: Center(
                                child: Container(
                                  width: 380 * widthRatio,
                                  height: 1,
                                  color: AppColors.plumu_gray_4,
                                ),
                              ),
                            );
                          },
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
                              onToggleReplyLike: (rIdx) {
                                final r = c.replies[rIdx];
                                final newLikedState = !r.liked;
                                setState(() {
                                  r.liked = newLikedState;
                                  r.likes += newLikedState ? 1 : (r.likes > 0 ? -1 : 0);
                                });

                                // 오프라인 큐에 추가 (백그라운드에서 서버 동기화)
                                _likeQueue.addToQueue(
                                  id: r.id,
                                  type: ChatLikeType.comment,
                                  action: newLikedState ? LikeAction.like : LikeAction.unlike,
                                );
                              },
                            );
                          },
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
          
          // 입력 바 (새 1차답변 or 대댓글)
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
  _Reply(this.id, this.author, this.text, {this.likes = 0, this.liked = false});
  String id;        // 대댓글 ID 추가
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

// lib/features/chat/widget/thread_widgets.dart
import 'package:flutter/material.dart';
import 'package:characters/characters.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';

/// 화면용 최소 대댓글 뷰모델
class ThreadReplyView {
  final String author;
  final String text;
  final int likes;
  final bool liked;
  const ThreadReplyView({
    required this.author,
    required this.text,
    this.likes = 0,
    this.liked = false,
  });
}

/// 댓글 1건 렌더(좋아요/대댓글/펼치기 + 대댓글목록 + 작성자 아바타 최대 2개)
class ThreadCommentTile extends StatelessWidget {
  final String author;
  final String text;
  final int likes;
  final bool liked;
  final List<ThreadReplyView> replies;
  final bool expanded;

  final VoidCallback onToggleLike;
  final VoidCallback onToggleExpand;
  final VoidCallback onTapReply;
  final ValueChanged<int> onToggleReplyLike;

  const ThreadCommentTile({
    super.key,
    required this.author,
    required this.text,
    required this.likes,
    required this.liked,
    required this.replies,
    required this.expanded,
    required this.onToggleLike,
    required this.onToggleExpand,
    required this.onTapReply,
    required this.onToggleReplyLike,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final widthRatio = screenWidth / 412.0;
    final heightRatio = screenHeight / 917.0;
    
    return Container(
      width: 380 * widthRatio,
      margin: EdgeInsets.symmetric(horizontal: (screenWidth - 380 * widthRatio) / 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 150 * heightRatio,
            child: Stack(
        children: [
          // person circle: 좌측 16, 위쪽 16
          Positioned(
            left: 16 * widthRatio,
            top: 16 * heightRatio,
            child: Image.asset(
              AppAssets.person_circle, 
              width: 33 * widthRatio, 
              height: 33 * heightRatio
            ),
          ),
          
          // 댓글 작성자 텍스트: 좌측 56, 위쪽 22
          Positioned(
            left: 56 * widthRatio,
            top: 22 * heightRatio,
            child: Text(
              author,
              style: const TextStyle(
                color: Color(0xFF282828),
                fontSize: 17,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          
          // 댓글 내용: 좌측 55, 위쪽 59
          Positioned(
            left: 55 * widthRatio,
            top: 59 * heightRatio,
            right: 16 * widthRatio,
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xFF282828),
                fontSize: 14,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                height: 1.43,
              ),
            ),
          ),
          
          // 세로선: 높이 59, plumu_gray_4, 좌측 32, 위쪽 53
          Positioned(
            left: 32 * widthRatio,
            top: 53 * heightRatio,
            child: Container(
              width: 1,
              height: 59 * heightRatio,
              color: AppColors.plumu_gray_4,
            ),
          ),
          
          // 하트 아이콘과 숫자
          Positioned(
            left: 55 * widthRatio,
            top: 85 * heightRatio,
            child: GestureDetector(
              onTap: onToggleLike,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    liked ? Icons.favorite : Icons.favorite_border, 
                    size: 18 * widthRatio, 
                    color: liked ? Colors.red : Colors.black87
                  ),
                  SizedBox(width: 4 * widthRatio),
                  Text(
                    '$likes', 
                    style: const TextStyle(
                      fontSize: 14, 
                      color: Color(0xFF1C1C1C)
                    ),
                  ),
                ],
              ),
            ),
          ),
          
           // 댓글 아이콘과 숫자
           Positioned(
             left: 93 * widthRatio,
             top: 85 * heightRatio,
            child: GestureDetector(
              onTap: onTapReply,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    AppAssets.message, 
                    width: 18 * widthRatio, 
                    height: 18 * heightRatio, 
                    color: Colors.black87
                  ),
                  SizedBox(width: 4 * widthRatio),
                  Text(
                    '${replies.length}', 
                    style: const TextStyle(
                      fontSize: 14, 
                      color: Color(0xFF1C1C1C)
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // show replies 아이콘과 텍스트: 좌측 44, 위쪽 116
          if (replies.isNotEmpty)
            Positioned(
              left: 44 * widthRatio,
              top: 116 * heightRatio,
              child: GestureDetector(
                onTap: onToggleExpand,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      AppAssets.show_replies,
                      width: 18 * widthRatio,
                      height: 18 * heightRatio,
                    ),
                    SizedBox(width: 4 * widthRatio),
                    Text(
                      expanded ? 'hide replies' : 'show replies',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
            ],
          ),
          ),
          
          // 대댓글들 (펼쳐진 상태일 때)
          if (expanded && replies.isNotEmpty)
            Container(
              width: 380 * widthRatio,
              padding: EdgeInsets.only(top: 8 * heightRatio, left: 20 * widthRatio),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(replies.length, (i) {
                  final r = replies[i];
                  return Container(
                    margin: EdgeInsets.only(bottom: 16 * heightRatio),
                    child: Stack(
                      children: [
                        // 대댓글 세로선 (모든 요소 위에)
                        Positioned(
                          left: 10 * widthRatio, // person_circle 중심과 일치
                          top: 24 * heightRatio,
                          child: Container(
                            width: 1,
                            height: 40 * heightRatio,
                            color: AppColors.plumu_gray_4,
                          ),
                        ),
                        // 대댓글 내용
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 대댓글 아바타
                            Image.asset(
                              AppAssets.person_circle, 
                              width: 20 * widthRatio, 
                              height: 20 * heightRatio
                            ),
                            SizedBox(width: 8 * widthRatio),
                            // 대댓글 내용
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    r.author,
                                    style: const TextStyle(
                                      color: Color(0xFF282828),
                                      fontSize: 13,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 4 * heightRatio),
                                  Text(
                                    r.text,
                                    style: const TextStyle(
                                      color: Color(0xFF282828),
                                      fontSize: 13,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w500,
                                      height: 1.43,
                                    ),
                                  ),
                                  SizedBox(height: 4 * heightRatio),
                                  GestureDetector(
                                    onTap: () => onToggleReplyLike(i),
                                    child: Row(
                                      children: [
                                        Icon(
                                          r.liked ? Icons.favorite : Icons.favorite_border, 
                                          size: 14 * widthRatio, 
                                          color: r.liked ? Colors.red : Colors.black87
                                        ),
                                        SizedBox(width: 4 * widthRatio),
                                        Text(
                                          '${r.likes}', 
                                          style: const TextStyle(
                                            fontSize: 11, 
                                            color: Color(0xFF1C1C1C)
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}

/// 하단 입력 바
class ThreadInputBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback onSubmit;

  const ThreadInputBar({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          color: AppColors.plumu_white,
          border: Border(top: BorderSide(color: AppColors.plumu_gray_2, width: 1)),
        ),
        child: Row(children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.plumu_gray_1,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: AppTextStyles.pretendard_regular.copyWith(fontSize: 14, color: AppColors.plumu_gray_5),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: InputBorder.none,
                ),
                style: AppTextStyles.pretendard_regular.copyWith(fontSize: 14),
                onSubmitted: (_) => onSubmit(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(icon: Icon(Icons.image_outlined, color: AppColors.plumu_gray_5, size: 20), onPressed: () {}),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: AppColors.plumu_gray_5, borderRadius: BorderRadius.circular(4)),
              child: Text('GIF', style: AppTextStyles.pretendard_medium.copyWith(fontSize: 10, color: AppColors.plumu_white)),
            ),
            onPressed: () {},
          ),
          IconButton(icon: Icon(Icons.open_in_full, color: AppColors.plumu_gray_5, size: 20), onPressed: () {}),
        ]),
      ),
    );
  }
}

class _TinyAvatars extends StatelessWidget {
  final List<String> names;
  const _TinyAvatars({required this.names});

  @override
  Widget build(BuildContext context) {
    if (names.isEmpty) return const SizedBox.shrink();
    String firstGrapheme(String s) => s.characters.isEmpty ? '?' : s.characters.first;
    return Row(
      children: names.take(2).map((n) {
        return Container(
          margin: const EdgeInsets.only(right: -4),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: AppColors.plumu_green_30per,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 1),
          ),
          alignment: Alignment.center,
          child: Text(
            firstGrapheme(n), 
            style: AppTextStyles.pretendard_medium.copyWith(fontSize: 8, color: AppColors.plumu_green_main),
          ),
        );
      }).toList(),
    );
  }
}

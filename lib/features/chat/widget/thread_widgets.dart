// lib/features/chat/widget/thread_widgets.dart
import 'package:flutter/material.dart';
import 'package:characters/characters.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';

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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.plumu_green_30per,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, size: 18, color: AppColors.plumu_green_main),
            ),
            const SizedBox(width: 12),
            Text(author, style: AppTextStyles.pretendard_medium.copyWith(fontSize: 14)),
          ]),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 44),
            child: Text(text, style: AppTextStyles.pretendard_regular.copyWith(fontSize: 14)),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 44),
            child: Row(children: [
              GestureDetector(
                onTap: onToggleLike,
                child: Row(children: [
                  Icon(liked ? Icons.favorite : Icons.favorite_border, size: 16, color: liked ? Colors.red : AppColors.plumu_gray_5),
                  const SizedBox(width: 4),
                  Text('$likes', style: AppTextStyles.pretendard_regular.copyWith(fontSize: 12, color: AppColors.plumu_gray_5)),
                ]),
              ),
              const SizedBox(width: 16),
              Row(children: [
                Icon(Icons.chat_bubble_outline, size: 16, color: AppColors.plumu_gray_5),
                const SizedBox(width: 4),
                Text('${replies.length}', style: AppTextStyles.pretendard_regular.copyWith(fontSize: 12, color: AppColors.plumu_gray_5)),
              ]),
              if (replies.isNotEmpty) ...[
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: onToggleExpand,
                  child: Row(children: [
                    Icon(expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 16, color: AppColors.plumu_gray_5),
                    const SizedBox(width: 4),
                    Text(expanded ? 'hide replies' : 'show replies', style: AppTextStyles.pretendard_regular.copyWith(fontSize: 12, color: AppColors.plumu_gray_5)),
                  ]),
                ),
              ],
            ]),
          ),
          if (expanded && replies.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 44, top: 12, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(replies.length, (i) {
                  final r = replies[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(color: AppColors.plumu_green_30per, shape: BoxShape.circle),
                            child: Icon(Icons.person, size: 14, color: AppColors.plumu_green_main),
                          ),
                          const SizedBox(width: 8),
                          Text(r.author, style: AppTextStyles.pretendard_medium.copyWith(fontSize: 13)),
                        ]),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.only(left: 32),
                          child: Text(r.text, style: AppTextStyles.pretendard_regular.copyWith(fontSize: 13)),
                        ),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.only(left: 32),
                          child: GestureDetector(
                            onTap: () => onToggleReplyLike(i),
                            child: Row(children: [
                              Icon(r.liked ? Icons.favorite : Icons.favorite_border, size: 14, color: r.liked ? Colors.red : AppColors.plumu_gray_5),
                              const SizedBox(width: 4),
                              Text('${r.likes}', style: AppTextStyles.pretendard_regular.copyWith(fontSize: 11, color: AppColors.plumu_gray_5)),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          const Divider(height: 1, color: AppColors.plumu_gray_2),
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

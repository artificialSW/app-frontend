import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'package:artificialsw_frontend/shared/utils/family_utils.dart';
import 'package:artificialsw_frontend/services/home/dto/archive/flower_card_dialog_response_dto/public_dto.dart';
import 'package:artificialsw_frontend/services/home/dto/archive/flower_card_dialog_response_dto/personal_dto.dart';
import 'package:artificialsw_frontend/services/home/dto/archive/flower_card_dialog_response_dto/comments_dto.dart';

class FlowerCardDialog extends StatefulWidget {
  final dynamic flowerCardData; // PublicDto 또는 PersonalDto

  const FlowerCardDialog({
    super.key,
    required this.flowerCardData,
  });

  @override
  State<FlowerCardDialog> createState() => _FlowerCardDialogState();
}

class _FlowerCardDialogState extends State<FlowerCardDialog> {
  Map<int, bool> replyVisibility = {}; // 대댓글 표시/숨김 상태

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context), // 화면 클릭 시 돌아가기
      child: Container(
        color: Colors.black.withOpacity(0.6), // FruitCardDialog와 동일한 배경
        child: Column(
          children: [
            SizedBox(height: 142), // 질문이 위에서 정확히 142만큼 내려온 지점에 위치
            Expanded(
              child: GestureDetector(
                onTap: () {}, // 내부 클릭은 이벤트 전파 방지
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 질문 영역
                          _buildQuestionSection(),
                          
                          // 댓글 영역
                          _buildCommentsSection(),
                          
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
              ),
            ),
            const SizedBox(height: 40), // 하단 여백
            
            // 돌아가기 버튼
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: CustomButton(
                text: '돌아가기',
                onPressed: () => Navigator.pop(context),
                width: MediaQuery.of(context).size.width - 56, // 좌우 패딩 28씩 제외
                height: 52,
                fontSize: 16,
                backgroundColor: const Color(0xFFF3F3F3),
                textColor: const Color(0xFF5CBD56),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            
            const SizedBox(height: 28), // 하단 패딩
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionSection() {
    String questionContent = '';
    String createAt = '';

    // PublicDto 또는 PersonalDto 분기 처리
    if (widget.flowerCardData is PublicDto) {
      final publicData = widget.flowerCardData as PublicDto;
      questionContent = publicData.question.content;
      createAt = _formatDate(publicData.question.CreateAt);
    } else if (widget.flowerCardData is PersonalDto) {
      final personalData = widget.flowerCardData as PersonalDto;
      questionContent = personalData.question.content;
      createAt = _formatDate(personalData.question.CreateAt);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 질문 텍스트
          Text(
            questionContent,
            style: const TextStyle(
              color: Color(0xFFF9F9F9),
              fontSize: 27,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
              height: 1.33,
              letterSpacing: -0.32,
            ),
          ),
          
          const SizedBox(height: 15),
          
          // 날짜
          SizedBox(
            width: 265,
            height: 25,
            child: Text(
              createAt,
              style: const TextStyle(
                color: Color(0xFFF9F9F9),
                fontSize: 15,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w400,
                height: 1.50,
                letterSpacing: -0.46,
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // 구분선
          Container(
            height: 1,
            color: const Color(0x66FFFFFF),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection() {
    List<CommentsDto> comments = [];

    // PublicDto 또는 PersonalDto에서 댓글 추출
    if (widget.flowerCardData is PublicDto) {
      final publicData = widget.flowerCardData as PublicDto;
      comments = publicData.comments;
    } else if (widget.flowerCardData is PersonalDto) {
      final personalData = widget.flowerCardData as PersonalDto;
      comments = personalData.comments;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: comments.map((comment) => _buildComment(comment)).toList(),
    );
  }

  Widget _buildComment(CommentsDto comment) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final widthRatio = screenWidth / 412.0;
    final heightRatio = screenHeight / 917.0;
    
    // 텍스트 길이에 따른 동적 높이 계산
    final textPainter = TextPainter(
      text: TextSpan(
        text: comment.content,
        style: const TextStyle(
          color: Color(0xFFF9F9F9),
          fontSize: 14,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500,
          height: 1.43,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: null,
    );
    
    // 텍스트가 들어갈 수 있는 최대 너비 (화면 폭의 2/3)
    final maxTextWidth = (screenWidth * 2 / 3) - (55 * widthRatio) - (16 * widthRatio);
    textPainter.layout(maxWidth: maxTextWidth);
    
    // 텍스트 높이에 따른 컨테이너 높이 계산
    final textHeight = textPainter.height;
    final baseHeight = 145 * heightRatio;
    final dynamicHeight = baseHeight + (textHeight > 20 ? textHeight - 20 : 0);
    
    return Container(
      width: 380 * widthRatio,
      margin: EdgeInsets.symmetric(horizontal: (screenWidth - 380 * widthRatio) / 2 - 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: dynamicHeight,
            child: Stack(
              children: [
                // person circle: 좌측 16, 위쪽 16
                Positioned(
                  left: 16 * widthRatio,
                  top: 16 * heightRatio,
                  child: Container(
                    width: 33 * widthRatio,
                    height: 33 * heightRatio,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(FamilyUtils.getProfileImageByFamilyType(comment.writer_role)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                
                // 댓글 작성자 텍스트: 좌측 56, 위쪽 22
                Positioned(
                  left: 56 * widthRatio,
                  top: 22 * heightRatio,
                  child: FutureBuilder<String>(
                    future: FamilyUtils.getDisplayNameByRole(comment.writer_role),
                    builder: (context, snapshot) {
                      final displayName = snapshot.data ?? comment.writer_role;
                      return Text(
                        displayName,
                        style: const TextStyle(
                          color: Color(0xFFF9F9F9),
                          fontSize: 17,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                        ),
                      );
                    },
                  ),
                ),
                
                // 댓글 내용: 좌측 55, 위쪽 59, 화면 폭의 2/3에서 줄바꿈
                Positioned(
                  left: 55 * widthRatio,
                  top: 59 * heightRatio,
                  right: 16 * widthRatio,
                  child: SizedBox(
                    width: screenWidth * 2 / 3 - 55 * widthRatio,
                    child: Text(
                      comment.content,
                      style: const TextStyle(
                        color: Color(0xFFF9F9F9),
                        fontSize: 14,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        height: 1.43,
                      ),
                    ),
                  ),
                ),
                
                // 세로선: 동적 높이로 조정
                Positioned(
                  left: 32 * widthRatio,
                  top: 53 * heightRatio,
                  child: Container(
                    width: 1,
                    height: (59 * heightRatio) + (textHeight > 20 ? textHeight - 20 : 0),
                    color: const Color(0xFFF9F9F9),
                  ),
                ),
                
                // 하트 아이콘과 숫자 (비활성화): 텍스트 높이에 따라 위치 조정
                Positioned(
                  left: 55 * widthRatio,
                  top: 85 * heightRatio + (textHeight > 20 ? textHeight - 20 : 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.favorite_border, // 비활성화 상태
                        size: 18 * widthRatio,
                        color: const Color(0xFFF9F9F9),
                      ),
                      SizedBox(width: 4 * widthRatio),
                      Text(
                        '${comment.likes}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFF9F9F9),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // 댓글 아이콘과 숫자 (비활성화): 텍스트 높이에 따라 위치 조정
                Positioned(
                  left: 93 * widthRatio,
                  top: 85 * heightRatio + (textHeight > 20 ? textHeight - 20 : 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        AppAssets.message,
                        width: 18 * widthRatio,
                        height: 18 * heightRatio,
                        color: const Color(0xFFF9F9F9),
                      ),
                      SizedBox(width: 4 * widthRatio),
                      Text(
                        '${comment.reply.length}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFF9F9F9),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // show replies 아이콘과 텍스트: 텍스트 높이에 따라 위치 조정
                if (comment.reply.isNotEmpty)
                  Positioned(
                    left: 44 * widthRatio,
                    top: 116 * heightRatio + (textHeight > 20 ? textHeight - 20 : 0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          replyVisibility[comment.commentId] = 
                              !(replyVisibility[comment.commentId] ?? false);
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.keyboard_arrow_down,
                            size: 18,
                            color: Color(0xFFF9F9F9),
                          ),
                          SizedBox(width: 4 * widthRatio),
                          Text(
                            replyVisibility[comment.commentId] == true ? 'hide replies' : 'show replies',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFFF9F9F9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // 대댓글들
          if (comment.reply.isNotEmpty && (replyVisibility[comment.commentId] == true))
            Container(
              margin: const EdgeInsets.only(top: 1), // 첫 대댓글과 위 영역 간격 최소화
              child: Column(
                children: comment.reply.asMap().entries.map((entry) {
                  final index = entry.key;
                  final reply = entry.value;
                  return Container(
                    margin: EdgeInsets.only(
                      bottom: index < comment.reply.length - 1 ? 0 : 0, // 대댓글 사이 간격 완전히 제거
                    ),
                    child: _buildReply(reply),
                  );
                }).toList(),
              ),
            ),
          
          // 댓글 구분선
          Container(
            width: 380 * widthRatio,
            margin: EdgeInsets.symmetric(horizontal: (screenWidth - 380 * widthRatio) / 2 - 10),
            child: Container(
              height: 1,
              color: const Color(0x33FFFFFF), // 반투명 흰색 구분선
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReply(CommentsDto reply) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final widthRatio = screenWidth / 412.0;
    final heightRatio = screenHeight / 917.0;
    
    // 텍스트 길이에 따른 동적 높이 계산
    final textPainter = TextPainter(
      text: TextSpan(
        text: reply.content,
        style: const TextStyle(
          color: Color(0xFFF9F9F9),
          fontSize: 14,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500,
          height: 1.43,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: null,
    );
    
    // 텍스트가 들어갈 수 있는 최대 너비 (화면 폭의 2/3)
    final maxTextWidth = (screenWidth * 2 / 3) - (55 * widthRatio) - (16 * widthRatio);
    textPainter.layout(maxWidth: maxTextWidth);
    
    // 텍스트 높이에 따른 컨테이너 높이 계산
    final textHeight = textPainter.height;
    final baseHeight = 120 * heightRatio;
    final dynamicHeight = baseHeight + (textHeight > 20 ? textHeight - 20 : 0);
    
    return Container(
      width: 380 * widthRatio,
      margin: EdgeInsets.symmetric(horizontal: (screenWidth - 380 * widthRatio) / 2 - 10),
      child: Container(
        height: dynamicHeight,
        child: Stack(
          children: [
            // person circle: 좌측 16, 위쪽 16
            Positioned(
              left: 16 * widthRatio,
              top: 16 * heightRatio,
              child: Container(
                width: 33 * widthRatio,
                height: 33 * heightRatio,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(FamilyUtils.getProfileImageByFamilyType(reply.writer_role)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            
            // 대댓글 작성자 텍스트: 좌측 56, 위쪽 22
            Positioned(
              left: 56 * widthRatio,
              top: 22 * heightRatio,
              child: FutureBuilder<String>(
                future: FamilyUtils.getDisplayNameByRole(reply.writer_role),
                builder: (context, snapshot) {
                  final displayName = snapshot.data ?? reply.writer_role;
                  return Text(
                    displayName,
                    style: const TextStyle(
                      color: Color(0xFFF9F9F9),
                      fontSize: 17,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                    ),
                  );
                },
              ),
            ),
            
            // 대댓글 내용: 좌측 55, 위쪽 59, 화면 폭의 2/3에서 줄바꿈
            Positioned(
              left: 55 * widthRatio,
              top: 59 * heightRatio,
              right: 16 * widthRatio,
              child: SizedBox(
                width: screenWidth * 2 / 3 - 55 * widthRatio,
                child: Text(
                  reply.content,
                  style: const TextStyle(
                    color: Color(0xFFF9F9F9),
                    fontSize: 14,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    height: 1.43,
                  ),
                ),
              ),
            ),
            
            // 세로선: 동적 높이로 조정
            Positioned(
              left: 32 * widthRatio,
              top: 53 * heightRatio,
              child: Container(
                width: 1,
                height: (59 * heightRatio) + (textHeight > 20 ? textHeight - 20 : 0),
                color: const Color(0xFFF9F9F9),
              ),
            ),
            
            // 하트 아이콘과 숫자 (비활성화): 텍스트 높이에 따라 위치 조정
            Positioned(
              left: 55 * widthRatio,
              top: 85 * heightRatio + (textHeight > 20 ? textHeight - 20 : 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.favorite_border, // 비활성화 상태
                    size: 18 * widthRatio,
                    color: const Color(0xFFF9F9F9),
                  ),
                  SizedBox(width: 4 * widthRatio),
                  Text(
                    '${reply.likes}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFF9F9F9),
                    ),
                  ),
                ],
              ),
            ),
            
            // 댓글 아이콘과 숫자 (대댓글은 0으로 표시): 텍스트 높이에 따라 위치 조정
            Positioned(
              left: 93 * widthRatio,
              top: 85 * heightRatio + (textHeight > 20 ? textHeight - 20 : 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    AppAssets.message,
                    width: 18 * widthRatio,
                    height: 18 * heightRatio,
                    color: const Color(0xFFF9F9F9),
                  ),
                  SizedBox(width: 4 * widthRatio),
                  Text(
                    '0', // 대댓글에는 더 이상의 댓글이 없으므로 0
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFF9F9F9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      // ISO 8601 형식에서 날짜 부분만 추출하고 포맷 변경
      final date = DateTime.parse(dateString);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      
      return '${months[date.month - 1]} ${date.day}. ${date.year}';
    } catch (e) {
      return 'Jul 24. 2025'; // 기본값
    }
  }
}
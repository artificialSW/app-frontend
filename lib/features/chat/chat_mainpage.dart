import 'package:flutter/material.dart';
import 'widget/personal_question_card.dart';
import 'widget/common_question_card.dart';
import 'model/personal_question.dart';
import 'model/common_question.dart';
import 'chat_personal_send_logic/state/personal_question_send.dart';
import 'chat_thread/chat_common_thread.dart';
import 'chat_thread/chat_personal_thread.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_top_bar.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';

// 카드 목록 전용(페이지 내부 전용이므로 private)
class _PersonalListItem {
  final PersonalQuestionEntity entity;
  final int likes;
  final int comments;
  const _PersonalListItem({required this.entity, required this.likes, required this.comments});
}

class ChatRoot extends StatefulWidget {
  const ChatRoot({super.key});
  @override
  State<ChatRoot> createState() => _ChatRootState();
}

class _ChatRootState extends State<ChatRoot> {
  int _selectedIndex = 0;

  // 개인질문
  String? _selectedPersonalId;
  final List<_PersonalListItem> _personalItems = [
    _PersonalListItem(
      entity: PersonalQuestionEntity(
        id: 'p5', askerUserId: 'u2', responderUserId: 'u1',
        text: '할아버지의 21살은 어땠나요?', visibility: VisibilityType.public, createdAt: DateTime.now(),
      ),
      likes: 0, comments: 0,
    ),
    _PersonalListItem(
      entity: PersonalQuestionEntity(
        id: 'p4', askerUserId: 'u3', responderUserId: 'u1',
        text: '개인 질문 4', visibility: VisibilityType.private, createdAt: DateTime.now(),
      ),
      likes: 0, comments: 0,
    ),
    _PersonalListItem(
      entity: PersonalQuestionEntity(
        id: 'p3', askerUserId: 'u2', responderUserId: 'u2',
        text: '개인 질문 3', visibility: VisibilityType.public, createdAt: DateTime.now(),
      ),
      likes: 0, comments: 0,
    ),
  ];

  // 공통질문 (더미 + 선택상태)
  String? _selectedCommonId;
  final CommonQuestion _weeklyCommonQuestion = const CommonQuestion(
    id: 'w-2025-36',
    title: '이번주의 공통질문',
    description: '배너 탭 가능',
    likes: 10,
    comments: 10,
  );
  final List<CommonQuestion> _pastCommonQuestions = const [
    CommonQuestion(id: 'c-5', title: '오랜만에 둘이서 게임이나 할까?', description: '질문 내용을 적어주세요', likes: 0, comments: 0),
    CommonQuestion(id: 'c-4', title: '공통질문4', description: '함께 시작하고 싶은 취미활동이 있나요?', likes: 0, comments: 0),
    CommonQuestion(id: 'c-3', title: '공통질문3', description: '질문 내용을 적어주세요', likes: 0, comments: 0),
    CommonQuestion(id: 'c-2', title: '공통질문2', description: '질문 내용을 적어주세요', likes: 0, comments: 0),
    CommonQuestion(id: 'c-1', title: '공통질문1', description: '질문 내용을 적어주세요', likes: 0, comments: 0),
  ];

  // 나에게 온 질문 개수 계산 (responderUserId가 현재 사용자인 질문들)
  int _getIncomingQuestionsCount() {
    return _personalItems.where((item) => item.entity.responderUserId == 'u1').length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: SizedBox(
          width: 44,
          child: Text(
            '소통방',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
              height: 1.50,
              letterSpacing: -0.46,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.send_rounded, color: Colors.black87),
                tooltip: '답변하기',
                onPressed: () => Navigator.pushNamed(context, '/personal-answer'),
              ),
              if (_getIncomingQuestionsCount() > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.plumu_green_main,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${_getIncomingQuestionsCount()}',
                        style: AppTextStyles.pretendard_medium.copyWith(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          _WeeklyQuestionBanner(
            question: _weeklyCommonQuestion,
            order: _pastCommonQuestions.length + 1,
          ),
          _TabBar(
            selectedIndex: _selectedIndex,
            onTabChanged: (index) => setState(() => _selectedIndex = index),
          ),
          Expanded(child: _selectedIndex == 0 ? _buildPersonalQuestions() : _buildCommonQuestions()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/personal-question'),
        backgroundColor: AppColors.plumu_gray_4,
        foregroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }

  Widget _buildPersonalQuestions() {
    if (_personalItems.isEmpty) {
      return const Center(child: Text('질문이 없어요.\n가족에게 궁금했던 점을 질문해보세요!', textAlign: TextAlign.center));
    }
    return ListView.builder(
      itemCount: _personalItems.length,
      itemBuilder: (_, i) {
        final item = _personalItems[i];
        return PersonalQuestionCard(
          question: item.entity,
          initialLikes: item.likes,
          commentsCount: item.comments,
          selected: _selectedPersonalId == item.entity.id,
          onTap: () {
            setState(() => _selectedPersonalId = item.entity.id);
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => ChatPersonalThreadPage(question: item.entity, askerName: item.entity.askerUserId),
            ));
          },
        );
      },
    );
  }

  Widget _buildCommonQuestions() {
    if (_pastCommonQuestions.isEmpty) {
      return const Center(child: Text('공통질문이 없어요.\n이번주의 공통질문을 확인해보세요!', textAlign: TextAlign.center));
    }
    return ListView.builder(
      itemCount: _pastCommonQuestions.length,
      itemBuilder: (_, i) {
        final q = _pastCommonQuestions[i];
        return CommonQuestionCard(
          question: q,
          selected: _selectedCommonId == q.id,
          onTap: () {
            setState(() => _selectedCommonId = q.id);
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => ChatCommonThreadPage(question: q, order: _pastCommonQuestions.length - i),
            ));
          },
        );
      },
    );
  }
}

// 이번주 공통질문 배너 위젯
class _WeeklyQuestionBanner extends StatelessWidget {
  final CommonQuestion question;
  final int order;

  const _WeeklyQuestionBanner({
    required this.question,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatCommonThreadPage(
              question: question,
              order: order,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.plumu_green_30per,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Text('🎉', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Text(
              '이번주의 공통질문',
              style: AppTextStyles.pretendard_medium.copyWith(
                fontSize: 16,
                color: AppColors.plumu_green_main,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 탭바 위젯
class _TabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const _TabBar({
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TabItem(
            text: '개인질문',
            isSelected: selectedIndex == 0,
            onTap: () => onTabChanged(0),
          ),
        ),
        Expanded(
          child: _TabItem(
            text: '공통질문',
            isSelected: selectedIndex == 1,
            onTap: () => onTabChanged(1),
          ),
        ),
      ],
    );
  }
}

// 개별 탭 아이템 위젯
class _TabItem extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          border: isSelected 
            ? Border(bottom: BorderSide(color: AppColors.plumu_gray_7, width: 1))
            : null,
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTextStyles.pretendard_medium.copyWith(
            fontSize: 15,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: isSelected ? AppColors.plumu_gray_7 : AppColors.plumu_gray_5,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'widget/personal_question_card.dart';
import 'widget/common_question_card.dart';
import 'model/personal_question.dart';
import 'model/common_question.dart';
import 'chat_personal_send_logic/state/personal_question_send.dart';
import 'chat_thread/chat_common_thread.dart';

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
        id: 'p5', askerUserId: 'u1', responderUserId: 'u2',
        text: '할아버지의 21살은 어땠나요?', visibility: VisibilityType.public, createdAt: DateTime.now(),
      ),
      likes: 0, comments: 0,
    ),
    _PersonalListItem(
      entity: PersonalQuestionEntity(
        id: 'p4', askerUserId: 'u1', responderUserId: 'u3',
        text: '개인 질문 4', visibility: VisibilityType.private, createdAt: DateTime.now(),
      ),
      likes: 0, comments: 0,
    ),
    _PersonalListItem(
      entity: PersonalQuestionEntity(
        id: 'p3', askerUserId: 'u1', responderUserId: 'u2',
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
    CommonQuestion(id: 'c-5', title: '오랜만에 둘이서 게임이나 할까?', description: '질문 내용을 적어주세요', likes: 10, comments: 10),
    CommonQuestion(id: 'c-4', title: '공통질문4', description: '함께 시작하고 싶은 취미활동이 있나요?', likes: 10, comments: 10),
    CommonQuestion(id: 'c-3', title: '공통질문3', description: '질문 내용을 적어주세요', likes: 10, comments: 10),
    CommonQuestion(id: 'c-2', title: '공통질문2', description: '질문 내용을 적어주세요', likes: 10, comments: 10),
    CommonQuestion(id: 'c-1', title: '공통질문1', description: '질문 내용을 적어주세요', likes: 10, comments: 10),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('소통방'),
        actions: [
          IconButton(icon: const Icon(Icons.send),
              onPressed: () => Navigator.pushNamed(context, '/personal-answer')),
        ],
      ),
      body: Column(
        children: [
          // 공통질문 배너 (탭 → 쓰레드 이동)
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatCommonThreadPage(
                    question: _weeklyCommonQuestion,
                    order: _pastCommonQuestions.length + 1, // 지난 개수 + 1
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [Icon(Icons.psychology), SizedBox(width: 8), Expanded(child: Text('이번주의 공통질문'))],
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedIndex = 0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Text('개인질문',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: _selectedIndex == 0 ? FontWeight.bold : FontWeight.normal)),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedIndex = 1),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    child: Text('공통질문',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: _selectedIndex == 1 ? FontWeight.bold : FontWeight.normal)),
                  ),
                ),
              ),
            ],
          ),
          Expanded(child: _selectedIndex == 0 ? _buildPersonalQuestions() : _buildCommonQuestions()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/personal-question'),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPersonalQuestions() {
    if (_personalItems.isEmpty) {
      return const Center(
        child: Text('질문이 없어요.\n가족에게 궁금했던 점을 질문해보세요!', textAlign: TextAlign.center),
      );
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
          onTap: () => setState(() => _selectedPersonalId = item.entity.id),
        );
      },
    );
  }

  // 공통질문 목록 (카드 탭 → 쓰레드 이동)
  Widget _buildCommonQuestions() {
    if (_pastCommonQuestions.isEmpty) {
      return const Center(
        child: Text('공통질문이 없어요.\n이번주의 공통질문을 확인해보세요!', textAlign: TextAlign.center),
      );
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
            final order = _pastCommonQuestions.length - i; // 5,4,3...
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatCommonThreadPage(
                  question: q,
                  order: order,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

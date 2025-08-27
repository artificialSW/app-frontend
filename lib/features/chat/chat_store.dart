import 'package:flutter/material.dart';

class QuestionItem {
  QuestionItem({
    required this.id,
    required this.title,
    required this.isPublic,
    required this.createdAt,
    this.likes = 0,
    this.comments = 0,
  });

  final String id;
  final String title;
  final bool isPublic;
  final DateTime createdAt;
  int likes;
  int comments;
}

class ChatStore {
  ChatStore._();
  static final ChatStore I = ChatStore._();

  /// 개인질문 리스트
  final ValueNotifier<List<QuestionItem>> personal =
  ValueNotifier<List<QuestionItem>>([]);

  /// 방금 추가된 카드의 id (하이라이트 용)
  String? lastAddedId;

  /// DM 답변 완료 후 목록에 추가 (카드 제목엔 preview 사용)
  void addFromDm({
    required String sender,
    required String preview,
    required bool isPrivate,
  }) {
    final q = QuestionItem(
      id: 'q_${DateTime.now().microsecondsSinceEpoch}',
      title: preview,               // 리스트 카드 제목
      isPublic: !isPrivate,
      createdAt: DateTime.now(),
      likes: 10,                    // 데모 값 (디자인에 맞춰 10/10)
      comments: 10,
    );

    final list = [...personal.value];
    list.insert(0, q);              // 최신이 위로
    personal.value = list;

    lastAddedId = q.id;             // 방금 추가된 카드 하이라이트 용
    // debugPrint('[ChatStore] added from DM: ${q.title}');
  }

  /// (+)로 직접 생성한 질문을 추가하고 싶을 때(선택)
  void addFromCreate({
    required String title,
    required bool isPublic,
  }) {
    final q = QuestionItem(
      id: 'q_${DateTime.now().microsecondsSinceEpoch}',
      title: title,
      isPublic: isPublic,
      createdAt: DateTime.now(),
      likes: 10,
      comments: 10,
    );
    final list = [...personal.value];
    list.insert(0, q);
    personal.value = list;
    lastAddedId = q.id;
  }
}

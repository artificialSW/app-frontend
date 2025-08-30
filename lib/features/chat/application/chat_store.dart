// lib/features/chat/chat_store.dart
import 'package:flutter/foundation.dart';
import '../domain/models.dart';
import '../domain/chat_repository.dart';

class ChatStore {
  ChatStore._();
  static final ChatStore I = ChatStore._();

  late ChatRepository _repo;
  bool _inited = false;

  // 개인질문
  final ValueNotifier<List<PersonalQuestion>> personal = ValueNotifier([]);

  // 공통질문
  final ValueNotifier<CommonQuestion?> weekly = ValueNotifier(null);
  final ValueNotifier<List<CommonQuestion>> commonHistory = ValueNotifier([]);

  // DM 인박스
  final ValueNotifier<List<InboxItem>> inbox = ValueNotifier([]);

  // 하이라이트 용
  String? lastAddedPersonalId;

  Future<void> init(ChatRepository repo) async {
    if (_inited) return;
    _repo = repo;
    _inited = true;
    await refreshAll();
  }

  Future<void> refreshAll() async {
    await Future.wait([
      refreshPersonal(),
      refreshWeekly(),
      refreshCommonHistory(),
      refreshInbox(),
    ]);
  }

  Future<void> refreshPersonal() async {
    personal.value = await _repo.fetchPersonalQuestions();
  }

  Future<void> refreshWeekly() async {
    weekly.value = await _repo.fetchWeeklyQuestion();
  }

  Future<void> refreshCommonHistory() async {
    commonHistory.value = await _repo.fetchCommonHistory();
  }

  Future<void> refreshInbox() async {
    inbox.value = await _repo.fetchInbox();
  }

  // 개인질문 생성
  Future<PersonalQuestion> createPersonal({
    required String title,
    required Privacy privacy,
    List<String> members = const [],
  }) async {
    final created = await _repo.createPersonalQuestion(
      title: title,
      privacy: privacy,
      members: members,
    );
    lastAddedPersonalId = created.id;
    await refreshPersonal();
    return created;
  }

  // DM 답변 → 인박스에서 제거되고 개인질문이 생김
  Future<PersonalQuestion> answerDm({
    required String dmId,
    required String answerText,
  }) async {
    final created = await _repo.answerDm(dmId: dmId, answerText: answerText);
    lastAddedPersonalId = created.id;
    await Future.wait([refreshInbox(), refreshPersonal()]);
    return created;
  }
}

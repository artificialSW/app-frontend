// lib/features/chat/chat_store.dart
import 'package:flutter/foundation.dart';
import '../domain/models.dart';           // Personal/Common/Inbox + (ThreadKey, Reply export)
import '../domain/thread_state.dart';     // ThreadData, ThreadState (배럴 export 안함)
import '../domain/chat_repository.dart';

class ChatStore {
  ChatStore._();
  static final ChatStore I = ChatStore._();

  late ChatRepository _repo;
  bool _inited = false;

  // ================= 기존 도메인 상태 =================

  // 개인질문
  final ValueNotifier<List<PersonalQuestion>> personal = ValueNotifier([]);

  // 공통질문
  final ValueNotifier<CommonQuestion?> weekly = ValueNotifier(null);
  final ValueNotifier<List<CommonQuestion>> commonHistory = ValueNotifier([]);

  // DM 인박스
  final ValueNotifier<List<InboxItem>> inbox = ValueNotifier([]);

  // 하이라이트 용
  String? lastAddedPersonalId;

  // ================= 스레드(댓글/대댓글) 캐시 =================
  // (개인/공통, threadId)별로 상태를 보존하여 재진입 시 사라지지 않도록 함
  final Map<ThreadKey, ThreadState> _threads = {};

  /// 스레드 상태 가져오기(없으면 빈 상태 생성)
  ThreadState getThread(ThreadKey key) =>
      _threads.putIfAbsent(key, () => ThreadState.empty(key));

  /// 최초 진입시에만 원격에서 로드. 이후엔 캐시 사용.
  Future<void> hydrateIfNeeded(ThreadKey key) async {
    final cached = _threads[key];
    if (cached != null && cached.replies.isNotEmpty) return; // 이미 로드됨
    final data = await _repo.fetchThread(key);
    _threads[key] = ThreadState(
      key: key,
      title: data.title,
      replies: List.unmodifiable(data.replies),
    );
    // 주의: ChatStore 자체가 ValueNotifier가 아니므로,
    // 페이지에서 setState() 또는 ValueListenableBuilder 등을 사용해 갱신해줘야 함.
  }

  /// 댓글/대댓글 추가 (낙관적 업데이트)
  void addReply(ThreadKey key, Reply reply) {
    final t = getThread(key);
    _threads[key] = t.copyWith(replies: [...t.replies, reply]);
    // 서버 반영 (실패 시 롤백은 실제 API 연동시 고려)
    _repo.persistReply(key, reply);
  }

  /// 좋아요 토글 (낙관적 업데이트)
  void toggleLike(ThreadKey key, String replyId, String userId) {
    final t = getThread(key);
    final updated = t.replies
        .map((r) => r.id == replyId ? r.toggleLike(userId) : r)
        .toList();
    _threads[key] = t.copyWith(replies: updated);
    _repo.toggleLike(key, replyId, userId);
  }

  // ================= 초기화/리스트 새로고침 =================

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

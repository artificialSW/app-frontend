// lib/features/chat/data/mock_chat_repository.dart
import '../domain/models.dart';
import '../domain/chat_repository.dart';

// ✅ 스레드용 타입(배럴에 없는 thread_state는 직접 import)
import '../domain/thread_key.dart';
import '../domain/thread_state.dart';
import '../domain/reply.dart';
import '../domain/enums.dart';

class MockChatRepository implements ChatRepository {
  // 메모리 저장소
  final List<PersonalQuestion> _personal = <PersonalQuestion>[];
  final List<InboxItem> _inbox = <InboxItem>[];
  late CommonQuestion _thisWeek;
  final List<CommonQuestion> _history = <CommonQuestion>[];

  // ✅ 스레드 저장소(공통/개인 분리)
  final Map<String, ThreadData> _commonThreads = <String, ThreadData>{};
  final Map<String, ThreadData> _personalThreads = <String, ThreadData>{};

  // ✅ 1인 1하트 보장을 위한 사용자별 좋아요 집합
  //  - key: questionId, value: userId 집합
  final Map<String, Set<String>> _questionLikedBy = <String, Set<String>>{};
  final Map<String, Set<String>> _contentLikedBy  = <String, Set<String>>{};

  MockChatRepository() {
    final now = DateTime.now();
    final week = _weekNumber(now);

    _thisWeek = CommonQuestion(
      id: 'cw_$week',
      title: '공통질문$week',
      body: '이번 주 질문 내용 샘플입니다.',
      weekIndex: week,
      createdAt: now,
      likes: 0,
      comments: 0,
    );

    // 지난 4주치 더미
    for (int i = 1; i <= 4; i++) {
      final w = week - i;
      _history.add(
        CommonQuestion(
          id: 'cw_$w',
          title: '공통질문$w',
          body: i == 2 ? '함께 시작하고 싶은 취미활동이 있나요?' : '질문 내용을 적어주세요',
          weekIndex: w,
          createdAt: now.subtract(Duration(days: 7 * i)),
          likes: 0,
          comments: 0,
        ),
      );
    }

    // DM 더미
    _inbox.addAll(<InboxItem>[
      InboxItem(
        id: 'dm_1',
        senderName: '아빠',
        preview: '아들 요즘 뭐하고 지내?',
        isPrivate: true,
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
      InboxItem(
        id: 'dm_2',
        senderName: '할아버지',
        preview: '오랜만에 같이 게임이나 할까?',
        isPrivate: false,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    ]);

    // ✅ 스레드 시드
    _commonThreads[_thisWeek.id] =
        ThreadData(id: _thisWeek.id, title: '${_thisWeek.title} 스레드', replies: const []);

    _personalThreads['me'] =
    const ThreadData(id: 'me', title: '나의 질문 스레드', replies: []);
  }

  // ---------------- 개인질문 ----------------
  @override
  Future<List<PersonalQuestion>> fetchPersonalQuestions() async {
    _personal.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return List.unmodifiable(_personal);
  }

  @override
  Future<PersonalQuestion> createPersonalQuestion({
    required String title,
    required Privacy privacy,
    List<String> members = const <String>[],
    String content = '', // ✅ content 초기값
  }) async {
    final p = PersonalQuestion.createdNow(
      id: 'pq_${DateTime.now().microsecondsSinceEpoch}',
      title: title,
      privacy: privacy,
      members: members,
      likes: 0,
      comments: 0,
      content: content,
      contentLikes: 0, // ✅ 분리된 카운트
    );
    _personal.insert(0, p);

    // ✅ 좋아요 집합 초기화
    _questionLikedBy[p.id] = <String>{};
    _contentLikedBy[p.id]  = <String>{};

    // ✅ 새 개인질문 스레드도 생성
    _personalThreads[p.id] = ThreadData(
      id: p.id,
      title: p.title,
      replies: const [],
    );

    return p;
  }

  // ---------------- 공통질문 ----------------
  @override
  Future<CommonQuestion> fetchWeeklyQuestion() async => _thisWeek;

  @override
  Future<List<CommonQuestion>> fetchCommonHistory() async {
    _history.sort((a, b) => b.weekIndex.compareTo(a.weekIndex));
    return List.unmodifiable(_history);
  }

  // ---------------- DM ----------------
  @override
  Future<List<InboxItem>> fetchInbox() async {
    _inbox.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return List.unmodifiable(_inbox);
  }

  @override
  Future<PersonalQuestion> answerDm({
    required String dmId,
    required String answerText,
    required String viewerId,
  }) async {
    final idx = _inbox.indexWhere((e) => e.id == dmId);
    if (idx < 0) {
      // 이미 처리된 DM → 일반 생성 대체
      return createPersonalQuestion(
        title: answerText.isEmpty ? '개인 질문' : answerText,
        privacy: Privacy.public,
        content: answerText, // ✅ content 채워서 반환
      );
    }

    final dm = _inbox.removeAt(idx);

    final members = dm.isPrivate ? <String>{dm.senderName, viewerId}.toList()
        : const <String>[];

    // DM → 개인질문 생성
    final created = await createPersonalQuestion(
      title: dm.preview, // 카드 제목은 DM 프리뷰
      privacy: dm.isPrivate ? Privacy.private : Privacy.public,
      members: dm.isPrivate ? <String>[dm.senderName] : const <String>[],
      content: answerText, // ✅ 헤더 아래에 보여줄 내 답변 본문
    );

    return created;
  }

  // ---------------- 좋아요(하트) ----------------
  @override
  Future<void> toggleQuestionLikeOne({
    required String questionId,
    required String userId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 20));
    final set = _questionLikedBy.putIfAbsent(questionId, () => <String>{});
    final i = _personal.indexWhere((e) => e.id == questionId);
    if (i < 0) return;
    final cur = _personal[i];

    if (set.contains(userId)) {
      set.remove(userId);
      _personal[i] = cur.copyWith(likes: (cur.likes - 1).clamp(0, 1 << 31));
    } else {
      set.add(userId);
      _personal[i] = cur.copyWith(likes: cur.likes + 1);
    }
  }

  @override
  Future<void> toggleContentLikeOne({
    required String questionId,
    required String userId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 20));
    final set = _contentLikedBy.putIfAbsent(questionId, () => <String>{});
    final i = _personal.indexWhere((e) => e.id == questionId);
    if (i < 0) return;
    final cur = _personal[i];

    if (set.contains(userId)) {
      set.remove(userId);
      _personal[i] = cur.copyWith(contentLikes: (cur.contentLikes - 1).clamp(0, 1 << 31));
    } else {
      set.add(userId);
      _personal[i] = cur.copyWith(contentLikes: cur.contentLikes + 1);
    }
  }

  // ---------------- Thread (공통/개인 공용) ----------------
  @override
  Future<ThreadData> fetchThread(ThreadKey key) async {
    await Future.delayed(const Duration(milliseconds: 80));
    final map = key.kind == ThreadKind.common ? _commonThreads : _personalThreads;
    return map[key.id] ??
        (map.values.isNotEmpty
            ? map.values.first
            : ThreadData(id: key.id, title: '스레드', replies: const []));
  }

  @override
  Future<void> persistReply(ThreadKey key, Reply reply) async {
    await Future.delayed(const Duration(milliseconds: 40));
    final map = key.kind == ThreadKind.common ? _commonThreads : _personalThreads;
    final cur = map[key.id];
    if (cur == null) return;
    map[key.id] = ThreadData(
      id: cur.id,
      title: cur.title,
      replies: [...cur.replies, reply],
    );
  }

  @override
  Future<void> toggleLike(ThreadKey key, String replyId, String userId) async {
    await Future.delayed(const Duration(milliseconds: 20));
    final map = key.kind == ThreadKind.common ? _commonThreads : _personalThreads;
    final cur = map[key.id];
    if (cur == null) return;

    final updated = cur.replies.map((r) {
      if (r.id != replyId) return r;
      return r.toggleLike(userId); // Reply 내부에서 1인 1하트 토글 처리
    }).toList();

    map[key.id] = ThreadData(id: cur.id, title: cur.title, replies: updated);
  }

  int _weekNumber(DateTime d) {
    // 간단 주차 계산(ISO 아님): 올해 1월 1일부터 경과일/7
    final first = DateTime(d.year, 1, 1);
    final days = d.difference(first).inDays;
    return (days / 7).floor() + 1;
  }
}

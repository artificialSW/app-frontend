// lib/features/chat/domain/chat_repository.dart
import 'models.dart';          // PersonalQuestion, CommonQuestion, InboxItem, Privacy
import 'thread_key.dart';      // ThreadKind/common|personal + id
import 'thread_state.dart';    // ThreadData, ThreadState
import 'reply.dart';           // Reply

/// 채팅/질문 도메인의 추상 리포지토리.
/// 실제 구현은 Mock/REST/Firebase 등에서 제공.
abstract class ChatRepository {
  // ---------------- 개인질문 ----------------

  /// 개인 질문 전체(또는 최신순) 가져오기
  /// NOTE:
  /// - 각 PersonalQuestion에는 content(내가 보낸 DM 답변 본문)와 contentLikes(해당 본문 하트 수)가 포함되어야 한다.
  /// - likes는 "질문 자체"의 하트 수이다(질문 카드 우하단).
  Future<List<PersonalQuestion>> fetchPersonalQuestions();

  /// 개인 질문 생성
  /// [content]는 초기 본문(없으면 기본 ''), DM 승격이 아닌 일반 생성 시에도 본문을 넣어둘 수 있다.
  Future<PersonalQuestion> createPersonalQuestion({
    required String title,
    required Privacy privacy,
    List<String> members = const <String>[],
    String content = '', // ✅ content 초기값
  });

  // ---------------- 공통질문 ----------------

  /// 이번 주 공통질문 1건
  Future<CommonQuestion> fetchWeeklyQuestion();

  /// 과거 공통질문 목록 (이번 주 제외)
  Future<List<CommonQuestion>> fetchCommonHistory();

  // ---------------- DM 인박스 ----------------

  /// “나에게 온 질문” 인박스 목록
  Future<List<InboxItem>> fetchInbox();

  /// DM에 답변 → 인박스에서 제거되고, 개인질문이 생성되어 목록으로 이동
  /// 반환되는 PersonalQuestion의 content에는 반드시 [answerText]가 세팅되어야 한다.
  Future<PersonalQuestion> answerDm({
    required String dmId,
    required String answerText,
  });

  // ---------------- 좋아요(하트) ----------------
  /// 질문(개인질문 항목 자체)의 하트 토글.
  /// - 규칙: 1인 1하트(토글). 이미 누른 사용자가 다시 호출하면 해제되어야 한다.
  /// - 서버/저장소는 동일 (userId, questionId) 쌍에 대해 멱등 토글을 보장해야 한다.
  Future<void> toggleQuestionLikeOne({
    required String questionId,
    required String userId,
  });

  /// 내 답변 본문(content)의 하트 토글.
  /// - 규칙: 1인 1하트(토글). 이미 누른 사용자가 다시 호출하면 해제되어야 한다.
  /// - 서버/저장소는 동일 (userId, questionId) 쌍에 대해 멱등 토글을 보장해야 한다.
  Future<void> toggleContentLikeOne({
    required String questionId,
    required String userId,
  });

  // ---------------- Thread (공통/개인 공용) ----------------

  /// 스레드(개인/공통 + id) 데이터 조회
  Future<ThreadData> fetchThread(ThreadKey key);

  /// 댓글/대댓글 추가 (낙관적 업데이트 권장)
  Future<void> persistReply(ThreadKey key, Reply reply);

  /// 댓글 좋아요 토글 (사용자 기준)
  /// - 규칙: 1인 1하트(토글)
  Future<void> toggleLike(ThreadKey key, String replyId, String userId);
}

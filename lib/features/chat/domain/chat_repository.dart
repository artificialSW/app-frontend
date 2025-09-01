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
  Future<List<PersonalQuestion>> fetchPersonalQuestions();

  /// 개인 질문 생성
  Future<PersonalQuestion> createPersonalQuestion({
    required String title,
    required Privacy privacy,
    List<String> members = const <String>[],
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
  Future<PersonalQuestion> answerDm({
    required String dmId,
    required String answerText,
  });

  // ---------------- Thread (공통/개인 공용) ----------------
  /// 스레드(개인/공통 + id) 데이터 조회
  Future<ThreadData> fetchThread(ThreadKey key);

  /// 댓글/대댓글 추가 (낙관적 업데이트 권장)
  Future<void> persistReply(ThreadKey key, Reply reply);

  /// 좋아요 토글 (사용자 기준)
  Future<void> toggleLike(ThreadKey key, String replyId, String userId);
}

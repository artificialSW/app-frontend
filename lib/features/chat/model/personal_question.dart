// 서버/DB에 저장된 개인질문 1건(목록/상세에 사용)
import '../chat_personal_send_logic/state/personal_question_send.dart';

class PersonalQuestionEntity {
  final String id;
  final String askerUserId;     // 질문자
  final String responderUserId; // 답변자
  final String text;
  final VisibilityType visibility;
  final DateTime createdAt;
  final bool isLiked;           // 좋아요 상태

  const PersonalQuestionEntity({
    required this.id,
    required this.askerUserId,
    required this.responderUserId,
    required this.text,
    required this.visibility,
    required this.createdAt,
    required this.isLiked,
  });

  // 클라이언트 보조 필터(보안 아님) — 실제 권한은 서버에서 강제
  bool canUserSee(String userId) {
    if (visibility == VisibilityType.public) return true;
    return userId == askerUserId || userId == responderUserId;
  }
}

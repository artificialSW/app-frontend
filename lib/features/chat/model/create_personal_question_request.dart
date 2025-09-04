// 생성 요청 DTO (서비스 연동 시 사용)
import 'personal_question_model.dart';

class CreatePersonalQuestionRequest {
  final String responderUserId;   // 선택한 가족의 userId
  final VisibilityType visibility;
  final String text;

  const CreatePersonalQuestionRequest({
    required this.responderUserId,
    required this.visibility,
    required this.text,
  });

  Map<String, dynamic> toJson() => {
    'responderUserId': responderUserId,
    'visibility': visibility.name, // 'public' | 'private'
    'text': text,
  };
}

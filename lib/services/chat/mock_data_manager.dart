import 'package:artificialsw_frontend/services/chat/dto/chat_main_personal_card/chat_main_personal_response_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_main_personal_card/chat_main_personal_question_card_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_main_common_card/chat_main_common_question_card_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_personal_detail/chat_personal_detail_response_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_personal_detail/chat_personal_detail_comment_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_personal_answer/chat_personal_answer_question_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_question_create/chat_family_member_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_question_create/chat_question_create_response_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_weekly_update/chat_weekly_update_response_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_weekly_common/chat_weekly_common_question_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_like/chat_like_response_dto.dart';

/// API 호출이 실패할 경우 사용할 Mock 데이터를 제공하는 매니저 클래스
/// ChatService에서 API 호출이 실패하면 자동으로 이 클래스의 메서드들이 호출
/// 실제 API 응답과 동일한 DTO 구조로 Mock 데이터를 제공
class MockDataManager {
  /// 개인질문 메인 페이지용 Mock 데이터를 반환
  /// ChatService.getChatMainPersonal() API 호출 실패 시 사용
  static ChatMainPersonalResponseDto getMainPersonalData() {
    return ChatMainPersonalResponseDto(
      questions: [
        ChatMainPersonalQuestionCardDto(
          questionId: 1,
          content: '할아버지의 21살은 어땠나요?',
          sender: 2,
          receiver: 1,
          isPublic: true,
          solved: true,
          likes: 0,
          comments: 2,
          isLiked: false,
          createdAt: '2025-08-15T12:10:00',
        ),
        ChatMainPersonalQuestionCardDto(
          questionId: 2,
          content: '개인 질문 4',
          sender: 3,
          receiver: 1,
          isPublic: false,
          solved: true,
          likes: 0,
          comments: 1,
          isLiked: true,
          createdAt: '2025-08-14T18:20:00',
        ),
        ChatMainPersonalQuestionCardDto(
          questionId: 3,
          content: '개인 질문 3',
          sender: 2,
          receiver: 2,
          isPublic: true,
          solved: true,
          likes: 0,
          comments: 0,
          isLiked: false,
          createdAt: '2025-08-13T10:32:00',
        ),
      ],
      unsolved: 2,
    );
  }

  // 공통질문 메인 페이지 Mock 데이터
  static List<ChatMainCommonQuestionCardDto> getMainCommonData() {
    return [
      ChatMainCommonQuestionCardDto(
        questionId: 1,
        content: '오랜만에 둘이서 게임이나 할까?',
        likes: 0,
        comments: 0,
        isLiked: false,
      ),
      ChatMainCommonQuestionCardDto(
        questionId: 2,
        content: '공통질문4',
        likes: 0,
        comments: 0,
        isLiked: false,
      ),
      ChatMainCommonQuestionCardDto(
        questionId: 3,
        content: '공통질문3',
        likes: 0,
        comments: 0,
        isLiked: false,
      ),
      ChatMainCommonQuestionCardDto(
        questionId: 4,
        content: '공통질문2',
        likes: 0,
        comments: 0,
        isLiked: false,
      ),
      ChatMainCommonQuestionCardDto(
        questionId: 5,
        content: '공통질문1',
        likes: 0,
        comments: 0,
        isLiked: false,
      ),
    ];
  }

  // 개인질문 상세 페이지 Mock 데이터
  static ChatPersonalDetailResponseDto getPersonalDetailData(String questionId) {
    return ChatPersonalDetailResponseDto(
      question: ChatMainPersonalQuestionCardDto(
        questionId: int.parse(questionId),
        content: '할아버지의 21살은 어땠나요?',
        sender: 2,
        receiver: 1,
        isPublic: true,
        solved: true,
        likes: 3,
        comments: 2,
        isLiked: true,
        createdAt: '2025-07-24T12:10:00',
      ),
      comments: [
        ChatPersonalDetailCommentDto(
          commentId: 1,
          writer: '할아버지',
          content: '날아다녔지',
          likes: 0,
          isLiked: false,
          reply: [],
        ),
        ChatPersonalDetailCommentDto(
          commentId: 2,
          writer: '동생',
          content: '아빠는 21살 때 어땠어요?',
          likes: 0,
          isLiked: false,
          reply: ['그건 좀...'],
        ),
      ],
    );
  }

  // 나에게 온 질문 목록 Mock 데이터
  static List<ChatPersonalAnswerQuestionDto> getMyQuestionsData() {
    return [
      ChatPersonalAnswerQuestionDto(
        questionId: 1,
        content: '아들 요즘 뭐하고 지내니?',
        sender: 1, // 아빠 (ID와 role 매핑 일치)
        receiver: 5, // 나
        likes: 0,
        comments: 0,
        solved: false,
        isPublic: true,
      ),
      ChatPersonalAnswerQuestionDto(
        questionId: 2,
        content: '오랜만에 같이 영화 볼까?',
        sender: 2, // 엄마 (ID와 role 매핑 일치)
        receiver: 5, // 나
        likes: 0,
        comments: 0,
        solved: false,
        isPublic: false,
      ),
    ];
  }

  // 가족구성원 목록 Mock 데이터
  static List<ChatFamilyMemberDto> getFamilyMembersData() {
    return [
      ChatFamilyMemberDto(id: 1, role: '아빠'),
      ChatFamilyMemberDto(id: 2, role: '엄마'),
      ChatFamilyMemberDto(id: 3, role: '할아버지'),
      ChatFamilyMemberDto(id: 4, role: '할머니'),
      ChatFamilyMemberDto(id: 5, role: '둘째아들'),
    ];
  }

  // 주간 공통질문 업데이트 Mock 데이터
  static ChatWeeklyUpdateResponseDto getWeeklyUpdateData() {
    return ChatWeeklyUpdateResponseDto(update: 'success');
  }

  // 이번주 공통질문 Mock 데이터
  static ChatWeeklyCommonQuestionDto getWeeklyCommonQuestionData() {
    return ChatWeeklyCommonQuestionDto(
      questionId: 123,
      questionContent: '이번주의 공통질문',
      likes: 10,
      posts: 5,
    );
  }

  // 공통질문 상세 페이지 Mock 데이터
  static Map<String, dynamic> getCommonDetailData(String questionId) {
    return {
      'question': {
        'Q_id': int.parse(questionId),
        'content': '오랜만에 둘이서 게임이나 할까?',
        'likes': 5,
        'CreateAt': '2025-07-24T12:10:00',
        'count': 1,
      },
      'comments': [
        {
          'commentId': 1,
          'writer': '아빠',
          'content': '낚시, 골프',
        'likes': 0,
        'isLiked': false,
        'reply': ['그건 좀...'],
        },
        {
          'commentId': 2,
          'writer': '엄마',
          'content': '뜨개질, 커피',
          'likes': 0,
          'isLiked': true,
          'reply': ['나도 그렇게 생각해요'],
        },
      ],
    };
  }

  // 질문 생성 Mock 응답 데이터
  static ChatQuestionCreateResponseDto getQuestionCreateMockData() {
    return ChatQuestionCreateResponseDto(
      questionId: 999, // 가짜 질문 ID
      errorCode: null,
      message: null,
    );
  }

  /// 좋아요 API용 Mock 응답 데이터를 반환
  /// ChatService.postChatLike() API 호출 실패 시 사용
  static ChatLikeResponseDto getLikeMockData() {
    return ChatLikeResponseDto(
      success: true, // Mock에서는 항상 성공으로 반환
    );
  }
}

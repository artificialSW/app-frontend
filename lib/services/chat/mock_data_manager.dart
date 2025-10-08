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
/// 
/// 성능 최적화: 모든 Mock 데이터는 싱글톤 캐시로 관리되며, 
/// 좋아요/댓글 등 변경사항은 캐시에서 직접 수정하여 반영
class MockDataManager {
  // 싱글톤 캐시 인스턴스들
  static ChatMainPersonalResponseDto? _mainPersonalCache;
  static List<ChatMainCommonQuestionCardDto>? _mainCommonCache;
  static List<ChatPersonalAnswerQuestionDto>? _myQuestionsCache;
  static List<ChatFamilyMemberDto>? _familyMembersCache;
  static ChatWeeklyCommonQuestionDto? _weeklyCommonCache;
  /// 개인질문 메인 페이지용 Mock 데이터를 반환 (싱글톤 캐시)
  /// ChatService.getChatMainPersonal() API 호출 실패 시 사용
  static ChatMainPersonalResponseDto getMainPersonalData() {
    if (_mainPersonalCache != null) return _mainPersonalCache!;
    
    _mainPersonalCache = ChatMainPersonalResponseDto(
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
    
    return _mainPersonalCache!;
  }

  /// 공통질문 메인 페이지용 Mock 데이터를 반환 (싱글톤 캐시)
  /// ChatService.getChatMainCommon() API 호출 실패 시 사용
  static List<ChatMainCommonQuestionCardDto> getMainCommonData() {
    if (_mainCommonCache != null) return _mainCommonCache!;
    
    _mainCommonCache = [
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
    
    return _mainCommonCache!;
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
  /// 나에게 온 질문 목록용 Mock 데이터를 반환 (싱글톤 캐시)
  /// ChatService.getChatMyQuestions() API 호출 실패 시 사용
  static List<ChatPersonalAnswerQuestionDto> getMyQuestionsData() {
    if (_myQuestionsCache != null) return _myQuestionsCache!;
    
    _myQuestionsCache = [
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
    
    return _myQuestionsCache!;
  }

  /// 가족구성원 목록용 Mock 데이터를 반환 (싱글톤 캐시)
  /// ChatService.getFamilyMembers() API 호출 실패 시 사용
  static List<ChatFamilyMemberDto> getFamilyMembersData() {
    if (_familyMembersCache != null) return _familyMembersCache!;
    
    _familyMembersCache = [
      ChatFamilyMemberDto(id: 1, role: '아빠'),
      ChatFamilyMemberDto(id: 2, role: '엄마'),
      ChatFamilyMemberDto(id: 3, role: '할아버지'),
      ChatFamilyMemberDto(id: 4, role: '할머니'),
      ChatFamilyMemberDto(id: 5, role: '둘째아들'),
    ];
    
    return _familyMembersCache!;
  }

  // 주간 공통질문 업데이트 Mock 데이터
  static ChatWeeklyUpdateResponseDto getWeeklyUpdateData() {
    return ChatWeeklyUpdateResponseDto(update: 'success');
  }

  // 이번주 공통질문 Mock 데이터
  /// 이번주 공통질문용 Mock 데이터를 반환 (싱글톤 캐시)
  /// ChatService.getWeeklyCommonQuestion() API 호출 실패 시 사용
  static ChatWeeklyCommonQuestionDto getWeeklyCommonQuestionData() {
    if (_weeklyCommonCache != null) return _weeklyCommonCache!;
    
    _weeklyCommonCache = ChatWeeklyCommonQuestionDto(
      questionId: 123,
      questionContent: '함께 시작하고 싶은\n취미 활동이 있나요?',
      likes: 0,
      posts: 0,
    );
    
    return _weeklyCommonCache!;
  }

  /// 개인질문 좋아요 상태를 토글하는 메서드
  /// UI에서 좋아요 버튼 클릭 시 캐시 데이터도 함께 업데이트
  static void togglePersonalQuestionLike(int questionId) {
    if (_mainPersonalCache == null) return;
    
    final question = _mainPersonalCache!.questions.firstWhere(
      (q) => q.questionId == questionId,
      orElse: () => throw Exception('Question not found'),
    );
    
    // 좋아요 상태 토글 및 개수 조정
    final updatedQuestion = ChatMainPersonalQuestionCardDto(
      questionId: question.questionId,
      content: question.content,
      sender: question.sender,
      receiver: question.receiver,
      isPublic: question.isPublic,
      solved: question.solved,
      likes: question.isLiked ? question.likes - 1 : question.likes + 1,
      comments: question.comments,
      isLiked: !question.isLiked,
      createdAt: question.createdAt,
    );
    
    // 캐시에서 해당 질문 교체
    final index = _mainPersonalCache!.questions.indexWhere((q) => q.questionId == questionId);
    if (index != -1) {
      _mainPersonalCache!.questions[index] = updatedQuestion;
    }
  }

  /// 공통질문 좋아요 상태를 토글하는 메서드
  /// UI에서 좋아요 버튼 클릭 시 캐시 데이터도 함께 업데이트
  static void toggleCommonQuestionLike(int questionId) {
    if (_mainCommonCache == null) return;
    
    final question = _mainCommonCache!.firstWhere(
      (q) => q.questionId == questionId,
      orElse: () => throw Exception('Question not found'),
    );
    
    // 좋아요 상태 토글 및 개수 조정
    final updatedQuestion = ChatMainCommonQuestionCardDto(
      questionId: question.questionId,
      content: question.content,
      likes: question.isLiked ? question.likes - 1 : question.likes + 1,
      comments: question.comments,
      isLiked: !question.isLiked,
    );
    
    // 캐시에서 해당 질문 교체
    final index = _mainCommonCache!.indexWhere((q) => q.questionId == questionId);
    if (index != -1) {
      _mainCommonCache![index] = updatedQuestion;
    }
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

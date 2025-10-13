import 'package:artificialsw_frontend/services/chat/dto/chat_home_thisweek/chat_home_thisweek_response_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_home_thisweek/chat_home_thisweek_comment_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_main_personal_card/chat_main_personal_question_card_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_main_common_card/chat_main_common_question_card_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_personal_detail/chat_personal_detail_response_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_personal_detail/chat_personal_detail_question_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_personal_detail/chat_personal_detail_comment_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_common_detail/chat_common_detail_response_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_common_detail/chat_common_detail_question_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_common_detail/chat_common_detail_comment_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_personal_answer/chat_personal_answer_question_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_question_create/chat_family_member_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_question_create/chat_question_create_response_dto.dart';
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
  static ChatHomeThisweekResponseDto? _homeThisweekCache;
  static List<ChatMainPersonalQuestionCardDto>? _mainPersonalCache;
  static List<ChatMainCommonQuestionCardDto>? _mainCommonCache;
  static List<ChatPersonalAnswerQuestionDto>? _myQuestionsCache;
  static List<ChatFamilyMemberDto>? _familyMembersCache;
  static ChatWeeklyCommonQuestionDto? _weeklyCommonCache;

  /// 소통방 홈 상단 이번주 공통 질문용 Mock 데이터를 반환 (싱글톤 캐시)
  /// ChatService.getChatHomeThisweek() API 호출 실패 시 사용
  static ChatHomeThisweekResponseDto getHomeThisweekData() {
    if (_homeThisweekCache != null) return _homeThisweekCache!;
    
    _homeThisweekCache = ChatHomeThisweekResponseDto(
      questions: '함께 시작하고 싶은\n취미 활동이 있나요?',
      questionRefId: 234,
      comments: [
        ChatHomeThisweekCommentDto(
          writer: '1',
          contents: '낚시하고 싶어요',
        ),
        ChatHomeThisweekCommentDto(
          writer: '2',
          contents: '골프 배워보고 싶습니다',
        ),
      ],
      unsolved: 3,
    );
    
    return _homeThisweekCache!;
  }

  /// 개인질문 메인 페이지용 Mock 데이터를 반환 (싱글톤 캐시)
  /// ChatService.getChatMainPersonal() API 호출 실패 시 사용
  static List<ChatMainPersonalQuestionCardDto> getMainPersonalData() {
    if (_mainPersonalCache != null) return _mainPersonalCache!;
    
    _mainPersonalCache = [
      ChatMainPersonalQuestionCardDto(
        questionRefId: 1,
        content: '할아버지의 21살은 어땠나요?',
        sender: 125, // grandfather
        receiver: 123, // father
        visibility: 1, // 공개
        likes: 0,
        comments: 2,
        isLiked: false,
      ),
      ChatMainPersonalQuestionCardDto(
        questionRefId: 2,
        content: '엄마, 오늘 저녁 뭐 먹을까요?',
        sender: 124, // mother
        receiver: 123, // father
        visibility: 0, // 비공개
        likes: 0,
        comments: 1,
        isLiked: true,
      ),
      ChatMainPersonalQuestionCardDto(
        questionRefId: 3,
        content: '형제, 게임 같이 할까?',
        sender: 127, // sibling
        receiver: 123, // father
        visibility: 1, // 공개
        likes: 0,
        comments: 0,
        isLiked: false,
      ),
    ];
    
    return _mainPersonalCache!;
  }

  /// 공통질문 메인 페이지용 Mock 데이터를 반환 (싱글톤 캐시)
  /// ChatService.getChatMainCommon() API 호출 실패 시 사용
  static List<ChatMainCommonQuestionCardDto> getMainCommonData() {
    if (_mainCommonCache != null) return _mainCommonCache!;
    
    _mainCommonCache = [
      ChatMainCommonQuestionCardDto(
        questionRefId: 1,
        content: '오랜만에 둘이서 게임이나 할까?',
        likes: 3,
        comments: 2,
        isLiked: false,
      ),
      ChatMainCommonQuestionCardDto(
        questionRefId: 2,
        content: '이번 주말에 가족 여행 어디 갈까요?',
        likes: 1,
        comments: 1,
        isLiked: true,
      ),
      ChatMainCommonQuestionCardDto(
        questionRefId: 3,
        content: '새로운 취미를 시작해볼까요?',
        likes: 0,
        comments: 0,
        isLiked: false,
      ),
      ChatMainCommonQuestionCardDto(
        questionRefId: 4,
        content: '오늘 날씨가 정말 좋네요!',
        likes: 2,
        comments: 1,
        isLiked: false,
      ),
      ChatMainCommonQuestionCardDto(
        questionRefId: 5,
        content: '함께 요리해볼까요?',
        likes: 1,
        comments: 3,
        isLiked: false,
      ),
    ];
    
    return _mainCommonCache!;
  }

  // 개인질문 상세 페이지 Mock 데이터
  static ChatPersonalDetailResponseDto getPersonalDetailData(String questionId) {
    return ChatPersonalDetailResponseDto(
      question: ChatPersonalDetailQuestionDto(
        questionRefId: int.parse(questionId),
        content: '할아버지의 21살은 어땠나요?',
        sender: 2,
        likes: 3,
        createdAt: '2025-10-12 14:08:39.0',
        isLiked: true,
      ),
      comments: [
        ChatPersonalDetailCommentDto(
          commentId: 1,
          writer: 3,
          content: '날아다녔지',
          likes: 0,
          isLiked: false,
          reply: [],
        ),
        ChatPersonalDetailCommentDto(
          commentId: 2,
          writer: 1,
          content: '아빠는 21살 때 어땠어요?',
          likes: 0,
          isLiked: false,
          reply: [
            ChatPersonalDetailCommentDto(
              commentId: 3,
              writer: 2,
              content: '그건 좀...',
              likes: 0,
              isLiked: false,
              reply: [],
            ),
          ],
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
        questionRefId: 12,
        content: '개인_안녕?',
        sender: 123,
        visibility: true, // 공개
      ),
      ChatPersonalAnswerQuestionDto(
        questionRefId: 234,
        content: '개인_안녕?',
        sender: 123,
        visibility: false, // 비공개
      ),
    ];
    
    return _myQuestionsCache!;
  }

  /// 가족구성원 목록용 Mock 데이터를 반환 (싱글톤 캐시)
  /// ChatService.getFamilyMembers() API 호출 실패 시 사용
  static List<ChatFamilyMemberDto> getFamilyMembersData() {
    if (_familyMembersCache != null) return _familyMembersCache!;
    
    _familyMembersCache = [
      ChatFamilyMemberDto(id: 123, role: 'father'),
      ChatFamilyMemberDto(id: 124, role: 'mother'),
      ChatFamilyMemberDto(id: 125, role: 'grandfather'),
      ChatFamilyMemberDto(id: 126, role: 'grandmother'),
      ChatFamilyMemberDto(id: 127, role: 'sibling'),
    ];
    
    return _familyMembersCache!;
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
    
    final question = _mainPersonalCache!.firstWhere(
      (q) => q.questionRefId == questionId,
      orElse: () => throw Exception('Question not found'),
    );
    
    // 좋아요 상태 토글 및 개수 조정
    final updatedQuestion = ChatMainPersonalQuestionCardDto(
      questionRefId: question.questionRefId,
      content: question.content,
      sender: question.sender,
      receiver: question.receiver,
      visibility: question.visibility,
      likes: question.isLiked ? question.likes - 1 : question.likes + 1,
      comments: question.comments,
      isLiked: !question.isLiked,
    );
    
    // 캐시에서 해당 질문 교체
    final index = _mainPersonalCache!.indexWhere((q) => q.questionRefId == questionId);
    if (index != -1) {
      _mainPersonalCache![index] = updatedQuestion;
    }
  }

  /// 공통질문 좋아요 상태를 토글하는 메서드
  /// UI에서 좋아요 버튼 클릭 시 캐시 데이터도 함께 업데이트
  static void toggleCommonQuestionLike(int questionId) {
    if (_mainCommonCache == null) return;
    
    final question = _mainCommonCache!.firstWhere(
      (q) => q.questionRefId == questionId,
      orElse: () => throw Exception('Question not found'),
    );
    
    // 좋아요 상태 토글 및 개수 조정
    final updatedQuestion = ChatMainCommonQuestionCardDto(
      questionRefId: question.questionRefId,
      content: question.content,
      likes: question.isLiked ? question.likes - 1 : question.likes + 1,
      comments: question.comments,
      isLiked: !question.isLiked,
    );
    
    // 캐시에서 해당 질문 교체
    final index = _mainCommonCache!.indexWhere((q) => q.questionRefId == questionId);
    if (index != -1) {
      _mainCommonCache![index] = updatedQuestion;
    }
  }

  // 공통질문 상세 페이지 Mock 데이터
  static ChatCommonDetailResponseDto getCommonDetailData(String questionId) {
    return ChatCommonDetailResponseDto(
      question: ChatCommonDetailQuestionDto(
        questionRefId: int.parse(questionId),
        content: '오랜만에 둘이서 게임이나 할까?',
        likes: 5,
        createdAt: '2025-07-24 12:10:00',
        count: 2,
        isLiked: false,
      ),
      comments: [
        ChatCommonDetailCommentDto(
          commentId: 1,
          writer: 1,
          content: '낚시, 골프',
          likes: 0,
          isLiked: false,
          reply: [
            ChatCommonDetailCommentDto(
              commentId: 3,
              writer: 3,
              content: '그건 좋네요!',
              likes: 0,
              isLiked: false,
              reply: [],
            )
          ],
        ),
        ChatCommonDetailCommentDto(
          commentId: 2,
          writer: 2,
          content: '뜨개질, 커피',
          likes: 0,
          isLiked: true,
          reply: [
            ChatCommonDetailCommentDto(
              commentId: 4,
              writer: 1,
              content: '나도 그렇게 생각해요',
              likes: 0,
              isLiked: false,
              reply: [],
            )
          ],
        ),
      ],
    );
  }

  // 질문 생성 Mock 응답 데이터
  static ChatQuestionCreateResponseDto getQuestionCreateMockData() {
    return ChatQuestionCreateResponseDto(
      questionRefId: 999, // 가짜 질문 ID
      errorCode: null,
      message: null,
    );
  }

  /// 좋아요 API용 Mock 응답 데이터를 반환
  /// ChatService.postChatLike() API 호출 실패 시 사용
  static ChatLikeResponseDto getLikeMockData({bool isLiked = true, int totalLikes = 1}) {
    return ChatLikeResponseDto(
      isLiked: isLiked,
      totalLikes: totalLikes,
    );
  }
}

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
      questions: '우리 가족만의\n연말 전통이 있나요?',
      questionRefId: 234,
      comments: [
        ChatHomeThisweekCommentDto(
          writer: 125, // 할아버지
          writerRole: '할아버지',
          contents: '제사상, 옛날 이야기',
        ),
        ChatHomeThisweekCommentDto(
          writer: 124, // 어머니
          writerRole: '어머니',
          contents: '케이크 만들기',
        ),
        ChatHomeThisweekCommentDto(
          writer: 126, // 할머니
          writerRole: '할머니',
          contents: '송편 빚으며 소원 빌기',
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
        content: '아빠 어렸을 때 꿈이 뭐였어요?',
        sender: 127, // 나(형)
        receiver: 123, // 아버지
        visibility: 1, // 공개
        likes: 5,
        comments: 3,
        isLiked: true,
      ),
      ChatMainPersonalQuestionCardDto(
        questionRefId: 2,
        content: '할머니, 처음 할아버지 만났을 때 기억나세요?',
        sender: 124, // 어머니
        receiver: 126, // 할머니
        visibility: 1, // 공개
        likes: 8,
        comments: 5,
        isLiked: false,
      ),
      ChatMainPersonalQuestionCardDto(
        questionRefId: 3,
        content: '엄마가 가장 좋아하는 노래가 뭐예요?',
        sender: 127, // 나(형)
        receiver: 124, // 어머니
        visibility: 0, // 비공개
        likes: 2,
        comments: 2,
        isLiked: false,
      ),
      ChatMainPersonalQuestionCardDto(
        questionRefId: 4,
        content: '할아버지, 군대 시절 이야기 해주세요',
        sender: 123, // 아버지
        receiver: 125, // 할아버지
        visibility: 1, // 공개
        likes: 8,
        comments: 4,
        isLiked: true,
      ),
      ChatMainPersonalQuestionCardDto(
        questionRefId: 5,
        content: '아버지가 제일 기억에 남는 여행지는?',
        sender: 124, // 어머니
        receiver: 123, // 아버지
        visibility: 1, // 공개
        likes: 3,
        comments: 1,
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
        questionRefId: 234,
        content: '우리 가족만의\n연말 전통이 있나요?',
        likes: 7,
        comments: 3,
        isLiked: false,
      ),
      ChatMainCommonQuestionCardDto(
        questionRefId: 101,
        content: '이번 설날에 다같이\n뭐 하고 싶으세요?',
        likes: 9,
        comments: 6,
        isLiked: true,
      ),
      ChatMainCommonQuestionCardDto(
        questionRefId: 102,
        content: '가족 모두 함께\n가보고 싶은 여행지는?',
        likes: 8,
        comments: 8,
        isLiked: true,
      ),
      ChatMainCommonQuestionCardDto(
        questionRefId: 103,
        content: '우리 가족 단톡방 이름\n뭐로 바꿀까요?',
        likes: 6,
        comments: 12,
        isLiked: false,
      ),
      ChatMainCommonQuestionCardDto(
        questionRefId: 104,
        content: '다같이 배우고 싶은\n취미가 있나요?',
        likes: 4,
        comments: 4,
        isLiked: false,
      ),
      ChatMainCommonQuestionCardDto(
        questionRefId: 105,
        content: '올해 우리 가족\n가장 기억에 남는 순간은?',
        likes: 9,
        comments: 7,
        isLiked: true,
      ),
    ];
    
    return _mainCommonCache!;
  }

  // 개인질문 상세 페이지 Mock 데이터
  static ChatPersonalDetailResponseDto getPersonalDetailData(String questionId) {
    final qId = int.parse(questionId);
    
    // 먼저 답변한 질문 캐시에서 확인
    if (_answeredQuestionsCache.containsKey(qId)) {
      print('📝 [Mock] 답변한 질문의 스레드 데이터 반환: $qId');
      return _answeredQuestionsCache[qId]!;
    }
    
    // questionId에 따라 다른 상세 데이터 반환
    if (qId == 1) {
    return ChatPersonalDetailResponseDto(
      question: ChatPersonalDetailQuestionDto(
          questionRefId: 1,
          content: '아빠 어렸을 때 꿈이 뭐였어요?',
          sender: 127,
          senderRole: '나',
          likes: 5,
          createdAt: '2025-10-10 09:15:22.0',
        isLiked: true,
      ),
      comments: [
        ChatPersonalDetailCommentDto(
          commentId: 1,
            writer: 123, // 아버지
            writerRole: '아버지',
            content: '파일럿이 되고 싶었단다. 하늘을 날고 싶었어',
            likes: 3,
            isLiked: true,
            reply: [
              ChatPersonalDetailCommentDto(
                commentId: 2,
                writer: 127, // 나
                writerRole: '나',
                content: '와 멋있다! 왜 안 되셨어요?',
                likes: 1,
                isLiked: false,
                reply: [],
              ),
            ],
          ),
          ChatPersonalDetailCommentDto(
            commentId: 3,
            writer: 124, // 어머니
            writerRole: '어머니',
            content: '아버지 시력이 안 좋아서 포기했대요',
            likes: 2,
            isLiked: false,
            reply: [],
          ),
        ],
      );
    } else if (qId == 2) {
      return ChatPersonalDetailResponseDto(
        question: ChatPersonalDetailQuestionDto(
          questionRefId: 2,
          content: '할머니, 처음 할아버지 만났을 때 기억나세요?',
          sender: 124,
          senderRole: '어머니',
          likes: 8,
          createdAt: '2025-10-09 15:30:00.0',
          isLiked: false,
        ),
        comments: [
          ChatPersonalDetailCommentDto(
            commentId: 4,
            writer: 126, // 할머니
            writerRole: '할머니',
            content: '소개팅으로 만났는데, 첫인상이 참 성실해 보였어요',
            likes: 5,
            isLiked: true,
            reply: [
              ChatPersonalDetailCommentDto(
                commentId: 5,
                writer: 125, // 할아버지
                writerRole: '할아버지',
                content: '나도 첫눈에 반했지',
                likes: 8,
                isLiked: true,
                reply: [],
              ),
            ],
          ),
          ChatPersonalDetailCommentDto(
            commentId: 6,
            writer: 123, // 아버지
            writerRole: '아버지',
            content: '우와 로맨틱하네요 ㅎㅎ',
            likes: 2,
          isLiked: false,
          reply: [],
        ),
        ChatPersonalDetailCommentDto(
            commentId: 7,
            writer: 127, // 나
            writerRole: '나',
            content: '할머니 할아버지 사랑 이야기 더 듣고 싶어요!',
            likes: 3,
            isLiked: false,
            reply: [],
          ),
        ],
      );
    } else if (qId == 3) {
      return ChatPersonalDetailResponseDto(
        question: ChatPersonalDetailQuestionDto(
          questionRefId: 3,
          content: '엄마가 가장 좋아하는 노래가 뭐예요?',
          sender: 127,
          senderRole: '나',
          likes: 2,
          createdAt: '2025-10-11 20:45:10.0',
          isLiked: false,
        ),
        comments: [
          ChatPersonalDetailCommentDto(
            commentId: 8,
            writer: 124, // 어머니
            writerRole: '어머니',
            content: '이문세의 "옛사랑"이야. 결혼 전에 많이 들었어',
            likes: 1,
            isLiked: true,
          reply: [
            ChatPersonalDetailCommentDto(
                commentId: 9,
                writer: 127, // 나
                writerRole: '나',
                content: '나중에 같이 들어봐요!',
                likes: 1,
              isLiked: false,
              reply: [],
            ),
          ],
        ),
      ],
      );
    } else if (qId == 4) {
      return ChatPersonalDetailResponseDto(
        question: ChatPersonalDetailQuestionDto(
          questionRefId: 4,
          content: '할아버지, 군대 시절 이야기 해주세요',
          sender: 123,
          senderRole: '아버지',
          likes: 8,
          createdAt: '2025-10-08 11:20:00.0',
          isLiked: true,
        ),
        comments: [
          ChatPersonalDetailCommentDto(
            commentId: 10,
            writer: 125, // 할아버지
            writerRole: '할아버지',
            content: '힘들었지만 전우들과의 우정은 평생 기억에 남는구나',
            likes: 4,
            isLiked: true,
            reply: [],
          ),
          ChatPersonalDetailCommentDto(
            commentId: 11,
            writer: 123, // 아버지
            writerRole: '아버지',
            content: '어떤 보직이셨어요?',
            likes: 1,
            isLiked: false,
            reply: [
              ChatPersonalDetailCommentDto(
                commentId: 12,
                writer: 125, // 할아버지
                writerRole: '할아버지',
                content: '취사병이었단다. 밥 짓는 솜씨는 그때 배웠지',
                likes: 5,
                isLiked: true,
                reply: [],
              ),
            ],
          ),
          ChatPersonalDetailCommentDto(
            commentId: 13,
            writer: 127, // 나
            writerRole: '나',
            content: '저도 나중에 군대 가면 잘 해낼 수 있을까요?',
            likes: 2,
            isLiked: false,
            reply: [],
          ),
        ],
      );
    } else if (qId == 5) {
      return ChatPersonalDetailResponseDto(
        question: ChatPersonalDetailQuestionDto(
          questionRefId: 5,
          content: '아버지가 제일 기억에 남는 여행지는?',
          sender: 124,
          senderRole: '어머니',
          likes: 3,
          createdAt: '2025-10-07 18:00:00.0',
          isLiked: false,
        ),
        comments: [
          ChatPersonalDetailCommentDto(
            commentId: 14,
            writer: 123, // 아버지
            writerRole: '아버지',
            content: '신혼여행 갔던 제주도가 아직도 생생해',
            likes: 3,
            isLiked: true,
            reply: [],
          ),
        ],
      );
    }
    
    // 기본값 (위 조건에 해당 안되는 경우)
    return ChatPersonalDetailResponseDto(
      question: ChatPersonalDetailQuestionDto(
        questionRefId: qId,
        content: '질문 내용',
        sender: 123,
        senderRole: '아버지',
        likes: 0,
        createdAt: '2025-10-13 00:00:00.0',
        isLiked: false,
      ),
      comments: [],
    );
  }

  // 나에게 온 질문 목록 Mock 데이터
  /// 나에게 온 질문 목록용 Mock 데이터를 반환 (싱글톤 캐시)
  /// ChatService.getChatMyQuestions() API 호출 실패 시 사용
  static List<ChatPersonalAnswerQuestionDto> getMyQuestionsData() {
    if (_myQuestionsCache != null) return _myQuestionsCache!;
    
    _myQuestionsCache = [
      ChatPersonalAnswerQuestionDto(
        questionRefId: 201,
        content: '요즘 학교 생활은 어때?',
        sender: 124, // 어머니
        senderRole: '어머니',
        visibility: true, // 공개
      ),
      ChatPersonalAnswerQuestionDto(
        questionRefId: 202,
        content: '주말에 같이 영화 볼까?',
        sender: 123, // 아버지
        senderRole: '아버지',
        visibility: false, // 비공개
      ),
      ChatPersonalAnswerQuestionDto(
        questionRefId: 203,
        content: '손자야, 할머니 생일 선물 뭐가 좋을까?',
        sender: 125, // 할아버지
        senderRole: '할아버지',
        visibility: true, // 공개
      ),
    ];
    
    return _myQuestionsCache!;
  }

  /// 가족구성원 목록용 Mock 데이터를 반환 (싱글톤 캐시)
  /// ChatService.getFamilyMembers() API 호출 실패 시 사용
  static List<ChatFamilyMemberDto> getFamilyMembersData() {
    if (_familyMembersCache != null) return _familyMembersCache!;
    
    _familyMembersCache = [
      ChatFamilyMemberDto(id: 123, role: '아버지'),
      ChatFamilyMemberDto(id: 124, role: '어머니'),
      ChatFamilyMemberDto(id: 125, role: '할아버지'),
      ChatFamilyMemberDto(id: 126, role: '할머니'),
      ChatFamilyMemberDto(id: 128, role: '형'), // 형 추가 (본인은 제외)
    ];
    
    return _familyMembersCache!;
  }


  // 이번주 공통질문 Mock 데이터
  /// 이번주 공통질문용 Mock 데이터를 반환 (싱글톤 캐시)
  /// ChatService.getWeeklyCommonQuestion() API 호출 실패 시 사용
  static ChatWeeklyCommonQuestionDto getWeeklyCommonQuestionData() {
    if (_weeklyCommonCache != null) return _weeklyCommonCache!;
    
    _weeklyCommonCache = ChatWeeklyCommonQuestionDto(
      questionId: 234,
      questionContent: '우리 가족만의\n연말 전통이 있나요?',
      likes: 7,
      posts: 3,
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
    final qId = int.parse(questionId);
    
    // questionId에 따라 다른 상세 데이터 반환
    if (qId == 234) {
      // 우리 가족만의 연말 전통이 있나요?
    return ChatCommonDetailResponseDto(
      question: ChatCommonDetailQuestionDto(
          questionRefId: 234,
          content: '우리 가족만의\n연말 전통이 있나요?',
          likes: 7,
          createdAt: '2025-10-13 08:00:00',
          count: 3,
        isLiked: false,
      ),
      comments: [
        ChatCommonDetailCommentDto(
          commentId: 1,
            writer: 125, // 할아버지
            writerRole: '할아버지',
            content: '매년 제사상 차리면서 옛날 이야기 나누지',
            likes: 3,
            isLiked: true,
            reply: [],
          ),
          ChatCommonDetailCommentDto(
            commentId: 2,
            writer: 124, // 어머니
            writerRole: '어머니',
            content: '크리스마스에 다같이 케이크 만들어요',
            likes: 2,
            isLiked: false,
            reply: [],
          ),
          ChatCommonDetailCommentDto(
            commentId: 3,
            writer: 126, // 할머니
            writerRole: '할머니',
            content: '송편 빚으면서 소원 말하는 게 우리 전통이에요',
            likes: 4,
            isLiked: true,
            reply: [],
          ),
        ],
      );
    } else if (qId == 101) {
      // 이번 설날에 다같이 뭐 하고 싶으세요?
      return ChatCommonDetailResponseDto(
        question: ChatCommonDetailQuestionDto(
          questionRefId: 101,
          content: '이번 설날에 다같이\n뭐 하고 싶으세요?',
          likes: 9,
          createdAt: '2025-10-12 10:00:00',
          count: 6,
          isLiked: true,
        ),
        comments: [
          ChatCommonDetailCommentDto(
            commentId: 4,
            writer: 127, // 나
            writerRole: '나',
            content: '윷놀이 하고 싶어요!',
            likes: 5,
            isLiked: true,
            reply: [
              ChatCommonDetailCommentDto(
                commentId: 5,
                writer: 123, // 아버지
                writerRole: '아버지',
                content: '좋지! 작년에도 재미있었잖아',
                likes: 3,
                isLiked: false,
                reply: [],
              ),
            ],
          ),
          ChatCommonDetailCommentDto(
            commentId: 6,
            writer: 124, // 어머니
            writerRole: '어머니',
            content: '떡국 만들기 체험 어때요?',
            likes: 8,
            isLiked: true,
            reply: [],
          ),
          ChatCommonDetailCommentDto(
            commentId: 7,
            writer: 126, // 할머니
            writerRole: '할머니',
            content: '다같이 한복 입고 사진 찍자',
            likes: 12,
            isLiked: true,
            reply: [
              ChatCommonDetailCommentDto(
                commentId: 8,
                writer: 127, // 나
                writerRole: '나',
                content: '완전 좋아요! 인생샷 찍어요',
                likes: 4,
                isLiked: true,
                reply: [],
              ),
            ],
          ),
          ChatCommonDetailCommentDto(
            commentId: 9,
            writer: 125, // 할아버지
            writerRole: '할아버지',
            content: '세배돈도 준비해야지',
            likes: 6,
            isLiked: false,
            reply: [],
          ),
        ],
      );
    } else if (qId == 102) {
      // 가족 모두 함께 가보고 싶은 여행지는?
      return ChatCommonDetailResponseDto(
        question: ChatCommonDetailQuestionDto(
          questionRefId: 102,
          content: '가족 모두 함께\n가보고 싶은 여행지는?',
          likes: 8,
          createdAt: '2025-10-11 14:30:00',
          count: 8,
          isLiked: true,
        ),
        comments: [
          ChatCommonDetailCommentDto(
            commentId: 10,
            writer: 123, // 아버지
            writerRole: '아버지',
            content: '제주도 한달살기 어때?',
            likes: 10,
            isLiked: true,
            reply: [
              ChatCommonDetailCommentDto(
                commentId: 11,
                writer: 124, // 어머니
                writerRole: '어머니',
                content: '좋아요! 바다 보면서 휴식',
                likes: 8,
                isLiked: true,
                reply: [],
              ),
            ],
          ),
          ChatCommonDetailCommentDto(
            commentId: 12,
            writer: 127, // 나
            writerRole: '나',
            content: '일본 오키나와 가고 싶어요',
            likes: 7,
            isLiked: false,
            reply: [],
          ),
          ChatCommonDetailCommentDto(
            commentId: 13,
            writer: 125, // 할아버지
            writerRole: '할아버지',
            content: '국내 온천 여행도 좋겠어',
            likes: 12,
            isLiked: true,
            reply: [
              ChatCommonDetailCommentDto(
                commentId: 14,
                writer: 126, // 할머니
                writerRole: '할머니',
                content: '무릎에 온천 좋다더라',
                likes: 5,
                isLiked: false,
                reply: [],
              ),
            ],
          ),
          ChatCommonDetailCommentDto(
            commentId: 15,
            writer: 124, // 어머니
            writerRole: '어머니',
            content: '유럽 크루즈 여행은 어떨까요?',
            likes: 15,
            isLiked: true,
            reply: [
              ChatCommonDetailCommentDto(
                commentId: 16,
                writer: 127, // 나
                writerRole: '나',
                content: '와 대박! 꿈의 여행이다',
                likes: 6,
                isLiked: true,
                reply: [],
              ),
            ],
          ),
        ],
      );
    } else if (qId == 103) {
      // 우리 가족 단톡방 이름 뭐로 바꿀까요?
      return ChatCommonDetailResponseDto(
        question: ChatCommonDetailQuestionDto(
          questionRefId: 103,
          content: '우리 가족 단톡방 이름\n뭐로 바꿀까요?',
          likes: 6,
          createdAt: '2025-10-10 16:20:00',
          count: 12,
          isLiked: false,
        ),
        comments: [
          ChatCommonDetailCommentDto(
            commentId: 17,
            writer: 127, // 나
            writerRole: '나',
            content: '행복한 우리집',
            likes: 3,
            isLiked: false,
            reply: [],
          ),
          ChatCommonDetailCommentDto(
            commentId: 18,
            writer: 124, // 어머니
            writerRole: '어머니',
            content: '사랑가득 김씨네',
            likes: 8,
            isLiked: true,
          reply: [
            ChatCommonDetailCommentDto(
                commentId: 19,
                writer: 123, // 아버지
                writerRole: '아버지',
                content: '이거 괜찮네요',
                likes: 4,
                isLiked: true,
                reply: [],
              ),
            ],
          ),
          ChatCommonDetailCommentDto(
            commentId: 20,
            writer: 125, // 할아버지
            writerRole: '할아버지',
            content: '5대가 함께',
            likes: 6,
              isLiked: false,
              reply: [],
          ),
          ChatCommonDetailCommentDto(
            commentId: 21,
            writer: 126, // 할머니
            writerRole: '할머니',
            content: '우리가족 최고♥',
            likes: 7,
            isLiked: true,
            reply: [
              ChatCommonDetailCommentDto(
                commentId: 22,
                writer: 127, // 나
                writerRole: '나',
                content: '할머니 하트 귀여워요 ㅋㅋ',
                likes: 5,
                isLiked: true,
                reply: [],
              ),
            ],
          ),
          ChatCommonDetailCommentDto(
            commentId: 23,
            writer: 123, // 아버지
            writerRole: '아버지',
            content: '김씨네 사람들',
            likes: 9,
            isLiked: true,
            reply: [
              ChatCommonDetailCommentDto(
                commentId: 24,
                writer: 124, // 어머니
                writerRole: '어머니',
                content: '심플하고 좋은데요?',
                likes: 6,
                isLiked: true,
                reply: [],
              ),
          ],
        ),
        ChatCommonDetailCommentDto(
            commentId: 25,
            writer: 127, // 나
            writerRole: '나',
            content: '패밀리FC',
            likes: 2,
            isLiked: false,
            reply: [],
          ),
        ],
      );
    } else if (qId == 104) {
      // 다같이 배우고 싶은 취미가 있나요?
      return ChatCommonDetailResponseDto(
        question: ChatCommonDetailQuestionDto(
          questionRefId: 104,
          content: '다같이 배우고 싶은\n취미가 있나요?',
          likes: 6,
          createdAt: '2025-10-09 11:00:00',
          count: 4,
          isLiked: false,
        ),
        comments: [
          ChatCommonDetailCommentDto(
            commentId: 26,
            writer: 125, // 할아버지
            writerRole: '할아버지',
            content: '서예 배우면 좋겠어',
            likes: 4,
            isLiked: true,
            reply: [],
          ),
          ChatCommonDetailCommentDto(
            commentId: 27,
            writer: 124, // 어머니
            writerRole: '어머니',
            content: '요리 클래스 함께 들어요',
            likes: 5,
          isLiked: true,
          reply: [
            ChatCommonDetailCommentDto(
                commentId: 28,
                writer: 127, // 나
                writerRole: '나',
                content: '베이킹 배우고 싶어요!',
                likes: 3,
              isLiked: false,
              reply: [],
              ),
            ],
          ),
          ChatCommonDetailCommentDto(
            commentId: 29,
            writer: 123, // 아버지
            writerRole: '아버지',
            content: '등산 어때요? 건강에도 좋고',
            likes: 7,
            isLiked: true,
            reply: [],
          ),
        ],
      );
    } else if (qId == 105) {
      // 올해 우리 가족 가장 기억에 남는 순간은?
      return ChatCommonDetailResponseDto(
        question: ChatCommonDetailQuestionDto(
          questionRefId: 105,
          content: '올해 우리 가족\n가장 기억에 남는 순간은?',
          likes: 9,
          createdAt: '2025-10-08 20:00:00',
          count: 7,
          isLiked: true,
        ),
        comments: [
          ChatCommonDetailCommentDto(
            commentId: 30,
            writer: 126, // 할머니
            writerRole: '할머니',
            content: '손자 대학 합격했을 때',
            likes: 12,
            isLiked: true,
            reply: [
              ChatCommonDetailCommentDto(
                commentId: 31,
                writer: 127, // 나
                writerRole: '나',
                content: '할머니 고맙습니다 ㅠㅠ',
                likes: 8,
                isLiked: true,
                reply: [],
              ),
            ],
          ),
          ChatCommonDetailCommentDto(
            commentId: 32,
            writer: 123, // 아버지
            writerRole: '아버지',
            content: '여름 휴가 때 다 같이 바다 간 거',
            likes: 10,
            isLiked: true,
            reply: [],
          ),
          ChatCommonDetailCommentDto(
            commentId: 33,
            writer: 124, // 어머니
            writerRole: '어머니',
            content: '추석 때 모처럼 다같이 모인 날',
            likes: 9,
            isLiked: true,
            reply: [
              ChatCommonDetailCommentDto(
                commentId: 34,
                writer: 125, // 할아버지
                writerRole: '할아버지',
                content: '그때 정말 좋았지',
                likes: 6,
                isLiked: false,
                reply: [],
              ),
            ],
          ),
          ChatCommonDetailCommentDto(
            commentId: 35,
            writer: 127, // 나
            writerRole: '나',
            content: '할아버지 생신 파티!',
            likes: 11,
            isLiked: true,
            reply: [],
          ),
        ],
      );
    }
    
    // 기본값
    return ChatCommonDetailResponseDto(
      question: ChatCommonDetailQuestionDto(
        questionRefId: qId,
        content: '공통 질문 내용',
        likes: 0,
        createdAt: '2025-10-13 00:00:00',
        count: 0,
        isLiked: false,
      ),
      comments: [],
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

  /// 개인질문에 댓글 추가 (시연용)
  /// API 호출 실패 시 mock 데이터에 댓글 추가
  static void addPersonalComment(int questionId, int writerId, String content) {
    // 실제로는 상세 페이지 캐시를 업데이트해야 하지만
    // 시연용으로는 간단하게 처리
    print('Mock: 개인질문 $questionId에 댓글 추가됨 - 작성자: $writerId, 내용: $content');
  }

  /// 공통질문에 댓글 추가 (시연용)
  /// API 호출 실패 시 mock 데이터에 댓글 추가
  static void addCommonComment(int questionId, int writerId, String content) {
    // 실제로는 상세 페이지 캐시를 업데이트해야 하지만
    // 시연용으로는 간단하게 처리
    print('Mock: 공통질문 $questionId에 댓글 추가됨 - 작성자: $writerId, 내용: $content');
  }

  /// 개인질문에 대댓글 추가 (시연용)
  /// API 호출 실패 시 mock 데이터에 대댓글 추가
  static void addPersonalReply(int questionId, int parentCommentId, int writerId, String content) {
    // 실제로는 상세 페이지 캐시를 업데이트해야 하지만
    // 시연용으로는 간단하게 처리
    print('Mock: 개인질문 $questionId의 댓글 $parentCommentId에 대댓글 추가됨 - 작성자: $writerId, 내용: $content');
  }

  /// 공통질문에 대댓글 추가 (시연용)
  /// API 호출 실패 시 mock 데이터에 대댓글 추가
  static void addCommonReply(int questionId, int parentCommentId, int writerId, String content) {
    // 실제로는 상세 페이지 캐시를 업데이트해야 하지만
    // 시연용으로는 간단하게 처리
    print('Mock: 공통질문 $questionId의 댓글 $parentCommentId에 대댓글 추가됨 - 작성자: $writerId, 내용: $content');
  }

  /// 나에게 온 질문에 답변 처리 (시연용)
  /// 답변하면 나에게 온 질문 목록에서 제거하고, 개인질문 목록에 추가
  static void answerMyQuestion({
    required int questionRefId,
    required String answer,
  }) {
    if (_myQuestionsCache == null || _mainPersonalCache == null || _homeThisweekCache == null) {
      print('⚠️ Mock 캐시가 초기화되지 않음');
      return;
    }

    // 1. 나에게 온 질문 목록에서 해당 질문 찾기
    final questionIndex = _myQuestionsCache!.indexWhere((q) => q.questionRefId == questionRefId);
    
    if (questionIndex == -1) {
      print('⚠️ 질문을 찾을 수 없음: $questionRefId');
      return;
    }

    final answeredQuestion = _myQuestionsCache![questionIndex];
    
    print('✅ [Mock] 질문 답변 처리:');
    print('   - 질문 ID: $questionRefId');
    print('   - 질문 내용: ${answeredQuestion.content}');
    print('   - 답변: $answer');
    print('   - 공개 여부: ${answeredQuestion.visibility ? "공개" : "비공개"}');

    // 2. 나에게 온 질문 목록에서 제거
    _myQuestionsCache!.removeAt(questionIndex);
    print('   ✓ 나에게 온 질문 목록에서 제거됨 (남은 개수: ${_myQuestionsCache!.length})');

    // 3. 개인질문 목록 맨 앞에 추가 (답변 완료된 상태로)
    _mainPersonalCache!.insert(0, ChatMainPersonalQuestionCardDto(
      questionRefId: questionRefId,
      content: answeredQuestion.content,
      sender: answeredQuestion.sender,
      receiver: 127, // 나
      visibility: answeredQuestion.visibility ? 1 : 0, // true면 1(공개), false면 0(비공개)
      likes: 0,
      comments: 1, // 내 답변 1개
      isLiked: false,
    ));
    print('   ✓ 개인질문 목록에 추가됨 (${answeredQuestion.visibility ? "공개" : "비공개 🔒"})');

    // 4. 스레드 상세 데이터도 생성 (질문 + 내 답변)
    _createPersonalDetailForAnsweredQuestion(
      questionRefId: questionRefId,
      questionContent: answeredQuestion.content,
      sender: answeredQuestion.sender,
      senderRole: answeredQuestion.senderRole,
      receiver: 127,
      receiverRole: '나',
      answer: answer,
      visibility: answeredQuestion.visibility,
    );
    print('   ✓ 스레드 상세 데이터 생성됨');

    // 5. 연두색 숫자(미해결 질문 개수) 감소
    final previousUnsolved = _homeThisweekCache!.unsolved;
    _homeThisweekCache = ChatHomeThisweekResponseDto(
      questions: _homeThisweekCache!.questions,
      questionRefId: _homeThisweekCache!.questionRefId,
      comments: _homeThisweekCache!.comments,
      unsolved: previousUnsolved > 0 ? previousUnsolved - 1 : 0,
    );
    print('   ✓ 미해결 질문 개수: $previousUnsolved → ${_homeThisweekCache!.unsolved}');
    
    print('🎉 [Mock] 답변 처리 완료!');
  }

  /// 답변한 질문의 스레드 상세 데이터 생성 (내부 헬퍼 함수)
  static void _createPersonalDetailForAnsweredQuestion({
    required int questionRefId,
    required String questionContent,
    required int sender,
    required String senderRole,
    required int receiver,
    required String receiverRole,
    required String answer,
    required bool visibility,
  }) {
    // 답변한 질문의 상세 데이터를 미리 캐싱
    // getPersonalDetailData()에서 이 질문 ID로 요청이 오면 반환할 수 있도록
    // (실제로는 Map으로 관리하는게 좋지만, 시연용으로 간단히 처리)
    
    // 기존 getPersonalDetailData() 함수가 questionId를 int로 받으므로
    // 해당 함수 내에서 새로 답변한 질문도 처리할 수 있도록
    // _answeredQuestionsCache에 저장
    _answeredQuestionsCache[questionRefId] = ChatPersonalDetailResponseDto(
      question: ChatPersonalDetailQuestionDto(
        questionRefId: questionRefId,
        content: questionContent,
        sender: sender,
        senderRole: senderRole,
        likes: 0,
        createdAt: DateTime.now().toString(),
        isLiked: false,
      ),
      comments: [
        ChatPersonalDetailCommentDto(
          commentId: DateTime.now().millisecondsSinceEpoch,
          writer: receiver, // 나(127)
          writerRole: receiverRole, // '나'
          content: answer, // 내가 작성한 답변
          likes: 0,
          isLiked: false,
          reply: [],
        ),
      ],
    );
  }

  // 답변한 질문들의 상세 데이터 캐시
  static final Map<int, ChatPersonalDetailResponseDto> _answeredQuestionsCache = {};

  /// 이번주 공통질문에 내 답변 추가 (시연용)
  /// 상단 배너에서 답변하면 Mock 캐시에 추가하고, 스레드에도 반영
  static void addMyAnswerToWeeklyQuestion({
    required int questionRefId,
    required String answer,
  }) {
    if (_homeThisweekCache == null) {
      print('⚠️ Mock 캐시가 초기화되지 않음');
      return;
    }

    print('✅ [Mock] 이번주 공통질문 답변 추가:');
    print('   - 질문 ID: $questionRefId');
    print('   - 답변: $answer');

    // 1. 이번주 공통질문 캐시에 내 답변 추가 (맨 앞에)
    final updatedComments = [
      ChatHomeThisweekCommentDto(
        writer: 127, // 나
        writerRole: '나',
        contents: answer,
      ),
      ..._homeThisweekCache!.comments,
    ];

    _homeThisweekCache = ChatHomeThisweekResponseDto(
      questions: _homeThisweekCache!.questions,
      questionRefId: _homeThisweekCache!.questionRefId,
      comments: updatedComments,
      unsolved: _homeThisweekCache!.unsolved,
    );
    
    print('   ✓ 상단 배너 캐시에 답변 추가됨 (총 ${updatedComments.length}개)');

    // 2. 공통질문 상세 캐시에도 추가 (스레드 화면에서 보이도록)
    _addMyAnswerToCommonDetail(questionRefId, answer);
    
    print('🎉 [Mock] 이번주 공통질문 답변 처리 완료!');
  }

  /// 공통질문 상세 캐시에 내 답변 추가 (내부 헬퍼 함수)
  static void _addMyAnswerToCommonDetail(int questionRefId, String answer) {
    // getCommonDetailData()가 반환하는 캐시를 업데이트
    // 실제로는 동적 캐싱 구조가 필요하지만, 시연용으로 간단히 처리
    
    // questionRefId가 234인 경우 (현재 이번주 질문)
    if (questionRefId == 234) {
      // 기존 상세 데이터가 있다면 댓글 추가
      // 없다면 새로 생성
      print('   ✓ 스레드 상세 캐시에도 반영 준비 (questionRefId: $questionRefId)');
      
      // TODO: 실제 구현 시 _commonDetailCache 같은 Map 구조로 관리
      // 현재는 로그만 출력
    }
  }
}

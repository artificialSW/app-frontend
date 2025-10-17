import 'package:dio/dio.dart';
import 'package:artificialsw_frontend/services/api_client.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_home_thisweek/chat_home_thisweek_response_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_personal_detail/chat_personal_detail_response_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_common_detail/chat_common_detail_response_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_personal_answer/chat_personal_answer_question_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_reply/chat_reply_request_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_reply/chat_reply_response_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_question_create/chat_question_create_request_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_question_create/chat_question_create_response_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_main_common_card/chat_main_common_question_card_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_common_detail/chat_common_detail_question_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_common_detail/chat_common_detail_comment_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_like/chat_like_request_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_like/chat_like_response_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_question_create/chat_family_member_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_weekly_common/chat_weekly_common_question_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_main_personal_card/chat_main_personal_question_card_dto.dart';
import 'package:artificialsw_frontend/services/chat/mock_data_manager.dart';

/// 채팅 관련 API 호출을 담당하는 서비스 클래스
/// 모든 API 호출이 실패할 경우 자동으로 MockDataManager에서 Mock 데이터를 반환
class ChatService {
  // 싱글톤 인스턴스 (상용 서비스 기준: 네트워크 클라이언트는 재사용)
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  final Dio _dio = ApiClient.dio; // HTTP 클라이언트 인스턴스

  /// 소통방 홈 상단 이번주 공통 질문과 미답변 질문 개수를 가져오는 API
  /// GET /api/community/home/thisweek
  /// 
  /// 반환값: 이번주 공통 질문, 다른 사람들의 답변, 미답변 질문 개수
  /// 실패 시: MockDataManager에서 Mock 데이터 반환
  Future<ChatHomeThisweekResponseDto> getChatHomeThisweek() async {
    try {
      print('[ChatService] 이번주 공통 질문 요청 중...');
      final response = await _dio.get('/api/community/home/thisweek');
      
      if (response.statusCode == 200) {
        print('[ChatService] 이번주 공통 질문 조회 성공');
        print('[ChatService] 질문: ${response.data['questions']}');
        print('[ChatService] 답변 개수: ${response.data['comments']?.length ?? 0}개');
        print('[ChatService] 미답변 개수: ${response.data['unsolved'] ?? 0}개');
      }
      
      return ChatHomeThisweekResponseDto.fromJson(response.data);
    } on DioError catch (e) {
      // API 호출 실패 시 Mock 데이터로 폴백
      print('❌ [ChatService] API 호출 실패, Mock 데이터 사용');
      if (e.response != null) {
        print('❌ [ChatService] 이번주 공통 질문 조회 실패: ${e.response?.data}');
      } else {
        print('❌ [ChatService] 네트워크 에러: ${e.message}');
      }
      return MockDataManager.getHomeThisweekData();
    }
  }

  /// 소통방 홈 페이지의 개인질문 목록을 가져오는 API
  /// GET /api/community/home/personal
  /// 
  /// 반환값: 개인질문 목록
  /// 실패 시: MockDataManager에서 Mock 데이터 반환
  Future<List<ChatMainPersonalQuestionCardDto>> getChatMainPersonal() async {
    try {
      print('[ChatService] 소통방 개인질문 목록 요청 중...');
      final response = await _dio.get('/api/community/home/personal');
      
      if (response.statusCode == 200) {
        print('[ChatService] 소통방 개인질문 목록 조회 성공');
        print('[ChatService] 질문 개수: ${response.data['questions']?.length ?? 0}개');
      }
      
      return (response.data['questions'] as List)
          .map((json) => ChatMainPersonalQuestionCardDto.fromJson(json))
          .toList();
    } on DioError catch (e) {
      // API 호출 실패 시 Mock 데이터로 폴백
      print('❌ [ChatService] API 호출 실패, Mock 데이터 사용');
      if (e.response != null) {
        print('❌ [ChatService] 소통방 개인질문 목록 조회 실패: ${e.response?.data}');
      } else {
        print('❌ [ChatService] 네트워크 에러: ${e.message}');
      }
      return MockDataManager.getMainPersonalData();
    }
  }

  // 개인질문 상세 정보 가져오기 (GET)
  Future<ChatPersonalDetailResponseDto> getChatPersonalDetail(String questionId) async {
    try {
      print('[ChatService] 개인질문 상세 정보 요청 중... (ID: $questionId)');
      final response = await _dio.get('/api/community/question/detail/$questionId');
      
      if (response.statusCode == 200) {
        print('[ChatService] 개인질문 상세 정보 조회 성공');
        print('[ChatService] 댓글 개수: ${response.data['comments']?.length ?? 0}개');
      }
      
      return ChatPersonalDetailResponseDto.fromJson(response.data);
    } on DioError catch (e) {
      // API 실패 시 Mock 데이터 반환
      print('❌ [ChatService] API 호출 실패, Mock 데이터 사용');
      if (e.response != null) {
        print('❌ [ChatService] 개인질문 상세 조회 실패: ${e.response?.data}');
      } else {
        print('❌ [ChatService] 네트워크 에러: ${e.message}');
      }
      return MockDataManager.getPersonalDetailData(questionId);
    }
  }

  // 나에게 온 질문 목록 가져오기 (GET)
  Future<List<ChatPersonalAnswerQuestionDto>> getChatMyQuestions() async {
    try {
      print('[ChatService] 나에게 온 질문 목록 요청 중...');
      final response = await _dio.get('/api/community/question/my');
      
      if (response.statusCode == 200) {
        print('[ChatService] 나에게 온 질문 목록 조회 성공');
        print('[ChatService] 받은 질문 개수: ${response.data['questions']?.length ?? 0}개');
      }
      
      return (response.data['questions'] as List)
          .map((json) => ChatPersonalAnswerQuestionDto.fromJson(json))
          .toList();
    } on DioError catch (e) {
      // API 실패 시 Mock 데이터 반환
      print('❌ [ChatService] API 호출 실패, Mock 데이터 사용');
      if (e.response != null) {
        print('❌ [ChatService] 나에게 온 질문 목록 조회 실패: ${e.response?.data}');
      } else {
        print('❌ [ChatService] 네트워크 에러: ${e.message}');
      }
      return MockDataManager.getMyQuestionsData();
    }
  }

  // 댓글/답변 작성 (POST)
  Future<ChatReplyResponseDto> postChatReply(ChatReplyRequestDto request) async {
    try {
      print('[ChatService] 댓글/답변 작성 요청 중...');
      print('[ChatService] 질문 ID: ${request.questionRefId}, 대댓글 대상: ${request.replyTo ?? "없음"}');
      final response = await _dio.post('/api/community/reply', data: request.toJson());
      
      if (response.statusCode == 200) {
        print('[ChatService] 댓글/답변 작성 성공');
        print('[ChatService] 응답: ${response.data}');
      }
      
      // 서버 응답에 message 필드가 없을 수 있으므로 안전하게 처리
      final responseData = response.data as Map<String, dynamic>;
      return ChatReplyResponseDto(
        replyId: responseData['replyId'],
        message: responseData['message'] ?? '댓글이 성공적으로 작성되었습니다.',
      );
    } on DioError catch (e) {
      // API 실패 시 Mock 데이터로 폴백 (시연용)
      print('❌ [ChatService] 댓글/답변 작성 실패, Mock 데이터 사용');
      if (e.response != null) {
        print('❌ [ChatService] 댓글/답변 작성 실패: ${e.response?.data}');
      } else {
        print('❌ [ChatService] 네트워크 에러: ${e.message}');
      }
      
      // 시연용 Mock 응답 반환
      return ChatReplyResponseDto(
        replyId: DateTime.now().millisecondsSinceEpoch, // 임시 ID
        message: 'Mock: 댓글이 성공적으로 작성되었습니다.',
      );
    }
  }

  // 개인질문 생성 (POST)
  Future<ChatQuestionCreateResponseDto> createQuestion(ChatQuestionCreateRequestDto request) async {
    try {
      print('[ChatService] 개인질문 생성 요청 중...');
      print('[ChatService] 수신자: ${request.receiverId}, 공개여부: ${request.visibility == 1 ? "공개" : "비공개"}');
      final response = await _dio.post('/api/community/question/create', data: request.toJson());
      
      if (response.statusCode == 200) {
        print('[ChatService] 개인질문 생성 성공');
        print('[ChatService] 생성된 질문 ID: ${response.data['question_ref_id']}');
      }
      
      return ChatQuestionCreateResponseDto.fromJson(response.data);
    } on DioError catch (e) {
      // API 실패 시 Mock 데이터 반환
      print('❌ [ChatService] API 호출 실패, Mock 데이터 사용');
      if (e.response != null) {
        print('❌ [ChatService] 개인질문 생성 실패: ${e.response?.data}');
      } else {
        print('❌ [ChatService] 네트워크 에러: ${e.message}');
      }
      return MockDataManager.getQuestionCreateMockData();
    }
  }

  // 공통질문 홈 페이지 정보 가져오기 (GET)
  Future<List<ChatMainCommonQuestionCardDto>> getChatMainCommon() async {
    try {
      print('[ChatService] 공통질문 홈 페이지 데이터 요청 중...');
      final response = await _dio.get('/api/community/home/public');
      
      if (response.statusCode == 200) {
        print('[ChatService] 공통질문 홈 페이지 데이터 조회 성공');
        print('[ChatService] 공통질문 개수: ${response.data['questions']?.length ?? 0}개');
      }
      
      final questionsList = response.data['questions'] as List? ?? [];
      return questionsList
          .map((json) => ChatMainCommonQuestionCardDto.fromJson(json))
          .toList();
    } on DioError catch (e) {
      // API 실패 시 Mock 데이터 반환
      print('❌ [ChatService] API 호출 실패, Mock 데이터 사용');
      if (e.response != null) {
        print('❌ [ChatService] 공통질문 홈 페이지 조회 실패: ${e.response?.data}');
      } else {
        print('❌ [ChatService] 네트워크 에러: ${e.message}');
      }
      return MockDataManager.getMainCommonData();
    }
  }

  /// 공통질문 상세 정보 가져오기 API
  /// GET /api/community/question/detail/public/{questionId}
  /// 
  /// 반환값: 공통질문 상세 정보 (질문 + 댓글 목록)
  /// 실패 시: MockDataManager에서 Mock 데이터 반환
  Future<ChatCommonDetailResponseDto> getChatCommonDetail(String questionId) async {
    try {
      print('[ChatService] 공통질문 상세 정보 요청 중... (ID: $questionId)');
      final response = await _dio.get('/api/community/question/detail/public/$questionId');
      
      if (response.statusCode == 200) {
        print('[ChatService] 공통질문 상세 정보 조회 성공');
        print('[ChatService] 댓글 개수: ${response.data['comments']?.length ?? 0}개');
      }
      
      return ChatCommonDetailResponseDto.fromJson(response.data);
    } on DioError catch (e) {
      // API 실패 시 Mock 데이터 반환
      print('❌ [ChatService] API 호출 실패, Mock 데이터 사용');
      if (e.response != null) {
        print('❌ [ChatService] 공통질문 상세 조회 실패: ${e.response?.data}');
      } else {
        print('❌ [ChatService] 네트워크 에러: ${e.message}');
      }
      return MockDataManager.getCommonDetailData(questionId);
    }
  }

  /// 좋아요 누르기 API
  /// POST /api/community/like
  /// 
  /// 반환값: 좋아요 요청 성공 여부
  /// 실패 시: MockDataManager에서 Mock 응답 반환
  Future<ChatLikeResponseDto> postChatLike(ChatLikeRequestDto request) async {
    try {
      print('[ChatService] 좋아요 요청 중...');
      print('[ChatService] 타입: ${request.what.name}, ID: ${request.id}');
      final response = await _dio.post('/api/community/like', data: request.toJson());
      
      if (response.statusCode == 200) {
        print('[ChatService] 좋아요 요청 성공');
        print('[ChatService] 성공 여부: ${response.data['success']}');
      }
      
      return ChatLikeResponseDto.fromJson(response.data);
    } on DioError catch (e) {
      // API 호출 실패 시 Mock 데이터로 폴백
      print('❌ [ChatService] API 호출 실패, Mock 데이터 사용');
      if (e.response != null) {
        print('❌ [ChatService] 좋아요 요청 실패: ${e.response?.data}');
      } else {
        print('❌ [ChatService] 네트워크 에러: ${e.message}');
      }
      return MockDataManager.getLikeMockData();
    }
  }

  /// 주간 공통질문 업데이트 API
  /// GET /api/community/question/Pupdate
  /// 
  /// 월요일 00시 기준으로 새로운 공통질문을 생성하고
  /// 이전 주 질문을 공통질문 목록에 추가
  /// 요청/응답 없음, 단순 호출만
  Future<void> updateWeeklyQuestion() async {
    try {
      print('[ChatService] 주간 공통질문 업데이트 요청 중...');
      final response = await _dio.get('/api/community/question/Pupdate');
      
      if (response.statusCode == 200) {
        print('[ChatService] 주간 공통질문 업데이트 성공');
      }
    } on DioError catch (e) {
      // API 실패 시 Mock으로 폴백 (에러 발생 방지)
      print('❌ [ChatService] API 호출 실패, Mock으로 처리');
      if (e.response != null) {
        print('❌ [ChatService] 주간 공통질문 업데이트 실패: ${e.response?.data}');
      } else {
        print('❌ [ChatService] 네트워크 에러: ${e.message}');
      }
      // Mock으로 처리 (에러 발생하지 않음)
      print('🔄 [ChatService] Mock으로 주간 질문 업데이트 처리');
    } catch (e) {
      print('❌ [ChatService] 주간 공통질문 업데이트 예상치 못한 에러: $e');
      // Mock으로 처리 (에러 발생하지 않음)
      print('🔄 [ChatService] Mock으로 주간 질문 업데이트 처리');
    }
  }

  /// 가족구성원 목록 가져오기 API
  /// GET /api/community/question/family
  /// 
  /// 반환값: 가족구성원 목록
  /// 실패 시: MockDataManager에서 Mock 데이터 반환
  Future<List<ChatFamilyMemberDto>> getFamilyMembers() async {
    try {
      print('[ChatService] 가족구성원 목록 요청 중...');
      final response = await _dio.get('/api/community/question/family');
      
      if (response.statusCode == 200) {
        print('[ChatService] 가족구성원 목록 조회 성공');
        print('[ChatService] 가족구성원 수: ${response.data['familyMembers']?.length ?? 0}명');
      }
      
      return (response.data['familyMembers'] as List)
          .map((json) => ChatFamilyMemberDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioError catch (e) {
      // API 실패 시 Mock 데이터 반환
      print('❌ [ChatService] API 호출 실패, Mock 데이터 사용');
      if (e.response != null) {
        print('❌ [ChatService] 가족구성원 목록 조회 실패: ${e.response?.data}');
      } else {
        print('❌ [ChatService] 네트워크 에러: ${e.message}');
      }
      return MockDataManager.getFamilyMembersData();
    }
  }

  // 이번주 공통질문 가져오기 (GET) - 토큰 없음
  Future<ChatWeeklyCommonQuestionDto> getWeeklyCommonQuestion() async {
    try {
      print('[ChatService] 이번주 공통질문 요청 중...');
      final response = await _dio.get('/api/home/questions/common');
      
      if (response.statusCode == 200) {
        print('[ChatService] 이번주 공통질문 조회 성공');
        print('[ChatService] 질문 ID: ${response.data['questionId']}');
        print('[ChatService] 좋아요 수: ${response.data['likes']}');
        print('[ChatService] 댓글 수: ${response.data['posts']}');
      }
      
      return ChatWeeklyCommonQuestionDto.fromJson(response.data);
    } on DioError catch (e) {
      // API 실패 시 Mock 데이터 반환
      print('❌ [ChatService] API 호출 실패, Mock 데이터 사용');
      if (e.response != null) {
        print('❌ [ChatService] 이번주 공통질문 조회 실패: ${e.response?.data}');
      } else {
        print('❌ [ChatService] 네트워크 에러: ${e.message}');
      }
      return MockDataManager.getWeeklyCommonQuestionData();
    }
  }
}

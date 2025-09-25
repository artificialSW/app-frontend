import 'package:dio/dio.dart';
import 'package:artificialsw_frontend/services/api_client.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_main_personal/chat_main_personal_response_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_personal_detail/chat_personal_detail_response_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_my_questions/chat_my_questions_response_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_reply/chat_reply_request_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_reply/chat_reply_response_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_question_create/chat_question_create_request_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_question_create/chat_question_create_response_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_main_common/chat_main_common_question_dto.dart';

class ChatService {
  final Dio _dio = ApiClient.dio;

  // 소통방 홈 페이지 정보 가져오기 (GET)
  Future<ChatMainPersonalResponseDto> getChatMainPersonal() async {
    try {
      print('[ChatService] 소통방 홈 페이지 데이터 요청 중...');
      final response = await _dio.get('/api/community/home');
      
      if (response.statusCode == 200) {
        print('[ChatService] 소통방 홈 페이지 데이터 조회 성공');
        print('[ChatService] 질문 개수: ${response.data['questions']?.length ?? 0}개');
        print('[ChatService] 미답변 개수: ${response.data['unsolved'] ?? 0}개');
      }
      
      return ChatMainPersonalResponseDto.fromJson(response.data);
    } on DioError catch (e) {
      // Dio 예외 처리
      if (e.response != null) {
        print('❌ [ChatService] 소통방 홈 페이지 조회 실패: ${e.response?.data}');
      } else {
        print('❌ [ChatService] 네트워크 에러: ${e.message}');
      }
      rethrow;
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
      // Dio 예외 처리
      if (e.response != null) {
        print('❌ [ChatService] 개인질문 상세 조회 실패: ${e.response?.data}');
      } else {
        print('❌ [ChatService] 네트워크 에러: ${e.message}');
      }
      rethrow;
    }
  }

  // 나에게 온 질문 목록 가져오기 (GET)
  Future<ChatMyQuestionsResponseDto> getChatMyQuestions() async {
    try {
      print('[ChatService] 나에게 온 질문 목록 요청 중...');
      final response = await _dio.get('/api/community/question/my');
      
      if (response.statusCode == 200) {
        print('[ChatService] 나에게 온 질문 목록 조회 성공');
        print('[ChatService] 받은 질문 개수: ${response.data['questions']?.length ?? 0}개');
      }
      
      return ChatMyQuestionsResponseDto.fromJson(response.data);
    } on DioError catch (e) {
      // Dio 예외 처리
      if (e.response != null) {
        print('❌ [ChatService] 나에게 온 질문 목록 조회 실패: ${e.response?.data}');
      } else {
        print('❌ [ChatService] 네트워크 에러: ${e.message}');
      }
      rethrow;
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
      
      return ChatReplyResponseDto.fromJson(response.data);
    } on DioError catch (e) {
      // Dio 예외 처리
      if (e.response != null) {
        print('❌ [ChatService] 댓글/답변 작성 실패: ${e.response?.data}');
      } else {
        print('❌ [ChatService] 네트워크 에러: ${e.message}');
      }
      rethrow;
    }
  }

  // 개인질문 생성 (POST)
  Future<ChatQuestionCreateResponseDto> createQuestion(ChatQuestionCreateRequestDto request) async {
    try {
      print('[ChatService] 개인질문 생성 요청 중...');
      print('[ChatService] 수신자: ${request.receiverId}, 공개여부: ${request.isPublic ? "공개" : "비공개"}');
      final response = await _dio.post('/api/community/question/create', data: request.toJson());
      
      if (response.statusCode == 200) {
        print('[ChatService] 개인질문 생성 성공');
        print('[ChatService] 생성된 질문 ID: ${response.data['questionId']}');
      }
      
      return ChatQuestionCreateResponseDto.fromJson(response.data);
    } on DioError catch (e) {
      // Dio 예외 처리
      if (e.response != null) {
        print('❌ [ChatService] 개인질문 생성 실패: ${e.response?.data}');
      } else {
        print('❌ [ChatService] 네트워크 에러: ${e.message}');
      }
      rethrow;
    }
  }

  // 공통질문 홈 페이지 정보 가져오기 (GET)
  Future<List<ChatMainCommonQuestionDto>> getChatMainCommon() async {
    try {
      print('[ChatService] 공통질문 홈 페이지 데이터 요청 중...');
      final response = await _dio.get('/api/community/home/public');
      
      if (response.statusCode == 200) {
        print('[ChatService] 공통질문 홈 페이지 데이터 조회 성공');
        print('[ChatService] 공통질문 개수: ${response.data['qusetions']?.length ?? 0}개');
      }
      
      return (response.data['qusetions'] as List)
          .map((json) => ChatMainCommonQuestionDto.fromJson(json))
          .toList();
    } on DioError catch (e) {
      // Dio 예외 처리
      if (e.response != null) {
        print('❌ [ChatService] 공통질문 홈 페이지 조회 실패: ${e.response?.data}');
      } else {
        print('❌ [ChatService] 네트워크 에러: ${e.message}');
      }
      rethrow;
    }
  }
}

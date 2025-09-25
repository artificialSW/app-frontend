import 'package:dio/dio.dart';
import 'package:artificialsw_frontend/services/api_client.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_main_personal/chat_main_personal_response_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_personal_detail/chat_personal_detail_response_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_my_questions/chat_my_questions_response_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_reply/chat_reply_request_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_reply/chat_reply_response_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_question_create/chat_question_create_request_dto.dart';
import 'package:artificialsw_frontend/services/chat/dto/chat_question_create/chat_question_create_response_dto.dart';

class ChatService {
  final Dio _dio = ApiClient.dio;

  // 🟢 소통방 홈 페이지 정보 가져오기 (GET)
  Future<ChatMainPersonalResponseDto> getChatMainPersonal() async {
    try {
      final response = await _dio.get('/api/community/home');
      return ChatMainPersonalResponseDto.fromJson(response.data);
    } on DioError catch (e) {
      // Dio 예외 처리
      if (e.response != null) {
        print('에러: ${e.response?.data}');
      } else {
        print('네트워크 에러: ${e.message}');
      }
      rethrow;
    }
  }

  // 🟢 개인질문 상세 정보 가져오기 (GET)
  Future<ChatPersonalDetailResponseDto> getChatPersonalDetail(String questionId) async {
    try {
      final response = await _dio.get('/api/community/question/detail/$questionId');
      return ChatPersonalDetailResponseDto.fromJson(response.data);
    } on DioError catch (e) {
      // Dio 예외 처리
      if (e.response != null) {
        print('에러: ${e.response?.data}');
      } else {
        print('네트워크 에러: ${e.message}');
      }
      rethrow;
    }
  }

  // 🟢 나에게 온 질문 목록 가져오기 (GET)
  Future<ChatMyQuestionsResponseDto> getChatMyQuestions() async {
    try {
      final response = await _dio.get('/api/community/question/my');
      return ChatMyQuestionsResponseDto.fromJson(response.data);
    } on DioError catch (e) {
      // Dio 예외 처리
      if (e.response != null) {
        print('에러: ${e.response?.data}');
      } else {
        print('네트워크 에러: ${e.message}');
      }
      rethrow;
    }
  }

  // 🟢 댓글/답변 작성 (POST)
  Future<ChatReplyResponseDto> postChatReply(ChatReplyRequestDto request) async {
    try {
      final response = await _dio.post('/api/community/reply', data: request.toJson());
      return ChatReplyResponseDto.fromJson(response.data);
    } on DioError catch (e) {
      // Dio 예외 처리
      if (e.response != null) {
        print('에러: ${e.response?.data}');
      } else {
        print('네트워크 에러: ${e.message}');
      }
      rethrow;
    }
  }

  // 🟢 개인질문 생성 (POST)
  Future<ChatQuestionCreateResponseDto> createQuestion(ChatQuestionCreateRequestDto request) async {
    try {
      final response = await _dio.post('/api/community/question/create', data: request.toJson());
      return ChatQuestionCreateResponseDto.fromJson(response.data);
    } on DioError catch (e) {
      // Dio 예외 처리
      if (e.response != null) {
        print('에러: ${e.response?.data}');
      } else {
        print('네트워크 에러: ${e.message}');
      }
      rethrow;
    }
  }
}

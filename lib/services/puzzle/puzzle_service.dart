import 'dart:io';

import 'package:artificialsw_frontend/services/puzzle/dto/puzzle_create/puzzle_create_request_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/puzzle_create/puzzle_create_response_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/puzzle_save_progress/puzzlepiece_position.dart';
import 'package:dio/dio.dart';
import 'package:artificialsw_frontend/services/api_client.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/puzzle_home/puzzle_home_get_dto.dart';

class PuzzleService {
  final Dio _dio = ApiClient.dio;

  // 🟢 퍼즐 홈 화면 정보 가져오기(GET)
  Future<PuzzleHomeGetDto> getPuzzleHome() async {
    final response = await _dio.get('/puzzle/home');

    return PuzzleHomeGetDto.fromJson(response.data);
  }

  // 사진 업로드(POST)
  Future<void> uploadPuzzleImageWithMetadata({
    required File imageFile,
    required String comment,
    required int userId,
    required String category,
  }) async {
    final formData = FormData.fromMap({
      'image': MultipartFile.fromFileSync(imageFile.path),
      'comment': comment,
      'userId': userId.toString(),  //userId → string으로
      'category': category,
    });

    try {
      final response = await _dio.post(
        '/puzzle/image',
        data: formData,
        options: Options(contentType: 'multipart/form-data'), //이미지를 보낼 거라 적어줌. 일반적으로는 작성 X
      );

      if (response.statusCode == 200) {
        print('✅ 업로드 성공');
      } else {
        print('⚠️ 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ 오류 발생: $e');
    }
  }

  // 🟡 퍼즐 생성
  Future<PuzzleCreateResponseDto> createPuzzle(PuzzleCreateRequestDto requestDto) async {
    try {
      final response = await _dio.post(
        '/puzzle/create',
        data: requestDto.toJson(), // JSON 자동 직렬화
      );

      return PuzzleCreateResponseDto.fromJson(response.data); //그냥 .g 파일에 있는 함수임. 어렵게 생각 ㄴㄴ
    } on DioError catch (e) {
      // Dio 예외 처리
      if (e.response != null) {
        print('에러: ${e.response?.data}');
      } else {
        print('네트워크 에러: ${e.message}');
      }
    }
    return PuzzleCreateResponseDto(
      puzzleId: '1',
      message: '🔥 서버 연결 실패 - 목데이터 사용 중',
      createdAt: DateTime.now().toIso8601String(),
      imageUrl: 'https://picsum.photos/600/400',
      category: 'Mock 카테고리',
      AIKeyword: ['Mock 키워드', 'Mock 키워드 2'],
    );
  }

  // 퍼즐 중간 저장
  Future<void> savePuzzleProgress({
    required String puzzleId,
    required int puzzleSize,
    required Map<String, PuzzlePiecePosition> pieces,
    required List<int> completedPiecesId,
    required String contributorId,
    required bool completed,
    required bool isPlayingPuzzle,
  }) async {
    final formData = FormData.fromMap({
      'puzzleId': puzzleId,
      'puzzleSize': puzzleSize,
      'pieces': pieces,
      'completedPiecesId': completedPiecesId,
      'contributorId': contributorId,
      'completed': completed,
      'isPlayingPuzzle': isPlayingPuzzle,
    });

    try {
      final response = await _dio.post(
        '/puzzles/$puzzleId/save-progress', //여기 경로 puzzle 아니고 puzzles 되어있다..
        data: formData,
      );

      if (response.statusCode == 200) {
        print('✅ 업로드 성공');
      } else {
        print('⚠️ 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ 오류 발생: $e');
    }
  }



// 🔵 퍼즐 삭제

}

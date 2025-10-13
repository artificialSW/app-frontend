import 'dart:io';

import 'package:artificialsw_frontend/services/puzzle/dto/get_archived_puzzle_list/puzzle_get_archived_list_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/play_completed_puzzle/play_puzzle_completed_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/get_completed_puzzle_list/puzzle_get_completed_list_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/play_in_progress_puzzle/play_puzzle_in_progress_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/get_in_progress_puzzle_list/puzzle_get_in_progress_data_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/get_in_progress_puzzle_list/puzzle_get_in_progress_list_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/image_upload/image_upload_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/puzzle_complete/puzzle_complete_request_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/puzzle_complete/puzzle_complete_response_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/puzzle_create/puzzle_create_request_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/puzzle_create/puzzle_create_response_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/puzzle_save_progress/puzzlepiece_position.dart';
import 'package:dio/dio.dart';
import 'package:artificialsw_frontend/services/api_client.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/puzzle_home/puzzle_home_get_dto.dart';

class PuzzleService {
  final Dio _dio = ApiClient.dio;

  // 🟢 퍼즐 홈 화면 정보 가져오기 (GET)
  Future<PuzzleHomeGetDto> getPuzzleHome() async {
    final response = await _dio.get('/puzzle/home');

    return PuzzleHomeGetDto.fromJson(response.data);
  }

  // 사진 업로드(POST)
  Future<void> uploadPuzzleImagesWithMetadata(ImageUploadDto dto) async {
    try {
      // DTO → JSON 변환
      final formData = dto.toJson();

      // POST 요청
      // final response = await _dio.post(
      //   '/puzzle/images',
      //   data: formData,
      //   options: Options(contentType: 'application/json'),
      // );

      final _accessToken = 'eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI5IiwiZmFtaWx5SWQiOjEsImlhdCI6MTc1OTkwNjgwMn0.JTuUNb8aRBDJeErsIpffTpwQ58ItDV5PD9qb9oTlIlFjVgxMP24iJd7Epe-boS7QsGRta-mlktAsJgHLF1u19w';

      final response = await _dio.post(
        'http://15.164.94.26:8080/api/puzzle/picture/upload',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $_accessToken', // ✅ 토큰 추가
          },
        ),
      );


      if (response.statusCode == 200) {
        print('✅ 여러 장 업로드 성공');
      } else {
        print('⚠️ 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ 오류 발생: $e');
    }
  }


  // 🟡 퍼즐 생성 : POST
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
      imageUrl: 'https://picsum.photos/400/400',
      category: 'Mock 카테고리',
      AIKeyword: ['Mock 키워드', 'Mock 키워드 2'],
    );
  }

  // 퍼즐 중간 저장 : POST
  Future<void> savePuzzleProgress({
    required String puzzleId,
    required String imageFile,
    //required int puzzleSize,
    required Map<String, PuzzlePiecePosition> pieces,
    required List<int> completedPiecesId,
    required String contributorId,
    required bool completed,
    required bool isPlayingPuzzle,
  }) async {
    final formData = FormData.fromMap({
      'puzzleId': puzzleId,
      'imageFile': imageFile,
      //'puzzleSize': puzzleSize,
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

  // 퍼즐 완료
  Future<PuzzleCompleteResponseDto> completePuzzle(PuzzleCompleteRequestDto request) async {

    try {
      final response = await _dio.post(
        '/puzzles/${request.puzzleId}/complete',
        data: request.toJson(), // JSON 자동 직렬화
      );

      return PuzzleCompleteResponseDto.fromJson(response.data); //그냥 .g 파일에 있는 함수임. 어렵게 생각 ㄴㄴ
    } catch (e) {
      print('❌ 퍼즐 완료 처리 실패: $e');
      return PuzzleCompleteResponseDto(
        puzzleId: '123',
        message: '🔥 서버 연결 실패 - 목데이터 사용 중',
        fruitName: 'Mock 과일 이름',
        fruitMessage: 'Mock 과일 메시지',
        contributors: ['mock', 'mock']
      ); // 이런 식의 기본 생성자가 있을 때만!
    }
  }

  // 진행중인 퍼즐 목록 불러오기 (GET)
  Future<PuzzleGetInProgressListDto> getInProgressList() async {
    final response = await _dio.get('/puzzles/in-progress');
    return PuzzleGetInProgressListDto.fromJson(response.data);
  }

  //진행중인 퍼즐 목록에서 퍼즐 풀기 (퍼즐 이어풀기) (GET)
  Future<PlayPuzzleInProgressDto> playInProgressPuzzle(String puzzleId) async {
    final response = await _dio.get('/puzzles/$puzzleId/progress');
    return PlayPuzzleInProgressDto.fromJson(response.data);
  }

  // 완료된 퍼즐 목록 불러오기 (GET)
  Future<PuzzleGetCompletedListDto> getCompletedList() async {
    final response = await _dio.get('/puzzles/completed');
    return PuzzleGetCompletedListDto.fromJson(response.data);
  }

  //완료된 퍼즐 목록에서 퍼즐 풀기 (퍼즐 다시풀기) (GET)
  Future<PlayPuzzleCompletedDto> playCompletedPuzzle(String puzzleId) async {
    final response = await _dio.get('/puzzles/$puzzleId/retry');
    return PlayPuzzleCompletedDto.fromJson(response.data);
  }

  // 아카이브된 퍼즐 불러오기 (GET)
  Future<PuzzleGetArchivedListDto> getArchivedList() async {
    final response = await _dio.get('/puzzles/archive');
    return PuzzleGetArchivedListDto.fromJson(response.data);
  }

  // 완료된 퍼즐을 아카이브로 이동 (POST)
  Future<void> archiveCompletedPuzzle(String puzzleId) async {
    try {
      final response = await _dio.post('/puzzles/$puzzleId/archive');

      if (response.statusCode == 200) {
        final message = response.data['message'];
        print('✅ 퍼즐 아카이브 성공: $message');
      } else {
        print('⚠️ 퍼즐 아카이브 실패: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final error = e.response?.data['message'] ?? e.message;
      print('❌ 아카이브 요청 중 오류 발생: $error');
    } catch (e) {
      print('❌ 예외 발생: $e');
    }
  }

// 🔵 퍼즐 삭제
  Future<void> deletePuzzle(String puzzleId) async {
    final response = await _dio.delete('/puzzles/$puzzleId');
    if (response.statusCode == 200) {
      print('✅ 퍼즐 삭제 성공');
    } else {
      print('⚠️ 퍼즐 삭제 실패(Puzzle_Service): ${response.statusCode}');
    }
  }
}

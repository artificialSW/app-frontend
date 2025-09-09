import 'dart:io';

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
        options: Options(contentType: 'multipart/form-data'),
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


  // 🔵 퍼즐 삭제

}

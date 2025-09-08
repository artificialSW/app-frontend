import 'package:dio/dio.dart';
import 'package:artificialsw_frontend/services/api_client.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/puzzle_home_get_dto.dart';

class PuzzleService {
  final Dio _dio = ApiClient.dio;

  // 🟢 퍼즐 홈 화면 정보 가져오기
  Future<PuzzleHomeGetDto> getPuzzleHome() async {
    final response = await _dio.get('/puzzle/home');

    return PuzzleHomeGetDto.fromJson(response.data);
  }

  // 🟡 퍼즐 생성


  // 🔵 퍼즐 삭제

}

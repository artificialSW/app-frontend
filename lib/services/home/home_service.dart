import 'package:dio/dio.dart';
import 'package:artificialsw_frontend/services/api_client.dart';

/// 홈 관련 서버 통신을 담당하는 서비스 클래스
/// 퍼즐과 동일한 패턴으로 구현
class HomeService {
  final Dio _dio = ApiClient.dio;

  // 🟢 사용자의 카드 컬렉션 조회 (GET)
  Future<Map<String, dynamic>> getUserCards({
    required String userId,
  }) async {
    try {
      final response = await _dio.get('/api/users/$userId/cards');
      return response.data;
    } catch (e) {
      print('❌ 카드 조회 오류: $e');
      throw Exception('카드 조회 실패: $e');
    }
  }

  // 🟡 선택된 카드 저장 (POST)
  Future<void> saveSelectedCards({
    required String userId,
    required List<String> selectedFruitIds,
    required List<String> selectedFlowerIds,
  }) async {
    try {
      final response = await _dio.post('/api/users/$userId/tree-decoration', data: {
        'selectedFruitIds': selectedFruitIds,
        'selectedFlowerIds': selectedFlowerIds,
      });

      if (response.statusCode == 200) {
        print('✅ 선택된 카드 저장 성공');
      } else {
        print('⚠️ 저장 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ 저장 오류: $e');
      throw Exception('선택된 카드 저장 실패: $e');
    }
  }

  // 🔵 선택된 카드 업데이트 (PUT)
  Future<void> updateSelectedCards({
    required String userId,
    required List<String> selectedFruitIds,
    required List<String> selectedFlowerIds,
  }) async {
    try {
      final response = await _dio.put('/api/users/$userId/tree-decoration', data: {
        'selectedFruitIds': selectedFruitIds,
        'selectedFlowerIds': selectedFlowerIds,
      });

      if (response.statusCode == 200) {
        print('✅ 선택된 카드 업데이트 성공');
      } else {
        print('⚠️ 업데이트 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ 업데이트 오류: $e');
      throw Exception('선택된 카드 업데이트 실패: $e');
    }
  }

  // 🟠 선택된 카드 삭제 (DELETE)
  Future<void> deleteSelectedCards({
    required String userId,
  }) async {
    try {
      final response = await _dio.delete('/api/users/$userId/tree-decoration');

      if (response.statusCode == 200) {
        print('✅ 선택된 카드 삭제 성공');
      } else {
        print('⚠️ 삭제 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ 삭제 오류: $e');
      throw Exception('선택된 카드 삭제 실패: $e');
    }
  }
}

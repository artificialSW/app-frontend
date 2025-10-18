import 'package:dio/dio.dart';
import 'package:artificialsw_frontend/services/api_client.dart';
import 'dto/tree_name_id/tree_name_request_dto.dart';
import 'dto/tree_name_id/tree_id_response_dto.dart';
import 'dto/custom_tree_fruit/fruit_hanging_request_dto.dart';
import 'dto/custom_tree_fruit/custom_fruit_response_dto.dart';
import 'dto/custom_tree_flower/flower_hanging_request_dto.dart';
import 'dto/custom_tree_flower/custom_flower_response_dto.dart';
import 'dto/guidebook/flower_unlock_response_dto.dart';
import 'dto/guidebook/fruit_unlock_response_dto.dart';

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

  //  나무 이름으로 나무 ID 조회 (POST)
  Future<TreeIdResponseDto> getTreeIdByName({
    required String userId,
    required String treeName,
  }) async {
    try {
      final requestDto = TreeNameRequestDto(treeName: treeName);
      final response = await _dio.post('/api/users/$userId/tree-name', data: requestDto.toJson());
      
      return TreeIdResponseDto.fromJson(response.data);
    } catch (e) {
      print('❌ 나무 ID 조회 오류: $e');
      throw Exception('나무 ID 조회 실패: $e');
    }
  }

  //  커스텀 나무 과일 조회 (GET)
  Future<CustomFruitResponseDto> getCustomTreeFruits({
    required String treeId,
  }) async {
    try {
      final response = await _dio.get('/api/tree/custom/$treeId/fruit');
      return CustomFruitResponseDto.fromJson(response.data);
    } catch (e) {
      print('❌ 커스텀 나무 과일 조회 오류: $e');
      throw Exception('커스텀 나무 과일 조회 실패: $e');
    }
  }

  // 🍎 5. 과일 달기 (POST) - 백엔드로 order 상태 전달
  // 요청 형태: {"fruit-hanging": [{"id": "fruit_id", "order": 1}, ...]}
  // order: 0(안달림), 1(첫번째위치), 2(두번째위치), 3(세번째위치)
  Future<void> hangFruits({
    required List<FruitHangingItem> fruitHangingItems,
  }) async {
    try {
      final requestDto = FruitHangingRequestDto(fruitHanging: fruitHangingItems);
      final response = await _dio.post('/api/tree/fruits/hanging', data: requestDto.toJson());
      
      if (response.statusCode == 200) {
        print('✅ 과일 달기 성공');
      } else {
        print('⚠️ 과일 달기 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ 과일 달기 오류: $e');
      throw Exception('과일 달기 실패: $e');
    }
  }

  //  커스텀 나무 꽃 조회 (GET)
  Future<CustomFlowerResponseDto> getCustomTreeFlowers({
    required String treeId,
  }) async {
    try {
      final response = await _dio.get('/api/tree/custom/$treeId/flower');
      return CustomFlowerResponseDto.fromJson(response.data);
    } catch (e) {
      print('❌ 커스텀 나무 꽃 조회 오류: $e');
      throw Exception('커스텀 나무 꽃 조회 실패: $e');
    }
  }

  // 🌸 5. 꽃 달기 (POST) - 백엔드로 order 상태 전달
  // 요청 형태: {"flower-hanging": [{"id": "flower_id", "order": 1}, ...]}
  // order: 0(안달림), 1(첫번째위치), 2(두번째위치), 3(세번째위치)
  Future<void> hangFlowers({
    required List<FlowerHangingItem> flowerHangingItems,
  }) async {
    try {
      final requestDto = FlowerHangingRequestDto(flowerHanging: flowerHangingItems);
      final response = await _dio.post('/api/tree/flowers/hanging', data: requestDto.toJson());
      
      if (response.statusCode == 200) {
        print('✅ 꽃 달기 성공');
      } else {
        print('⚠️ 꽃 달기 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ 꽃 달기 오류: $e');
      throw Exception('꽃 달기 실패: $e');
    }
  }

  // 📖 꽃 도감 해금 상태 조회 (GET)
  Future<FlowerUnlockResponseDto> getFlowerUnlockStatus() async {
    try {
      final response = await _dio.get('/api/book/flower');
      return FlowerUnlockResponseDto.fromJson(response.data);
    } catch (e) {
      print('❌ 꽃 도감 해금 상태 조회 오류: $e');
      throw Exception('꽃 도감 해금 상태 조회 실패: $e');
    }
  }

  // 🍎 과일 도감 해금 상태 조회 (GET)
  Future<FruitUnlockResponseDto> getFruitUnlockStatus() async {
    try {
      final response = await _dio.get('/api/book/fruit');
      return FruitUnlockResponseDto.fromJson(response.data);
    } catch (e) {
      print('❌ 과일 도감 해금 상태 조회 오류: $e');
      throw Exception('과일 도감 해금 상태 조회 실패: $e');
    }
  }

}

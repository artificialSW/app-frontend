import 'package:dio/dio.dart';
import 'package:artificialsw_frontend/services/api_client.dart';
import 'dto/tree_name_id/tree_name_request_dto.dart';
import 'dto/tree_name_id/tree_id_response_dto.dart';
import 'dto/guidebook/flower_unlock_response_dto.dart';
import 'dto/guidebook/fruit_unlock_response_dto.dart';
import 'dto/archive/archive_flower_response_dto.dart';
import 'dto/archive/archive_fruit_response_dto.dart';
import 'mock_data_manager.dart';
import 'package:artificialsw_frontend/services/storage_service.dart';
import 'package:artificialsw_frontend/shared/constants/constants.dart';
import 'package:artificialsw_frontend/services/home/dto/archive/fruit_card_dialog_response_dto.dart';
import 'dart:convert';
import 'package:artificialsw_frontend/services/home/dto/archive/flower_card_dialog_response_dto/personal_dto.dart';
import 'package:artificialsw_frontend/services/home/dto/archive/flower_card_dialog_response_dto/public_dto.dart';

/// 홈 관련 서버 통신을 담당하는 서비스 클래스
/// 퍼즐과 동일한 패턴으로 구현
class HomeService {
  final Dio _dio = ApiClient.dio;

//   Future<Map<String, int>> getScores({
//
// })

  // 🟢 사용자의 카드 컬렉션 조회 (GET)
  // Future<Map<String, dynamic>> getUserCards({
  //   required String userId,
  // }) async {
  //   try {
  //     final response = await _dio.get('/api/users/$userId/cards');
  //     return response.data;
  //   } catch (e) {
  //     print('❌ 카드 조회 오류: $e');
  //     throw Exception('카드 조회 실패: $e');
  //   }
  // }

  // 🟡 선택된 카드 저장 (POST)
  // Future<void> saveSelectedCards({
  //   required String userId,
  //   required List<String> selectedFruitIds,
  //   required List<String> selectedFlowerIds,
  // }) async {
  //   try {
  //     final response = await _dio.post('/api/users/$userId/tree-decoration', data: {
  //       'selectedFruitIds': selectedFruitIds,
  //       'selectedFlowerIds': selectedFlowerIds,
  //     });
  //
  //     if (response.statusCode == 200) {
  //       print('✅ 선택된 카드 저장 성공');
  //     } else {
  //       print('⚠️ 저장 실패: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('❌ 저장 오류: $e');
  //     throw Exception('선택된 카드 저장 실패: $e');
  //   }
  // }

  //  나무 이름으로 나무 ID 조회 (POST)
  // Future<TreeIdResponseDto> getTreeIdByName({
  //   required String userId,
  //   required String treeName,
  // }) async {
  //   try {
  //     final requestDto = TreeNameRequestDto(treeName: treeName);
  //     final response = await _dio.post('/api/users/$userId/tree-name', data: requestDto.toJson());
  //
  //     return TreeIdResponseDto.fromJson(response.data);
  //   } catch (e) {
  //     print('❌ 나무 ID 조회 오류: $e');
  //     throw Exception('나무 ID 조회 실패: $e');
  //   }
  // }


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

  // 📚 아카이브 꽃 데이터 조회 (GET)
  // /api/archives/main/{year}/{month}/{period}/{treeIndex}
  // period: 1(~15일), 2(16~말일)
  // treeIndex: 1,2(꽃)
  Future<List<ArchiveFlowerResponseDto>> getArchiveFlowerData({
    required int year,
    required int month,
    required int period,
    required int treeIndex,
  }) async {
    try {
      final _accessToken = StorageService.getAccessToken();
      if(_accessToken == null){
        print("access token is null!!!");
      }
      // 실제 API 호출 시도
      final response = await _dio.get('$baseUrl/api/tree/main/$year/$month/$period/$treeIndex/flower');

      return ArchiveFlowerResponseDto.fromJsonList(response.data);
    } catch (e) {
      print('❌ 아카이브 꽃 데이터 조회 오류: $e');
      print('🔄 목데이터로 폴백합니다.');
      
      // API 실패 시 목데이터로 폴백
      return MockDataManager().getArchiveFlowerData(
        year: year,
        month: month,
        period: period,
        treeIndex: treeIndex,
      );
    }
  }

  // 📚 아카이브 열매 데이터 조회 (GET)
  // /api/archives/main/{year}/{month}/{period}/{treeIndex}
  // period: 1(~15일), 2(16~말일)
  // treeIndex: 3,4(열매)
  Future<List<ArchiveFruitResponseDto>> getArchiveFruitData({
    required int year,
    required int month,
    required int period,
    required int treeIndex,
  }) async {
    try {
      final _accessToken = StorageService.getAccessToken();
      if(_accessToken == null){
        print("access token is null!!!");
      }
      // 실제 API 호출 시도
      final response = await _dio.get('$baseUrl/api/tree/$year/$month/$period/$treeIndex/fruit');
      
      return ArchiveFruitResponseDto.fromJsonList(response.data);
    } catch (e) {
      print('❌ 아카이브 열매 데이터 조회 오류: $e');
      print('🔄 목데이터로 폴백합니다.');
      
      // API 실패 시 목데이터로 폴백
      return MockDataManager().getArchiveFruitData(
        year: year,
        month: month,
        period: period,
        treeIndex: treeIndex,
      );
    }
  }

  Future<FruitCardDialogResponseDto?> getFruitCardInfo(String fruitId) async {
    final _accessToken = StorageService.getAccessToken();
    if(_accessToken == null) {
      print("access token is null!!!");
    }

    try{
      final body = {
        'fruitId': int.parse(fruitId),
      };
      // const encoder = JsonEncoder.withIndent('  ');
      // final prettyJson = encoder.convert(body);
      // print('📦 Json: \n$prettyJson');

      final response = await _dio.get(
        '$baseUrl/api/tree/fruit',
        data: body,
        options: Options(headers: {'Authorization': 'Bearer $_accessToken'}),
      );

      if (response.statusCode == 200) {
        print('✅ 성공');
      } else {
        print('⚠️ 실패: ${response.statusCode}');
      }

      return FruitCardDialogResponseDto.fromJson(response.data);
    } catch (e) {
      print('❌ 열매 card dialog 조회 오류: $e');
      return null;
    }
  }

  Future<dynamic?> getFlowerCardInfo(String flowerId) async { //<PersonalDto> or <PublicDto>
    final _accessToken = StorageService.getAccessToken();
    if(_accessToken == null) {
      print("access token is null!!!");
    }

    try{
      final response = await _dio.get(
        '$baseUrl/api/tree/flower/$flowerId',
        options: Options(headers: {'Authorization': 'Bearer $_accessToken'}),
      );

      if (response.statusCode == 200) {
        print('✅ 성공');
      } else {
        print('⚠️ 실패: ${response.statusCode}');
      }

      ///여기서부터 Public인지 Personal인지 구별하기 위한 안전 로직
      final data = response.data is String
          ? jsonDecode(response.data)
          : response.data;
      final question = data['question'];
      if (question != null && question['count'] != null) {
        return PublicDto.fromJson(response.data);
      } else {
        return PersonalDto.fromJson(response.data);
      }

      print('Public, Personal 모두 아닌 이상한 DTO');
      return null;
    } catch (e) {
      print('❌ 열매 card dialog 조회 오류: $e');
      return null;
    }
  }

}

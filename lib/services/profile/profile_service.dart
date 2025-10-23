import 'package:dio/dio.dart';
import 'package:artificialsw_frontend/services/api_client.dart';
import 'package:artificialsw_frontend/services/storage_service.dart';
import 'package:artificialsw_frontend/services/profile/dto/profile_response_dto.dart';
import 'package:artificialsw_frontend/services/profile/dto/profile_edit_request_dto.dart';

class ProfileService {
  static final ProfileService _instance = ProfileService._internal();
  factory ProfileService() => _instance;
  ProfileService._internal();

  final Dio _dio = ApiClient.dio;

  /// 마이페이지 정보 조회 (GET)
  /// /api/mypage
  Future<ProfileResponseDto> getProfile() async {
    try {
      final _accessToken = await StorageService.getAccessToken();
      if(_accessToken == null) {
        print("access token is null!!!");
      }

      final response = await _dio.get(
        '/api/mypage',
        options: Options(headers: {'Authorization': 'Bearer $_accessToken'}),
      );

      if (response.statusCode == 200) {
        print('✅ 마이페이지 정보 조회 성공');
      } else {
        print('⚠️ 마이페이지 정보 조회 실패: ${response.statusCode}');
      }

      return ProfileResponseDto.fromJson(response.data);
    } catch (e) {
      print('❌ 마이페이지 정보 조회 오류: $e');
      throw Exception('마이페이지 정보 조회 실패: $e');
    }
  }

  /// 📝 프로필 수정 (PUT)
  /// /api/mypage/edit
  Future<void> updateProfile(ProfileEditRequestDto request) async {
    try {
      final _accessToken = await StorageService.getAccessToken();
      if (_accessToken == null) {
        print("Access token is null for profile update!");
        throw Exception("Access token is null");
      }

      final response = await _dio.put(
        '/api/mypage/edit',
        data: request.toJson(),
        options: Options(headers: {'Authorization': 'Bearer $_accessToken'}),
      );

      if (response.statusCode == 200) {
        print('✅ 마이페이지 정보 수정 성공');
      } else {
        print('⚠️ 마이페이지 정보 수정 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ 마이페이지 정보 수정 오류: $e');
      throw Exception('마이페이지 정보 수정 실패: $e');
    }
  }
}

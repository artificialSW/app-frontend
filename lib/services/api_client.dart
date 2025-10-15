import 'package:dio/dio.dart';
import 'package:artificialsw_frontend/services/storage_service.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://15.164.94.26:8080', // 서버 주소
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
    ),
  )
    ..interceptors.addAll([
      // 요청 로그
      LogInterceptor(responseBody: true),
      // 인증 토큰 자동 첨부
      InterceptorsWrapper(onRequest: (options, handler) async {
        try {
          final token = await StorageService.getAccessToken();
          print('🔑 [ApiClient] 저장된 토큰: ${token != null ? "${token.substring(0, 20)}..." : "null"}');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
            print('✅ [ApiClient] Authorization 헤더 추가됨');
          } else {
            print('❌ [ApiClient] 토큰이 없어서 헤더 추가 안됨');
          }
        } catch (e) {
          print('❌ [ApiClient] 토큰 조회 실패: $e');
        }
        return handler.next(options);
      }),
    ]);
}

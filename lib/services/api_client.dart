import 'package:dio/dio.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "http://15.164.94.26:8080", ///여기에 실제 서버 주소
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: 'application/json',
    ),
  )..interceptors.addAll([
    LogInterceptor(responseBody: true), // 콘솔 출력용
  ]);
}

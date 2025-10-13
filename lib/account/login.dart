import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'package:artificialsw_frontend/services/storage_service.dart';
import 'package:artificialsw_frontend/shared/constants/constants.dart';
import 'package:dio/dio.dart';
import 'dart:convert';


class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 사용자 입력을 받을 컨트롤러
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final Dio _dio = Dio();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppAssets.account_background, // 실제 파일 경로에 맞게 수정!
              fit: BoxFit.cover, // 화면 꽉 채움
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ID 입력 필드
                  TextField(
                    controller: _idController,
                    decoration: const InputDecoration(
                      labelText: 'ID',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 비밀번호 입력 필드
                  TextField(
                    controller: _pwController,
                    obscureText: true, // 입력값 숨김 처리
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 로그인 버튼
                  ElevatedButton(
                    onPressed: _login,
                    //onPressed: () => Navigator.pushNamed(context, '/shell'),
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 16),

                  // 회원가입 유도 텍스트
                  GestureDetector(
                    onTap: () {
                      // TODO: 회원가입 페이지로 이동
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text(
                      '아직 계정이 없으신가요? 회원가입',
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _login() async {
    final id = _idController.text.trim();
    final pw = _pwController.text.trim();
    debugPrint('Login Attempt: ID: $id, PW: $pw');

    if (id.isEmpty || pw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('아이디와 비밀번호를 모두 입력하세요.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try{
      // 1. 로그인 API 호출
      final loginUri = Uri.parse('$baseUrl/api/login').toString();

      final loginResponse = await _dio.post(
        'http://15.164.94.26:8080/api/login',
        data: {'id': id, 'password': pw},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      //print(loginResponse.data);

      //final loginData = loginResponse.data is String
       //   ? jsonDecode(loginResponse.data)
        //  : loginResponse.data;

      //if (loginData['isSuccess'] == true) {
      if (true) {
        //final loginResult = loginData['result'];
        final accessToken = loginResponse.data.toString();
        //final userType = loginResult['userType'];
        //String? refreshToken;
        //final String? rawCookie = loginResponse.headers['set-cookie'];
        // if (rawCookie != null) {
        //   final regExp = RegExp(r'refresh_token=([^;]+)');
        //   final match = regExp.firstMatch(rawCookie);
        //   if (match != null) {
        //     refreshToken = match.group(1);
        //   }
        // }

        // if (refreshToken == null) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(
        //       content: Text('로그인에 실패했습니다. (토큰 오류)'),
        //       duration: Duration(seconds: 2),
        //     ),
        //   );
        //   return;
        // }


        // 2. 토큰 저장
        //await StorageService.saveAccessToken(accessToken, refreshToken);
        await StorageService.saveAccessToken(accessToken);

        // 3. 유저 가치(Value) 정보 API 호출
        // final userInfoUri = Uri.parse('$baseUrl/users/value');
        // final userInfoResponse = await http.get(
        //   userInfoUri,
        //   headers: {'Authorization': 'Bearer $accessToken'},
        // );
        //
        // if (userInfoResponse.statusCode != 200) {
        //   setState(() => _errorMessage = '사용자 정보 로딩에 실패했습니다.');
        //   return;
        // }
        //
        // final userInfoData = jsonDecode(utf8.decode(userInfoResponse.bodyBytes));
        // if (userInfoData['isSuccess'] != true) {
        //   setState(() => _errorMessage = '사용자 정보 로딩에 실패했습니다.');
        //   return;
        // }
        //
        // final valueResult = userInfoData['result'];
        //
        // // 4. 두 API 응답을 합쳐서 하나의 UserInfo 객체 생성
        // final UserInfo userInfo = UserInfo(
        //   userId: valueResult['userId'],
        //   userName: valueResult['userName'],
        //   totalPoint: valueResult['totalPoint'],
        //   totalDonation: valueResult['totalDonation'],
        //   totalPurchasePrice: valueResult['totalPurchasePrice'],
        //   totalPurchaseWeight: valueResult['totalPurchaseWeight'],
        //   totalDiscountPrice: valueResult['totalDiscountPrice'],
        //   email: loginResult['email'], // From login API
        //   userType: userType, // From login API
        // );
        //
        // // 5. 통합된 사용자 정보를 Storage Service에 저장
        // await StorageService().saveUserInfo(userInfo);

        //setState(() => _errorMessage = null);

        Navigator.pushNamed(context, '/shell');
        //String route = '';
        //if(mounted) Navigator.pushReplacementNamed(context, route);

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('아이디 또는 비밀번호가 일치하지 않습니다.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('로그인 중 오류가 발생했습니다: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
      debugPrint('Login Error: $e');
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    super.dispose();
  }
}

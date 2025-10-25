import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/services/storage_service.dart';
import 'package:artificialsw_frontend/shared/constants/constants.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';


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

  // Future<void> _checkLoginStatus() async {
  //
  //   final _accessToken = await StorageService.getAccessToken();
  //   //final refreshToken = await StorageService.getRefreshToken();
  //   //final userInfo = await StorageService().getUserInfo();
  //
  //   print("저장된 accessToken: $_accessToken");
  //   if (!mounted) return;
  //
  //   // 토큰과 유저 정보가 모두 있을 경우, 토큰 재발급 시도
  //   //if (accessToken != null && refreshToken != null && userInfo != null) {
  //   if (accessToken != null) {
  //     try {
  //
  //       final autoLoginResponse = await _dio.post(
  //         'http://15.164.94.26:8080/api/autologin',
  //         options: Options(
  //           headers: {
  //             'Content-Type': 'application/json',
  //             'Authorization': 'Bearer $_accessToken'
  //           },
  //         ),
  //       );
  //
  //       // 1. 토큰 재발급 성공
  //       if (autoLoginResponse.statusCode == 200) {
  //         if (data['isSuccess'] == true) {
  //           final newAccessToken = data['result']['accessToken'];
  //           print('access token is: $newAccessToken');
  //
  //           String? newRefreshToken;
  //           final String? rawCookie = response.headers['set-cookie'];
  //           if (rawCookie != null) {
  //             final regExp = RegExp(r'refresh_token=([^;]+)');
  //             final match = regExp.firstMatch(rawCookie);
  //             if (match != null) {
  //               newRefreshToken = match.group(1);
  //             }
  //           }
  //           if (newRefreshToken == null) {
  //             setState(() => _errorMessage = '로그인에 실패했습니다. (토큰 오류)');
  //             return;
  //           }
  //
  //           // 2. 토큰 저장
  //           await StorageService.saveTokens(newAccessToken, newRefreshToken);
  //           print('Access Token 재발급 성공');
  //           await saveFcmTokenToServer(); // 로그인 후 다시 저장
  //           _navigateToMainPage(userInfo); // 메인 페이지로 이동
  //           return;
  //         }
  //       }
  //       // 2. 토큰 재발급 실패 (리프레시 토큰 만료 등)
  //       throw Exception('Failed to reissue token');
  //     } catch (e) {
  //       print('토큰 재발급 실패: $e');
  //       // 실패 시 모든 정보를 지우고 로그인 화면으로 보냄
  //       await StorageService().clearAllData();
  //       Navigator.pushReplacementNamed(context, '/login');
  //     }
  //   } else {
  //     // 3. 저장된 정보가 없으면 로그인 화면으로 이동
  //     Navigator.pushReplacementNamed(context, '/login');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final _screenHeight = MediaQuery.of(context).size.height;
    final _screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      resizeToAvoidBottomInset: true, // ✅ 키보드에 맞게 화면 자동 조정
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent, // 투명 영역도 터치 감지
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                AppAssets.account_background, // 실제 파일 경로에 맞게 수정!
                fit: BoxFit.cover, // 화면 꽉 채움
              ),
            ),
            SingleChildScrollView( // ✅ 스크롤로 overflow 방지
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height, // 화면 최소 높이 유지
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: _screenHeight * 0.15),
                        Image.asset(
                          AppAssets.logo_white,
                          height: _screenHeight * 0.15,
                          width: _screenWidth * 0.3,
                        ),
                        Image.asset(
                          AppAssets.plumu_white,
                          height: _screenHeight * 0.037,
                        ),
                        const SizedBox(height: 84),
                        KeepLoginRow(),
                        const SizedBox(height: 10),

                        /// 전화번호(아이디) 입력 필드
                        TextField(
                          controller: _idController,
                          decoration: InputDecoration(
                            hintText: '전화번호를 입력해주세요',
                            hintStyle: const TextStyle(
                              color: AppColors.plumu_gray_4,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        /// 비밀번호 입력 필드
                        TextField(
                          controller: _pwController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: '비밀번호를 입력해주세요',
                            hintStyle: const TextStyle(
                              color: AppColors.plumu_gray_4,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        CustomButton(
                            text: '로그인',
                            onPressed: () {
                              login(_idController.text.trim(), _pwController.text.trim());
                            }
                        ),

                        const Spacer(),

                        CustomButton(
                          text: '회원가입',
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          backgroundColor: AppColors.plumu_gray_1,
                          textColor: AppColors.plumu_gray_7,
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void login(String id, String pw) async {
    final _fcmToken = await StorageService.getFCMToken();
    final id = _idController.text.trim();
    final pw = _pwController.text.trim();
    debugPrint('Login Attempt: ID: $id, PW: $pw, FCMToken: ${_fcmToken ?? ''}');

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
        loginUri,
        data: {
          'id': id,
          'password': pw,
          'token': _fcmToken ?? ''
        },
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
        final accessToken = loginResponse.data['token'].toString();
        debugPrint('login response is!!!!!!!!!!!!!: $loginResponse');
        final archiveId = loginResponse.data['archiveId'].toString();
        await StorageService.saveArchiveId(archiveId);
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

        print("🔥🔥🔥🔥my access token is: $accessToken");

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


class KeepLoginRow extends StatefulWidget {
  const KeepLoginRow({super.key});

  @override
  State<KeepLoginRow> createState() => _KeepLoginRowState();
}

class _KeepLoginRowState extends State<KeepLoginRow> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isChecked = !_isChecked),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Spacer(),
          Container(
            width: 13,
            height: 13,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(4),
              color: _isChecked ? Colors.white : Colors.transparent,
            ),
            child: _isChecked
                ? const Icon(
              Icons.check,
              size: 12,
              color: Color(0xFF6CBF84), // 체크 색상
            )
                : null,
          ),
          const SizedBox(width: 8),
          const Text(
            "로그인 상태 유지",
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}


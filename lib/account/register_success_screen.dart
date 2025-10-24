import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/account/login.dart';
import 'package:artificialsw_frontend/services/storage_service.dart';
import 'package:artificialsw_frontend/shared/constants/constants.dart';
import 'package:dio/dio.dart';
import 'package:artificialsw_frontend/shell.dart';
import 'package:artificialsw_frontend/features/home/tutorial_logic/help_page.dart';


void showSignUpCompleteDialog(BuildContext context, String phone, String pw) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.3), // 배경 어둡게 (선택)
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, anim1, anim2) {
      return _SignUpCompleteContent(phone: phone, pw: pw); // 전체 화면으로 덮음
    },
  );
}


class _SignUpCompleteContent extends StatefulWidget {
  final String phone;
  final String pw;

  const _SignUpCompleteContent({
    Key? key,
    required this.phone,
    required this.pw,
  }) : super(key: key);

  @override
  State<_SignUpCompleteContent> createState() => _SignUpCompleteContentState();
}

class _SignUpCompleteContentState extends State<_SignUpCompleteContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.forward();

    _autoLoginAfterDelay();
  }

  Future<void> _autoLoginAfterDelay() async {

    await Future.delayed(const Duration(seconds: 2)); // 체류 시간
    if (!mounted) return;

    try{
      // 1. 로그인 API 호출
      Navigator.of(context).pop(); // 다이얼로그 닫기

      final loginUri = Uri.parse('$baseUrl/api/login').toString();

      final loginResponse = await _dio.post(
        loginUri,
        data: {'id': widget.phone, 'password': widget.pw},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      final data = loginResponse.data;

      if (data != null && data['token'] != null) {
        final accessToken = loginResponse.data['token'].toString();
        debugPrint('login response is!!!!!!!!!!!!!: $loginResponse');
        final archiveId = loginResponse.data['archiveId'].toString();

        await StorageService.saveAccessToken(accessToken);
        await StorageService.saveArchiveId(archiveId);

        debugPrint('🔥 로그인 성공 — 토큰: $accessToken');

        // 로그인 성공 후
        if (mounted) {
          // Navigator.pushReplacementNamed(context, '/shell').then((_) {
          //   // Shell 진입이 끝난 뒤 HelpPage 열기
          //   Future.delayed(Duration(milliseconds: 300), () {
          //     Navigator.of(context).push(
          //       MaterialPageRoute(builder: (_) => HelpPage()),
          //     );
          //   });
          // });
          Navigator.pushReplacementNamed(
            context,
            '/shell',
            arguments: {'goToHelp': true}, // ✅ 전달
          );
        }

        //Navigator.pushReplacementNamed(context, '/shell');
        // final shellState = context.findAncestorStateOfType<ShellState>();
        // if (shellState == null) return;
        //
        // // 홈 탭으로 전환
        // shellState.setState(() => shellState.index = 0);
        //
        // // 2️⃣ 홈 탭의 Navigator 위에 HelpPage를 push
        // Future.microtask(() {
        //   shellState.keys[0].currentState?.push(
        //     MaterialPageRoute(builder: (_) => HelpPage()),
        //   );
        // });

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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ✅ 배경 (나중에 이미지로 교체 예정)
          Positioned.fill(
            child: Image.asset(
              AppAssets.account_background, // 실제 파일 경로에 맞게 수정!
              fit: BoxFit.cover, // 화면 꽉 채움
            ),
          ),
          // ✅ 가운데 내용
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 체크 아이콘
              Image.asset(
                AppAssets.check,
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 24),

              // ignore: diagnostic_describe_all_properties, hardcoded_text
              Text(
                '회원가입이 완료됐어요!\n섬을 꾸미러 가볼까요?',
                style: AppTextStyles.pretendard_bold.copyWith(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),

          // ✅ 캐릭터 자리 (이미지는 나중에 추가)
          Positioned(
            bottom: 0,
            right: -40,
            child: Image.asset(
              AppAssets.app_character_smile,
              width: 350,
              height: 350,
            )
          ),
        ],
      ),
    );
  }
}
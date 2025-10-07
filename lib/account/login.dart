import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // 사용자 입력을 받을 컨트롤러
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

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

  void _login() {
    final id = _idController.text.trim();
    final pw = _pwController.text.trim();

    // TODO: 로그인 로직 (백엔드 연동 예정)
    print('Login Attempt: ID: $id, PW: $pw');

    Navigator.pushNamed(context, '/shell');

  }

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // 각 입력 필드를 위한 컨트롤러들
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF335CB0),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              AppAssets.account_background,
              fit: BoxFit.cover,
            )
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0), // 화면 여백
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ID 입력
                  TextField(
                    controller: _idController,
                    decoration: const InputDecoration(
                      labelText: 'ID',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 비밀번호 입력
                  TextField(
                    controller: _pwController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 나이 입력
                  TextField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Age',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 생일 입력
                  TextField(
                    controller: _birthdayController,
                    decoration: const InputDecoration(
                      labelText: 'Birthday',
                      hintText: 'YYYY-MM-DD',
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 회원가입 버튼
                  ElevatedButton(
                    onPressed: _register,
                    child: const Text('Register'),
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }

  // 버튼 누르면 실행되는 함수 (백엔드로 보내는 로직 예정)
  void _register() {
    final id = _idController.text.trim();
    final pw = _pwController.text.trim();
    final age = _ageController.text.trim();
    final birthday = _birthdayController.text.trim();

    // TODO: 여기에 백엔드 API 연동 코드 작성
    print('ID: $id');
    print('PW: $pw');
    print('Age: $age');
    print('Birthday: $birthday');

    Navigator.pushNamed(context, '/login');
  }

  @override
  void dispose() {
    _idController.dispose();
    _pwController.dispose();
    _ageController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }
}
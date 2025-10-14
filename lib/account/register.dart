import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // 컨트롤러
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _pwController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _ageController = TextEditingController();
  final _familyCodeController = TextEditingController();
  final _customMemberController = TextEditingController(); // ← 기타 선택 시 상세 입력

  String? _selectedGender;
  String? _selectedFamilyType;
  String? _selectedMemberRole; // 드롭다운에서 선택된 구성원

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField(_nameController, '이름'),
                    const SizedBox(height: 12),

                    _buildTextField(
                      _phoneController,
                      '전화번호 (예: 010-0000-0000)',
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),

                    _buildTextField(_pwController, '비밀번호', obscureText: true),
                    const SizedBox(height: 12),

                    _buildTextField(_nicknameController, '닉네임'),
                    const SizedBox(height: 12),

                    _buildTextField(
                      _birthdayController,
                      '생년월일',
                      hint: 'YYYY / MM / DD',
                    ),
                    const SizedBox(height: 12),

                    // 성별 선택
                    const Text('성별', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSelectableBox(
                            label: '남성',
                            isSelected: _selectedGender == 'M',
                            onTap: () => setState(() => _selectedGender = 'M'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildSelectableBox(
                            label: '여성',
                            isSelected: _selectedGender == 'F',
                            onTap: () => setState(() => _selectedGender = 'F'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    _buildTextField(
                      _ageController,
                      '나이',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),

                    // 가족 선택
                    const Text('가족 선택', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSelectableBox(
                            label: '새로운 가족 생성',
                            isSelected: _selectedFamilyType == '새로운 가족 생성',
                            onTap: () => setState(() {
                              _selectedFamilyType = '새로운 가족 생성';
                              _familyCodeController.clear();
                            }),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildSelectableBox(
                            label: '기존 가족 가입',
                            isSelected: _selectedFamilyType == '기존 가족 가입',
                            onTap: () => setState(() {
                              _selectedFamilyType = '기존 가족 가입';
                            }),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // ✅ 기존 가족 가입 시에만 표시
                    if (_selectedFamilyType == '기존 가족 가입') ...[
                      _buildTextField(
                        _familyCodeController,
                        '가족 인증 코드',
                      ),
                      const SizedBox(height: 12),
                    ],

                    // ✅ 구성원 선택 (항상 표시)
                    const Text('구성원 선택', style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: _selectedMemberRole,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      hint: const Text('구성원을 선택하세요'),
                      items: const [
                        DropdownMenuItem(
                          value: '아버지',
                          child: Text('아버지'),
                        ),
                        DropdownMenuItem(
                          value: '어머니',
                          child: Text('어머니'),
                        ),
                        DropdownMenuItem(
                          value: '자녀',
                          child: Text('자녀'),
                        ),
                        DropdownMenuItem(
                          value: '조부모',
                          child: Text('조부모'),
                        ),
                        DropdownMenuItem(
                          value: '기타',
                          child: Text('기타'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedMemberRole = value;
                          if (value != '기타') {
                            _customMemberController.clear();
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 12),

                    // ✅ “기타” 선택 시만 상세 입력란 표시
                    if (_selectedMemberRole == '기타') ...[
                      _buildTextField(
                        _customMemberController,
                        '상세 역할을 입력하세요 (예: 삼촌, 고모 등)',
                      ),
                      const SizedBox(height: 12),
                    ],

                    // 회원가입 버튼
                    ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF335CB0),
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        '회원가입',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 공통 입력 필드
  Widget _buildTextField(
      TextEditingController controller,
      String label, {
        bool obscureText = false,
        TextInputType keyboardType = TextInputType.text,
        String? hint,
      }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(fontSize: 13),
        hintStyle: const TextStyle(fontSize: 13, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  // 선택형 박스 (성별, 가족유형 공용)
  Widget _buildSelectableBox({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF335CB0) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF335CB0) : Colors.grey.shade400,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _register() {
    // 필수 입력값 확인
    if (_nameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _pwController.text.trim().isEmpty ||
        _nicknameController.text.trim().isEmpty ||
        _birthdayController.text.trim().isEmpty ||
        _selectedGender == null ||
        _ageController.text.trim().isEmpty ||
        _selectedFamilyType == null ||
        _selectedMemberRole == null ||
        // 기존 가족 가입인데 코드가 비어있는 경우
        (_selectedFamilyType == '기존 가족 가입' &&
            _familyCodeController.text.trim().isEmpty) ||
        // 기타 선택인데 상세 역할 미입력
        (_selectedMemberRole == '기타' &&
            _customMemberController.text.trim().isEmpty)) {
      _showErrorDialog("모든 항목을 입력해야 회원가입이 가능합니다.");
      return;
    }

    // 유효성 검사를 통과한 경우만 데이터 전송
    final data = {
      "name": _nameController.text.trim(),
      "phone": _phoneController.text.trim(),
      "password": _pwController.text.trim(),
      "nickname": _nicknameController.text.trim(),
      "birthday": _birthdayController.text.trim(),
      "gender": _selectedGender,
      "age": int.tryParse(_ageController.text.trim()) ?? 0,
      "familyType": _selectedFamilyType,
      "memberRole": _selectedMemberRole == '기타'
          ? _customMemberController.text.trim()
          : _selectedMemberRole,
    };

    // 기존 가족 가입인 경우에만 familyVerificationCode 추가
    if (_selectedFamilyType == '기존 가족 가입') {
      data["familyVerificationCode"] = _familyCodeController.text.trim();
    }

    print('회원가입 데이터: $data');
    // TODO: Dio API 연동
    Navigator.pushNamed(context, '/login');
  }

// 에러 다이얼로그
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text(
            "입력 누락",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("확인"),
            ),
          ],
        );
      },
    );
  }


  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _pwController.dispose();
    _nicknameController.dispose();
    _birthdayController.dispose();
    _ageController.dispose();
    _familyCodeController.dispose();
    _customMemberController.dispose();
    super.dispose();
  }
}
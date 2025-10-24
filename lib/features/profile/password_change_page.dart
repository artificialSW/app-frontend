import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../shared/constants/app_colors.dart';
import '../../shared/constants/app_text_styles.dart';
import '../../shared/widgets/custom_button.dart';

class PasswordChangePage extends StatefulWidget {
  const PasswordChangePage({super.key});

  @override
  State<PasswordChangePage> createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends State<PasswordChangePage> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  bool _isPasswordConfirmed = false;
  bool _isPasswordValid = false;
  bool _isConfirmButtonPressed = false; // 확인 버튼을 눌렀는지 여부
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  void initState() {
    super.initState();
    _newPasswordController.addListener(_onPasswordChanged);
    _confirmPasswordController.addListener(_onPasswordChanged);
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onPasswordChanged() {
    setState(() {
      _isPasswordValid = _isValidPassword(_newPasswordController.text);
      _isPasswordConfirmed = _newPasswordController.text == _confirmPasswordController.text && 
                           _newPasswordController.text.isNotEmpty;
      // 비밀번호가 변경되면 확인 버튼 상태 초기화
      _isConfirmButtonPressed = false;
    });
  }

  bool _isValidPassword(String password) {
    // 8~20자 영문, 숫자 조합
    if (password.length < 8 || password.length > 20) return false;
    bool hasLetter = password.contains(RegExp(r'[a-zA-Z]'));
    bool hasNumber = password.contains(RegExp(r'[0-9]'));
    return hasLetter && hasNumber;
  }

  void _onConfirmPressed() {
    if (_isPasswordConfirmed) {
      setState(() {
        _isConfirmButtonPressed = true; // 확인 버튼을 눌렀음을 표시
        // 확인 버튼을 눌렀을 때의 로직
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('비밀번호가 확인되었습니다.'),
            duration: Duration(seconds: 1),
            backgroundColor: AppColors.plumu_green_main,
          ),
        );
      });
    }
  }

  void _onModifyPressed() {
    if (_isPasswordConfirmed && _isConfirmButtonPressed) {
      // 실제 비밀번호 변경 API 호출 로직
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('비밀번호가 변경되었습니다.'),
          duration: Duration(seconds: 2),
          backgroundColor: AppColors.plumu_green_main,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final widthRatio = screenWidth / 430;
    final heightRatio = screenHeight / 932;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          '개인정보 수정',
          style: AppTextStyles.pretendard_bold.copyWith(
            fontSize: 17,
            color: AppColors.plumu_gray_7,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 28 * widthRatio),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40 * heightRatio),
            
            // 전화번호 섹션 (읽기 전용)
            Text(
              '전화번호',
              style: AppTextStyles.pretendard_medium.copyWith(
                color: const Color(0xFF282828),
                fontSize: 16,
                height: 1.25,
              ),
            ),
            SizedBox(height: 8 * heightRatio),
            Container(
              width: 348 * widthRatio,
              height: 52 * heightRatio,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    color: Color(0xFFAAAAAA),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '010-1234-5678', // 실제 전화번호로 교체 필요
                    style: AppTextStyles.pretendard_regular.copyWith(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            
            SizedBox(height: 24 * heightRatio),
            
            // 현재 비밀번호 섹션
            Text(
              '현재 비밀번호',
              style: AppTextStyles.pretendard_medium.copyWith(
                color: const Color(0xFF282828),
                fontSize: 16,
                height: 1.25,
              ),
            ),
            SizedBox(height: 8 * heightRatio),
            Container(
              width: 348 * widthRatio,
              height: 52 * heightRatio,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    color: Color(0xFFAAAAAA),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: TextField(
                controller: _currentPasswordController,
                obscureText: !_showCurrentPassword,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showCurrentPassword ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.plumu_gray_5,
                    ),
                    onPressed: () {
                      setState(() {
                        _showCurrentPassword = !_showCurrentPassword;
                      });
                    },
                  ),
                ),
                style: AppTextStyles.pretendard_regular.copyWith(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            
            SizedBox(height: 24 * heightRatio),
            
            // 새 비밀번호 섹션
            Text(
              '새 비밀번호',
              style: AppTextStyles.pretendard_medium.copyWith(
                color: const Color(0xFF282828),
                fontSize: 16,
                height: 1.25,
              ),
            ),
            SizedBox(height: 8 * heightRatio),
            Container(
              width: 348 * widthRatio,
              height: 52 * heightRatio,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(
                    width: 1,
                    color: Color(0xFFAAAAAA),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: TextField(
                controller: _newPasswordController,
                obscureText: !_showNewPassword,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showNewPassword ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.plumu_gray_5,
                    ),
                    onPressed: () {
                      setState(() {
                        _showNewPassword = !_showNewPassword;
                      });
                    },
                  ),
                ),
                style: AppTextStyles.pretendard_regular.copyWith(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 8 * heightRatio),
            Text(
              '8~20자 영문, 숫자의 조합으로 입력해 주세요.',
              style: AppTextStyles.pretendard_regular.copyWith(
                color: AppColors.plumu_gray_5,
                fontSize: 12,
              ),
            ),
            
            SizedBox(height: 24 * heightRatio),
            
            // 비밀번호 재입력 섹션
            Text(
              '비밀번호 재입력',
              style: AppTextStyles.pretendard_medium.copyWith(
                color: const Color(0xFF282828),
                fontSize: 16,
                height: 1.25,
              ),
            ),
            SizedBox(height: 8 * heightRatio),
            Row(
              children: [
                Container(
                  width: 270 * widthRatio,
                  height: 52 * heightRatio,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 1,
                        color: Color(0xFFAAAAAA),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: TextField(
                    controller: _confirmPasswordController,
                    obscureText: !_showConfirmPassword,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                          color: AppColors.plumu_gray_5,
                        ),
                        onPressed: () {
                          setState(() {
                            _showConfirmPassword = !_showConfirmPassword;
                          });
                        },
                      ),
                    ),
                    style: AppTextStyles.pretendard_regular.copyWith(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 8 * widthRatio),
                CustomButton(
                  text: '확인',
                  onPressed: _isPasswordConfirmed ? _onConfirmPressed : null,
                  width: 70 * widthRatio,
                  height: 52 * heightRatio,
                  fontSize: 14,
                  textColor: Colors.white,
                  backgroundColor: _isPasswordConfirmed 
                      ? AppColors.plumu_green_main 
                      : AppColors.plumu_gray_3,
                  borderRadius: BorderRadius.circular(8),
                ),
              ],
            ),
            SizedBox(height: 8 * heightRatio),
            Text(
              '8~20자 영문, 숫자의 조합으로 입력해 주세요.',
              style: AppTextStyles.pretendard_regular.copyWith(
                color: AppColors.plumu_gray_5,
                fontSize: 12,
              ),
            ),
            
             // 수정하기 버튼 - 중앙정렬하고 살짝 위로 조정
             Padding(
               padding: EdgeInsets.only(top: 298 * heightRatio),
               child: Center(
                 child: CustomButton(
                   text: '수정하기',
                   onPressed: (_isPasswordConfirmed && _isConfirmButtonPressed) ? _onModifyPressed : null,
                   width: 348 * widthRatio,
                   height: 52 * heightRatio,
                   fontSize: 16,
                   textColor: Colors.white,
                   backgroundColor: (_isPasswordConfirmed && _isConfirmButtonPressed)
                       ? AppColors.plumu_green_main 
                       : AppColors.plumu_gray_3,
                   borderRadius: BorderRadius.circular(8),
                 ),
               ),
             ),
             
             SizedBox(height: 30 * heightRatio),
          ],
        ),
      ),
    );
  }
}

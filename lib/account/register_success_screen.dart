import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';

void showSignUpCompleteDialog(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.3), // 배경 어둡게 (선택)
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, anim1, anim2) {
      return _SignUpCompleteContent(); // 전체 화면으로 덮음
    },
  );
}


class _SignUpCompleteContent extends StatefulWidget {
  @override
  State<_SignUpCompleteContent> createState() => _SignUpCompleteContentState();
}

class _SignUpCompleteContentState extends State<_SignUpCompleteContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _controller.forward();

    // ✅ 체류 시간 설정 (예: 3초)
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop(); // 다이얼로그 닫기
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
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
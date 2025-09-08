import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';

/// 공통 다이얼로그 컴포넌트
/// 팝업 형태의 확인/알림 다이얼로그를 표시하는 위젯
class CommonDialog extends StatelessWidget {
  final String title;           // 다이얼로그 제목 (진한 텍스트)
  final String subtitle;        // 다이얼로그 부제목 (연한 텍스트)
  final String buttonText;      // 버튼에 표시될 텍스트
  final VoidCallback? onButtonPressed;  // 버튼 클릭 시 실행될 콜백

  const CommonDialog({
    super.key,
    required this.title,
    required this.subtitle,
    this.buttonText = '확인',
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,  // 다이얼로그 배경을 투명하게 설정
      child: Container(
        width: 290,   // 다이얼로그 너비
        // height: 160,  // 높이 고정 해제 - 텍스트에 따라 자동 조절
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),  // 둥근 모서리
          color: const Color(0xD9FFFFFF),           // 반투명 흰색 배경 (85% 불투명도)
          boxShadow: [
            // 내부 하이라이트 그림자 효과
            BoxShadow(
              color: Colors.white,
              offset: const Offset(0.318, 0.318),
              blurRadius: 2,
              blurStyle: BlurStyle.inner,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 29, 15, 15), // 위 29, 좌우/아래 15
          child: Column(
            mainAxisSize: MainAxisSize.min,  // 최소 크기로 설정 - 내용에 맞게 조절
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 텍스트 영역 (제목 + 부제목)
              Padding(
                padding: const EdgeInsets.only(left: 13), // 좌측 추가 여백 (총 28)
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: _titleStyle),       // 제목 (위쪽 29)
                    Text(subtitle, style: _subtitleStyle), // 부제목 (바로 이어서)
                  ],
                ),
              ),

              // 버튼 영역
              Center(
                child: CustomButton(
                  text: buttonText,
                  onPressed: onButtonPressed ?? () => Navigator.of(context).pop(),
                  width: 263,
                  height: 48,
                  fontSize: 16,
                  backgroundColor: AppColors.plumu_green_main,
                  textColor: AppColors.plumu_white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ],
          ),
        ),



      ),
    );
  }


  // 제목 텍스트 스타일 (진한 텍스트)
  static const TextStyle _titleStyle = TextStyle(
    color: AppColors.plumu_gray_7,    // #282828 색상
    fontFamily: 'Pretendard',         // Pretendard 폰트
    fontSize: 17,                     // 17px 크기
    fontWeight: FontWeight.w700,      // 700 굵기
    height: 1.41,                     // 141.176% 줄간격
  );

  // 부제목 텍스트 스타일 (연한 텍스트)
  static const TextStyle _subtitleStyle = TextStyle(
    color: AppColors.plumu_gray_7,    // #282828 색상
    fontFamily: 'Pretendard',         // Pretendard 폰트
    fontSize: 14,                     // 14px 크기
    fontWeight: FontWeight.w500,      // 500 굵기
    height: 1.71,                     //
  );


  /// 다이얼로그를 표시하는 정적 메서드
  /// 간편하게 다이얼로그를 띄울 수 있는 헬퍼 메서드
  static void show({
    required BuildContext context,    // 현재 컨텍스트
    required String title,            // 다이얼로그 제목
    required String subtitle,         // 다이얼로그 부제목
    String buttonText = '확인',        // 버튼 텍스트 (기본값: '확인')
    VoidCallback? onButtonPressed,    // 버튼 클릭 콜백
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,      // 배경 터치로 닫기 비활성화
      builder: (BuildContext context) {
        return CommonDialog(
          title: title,
          subtitle: subtitle,
          buttonText: buttonText,
          onButtonPressed: onButtonPressed,
        );
      },
    );
  }
}

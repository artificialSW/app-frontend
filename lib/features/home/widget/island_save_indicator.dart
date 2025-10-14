import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';

/// 섬 저장 완료 인디케이터 다이얼로그
/// 2주가 지나 섬이 저장되었다는 알림을 표시하는 위젯
class IslandSaveIndicator extends StatelessWidget {
  final VoidCallback? onConfirmPressed;  // 확인 버튼 클릭 시 실행될 콜백

  const IslandSaveIndicator({
    super.key,
    this.onConfirmPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,  // 다이얼로그 배경을 투명하게 설정
      child: Container(
        width: 293,
        height: 179,
        child: Stack(
          children: [
            // 배경 컨테이너
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: 293,
                height: 179,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x333A0D10),
                      blurRadius: 20,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    )
                  ],
                ),
              ),
            ),
            
            // 확인 버튼
            Positioned(
              left: 16,
              top: 116,
              child: Container(
                width: 263,
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: ShapeDecoration(
                  color: AppColors.plumu_green_main,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x0C42474C),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: Color(0x5142474C),
                      blurRadius: 0.50,
                      offset: Offset(0, 0),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: GestureDetector(
                  onTap: onConfirmPressed ?? () => Navigator.of(context).pop(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '확인',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontFamily: 'SF Pro Text',
                          fontWeight: FontWeight.w600,
                          height: 1.29,
                          letterSpacing: -0.41,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // 제목 텍스트
            Positioned(
              left: 28,
              top: 29,
              child: Text(
                '2주가 지나 섬이 저장되었어요!',
                style: TextStyle(
                  color: const Color(0xFF1B1D1B),
                  fontSize: 19,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  height: 1.26,
                ),
              ),
            ),
            
            // 설명 텍스트
            Positioned(
              left: 28,
              top: 61,
              child: Text(
                '수확한 꽃과 열매를 \n아카이브에서 확인할 수 있어요',
                style: TextStyle(
                  color: const Color(0xFF3B3D3B),
                  fontSize: 14,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  height: 1.36,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 인디케이터를 표시하는 정적 메서드
  /// 간편하게 인디케이터를 띄울 수 있는 헬퍼 메서드
  static void show({
    required BuildContext context,        // 현재 컨텍스트
    VoidCallback? onConfirmPressed,       // 확인 버튼 클릭 콜백
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,          // 배경 터치로 닫기 비활성화
      builder: (BuildContext context) {
        return IslandSaveIndicator(
          onConfirmPressed: onConfirmPressed,
        );
      },
    );
  }
}

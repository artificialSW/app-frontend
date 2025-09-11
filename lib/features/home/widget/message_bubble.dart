import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';

/// 메시지 입력용 말풍선 위젯
/// - 둥근 말풍선 모양의 텍스트 입력 필드
/// - 퍼즐 아이콘과 동일한 왼쪽 정렬 (32px 패딩)
/// - 실시간 텍스트 입력 및 힌트 텍스트 표시
/// - 하단에 꼬리 이미지(bubble_2) 포함
class MessageBubble extends StatelessWidget {
  /// 텍스트 입력을 제어하는 컨트롤러
  final TextEditingController controller;

  const MessageBubble({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    // 공통 텍스트 스타일 정의 (입력 텍스트와 힌트 텍스트에 동일하게 적용)
    final textStyle = AppTextStyles.pretendard_medium.copyWith(
      color: AppColors.plumu_green_main,
      fontSize: 14,
    );
    
    return Padding(
      padding: const EdgeInsets.only(left: 32.0), // 퍼즐 아이콘과 메시지 아이콘과 동일한 패딩
      child: Stack(
        clipBehavior: Clip.none, // 꼬리 이미지가 잘리지 않도록 설정
        children: [
          // 말풍선 본체 (둥근 컨테이너)
          Container(
            width: 197.11,
            height: 53.94,
            decoration: ShapeDecoration(
              color: const Color(0xFFC6EEC8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(33),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x26000000),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 162.20, // 텍스트 영역 최대 너비
                  maxHeight: 16.67, // 텍스트 영역 최대 높이
                ),
                child: TextField(
                  controller: controller, // 외부에서 전달받은 컨트롤러
                  textAlign: TextAlign.center, // 텍스트 중앙 정렬
                  maxLines: 1, // 한 줄만 입력 가능
                  cursorColor: AppColors.plumu_green_main, // 커서 색상
                  style: textStyle, // 입력 텍스트 스타일
                  decoration: InputDecoration(
                    isDense: true, // 컴팩트한 디자인
                    border: InputBorder.none, // 기본 테두리 제거
                    contentPadding: EdgeInsets.zero, // 내부 패딩 제거
                    hintText: '간단한 메세지를 남겨봐요!', // 힌트 텍스트
                    hintStyle: textStyle, // 힌트 텍스트 스타일
                  ),
                ),
              ),
            ),
          ),
          // 말풍선 꼬리 이미지 (아래 중앙 배치)
          Positioned(
            bottom: -20, // 컨테이너 아래로 배치하여 자연스럽게 연결
            left: 80, // 버블 본체 중앙 정렬 (197.11 / 2 - 37 / 2)
            child: Image.asset(
              'assets/icons/bubble_2.png',
              width: 37, // 꼬리 너비 (컨테이너 폭 대비 적절한 비율)
              height: 25, // 꼬리 높이
            ),
          ),
        ],
      ),
    );
  }
}

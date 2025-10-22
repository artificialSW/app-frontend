import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/services/home/home_service.dart';

/// 새로운 꽃/과일 Progress Bar 위젯
/// - 시간대별 아이콘과 색상
/// - 10개 세그먼트로 구성된 진행률 표시
/// - 반응형 크기 조정
class ProgressBarWithIcon extends StatelessWidget {
  final bool isFlower; // true: 꽃 progress bar, false: 과일 progress bar
  final double progress; // 0.0 ~ 1.0 (세그먼트 기준)
  final int maxSegments; // 최대 세그먼트 수 (기본값: 꽃 10개, 열매 8개)

  const ProgressBarWithIcon({
    super.key,
    required this.isFlower,
    required this.progress,
    this.maxSegments = 10, // 기본값 10개
  });

  /// 현재 시간에 따른 아이콘 경로 반환
  String _getTimeBasedIconPath() {
    final now = DateTime.now();
    final hour = now.hour;
    
    String timePrefix;
    if (hour >= 4 && hour < 8) {
      timePrefix = 'dawn';
    } else if (hour >= 8 && hour < 16) {
      timePrefix = 'morning';
    } else if (hour >= 16 && hour < 20) {
      timePrefix = 'afternoon';
    } else {
      timePrefix = 'night';
    }
    
    return isFlower 
        ? 'assets/icons/flower_icon_$timePrefix.png'
        : 'assets/icons/fruit_icon_$timePrefix.png';
  }

  /// 현재 시간에 따른 progress bar 내부 색상 반환
  Color _getTimeBasedColor() {
    final now = DateTime.now();
    final hour = now.hour;
    
    if (hour >= 4 && hour < 8) {
      return Color(0x193A0D10);
    } else if (hour >= 8 && hour < 16) {
      return Color(0x193A0D10);
    } else if (hour >= 16 && hour < 20) {
      return Color(0x193A0D10);
    } else {
      return Color(0x193A0D10);
    }
  }

  // Future<dynamic> _getScore(){
  //   final _accessToken = StorageService.getAccessToken();
  //
  //   if(_accessToken == null){
  //     print('access token is null!!!');
  //   }
  //
  //   final response =
  // }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // 기준 화면 크기 (412x917)에 대한 비율 계산
    final widthRatio = screenWidth / 412.0;
    final heightRatio = screenHeight / 917.0;
    
    // 아이콘 크기 (반응형) - 정확한 디자인 크기
    final iconWidth = isFlower ? 30.16 * widthRatio : 27.14 * widthRatio;
    final iconHeight = isFlower ? 28.92 * heightRatio : 30.91 * heightRatio;
    
    // Progress bar 크기 (반응형) - 정확한 디자인 크기
    final barWidth = 153.81 * widthRatio;
    final barHeight = 28.92 * heightRatio;
    
    // 세그먼트 크기 (반응형) - 열매는 더 뚱뚱하게
    final segmentWidth = isFlower 
        ? 7.98 * widthRatio  // 꽃: 기본 크기
        : 9.5 * widthRatio;  // 열매: 더 넓게 (약 19% 증가)
    final segmentHeight = 19.95 * heightRatio;
    
    // 진행된 세그먼트 개수 (동적 기준)
    final filledSegments = (progress * maxSegments).round().clamp(0, maxSegments);

    return Row(
      children: [
        // 아이콘 (progress bar 왼쪽에 별도 배치)
        Container(
          width: iconWidth,
          height: iconHeight,
          child: Image.asset(
            _getTimeBasedIconPath(),
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(width: 4 * widthRatio), // 아이콘과 바 간격 4px (반응형)
        // Progress bar (아이콘과 분리)
        Container(
          width: barWidth,
          height: barHeight,
          decoration: ShapeDecoration(
            color: Colors.white.withValues(alpha: 0.40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(19.95 * widthRatio),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x193A0D10),
                blurRadius: 19.95 * widthRatio,
                offset: Offset(0, 3.99 * heightRatio),
                spreadRadius: 0,
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // 세그먼트들을 중앙 정렬
            children: List.generate(maxSegments, (index) {
              final isFilled = index < filledSegments;
              // 열매는 세그먼트 간격을 더 넓게
              final segmentSpacing = isFlower ? 4.8 * widthRatio : 6.5 * widthRatio;
              return Container(
                width: segmentWidth,
                height: segmentHeight,
                margin: EdgeInsets.only(right: index < maxSegments - 1 ? segmentSpacing : 0), // 세그먼트 간격 (반응형)
                decoration: ShapeDecoration(
                  color: isFilled ? Colors.white : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.99 * widthRatio),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}


import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/features/home/home_mainpage.dart';
import 'package:artificialsw_frontend/features/home/widget/guidebook_widgets/hash_tag_widget.dart';

/// 가이드북 꽃 상세 페이지
/// 꽃 클릭 시 나타나는 상세 정보 페이지
class GuidebookFlowerDetailPage extends StatelessWidget {
  final int flowerIndex; // 꽃 인덱스 (0-11)

  const GuidebookFlowerDetailPage({
    super.key,
    required this.flowerIndex,
  });

  /// 꽃별 데이터 반환 (책 배치 기준)
  Map<String, dynamic> _getFlowerData(int index) {
    switch (index) {
      case 0: // 동백꽃
        return {
          'name': '동백꽃',
          'number': '01',
          'icon': AppAssets.flower_camellia,
          'width': 85.0,
          'height': 85.0,
          'color': AppColors.plumu_flower_love_check,
          'gradient': AppColors.plumu_flower_love_card_end,
        };
      case 1: // 아카시아
        return {
          'name': '아카시아',
          'number': '02',
          'icon': AppAssets.flower_acacia,
          'width': 95.93,
          'height': 125.84,
          'color': AppColors.plumu_flower_comfort_check,
          'gradient': AppColors.plumu_flower_comfort_card_end,
        };
      case 2: // 매화
        return {
          'name': '매화꽃',
          'number': '03',
          'icon': AppAssets.flower_plum,
          'width': 80.0,
          'height': 80.0,
          'color': AppColors.plumu_flower_special_check,
          'gradient': AppColors.plumu_flower_special_card_end,
        };
      case 3: // 팥배꽃
        return {
          'name': '팥배꽃',
          'number': '04',
          'icon': AppAssets.flower_patbae,
          'width': 80.0,
          'height': 80.0,
          'color': AppColors.plumu_flower_memory_check,
          'gradient': AppColors.plumu_flower_memory_card_end,
        };
      case 4: // 벚꽃
        return {
          'name': '벚꽃',
          'number': '05',
          'icon': AppAssets.flower_cherry,
          'width': 91.0,
          'height': 91.0,
          'color': AppColors.plumu_flower_joy_check,
          'gradient': AppColors.plumu_flower_joy_card_end,
        };
      case 5: // 목련
        return {
          'name': '목련',
          'number': '06',
          'icon': AppAssets.flower_magnolia,
          'width': 84.0,
          'height': 88.0,
          'color': AppColors.plumu_flower_hobby_check,
          'gradient': AppColors.plumu_flower_hobby_card_end,
        };
      case 6: // 장미
        return {
          'name': '장미',
          'number': '07',
          'icon': AppAssets.flower_rose,
          'width': 79.0,
          'height': 91.0,
          'color': AppColors.plumu_flower_love_check,
          'gradient': AppColors.plumu_flower_love_card_end,
        };
      case 7: // 수국
        return {
          'name': '수국',
          'number': '08',
          'icon': AppAssets.flower_hydrangea,
          'width': 83.28,
          'height': 75.0,
          'color': AppColors.plumu_flower_comfort_check,
          'gradient': AppColors.plumu_flower_comfort_card_end,
        };
      case 8: // 튤립
        return {
          'name': '튤립',
          'number': '09',
          'icon': AppAssets.flower_tulip,
          'width': 62.21,
          'height': 87.54,
          'color': AppColors.plumu_flower_special_check,
          'gradient': AppColors.plumu_flower_special_card_end,
        };
      case 9: // 제비꽃 (2행 4번째)
        return {
          'name': '제비꽃',
          'number': '10',
          'icon': AppAssets.flower_violet,
          'width': 97.0,
          'height': 97.0,
          'color': const Color(0xFF8732D0),
          'gradient': const Color(0xFFF6DCFF),
        };
      case 10: // 코스모스 (2행 5번째)
        return {
          'name': '코스모스',
          'number': '11',
          'icon': AppAssets.flower_cosmos,
          'width': 80.0,
          'height': 80.0,
          'color': AppColors.plumu_flower_joy_check,
          'gradient': AppColors.plumu_flower_joy_card_end,
        };
      case 11: // 해바라기 (2행 6번째)
        return {
          'name': '해바라기',
          'number': '12',
          'icon': AppAssets.flower_sunflower,
          'width': 95.0,
          'height': 93.0,
          'color': AppColors.plumu_flower_hobby_check,
          'gradient': AppColors.plumu_flower_hobby_card_end,
        };
      default:
        return {
          'name': '동백꽃',
          'number': '01',
          'icon': AppAssets.flower_camellia,
          'width': 85.0,
          'height': 85.0,
          'color': AppColors.plumu_flower_love_check,
          'gradient': AppColors.plumu_flower_love_card_end,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final flowerData = _getFlowerData(flowerIndex);
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // 뒷배경 (HomeRoot)
          const HomeRoot(),
          
          // 투명 오버레이
          Container(
            color: AppColors.plumu_black.withOpacity(0.1),
          ),
          
          // 그라데이션 배경 (꽃별 색상)
          Container(
            decoration: ShapeDecoration(
              shape: const RoundedRectangleBorder(),
              gradient: LinearGradient(
                begin: const Alignment(0.50, -0.5),
                end: const Alignment(0.50, 1.00),
                colors: [
                  Colors.white.withOpacity(0.875),
                  (flowerData['gradient'] as Color).withOpacity(0.875),
                ],
              ),
            ),
          ),
          
          // 제목 텍스트 (꽃별 색상)
          Positioned(
            top: 140,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '우리 가족의\n꽃 도감 확인하기',
                    style: AppTextStyles.pretendard_bold.copyWith(
                      color: flowerData['color'] as Color,
                      fontSize: 27,
                      height: 1.33,
                      letterSpacing: -0.32,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 265,
                    height: 25,
                    child: Text(
                      '${flowerData['name']}의 생성 기준을 확인해보세요!',
                      style: AppTextStyles.pretendard_medium.copyWith(
                        color: const Color(0xFF333333),
                        fontSize: 15,
                        height: 1.50,
                        letterSpacing: -0.46,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 가이드북 이미지 (크기와 위치 조정)
          Positioned(
            top: 300,
            left: 0,
            right: 0,
            child: Center(
              child: Stack(
                children: [
                  Image.asset(
                    AppAssets.guidebook,
                    width: 357,
                    height: 256,
                    fit: BoxFit.contain,
                  ),
                  // 책 안의 텍스트 (꽃별 이름과 번호)
                  Positioned(
                    left: 51,
                    top: 44,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${flowerData['name']} ',
                            style: AppTextStyles.pretendard_bold.copyWith(
                              color: AppColors.plumu_black,
                              fontSize: 17.73,
                              height: 1.33,
                              letterSpacing: -0.21,
                            ),
                          ),
                          TextSpan(
                            text: flowerData['number'] as String,
                            style: AppTextStyles.pretendard_bold.copyWith(
                              color: AppColors.plumu_black,
                              fontSize: 8.10,
                              height: 2.92,
                              letterSpacing: -0.21,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // 꽃 아이콘 (꽃별 아이콘과 크기)
                  Positioned(
                    left: 62,
                    top: 78,
                    child: Image.asset(
                      flowerData['icon'] as String,
                      width: flowerData['width'] as double,
                      height: flowerData['height'] as double,
                      fit: BoxFit.contain,
                    ),
                  ),
                  // 동백꽃과 장미일 때 해시태그 표시 (오른쪽 페이지 중앙정렬)
                  if (flowerIndex == 0 || flowerIndex == 6) // 동백꽃 (인덱스 0) 또는 장미 (인덱스 6)
                    Positioned(
                      left: 204,
                      top: 75,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HashTagWidget(
                            text: '#사랑',
                            backgroundColor: AppColors.plumu_flower_love_card_end,
                            borderColor: AppColors.plumu_flower_love_check,
                            textColor: AppColors.plumu_flower_love_check,
                          ),
                          const SizedBox(height: 8),
                          HashTagWidget(
                            text: '#애정표현',
                            backgroundColor: AppColors.plumu_flower_love_card_end,
                            borderColor: AppColors.plumu_flower_love_check,
                            textColor: AppColors.plumu_flower_love_check,
                          ),
                        ],
                      ),
                    ),
                  // 아카시아와 수국일 때 해시태그 표시 (오른쪽 페이지 중앙정렬)
                  if (flowerIndex == 1 || flowerIndex == 7) // 아카시아 (인덱스 1) 또는 수국 (인덱스 7)
                    Positioned(
                      left: 204,
                      top: 75,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HashTagWidget(
                            text: '#힘든일',
                            backgroundColor: AppColors.plumu_flower_comfort_card_end,
                            borderColor: AppColors.plumu_flower_comfort_check,
                            textColor: AppColors.plumu_flower_comfort_check,
                          ),
                          const SizedBox(height: 8),
                          HashTagWidget(
                            text: '#위로와격려',
                            backgroundColor: AppColors.plumu_flower_comfort_card_end,
                            borderColor: AppColors.plumu_flower_comfort_check,
                            textColor: AppColors.plumu_flower_comfort_check,
                          ),
                        ],
                      ),
                    ),
                  // 매화꽃과 튤립일 때 해시태그 표시 (오른쪽 페이지 중앙정렬)
                  if (flowerIndex == 2 || flowerIndex == 8) // 매화꽃 (인덱스 2) 또는 튤립 (인덱스 8)
                    Positioned(
                      left: 204,
                      top: 75,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HashTagWidget(
                            text: '#기념일',
                            backgroundColor: AppColors.plumu_flower_special_card_end,
                            borderColor: AppColors.plumu_flower_special_check,
                            textColor: AppColors.plumu_flower_special_check,
                          ),
                          const SizedBox(height: 8),
                          HashTagWidget(
                            text: '#특별한날',
                            backgroundColor: AppColors.plumu_flower_special_card_end,
                            borderColor: AppColors.plumu_flower_special_check,
                            textColor: AppColors.plumu_flower_special_check,
                          ),
                        ],
                      ),
                    ),
                  // 팥배꽃일 때 해시태그 표시 (오른쪽 페이지 중앙정렬)
                  if (flowerIndex == 3) // 팥배꽃 (인덱스 3)
                    Positioned(
                      left: 204,
                      top: 75,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HashTagWidget(
                            text: '#추억',
                            backgroundColor: AppColors.plumu_flower_memory_card_end,
                            borderColor: AppColors.plumu_flower_memory_check,
                            textColor: AppColors.plumu_flower_memory_check,
                          ),
                          const SizedBox(height: 8),
                          HashTagWidget(
                            text: '#과거회상',
                            backgroundColor: AppColors.plumu_flower_memory_card_end,
                            borderColor: AppColors.plumu_flower_memory_check,
                            textColor: AppColors.plumu_flower_memory_check,
                          ),
                        ],
                      ),
                    ),
                  // 벚꽃과 코스모스일 때 해시태그 표시 (오른쪽 페이지 중앙정렬)
                  if (flowerIndex == 4 || flowerIndex == 10) // 벚꽃 (인덱스 4) 또는 코스모스 (인덱스 10)
                    Positioned(
                      left: 204,
                      top: 75,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HashTagWidget(
                            text: '#기쁜일',
                            backgroundColor: AppColors.plumu_flower_joy_card_end,
                            borderColor: AppColors.plumu_flower_joy_check,
                            textColor: AppColors.plumu_flower_joy_check,
                          ),
                          const SizedBox(height: 8),
                          HashTagWidget(
                            text: '#행복한순간',
                            backgroundColor: AppColors.plumu_flower_joy_card_end,
                            borderColor: AppColors.plumu_flower_joy_check,
                            textColor: AppColors.plumu_flower_joy_check,
                          ),
                        ],
                      ),
                    ),
                  // 목련과 해바라기일 때 해시태그 표시 (오른쪽 페이지 중앙정렬)
                  if(flowerIndex == 9)
                    Positioned(
                      left: 204,
                      top: 75,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HashTagWidget(
                            text: '#추억',
                            backgroundColor: const Color(0xFFF6DCFF),
                            borderColor: const Color(0xFF8732D0),
                            textColor: const Color(0xFF8732D0),
                          ),
                          const SizedBox(height: 8),
                          HashTagWidget(
                            text: '#과거회상',
                            backgroundColor: const Color(0xFFF6DCFF),
                            borderColor: const Color(0xFF8732D0),
                            textColor: const Color(0xFF8732D0),
                          ),
                        ],
                      ),
                    ),
                  if (flowerIndex == 5 || flowerIndex == 11) // 목련 (인덱스 5) 또는 해바라기 (인덱스 11)
                    Positioned(
                      left: 204,
                      top: 75,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HashTagWidget(
                            text: '#취미',
                            backgroundColor: AppColors.plumu_flower_hobby_card_end,
                            borderColor: AppColors.plumu_flower_hobby_check,
                            textColor: AppColors.plumu_flower_hobby_check,
                          ),
                          const SizedBox(height: 8),
                          HashTagWidget(
                            text: '#관심사',
                            backgroundColor: AppColors.plumu_flower_hobby_card_end,
                            borderColor: AppColors.plumu_flower_hobby_check,
                            textColor: AppColors.plumu_flower_hobby_check,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          // 확인 버튼 (꽃별 색상)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Center(
                child: CustomButton(
                  text: '확인',
                  onPressed: () => Navigator.of(context).pop(),
                  backgroundColor: flowerData['color'] as Color,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

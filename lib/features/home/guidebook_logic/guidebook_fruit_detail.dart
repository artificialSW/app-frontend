import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'package:artificialsw_frontend/features/home/home_mainpage.dart';

/// 가이드북 열매 상세 페이지 (꽃 상세 UI 재사용)
class GuidebookFruitDetailPage extends StatelessWidget {
  final int fruitIndex; // 0-15 (봄0-3, 여름4-7, 가을8-11, 겨울12-15)

  const GuidebookFruitDetailPage({super.key, required this.fruitIndex});

  bool get _isSpring => fruitIndex >= 0 && fruitIndex <= 3;

  Map<String, dynamic> _getFruitData(int index) {
    switch (index) {
      // 봄 (1쪽) - 생성기준 01
      case 0:
        return {
          'name': '체리', 'number': '01', 'icon': AppAssets.fruit_cherry,
          'season': '봄', 'months': '3월/4월/5월', 'criteria': '01',
          'primary': const Color(0xFFD91D58), 'bgSoft': const Color(0xFFFFD6E3),
        };
      case 1:
        return {
          'name': '딸기', 'number': '02', 'icon': AppAssets.fruit_strawberry,
          'season': '봄', 'months': '3월/4월/5월', 'criteria': '01',
          'primary': const Color(0xFFD91D58), 'bgSoft': const Color(0xFFFFD6E3),
        };
      case 2:
        return {
          'name': '키위', 'number': '03', 'icon': AppAssets.fruit_kiwi,
          'season': '봄', 'months': '3월/4월/5월', 'criteria': '01',
          'primary': const Color(0xFFD91D58), 'bgSoft': const Color(0xFFFFD6E3),
        };
      case 3:
        return {
          'name': '산딸기', 'number': '04', 'icon': AppAssets.fruit_raspberry,
          'season': '봄', 'months': '3월/4월/5월', 'criteria': '01',
          'primary': const Color(0xFFD91D58), 'bgSoft': const Color(0xFFFFD6E3),
        };
      
      // 여름 (2쪽) - 생성기준 02
      case 4:
        return {
          'name': '복숭아', 'number': '05', 'icon': AppAssets.fruit_peach,
          'season': '여름', 'months': '6월/7월/8월', 'criteria': '02',
          'primary': const Color(0xFF5CBD56), 'bgSoft': const Color(0xFFE7FFE6),
        };
      case 5:
        return {
          'name': '자두', 'number': '06', 'icon': AppAssets.fruit_plum,
          'season': '여름', 'months': '6월/7월/8월', 'criteria': '02',
          'primary': const Color(0xFF5CBD56), 'bgSoft': const Color(0xFFE7FFE6),
        };
      case 6:
        return {
          'name': '망고', 'number': '07', 'icon': AppAssets.fruit_mango,
          'season': '여름', 'months': '6월/7월/8월', 'criteria': '02',
          'primary': const Color(0xFF5CBD56), 'bgSoft': const Color(0xFFE7FFE6),
        };
      case 7:
        return {
          'name': '블루베리', 'number': '08', 'icon': AppAssets.fruit_blueberry,
          'season': '여름', 'months': '6월/7월/8월', 'criteria': '02',
          'primary': const Color(0xFF5CBD56), 'bgSoft': const Color(0xFFE7FFE6),
        };
      
      // 가을 (3쪽) - 생성기준 03
      case 8:
        return {
          'name': '포도', 'number': '09', 'icon': AppAssets.fruit_grape,
          'season': '가을', 'months': '9월/10월/11월', 'criteria': '03',
          'primary': const Color(0xFFD55619), 'bgSoft': const Color(0xFFFFDCCA),
        };
      case 9:
        return {
          'name': '배', 'number': '10', 'icon': AppAssets.fruit_pear,
          'season': '가을', 'months': '9월/10월/11월', 'criteria': '03',
          'primary': const Color(0xFFD55619), 'bgSoft': const Color(0xFFFFDCCA),
        };
      case 10:
        return {
          'name': '감', 'number': '11', 'icon': AppAssets.fruit_persimmon,
          'season': '가을', 'months': '9월/10월/11월', 'criteria': '03',
          'primary': const Color(0xFFD55619), 'bgSoft': const Color(0xFFFFDCCA),
        };
      case 11:
        return {
          'name': '대추', 'number': '12', 'icon': AppAssets.fruit_jujube,
          'season': '가을', 'months': '9월/10월/11월', 'criteria': '03',
          'primary': const Color(0xFFD55619), 'bgSoft': const Color(0xFFFFDCCA),
        };
      
      // 겨울 (4쪽) - 생성기준 04
      case 12:
        return {
          'name': '사과', 'number': '13', 'icon': AppAssets.fruit_apple,
          'season': '겨울', 'months': '12월/1월/2월', 'criteria': '04',
          'primary': const Color(0xFF00BBE0), 'bgSoft': const Color(0xFFD9FCFF),
        };
      case 13:
        return {
          'name': '귤', 'number': '14', 'icon': AppAssets.fruit_mandarin,
          'season': '겨울', 'months': '12월/1월/2월', 'criteria': '04',
          'primary': const Color(0xFF00BBE0), 'bgSoft': const Color(0xFFD9FCFF),
        };
      case 14:
        return {
          'name': '석류', 'number': '15', 'icon': AppAssets.fruit_pomegranate,
          'season': '겨울', 'months': '12월/1월/2월', 'criteria': '04',
          'primary': const Color(0xFF00BBE0), 'bgSoft': const Color(0xFFD9FCFF),
        };
      case 15:
        return {
          'name': '유자', 'number': '16', 'icon': AppAssets.fruit_yuja,
          'season': '겨울', 'months': '12월/1월/2월', 'criteria': '04',
          'primary': const Color(0xFF00BBE0), 'bgSoft': const Color(0xFFD9FCFF),
        };
      
      default:
        return {
          'name': '체리', 'number': '01', 'icon': AppAssets.fruit_cherry,
          'season': '봄', 'months': '3월/4월/5월', 'criteria': '01',
          'primary': const Color(0xFFD91D58), 'bgSoft': const Color(0xFFFFD6E3),
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = _getFruitData(fruitIndex);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final widthRatio = screenWidth / 412; // 기준 화면 412px
    final heightRatio = screenHeight / 917; // 기준 화면 917px

    // 계절별 컬러/배경 정의 (동적)
    final Color primary = data['primary'] as Color;
    final Color bgSoft = data['bgSoft'] as Color;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // 뒤 배경 (꽃 상세와 동일)
          const HomeRoot(),
          
          // 투명 오버레이 (꽃 상세와 동일한 투명도)
          Container(
            color: const Color(0xFF1B1D1B).withOpacity(0.1),
          ),

          // 그라데이션 배경 (봄 과일 기준, 꽃 상세와 동일한 구조)
          Container(
            decoration: ShapeDecoration(
              shape: const RoundedRectangleBorder(),
              gradient: LinearGradient(
                begin: const Alignment(0.50, -0.5),
                end: const Alignment(0.50, 1.00),
                colors: [
                  Colors.white.withOpacity(0.875),
                  bgSoft.withOpacity(0.875),
                ],
              ),
            ),
          ),

          // 제목/부제목 (적응형)
          Positioned(
            top: 140 * heightRatio,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.only(left: 32 * widthRatio),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '우리 가족의\n열매 도감 확인하기',
                    style: TextStyle(
                      color: primary,
                      fontSize: 27 * widthRatio,
                      height: 1.33,
                      letterSpacing: -0.32 * widthRatio,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                  SizedBox(height: 8 * heightRatio),
                  SizedBox(
                    width: 265 * widthRatio,
                    height: 25 * heightRatio,
                    child: Text(
                      '${data['name']}의 생성 기준을 확인해보세요!',
                      style: TextStyle(
                        color: const Color(0xFF333333),
                        fontSize: 15 * widthRatio,
                        height: 1.50,
                        letterSpacing: -0.46 * widthRatio,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 책과 내부 구성 (책 내부 요소들만 포함)
          Positioned(
            top: 300 * heightRatio,
            left: 0,
            right: 0,
            child: Center(
              child: Stack(
                children: [
                  Image.asset(
                    AppAssets.guidebook,
                    width: 357 * widthRatio,
                    height: 256 * heightRatio,
                    fit: BoxFit.contain,
                  ),
                  // 책 안의 텍스트 (열매 이름 + 번호) - 적응형
                  Positioned(
                    left: 51 * widthRatio,
                    top: 44 * heightRatio,
                    child: SizedBox(
                      width: 240 * widthRatio,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: '${data['name']} ',
                              style: TextStyle(
                                color: const Color(0xFF1B1D1B),
                                fontSize: 17.73 * widthRatio,
                                height: 1.33,
                                letterSpacing: -0.21 * widthRatio,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Pretendard',
                              ),
                            ),
                            TextSpan(
                              text: data['number'] as String,
                              style: TextStyle(
                                color: const Color(0xFF1B1D1B),
                                fontSize: 8.10 * widthRatio,
                                height: 2.92,
                                letterSpacing: -0.21 * widthRatio,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Pretendard',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // 열매 아이콘 (꽃 아이콘 자리에) - 적응형
                  Positioned(
                    left: 62 * widthRatio,
                    top: 78 * heightRatio,
                    child: Image.asset(
                      data['icon'] as String,
                      width: 85 * widthRatio,
                      height: 85 * heightRatio,
                      fit: BoxFit.contain,
                    ),
                  ),
                  // 생성기준 라벨 - 책 내부 기준 (우측 53, 위쪽 50)
                  Positioned(
                    right: 53 * widthRatio,
                    top: 50 * heightRatio,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '생성기준 ',
                            style: TextStyle(
                              color: const Color(0xFF1B1D1B),
                              fontSize: 17.73 * widthRatio,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w700,
                              height: 1.33,
                              letterSpacing: -0.21 * widthRatio,
                            ),
                          ),
                          TextSpan(
                            text: data['criteria'] as String,
                            style: TextStyle(
                              color: const Color(0xFF1B1D1B),
                              fontSize: 8.10 * widthRatio,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w700,
                              height: 2.92,
                              letterSpacing: -0.21 * widthRatio,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // 계절 배지 - 책 내부 기준 (우측 53.28, 위쪽 92) - 높이 27.84 고정(적응형)
                  Positioned(
                    right: 53.28 * widthRatio,
                    top: 92 * heightRatio,
                    child: SizedBox(
                      height: 27.84 * heightRatio,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.36 * widthRatio,
                        ),
                        alignment: Alignment.center,
                        decoration: ShapeDecoration(
                          color: bgSoft,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 0.84 * widthRatio, color: bgSoft),
                            borderRadius: BorderRadius.circular(17.64 * widthRatio),
                          ),
                        ),
                        child: Text(
                          '#${data['season']}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: primary,
                            fontSize: 13.44 * widthRatio,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // 월 배지 - 책 내부 기준 (우측 53.28, 위쪽 126) - 높이 27.84 고정(적응형)
                  Positioned(
                    right: 53.28 * widthRatio,
                    top: 126 * heightRatio,
                    child: SizedBox(
                      height: 27.84 * heightRatio,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.36 * widthRatio,
                        ),
                        alignment: Alignment.center,
                        decoration: ShapeDecoration(
                          color: bgSoft,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 0.84 * widthRatio, color: bgSoft),
                            borderRadius: BorderRadius.circular(17.64 * widthRatio),
                          ),
                        ),
                        child: Text(
                          '#${data['months']}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: primary,
                            fontSize: 13.44 * widthRatio,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 확인 버튼 (적응형, primary 색상)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                20 * widthRatio, 
                0, 
                20 * widthRatio, 
                20 * heightRatio
              ),
              child: Center(
                child: CustomButton(
                  text: '확인',
                  onPressed: () => Navigator.of(context).pop(),
                  backgroundColor: primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'package:artificialsw_frontend/features/home/home_mainpage.dart';
import 'package:artificialsw_frontend/features/home/widget/guidebook_widgets/guidebook_tab_bar.dart';
import 'package:artificialsw_frontend/features/home/widget/guidebook_widgets/guidebook_swipe_area.dart';
import 'package:artificialsw_frontend/services/home/home_service.dart';

/// 가이드북 메인 페이지
/// 사용자가 앱의 기능과 사용법을 확인할 수 있는 페이지
class GuidebookMainPage extends StatefulWidget {
  const GuidebookMainPage({super.key});

  @override
  State<GuidebookMainPage> createState() => _GuidebookMainPageState();
}

class _GuidebookMainPageState extends State<GuidebookMainPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _selectedTab = 0; // 0: 꽃, 1: 열매
  final HomeService _homeService = HomeService();
  late final Future<List<bool>> _flowerUnlockFuture;
  late final Future<List<bool>> _fruitUnlockFuture;

  @override
  void initState() {
    super.initState();
    _flowerUnlockFuture = _getFlowerUnlockedStates();
    _fruitUnlockFuture = _getFruitUnlockedStates();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// 기본 해금 상태 반환 (즉시 표시용)
  List<bool> _getDefaultUnlockStates() {
    // 1행: 0: 동백꽃, 1: 아카시아, 2: 매화, 3: 팥배꽃, 4: 벚꽃, 5: 목련
    // 2행: 6: 장미, 7: 수국, 8: 튤립, 9: 제비꽃, 10: 코스모스, 11: 해바라기
    return [
      true,  // 0: 동백꽃
      true,  // 1: 아카시아
      false, // 2: 매화 (잠금)
      true,  // 3: 팥배꽃
      false, // 4: 벚꽃 (잠금)
      true,  // 5: 목련
      true,  // 6: 장미
      false, // 7: 수국 (잠금)
      true,  // 8: 튤립
      true, // 9: 제비꽃 (잠금)
      true,  // 10: 코스모스
      false, // 11: 해바라기 (잠금)
    ];
  }

  /// 기본 열매 해금 상태 반환 (각 계절별 2개씩만 해금)
  List<bool> _getDefaultFruitUnlockStates() {
    // 16개 열매 중 각 계절별로 2개씩만 해금
    // 봄(0-3): 체리, 딸기 해금 / 키위, 산딸기 잠금
    // 여름(4-7): 복숭아, 자두 해금 / 망고, 블루베리 잠금  
    // 가을(8-11): 포도, 배 해금 / 감, 대추 잠금
    // 겨울(12-15): 사과, 귤 해금 / 석류, 유자 잠금
    return [
      true,  // 0: 체리 (봄)
      true,  // 1: 딸기 (봄)
      false, // 2: 키위 (봄) - 잠금
      false, // 3: 산딸기 (봄) - 잠금
      true,  // 4: 복숭아 (여름)
      true,  // 5: 자두 (여름)
      false, // 6: 망고 (여름) - 잠금
      false, // 7: 블루베리 (여름) - 잠금
      true,  // 8: 포도 (가을)
      true,  // 9: 배 (가을)
      false, // 10: 감 (가을) - 잠금
      false, // 11: 대추 (가을) - 잠금
      true,  // 12: 사과 (겨울)
      true,  // 13: 귤 (겨울)
      false, // 14: 석류 (겨울) - 잠금
      false, // 15: 유자 (겨울) - 잠금
    ];
  }

  /// 과일 해금 상태 반환 (API 호출)
  Future<List<bool>> _getFruitUnlockedStates() async {
    try {
      final response = await _homeService.getFruitUnlockStatus();
      final unlockedIds = response.resolvedFruits;
      
      // 16개 과일의 해금 상태 (true: 해금됨, false: 잠금)
      return List.generate(16, (index) => unlockedIds.contains(index));
    } catch (e) {
      print('❌ 과일 해금 상태 조회 실패, 기본값 사용: $e');
      return _getDefaultFruitUnlockStates();
    }
  }

  /// 꽃 해금 상태 반환 (API 호출)
  Future<List<bool>> _getFlowerUnlockedStates() async {
    try {
      final response = await _homeService.getFlowerUnlockStatus();
      final unlockedIds = response.resolvedFlowers;
      
      // 12개 꽃의 해금 상태 (true: 해금됨, false: 잠금)
      return List.generate(12, (index) => unlockedIds.contains(index));
    } catch (e) {
      print('❌ 꽃 해금 상태 조회 실패, 기본값 사용: $e');
      return _getDefaultUnlockStates();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // 뒤에 흐리게 보이는 메인페이지
          Positioned.fill(
            child: Container(
              color: AppColors.plumu_black.withOpacity(0.1), // 더 투명하게
              child: const HomeRoot(), // 메인페이지 위젯
            ),
          ),

          // 가이드북 오버레이
          Positioned.fill(
            child: Container(
              color: Colors.transparent,
              child: Stack(
                children: [
                  // 배경 Container
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: ShapeDecoration(
                      gradient: LinearGradient(
                        begin: const Alignment(0.50, -0.5),
                        end: const Alignment(0.50, 1.00),
                        colors: [Colors.white.withOpacity(0.875), const Color(0xFFC9FBC6).withOpacity(0.875)],
                      ),
                      shape: const RoundedRectangleBorder(), // 둥근 모서리 제거
                    ),
                  ),

                  // 콘텐츠
                  Column(
                    children: [
                      // 상단 여백
                      const SizedBox(height: 80),
                      GuidebookTabBar(
                        selectedTab: _selectedTab,
                        onTabChanged: (tab) => setState(() => _selectedTab = tab),
                      ),
                      FutureBuilder<List<bool>>(
                        future: _flowerUnlockFuture,
                        initialData: _getDefaultUnlockStates(), // 즉시 표시할 기본값
                        builder: (context, flowerSnapshot) {
                          final flowerUnlockedStates = flowerSnapshot.data ?? _getDefaultUnlockStates();
                          return FutureBuilder<List<bool>>(
                            future: _fruitUnlockFuture,
                            initialData: _getDefaultFruitUnlockStates(), // 즉시 표시할 기본값
                            builder: (context, fruitSnapshot) {
                              final fruitUnlockedStates = fruitSnapshot.data ?? _getDefaultFruitUnlockStates();
                              return GuidebookSwipeArea(
                                pageController: _pageController,
                                currentPage: _currentPage,
                                selectedTab: _selectedTab,
                                onPageChanged: (page) => setState(() => _currentPage = page),
                                flowerUnlockedStates: flowerUnlockedStates,
                                fruitUnlockedStates: fruitUnlockedStates,
                              );
                            },
                          );
                        },
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: CustomButton(
                          text: '확인',
                          onPressed: () => Navigator.of(context).pop(),
                          width: MediaQuery.of(context).size.width * 0.8,
                        ),
                      ),
                    ],
                  ),

                  // 제목과 부제목 (탭/해금상태에 따라 동적 변경)
                  Positioned(
                    top: 180,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 32),
                      child: FutureBuilder<List<bool>>(
                        future: _flowerUnlockFuture,
                        initialData: _getDefaultUnlockStates(),
                        builder: (context, snapshot) {
                          final flowerUnlockedStates = snapshot.data ?? _getDefaultUnlockStates();
                          final bool anyFlowerUnlocked = flowerUnlockedStates.any((e) => e);

                          final String title = _selectedTab == 0
                              ? '우리 가족의\n꽃 도감 확인하기'
                              : '우리 가족의\n열매 도감 확인하기';

                          final String subtitle = _selectedTab == 0
                              ? (anyFlowerUnlocked ? '꽃 생성 기준을 확인해보세요!' : '아직 획득한 꽃이 없어요')
                              : '열매 생성 기준을 확인해보세요!';

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: AppTextStyles.pretendard_bold.copyWith(
                                  color: AppColors.plumu_black,
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
                                  subtitle,
                                  style: AppTextStyles.pretendard_medium.copyWith(
                                    color: AppColors.plumu_gray_8,
                                    fontSize: 15,
                                    height: 1.50,
                                    letterSpacing: -0.46,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

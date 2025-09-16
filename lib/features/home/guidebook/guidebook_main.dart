import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'package:artificialsw_frontend/features/home/home_mainpage.dart';
import 'package:artificialsw_frontend/features/home/widget/guidebook_widgets/guidebook_tab_bar.dart';
import 'package:artificialsw_frontend/features/home/widget/guidebook_widgets/guidebook_swipe_area.dart';

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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
                      const SizedBox(height: 100),
                      GuidebookTabBar(
                        selectedTab: _selectedTab,
                        onTabChanged: (tab) => setState(() => _selectedTab = tab),
                      ),
                      GuidebookSwipeArea(
                        pageController: _pageController,
                        currentPage: _currentPage,
                        selectedTab: _selectedTab,
                        onPageChanged: (page) => setState(() => _currentPage = page),
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

                  // 제목과 부제목
                  Positioned(
                    top: 180,
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
                              '꽃 생성 기준을 확인해보세요!',
                              style: AppTextStyles.pretendard_medium.copyWith(
                                color: AppColors.plumu_gray_8,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

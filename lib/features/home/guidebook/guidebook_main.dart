import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/features/home/home_mainpage.dart';

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
              color: AppColors.plumu_black.withOpacity(0.3), // 어둡게 처리
              child: const HomeRoot(), // 메인페이지 위젯
            ),
          ),

          // 가이드북 오버레이
          Positioned.fill(
            child: Container(
              color: Colors.transparent,
              child: Column(
                children: [
                  // 상단 바
                  Container(
                    height: 100,
                    color: AppColors.plumu_white.withOpacity(0.9),
                    child: SafeArea(
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: AppColors.plumu_black,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          Expanded(
                            child: Text(
                              '가이드북',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.pretendard_bold.copyWith(
                                fontSize: 18,
                                color: AppColors.plumu_black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 48), // 뒤로가기 버튼과 균형 맞추기
                        ],
                      ),
                    ),
                  ),

                  // 책 모양 스와이프 영역
                  Expanded(
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: PageView.builder(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          itemCount: 3, // 3페이지로 설정
                          itemBuilder: (context, index) {
                            return _buildBookPage(index);
                          },
                        ),
                      ),
                    ),
                  ),

                  // 페이지 인디케이터
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(3, (index) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? AppColors.plumu_green_main
                                : AppColors.plumu_gray_5.withOpacity(0.3),
                          ),
                        );
                      }),
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

  /// 책 페이지를 생성하는 위젯
  Widget _buildBookPage(int pageIndex) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.plumu_white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book,
              size: 64,
              color: AppColors.plumu_green_main,
            ),
            const SizedBox(height: 16),
            Text(
              '페이지 ${pageIndex + 1}',
              style: AppTextStyles.pretendard_bold.copyWith(
                fontSize: 24,
                color: AppColors.plumu_black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '가이드북 내용이 여기에 표시됩니다',
              style: AppTextStyles.pretendard_medium.copyWith(
                fontSize: 16,
                color: AppColors.plumu_gray_5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

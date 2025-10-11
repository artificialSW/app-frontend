import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'package:artificialsw_frontend/features/home/widget/home_bottom_buttons.dart';

/// 튜토리얼 페이지 위젯
/// 살펴보러가기 버튼 클릭 시 표시되는 튜토리얼 화면
class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onClosePressed(BuildContext context) {
    Navigator.of(context).pop(); // 튜토리얼 페이지 닫기
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 기준 화면 크기 (412x917)에 대한 비율 계산
    final widthRatio = screenWidth / 412.0;
    final heightRatio = screenHeight / 917.0;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: screenWidth,
        height: screenHeight,
        child: Stack(
        children: [
          // 메인 화면 배경 (뒤에 비치도록)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(_getTimeBasedBackground()),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          
          // plumu 로고 (메인 화면과 동일한 위치, 뚜렷하게 앞쪽으로)
          Positioned(
            left: 0,
            right: 0,
            top: MediaQuery.of(context).padding.top + 16 * heightRatio, // AppBar 높이 56에서 중앙 정렬
            child: Center(
              child: Text(
                'plumu',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24 * widthRatio,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w700,
                  height: 1.2, // 텍스트 잘림 방지
                ),
              ),
            ),
          ),
          
          // 반투명 오버레이 (50% 투명도)
          Positioned.fill(
            child: Container(
              color: const Color(0x801B1B1B),
            ),
          ),
          
          // 섬 이미지 (메인 화면과 동일한 위치, 뚜렷하게 앞쪽으로)
          Positioned(
            left: 37 * widthRatio,
            right: 37 * widthRatio,
            top: 236 * heightRatio,
            child: Container(
              width: 338 * widthRatio,
              height: 302.46 * heightRatio,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppAssets.island_information),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          
          
          // 튜토리얼 콘텐츠 (PageView)
          Positioned.fill(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _buildFirstPage(widthRatio, heightRatio),
                _buildSecondPage(widthRatio, heightRatio),
              ],
            ),
          ),
          
          // X 닫기 아이콘 (우측 상단)
          Positioned(
            right: 34 * widthRatio,
            top: MediaQuery.of(context).padding.top + 12 * heightRatio,
            child: GestureDetector(
              onTap: () => _onClosePressed(context),
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 30 * widthRatio,
              ),
            ),
          ),
          
          
          // 페이지 인디케이터 (위에서 536 위치, 중앙 정렬)
          Positioned(
            left: 0,
            right: 0,
            top: 536 * heightRatio,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8 * widthRatio,
                  height: 8 * heightRatio,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == 0 ? Colors.white : Colors.white.withOpacity(0.3),
                  ),
                ),
                SizedBox(width: 8 * widthRatio),
                Container(
                  width: 8 * widthRatio,
                  height: 8 * heightRatio,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == 1 ? Colors.white : Colors.white.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildFirstPage(double widthRatio, double heightRatio) {
    return Stack(
      children: [
        // 첫 번째 텍스트: "나무를 클릭하여 열매/꽃 살펴보기"
        Positioned(
          left: 157 * widthRatio,
          top: 168 * heightRatio,
          child: Text(
            '나무를 클릭하여 열매/꽃 살펴보기',
            style: TextStyle(
              color: const Color(0xFFF7F7F7),
              fontSize: 16 * widthRatio,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ),
        
        // 두 번째 텍스트: "언제든 도움말 확인하기"
        Positioned(
          left: 32 * widthRatio,
          top: 556 * heightRatio,
          child: Text(
            '언제든 도움말 확인하기',
            style: TextStyle(
              color: const Color(0xFFF7F7F7),
              fontSize: 16 * widthRatio,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ),
        
        // 세 번째 텍스트: "획득한 열매/꽃 확인하기"
        Positioned(
          left: 73 * widthRatio,
          top: 600 * heightRatio,
          child: Text(
            '획득한 열매/꽃 확인하기',
            style: TextStyle(
              color: const Color(0xFFF7F7F7),
              fontSize: 16 * widthRatio,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ),
        
        // 네 번째 텍스트: "우리 가족의 섬 아카이브 확인하기"
        Positioned(
          left: 168 * widthRatio,
          top: 631 * heightRatio,
          child: Text(
            '우리 가족의 섬 아카이브 확인하기',
            style: TextStyle(
              color: const Color(0xFFF7F7F7),
              fontSize: 16 * widthRatio,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ),
        
        // 하단 버튼들 (첫 번째 페이지에서만 표시)
        Positioned(
          left: 0,
          right: 0,
          top: 717 * heightRatio,
          child: HomeBottomButtons(),
        ),
        
        // 도움말 버튼 (첫 번째 페이지에서만 표시)
        Positioned(
          left: 32 * widthRatio,
          top: 670 * heightRatio,
          child: GestureDetector(
            onTap: () {
              // 도움말 버튼 클릭 시 아무 동작 안함 (튜토리얼 중이므로)
            },
            child: Container(
              width: 40 * widthRatio,
              height: 40 * heightRatio,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppAssets.help),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        
        // vector6 이미지 (나무를 클릭하여... 밑에 두번째 나무와 연결)
        Positioned(
          left: 180 * widthRatio, // 두번째 나무 위치로 조정
          top: 200 * heightRatio, // 텍스트 아래에서 섬의 두번째 나무로
          child: Container(
            width: 20 * widthRatio, // 너비 20px
            height: 40 * heightRatio, // 높이 40px
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.vector6),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        
        // vector8 이미지 (언제든 도움말... 밑에 도움말 아이콘과 연결)
        Positioned(
          left: 40.6 * widthRatio, // 도움말 아이콘 위치로 조정
          top: 589 * heightRatio, // 텍스트 아래에서 도움말 아이콘으로
          child: Container(
            width: 20 * widthRatio, // 너비 20px
            height: 83 * heightRatio, // 높이 83px
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.vector8),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        
        // vector9 이미지 (획득한 열매/꽃... 밑에 도감 버튼과 연결)
        Positioned(
          left: 94 * widthRatio, // 도감 버튼 위치로 조정
          top: 635 * heightRatio, // 텍스트 아래에서 도감 버튼으로
          child: Container(
            width: 20 * widthRatio, // 너비 20px
            height: 80 * heightRatio, // 높이 80px
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.vector8),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        
        // vector5 이미지 (우리 가족의 섬... 밑에 섬 보관소 버튼과 연결)
        Positioned(
          left: 352 * widthRatio, // 섬 보관소 버튼 위치로 조정
          top: 667 * heightRatio, // 텍스트 아래에서 섬 보관소 버튼으로
          child: Container(
            width: 20 * widthRatio, // 너비 20px
            height: 50 * heightRatio, // 높이 50px
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.vector9),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecondPage(double widthRatio, double heightRatio) {
    return Stack(
      children: [
        // 상단 타이틀: "plumu의 섬은 2주마다 바뀌어요!"
        Positioned(
          left: 0,
          right: 0,
          top: 135 * heightRatio, // 위쪽 패딩 135
          child: Text(
            'plumu의 섬은 2주마다 바뀌어요!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20 * widthRatio,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
              height: 1.60,
              letterSpacing: -0.25 * widthRatio,
            ),
          ),
        ),
        
        // 꽃나무 1 이미지
        Positioned(
          left: 44 * widthRatio, // 좌측 패딩 44
          top: 538 * heightRatio, // 위쪽 패딩 538
          child: Container(
            width: 63 * widthRatio, // 크기 63x111
            height: 111 * heightRatio,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.information_flower_tree2),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        
        // 꽃나무 2 이미지
        Positioned(
          left: 115 * widthRatio, // 좌측 패딩 115
          top: 571 * heightRatio, // 위쪽 패딩 571
          child: Container(
            width: 39 * widthRatio, // 크기 39x78
            height: 78 * heightRatio,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.information_flower_tree1),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        
        // 과일나무 1 이미지
        Positioned(
          left: 42 * widthRatio, // 좌측 패딩 42
          top: 661 * heightRatio, // 위쪽 패딩 671
          child: Container(
            width: 60 * widthRatio, // 크기 60x100
            height: 100 * heightRatio,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.information_fruit_tree1),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        
        // 과일나무 2 이미지
        Positioned(
          left: 110 * widthRatio, // 좌측 패딩 110
          top: 687 * heightRatio, // 위쪽 패딩 687
          child: Container(
            width: 32 * widthRatio, // 크기 32x74
            height: 74 * heightRatio,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.information_fruit_tree2),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        
        // 꽃나무 설명 텍스트
        Positioned(
          left: 166 * widthRatio, // 좌측 패딩 166
          top: 615 * heightRatio, // 위쪽 패딩 615
          child: Text(
            '큰 꽃나무에는 6개의 꽃들이,\n작은 꽃나무에는 4개의 꽃들이 피어나요',
            style: TextStyle(
              color: const Color(0xFFF7F7F7),
              fontSize: 13 * widthRatio,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              height: 1.31,
            ),
          ),
        ),
        
        // 과일나무 설명 텍스트
        Positioned(
          left: 154 * widthRatio, // 좌측 패딩 154
          top: 727 * heightRatio, // 위쪽 패딩 727
          child: Text(
            '큰 열매 나무에는 6개의 꽃들이,\n작은 열매 나무에는 3개의 꽃들이 피어나요',
            style: TextStyle(
              color: const Color(0xFFF7F7F7),
              fontSize: 13 * widthRatio,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              height: 1.31,
            ),
          ),
        ),
        
        // 꽃나무 라벨 1
        Positioned(
          left: 103 * widthRatio, // 좌측 패딩 108
          top: 204 * heightRatio, // 위쪽 패딩 204
          child: Text(
            '꽃나무',
            style: TextStyle(
              color: const Color(0xFFF7F7F7),
              fontSize: 16 * widthRatio,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ),
        
        // 꽃나무 라벨 2
        Positioned(
          left: 172 * widthRatio, // 좌측 패딩 177
          top: 188 * heightRatio, // 위쪽 패딩 188
          child: Text(
            '꽃나무',
            style: TextStyle(
              color: const Color(0xFFF7F7F7),
              fontSize: 16 * widthRatio,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ),
        
        // 열매나무 라벨 1
        Positioned(
          left: 238 * widthRatio, // 좌측 패딩 243
          top: 240 * heightRatio, // 위쪽 패딩 240
          child: Text(
            '열매나무',
            style: TextStyle(
              color: const Color(0xFFF7F7F7),
              fontSize: 16 * widthRatio,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ),
        
        // 열매나무 라벨 2
        Positioned(
          left: 298 * widthRatio, // 좌측 패딩 303
          top: 314 * heightRatio, // 위쪽 패딩 314
          child: Text(
            '열매나무',
            style: TextStyle(
              color: const Color(0xFFF7F7F7),
              fontSize: 16 * widthRatio,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ),
        
        // vector5 - 1번째 (좌측패딩 129, 위쪽패딩 238)
        Positioned(
          left: 116 * widthRatio,
          top: 230 * heightRatio,
          child: Container(
            width: 20 * widthRatio,
            height: 23 * heightRatio,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.vector5),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        
        // vector5 - 2번째 (좌측패딩 198, 위쪽패딩 219)
        Positioned(
          left: 180 * widthRatio,
          top: 219 * heightRatio,
          child: Container(
            width: 20 * widthRatio,
            height: 23 * heightRatio,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.vector5),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        
        // vector5 - 3번째 (좌측패딩 271, 위쪽패딩 271)
        Positioned(
          left: 251 * widthRatio,
          top: 271 * heightRatio,
          child: Container(
            width: 20 * widthRatio,
            height: 23 * heightRatio,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.vector5),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        
        // vector5 - 4번째 (좌측패딩 315, 위쪽패딩 345)
        Positioned(
          left: 290 * widthRatio,
          top: 345 * heightRatio,
          child: Container(
            width: 20 * widthRatio,
            height: 23 * heightRatio,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.vector5),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 시간대별 배경 이미지 반환 (메인 화면과 동일)
  String _getTimeBasedBackground() {
    final now = DateTime.now();
    final hour = now.hour;
    
    if (hour >= 4 && hour < 8) {
      return 'assets/images/dawn.png';
    } else if (hour >= 8 && hour < 16) {
      return 'assets/images/morning.png';
    } else if (hour >= 16 && hour < 20) {
      return 'assets/images/afternoon.png';
    } else {
      return 'assets/images/night.png';
    }
  }
}

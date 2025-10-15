import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'package:artificialsw_frontend/features/home/widget/island_archive_filter_dropdown.dart';

/// 섬 아카이브 페이지
/// 
/// 섬 보관소에서 저장된 섬들을 월별로 확인할 수 있는 화면
/// 시간대별 배경, 월 네비게이션, 필터링 기능을 포함함
class IslandArchivePage extends StatefulWidget {
  const IslandArchivePage({super.key});

  @override
  State<IslandArchivePage> createState() => _IslandArchivePageState();
}

class _IslandArchivePageState extends State<IslandArchivePage> {
  int _currentMonth = 9; // 현재 월 (9월부터 시작)
  int _selectedYear = 2025; // 선택된 연도
  bool _isFilterVisible = false; // 필터 드롭다운 표시 여부
  int _currentPage = 0; // 현재 페이지 (인디케이터용)

  /// 현재 시간에 따라 배경 이미지를 선택하는 함수
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

  /// 월을 문자열로 변환하는 함수
  String _getMonthString(int month) {
    return '${month}월';
  }

  /// 이전 월로 이동 (1월에서는 더 이상 이동 불가)
  void _previousMonth() {
    setState(() {
      if (_currentMonth > 1) {
        _currentMonth--;
      } else {
        // 1월에서는 더 이상 이동하지 않음
        return;
      }
    });
  }

  /// 다음 월로 이동 (12월에서는 더 이상 이동 불가)
  void _nextMonth() {
    setState(() {
      if (_currentMonth < 12) {
        _currentMonth++;
      } else {
        // 12월에서는 더 이상 이동하지 않음
        return;
      }
    });
  }

  /// 필터 토글
  void _toggleFilter() {
    setState(() {
      _isFilterVisible = !_isFilterVisible;
    });
  }

  /// 연도 선택 처리
  void _onYearSelected(int year) {
    setState(() {
      _selectedYear = year;
      _isFilterVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // 기준 화면 크기 (412x917)에 대한 비율 계산
    final widthRatio = screenWidth / 412.0;
    final heightRatio = screenHeight / 917.0;

    return Scaffold(
      body: Stack(
        children: [
          // 시간대별 배경 이미지 (화면 전체를 채움)
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

          // 제목 텍스트
          Positioned(
            left: 0,
            right: 0,
            top: 58 * heightRatio,
            child: Text(
              _selectedYear == -1 ? '전체 섬 아카이브' : '${_selectedYear}년 섬 아카이브',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17 * widthRatio,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w700,
                height: 1.50,
                letterSpacing: -0.46,
              ),
            ),
          ),

          // 필터 토글 버튼
          Positioned(
            right: 13 * widthRatio,
            top: 52 * heightRatio,
            child: GestureDetector(
              onTap: _toggleFilter,
              behavior: HitTestBehavior.opaque, // 터치 영역 확실히 보장
              child: Container(
                width: 33 * widthRatio,
                height: 33 * heightRatio,
                child: Image.asset(
                  AppAssets.toggle,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // 월 표시 텍스트
          Positioned(
            left: 0,
            right: 0,
            top: 165 * heightRatio,
            child: Text(
              _getMonthString(_currentMonth),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 50.48 * widthRatio,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // 이전 월 버튼 (왼쪽 화살표 - 좌우반전)
          Positioned(
            left: 114 * widthRatio,
            top: 189 * heightRatio,
            child: GestureDetector(
              onTap: _currentMonth > 1 ? _previousMonth : null,
              child: Opacity(
                opacity: _currentMonth > 1 ? 1.0 : 0.3, // 1월에서는 반투명
                child: Transform.flip(
                  flipX: true,
                  child: Container(
                    width: 24 * widthRatio,
                    height: 24 * heightRatio,
                    child: Image.asset(
                      AppAssets.back_white,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 다음 월 버튼 (오른쪽 화살표)
          Positioned(
            left: 290 * widthRatio,
            top: 189 * heightRatio,
            child: GestureDetector(
              onTap: _currentMonth < 12 ? _nextMonth : null,
              child: Opacity(
                opacity: _currentMonth < 12 ? 1.0 : 0.3, // 12월에서는 반투명
                child: Container(
                  width: 24 * widthRatio,
                  height: 24 * heightRatio,
                  child: Image.asset(
                    AppAssets.back_white,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          // 섬 아카이브 이미지 (PageView로 스와이프 가능)
          Positioned(
            left: 31 * widthRatio,
            top: 356 * heightRatio,
            child: Container(
              width: 354 * widthRatio,
              height: 317 * heightRatio,
              child: PageView.builder(
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: 2, // 2개 페이지
                itemBuilder: (context, index) {
                  return Image.asset(
                    AppAssets.island_archive,
                    fit: BoxFit.contain,
                  );
                },
              ),
            ),
          ),

          // 페이지 인디케이터
          Positioned(
            left: 0,
            right: 0,
            top: 711 * heightRatio,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(2, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4 * widthRatio),
                  width: 8 * widthRatio,
                  height: 8 * heightRatio,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index 
                        ? Colors.white 
                        : Colors.black.withOpacity(0.3),
                  ),
                );
              }),
            ),
          ),

          // 필터 드롭다운 (조건부 표시)
          if (_isFilterVisible)
            Positioned(
              right: 24 * widthRatio,
              top: 89 * heightRatio,
              child: IslandArchiveFilterDropdown(
                selectedYear: _selectedYear,
                onYearSelected: _onYearSelected,
              ),
            ),

          // 돌아가기 버튼
          Positioned(
            left: 32 * widthRatio,
            right: 32 * widthRatio,
            bottom: 28 * heightRatio,
            child: CustomButton(
              text: '돌아가기',
              onPressed: () => Navigator.pop(context),
              width: 348 * widthRatio,
              height: 52 * heightRatio,
            ),
          ),
        ],
      ),
    );
  }
}

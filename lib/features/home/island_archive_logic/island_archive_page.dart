import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'package:artificialsw_frontend/features/home/widget/island_archive_filter_dropdown.dart';
import 'package:artificialsw_frontend/features/home/single_tree_logic/archive_tree_loading_page.dart';

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

  /// 다음 월로 이동 가능한지 확인
  bool _canGoToNextMonth() {
    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;
    
    // 12월에서는 더 이상 이동 불가
    if (_currentMonth >= 12) {
      return false;
    }
    
    // 현재 년도에서 현재 월보다 미래로는 이동 불가
    if (_selectedYear == currentYear && _currentMonth >= currentMonth) {
      return false;
    }
    
    // 현재 년도보다 미래 년도로는 이동 불가
    if (_selectedYear > currentYear) {
      return false;
    }
    
    return true;
  }

  /// 다음 월로 이동 (12월 또는 현재 시간 기준 미래 월에서는 더 이상 이동 불가)
  void _nextMonth() {
    if (!_canGoToNextMonth()) {
      return;
    }
    
    setState(() {
      _currentMonth++;
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

  /// 현재 선택된 월/년도의 나무가 클릭 가능한지 확인
  bool _isTreeClickable() {
    final now = DateTime.now();
    final currentYear = now.year;
    final currentMonth = now.month;
    final currentDay = now.day;
    
    // 현재 년도보다 미래는 클릭 불가
    if (_selectedYear > currentYear) {
      return false;
    }
    
    // 현재 년도이지만 현재 월보다 미래는 클릭 불가
    if (_selectedYear == currentYear && _currentMonth > currentMonth) {
      return false;
    }
    
    // 현재 년도, 현재 월인 경우
    if (_selectedYear == currentYear && _currentMonth == currentMonth) {
      // 현재 페이지가 첫 번째 섬(1~15일)인 경우
      if (_currentPage == 0) {
        // 첫 번째 섬은 항상 클릭 가능 (과거이므로)
        return true;
      }
      // 현재 페이지가 두 번째 섬(16~말일)인 경우
      else {
        // 현재 날짜가 16일 이후여야 두 번째 섬 클릭 가능
        return currentDay >= 16;
      }
    }
    
    // 과거 년도/월은 모두 클릭 가능
    return true;
  }

  /// 나무 클릭 시 아카이브 로딩 페이지로 이동
  void _onTreeTap(int treeIndex) {
    // 클릭 가능한지 확인
    if (!_isTreeClickable()) {
      return; // 클릭 불가능하면 아무것도 하지 않음
    }
    
    // 현재 날짜 기준으로 period 결정 (1: ~15일, 2: 16~말일)
    final now = DateTime.now();
    final period = now.day <= 15 ? 1 : 2;
    
    // 나무 타입 결정 (1,2: 꽃, 3,4: 열매)
    final treeType = treeIndex <= 2 ? 'flower-$treeIndex' : 'fruit-${treeIndex - 2}';
    
    // 아카이브 로딩 페이지 표시
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ArchiveTreeLoadingPage(
        treeType: treeType,
        year: _selectedYear,
        month: _currentMonth,
        period: period,
        treeIndex: treeIndex,
      ),
    );
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
              onTap: _canGoToNextMonth() ? _nextMonth : null,
              child: Opacity(
                opacity: _canGoToNextMonth() ? 1.0 : 0.3, // 미래 월에서는 반투명
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
                  return Stack(
                    children: [
                      // 섬 아카이브 이미지
                      Image.asset(
                        AppAssets.island_archive,
                        fit: BoxFit.contain,
                      ),
                      // 나무 클릭 영역들 (4개 나무) - 354×317px 기준, (0,0)이 왼쪽 아래
                      // 첫번째 나무: 왼쪽아래(45,149) → 오른쪽위(120,245) → w=75, h=96
                      Positioned(
                        left: 45 * widthRatio,
                        bottom: 149 * heightRatio,
                        child: GestureDetector(
                          onTap: _isTreeClickable() ? () => _onTreeTap(1) : null,
                          child: Container(
                            width: 75 * widthRatio,
                            height: 96 * heightRatio,
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      // 두번째 나무: 왼쪽아래(139,205) → 오른쪽위(203,307) → w=64, h=102
                      Positioned(
                        left: 139 * widthRatio,
                        bottom: 205 * heightRatio,
                        child: GestureDetector(
                          onTap: _isTreeClickable() ? () => _onTreeTap(2) : null,
                          child: Container(
                            width: 64 * widthRatio,
                            height: 102 * heightRatio,
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      // 세번째 나무: 왼쪽아래(205,138) → 오른쪽위(273,245) → w=68, h=107
                      Positioned(
                        left: 205 * widthRatio,
                        bottom: 138 * heightRatio,
                        child: GestureDetector(
                          onTap: _isTreeClickable() ? () => _onTreeTap(3) : null,
                          child: Container(
                            width: 68 * widthRatio,
                            height: 107 * heightRatio,
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      // 네번째 나무: 왼쪽아래(265,118) → 오른쪽위(296,170) → w=31, h=52
                      Positioned(
                        left: 265 * widthRatio,
                        bottom: 118 * heightRatio,
                        child: GestureDetector(
                          onTap: _isTreeClickable() ? () => _onTreeTap(4) : null,
                          child: Container(
                            width: 31 * widthRatio,
                            height: 52 * heightRatio,
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ],
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

import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'package:artificialsw_frontend/features/home/widget/island_archive_filter_dropdown.dart';
import 'package:artificialsw_frontend/features/home/single_tree_logic/archive_tree_loading_page.dart';
import 'package:artificialsw_frontend/services/home/home_service.dart';
import 'package:artificialsw_frontend/services/home/dto/archive/archive_flower_response_dto.dart';
import 'package:artificialsw_frontend/services/home/dto/archive/archive_fruit_response_dto.dart';
import 'dart:math';
import 'package:artificialsw_frontend/shared/flower.dart';
import 'package:artificialsw_frontend/shared/fruit.dart';

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
  List<ArchiveFlowerResponseDto>? flowers1; // 아카이브 메인화면에 미리보기처럼 뜰 부착물
  List<ArchiveFlowerResponseDto>? flowers2; // 아카이브 메인화면에 미리보기처럼 뜰 부착물
  List<ArchiveFruitResponseDto>? fruits3; // 아카이브 메인화면에 미리보기처럼 뜰 부착물
  List<ArchiveFruitResponseDto>? fruits4; // 아카이브 메인화면에 미리보기처럼 뜰 부착물
  final homeService = HomeService();
  bool _showAttachments = false;

  // 기준 나무 크기 (디자인 스펙)
  static const double _baseTreeWidth = 306.97;
  static const double _baseTreeHeight = 539.58;

  // 두 번째 나무 기준 크기 (디자인 스펙)
  static const double _baseTree2Width = 259.94;
  static const double _baseTree2Height = 523.06;

  // 세 번째(과일) 나무 기준 크기 (디자인 스펙)
  static const double _baseTree3Width = 293.63;
  static const double _baseTree3Height = 486.20;

  // 네 번째(과일) 나무 기준 크기 (디자인 스펙)
  static const double _baseTree4Width = 200.20;
  static const double _baseTree4Height = 464.44;

  // 기준 좌표계에서의 꽃 위치 (왼쪽/위쪽 패딩)
  // 1~6번째 카드가 열릴 위치 (첫 번째 나무 내부 기준)
  final List<Offset> _baseFlowerPositions = const [
    Offset(132, 53),   // 1번째 꽃
    Offset(86, 130),   // 2번째 꽃
    Offset(164, 174),  // 3번째 꽃
    Offset(91, 235),   // 4번째 꽃
    Offset(37, 305),   // 5번째 꽃
    Offset(196, 290),  // 6번째 꽃
  ];

  // 두 번째 나무 기준 좌표계에서의 꽃 위치 (왼쪽/위쪽 패딩)
  // 1~4번째 카드가 열릴 위치 (두 번째 나무 내부 기준)
  final List<Offset> _baseFlower2Positions = const [
    Offset(105, 62),   // 1번째 꽃
    Offset(57, 134),   // 2번째 꽃
    Offset(152, 181),  // 3번째 꽃
    Offset(57, 237),   // 4번째 꽃
  ];

  // 세 번째 나무(과일) 기준 좌표계에서의 과일 위치 (왼쪽/위쪽 패딩)
  // 1~4번째 카드가 열릴 위치 (세 번째 나무 내부 기준)
  final List<Offset> _baseFruit1Positions = const [
    Offset(105, 59),  // 1번째 과일
    Offset(162, 130), // 2번째 과일
    Offset(74, 169),  // 3번째 과일
    Offset(168, 232), // 4번째 과일
  ];

  // 네 번째 나무(과일) 기준 좌표계에서의 과일 위치 (왼쪽/위쪽 패딩)
  // 1~3번째 카드가 열릴 위치 (네 번째 나무 내부 기준)
  final List<Offset> _baseFruit2Positions = const [
    Offset(71, 52),   // 1번째 과일
    Offset(32, 133),  // 2번째 과일
    Offset(105, 167), // 3번째 과일
  ];

  /// 나무 타입에 따라 다른 크기와 위치 정보를 반환하는 함수
  ///
  /// 각 나무마다 다른 크기와 화면에서의 위치를 가지고 있음
  /// 반응형 레이아웃을 위해 화면 비율에 따라 크기가 조정됨
  Map<String, double> _getTreeLayout(String treeType) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 기준 화면 크기 (412x917)에 대한 비율 계산
    final widthRatio = screenWidth / 412.0;
    final heightRatio = screenHeight / 917.0;

    switch (treeType) {
      case 'flower-1':
        return {
          'width': 128.0 * widthRatio,
          'height': 243.0 * heightRatio,
          'topPadding': 197.0 * heightRatio,
        };
      case 'flower-2':
      // fruit_tree_1 이미지 사용하므로 fruit-1의 크기/위치 적용
        return {
          'width': 99.0 * widthRatio,
          'height': 221.0 * heightRatio,
          'topPadding': 193.0 * heightRatio,
        };
      case 'fruit-1':
      // flower_tree_2 이미지 사용하므로 flower-2의 크기/위치 적용
        return {
          'width': 99.0 * widthRatio,
          'height': 221.0 * heightRatio,
          'topPadding': 232.0 * heightRatio,
        };
      case 'fruit-2':
        return {
          'width': 169.0 * widthRatio,
          'height': 392.0 * heightRatio,
          'topPadding': 242.0 * heightRatio,
        };
      default:
        return {
          'width': 258.0 * widthRatio,
          'height': 453.0 * heightRatio,
          'topPadding': 197.0 * heightRatio,
        };
    }
  }

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
        _fetchAttachmentsForMonth(_currentMonth, _selectedYear, _currentPage);
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
      _fetchAttachmentsForMonth(_currentMonth, _selectedYear, _currentPage);
    });
  }

  Future<void> _fetchAttachmentsForMonth(int month, int year, int page) async {
    // 🌙 1️⃣ 기존 부착물 fade-out
    if (mounted) {
      setState(() {
        _showAttachments = false;
      });
    }

    // ⏳ fade-out이 끝날 때까지 기다리기 (AnimatedOpacity duration과 동일)
    await Future.delayed(const Duration(seconds: 3));

    // 🧠 이제 완전히 투명 상태 → 새 데이터 로드
    final flowers1Data = await homeService.getArchiveFlowerData(
      year: year, month: month, period: page + 1, treeIndex: 1,
    );
    final flowers2Data = await homeService.getArchiveFlowerData(
      year: year, month: month, period: page + 1, treeIndex: 2,
    );
    final fruits3Data = await homeService.getArchiveFruitData(
      year: year, month: month, period: page + 1, treeIndex: 3,
    );
    final fruits4Data = await homeService.getArchiveFruitData(
      year: year, month: month, period: page + 1, treeIndex: 4,
    );

    // 🔹 받은 데이터 UI 반영
    if (mounted) {
      setState(() {
        flowers1 = flowers1Data;
        flowers2 = flowers2Data;
        fruits3 = fruits3Data;
        fruits4 = fruits4Data;
      });
    }

    // 🌸 2️⃣ 새 데이터 fade-in
    if (mounted) {
      setState(() {
        _showAttachments = true;
      });
    }
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
      _fetchAttachmentsForMonth(_currentMonth, _selectedYear, _currentPage);
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

  // 나무 위 꽃 하나를 그리는 위젯 (적응형 좌표/크기) - 첫 번째 나무용
  Widget _buildOverlayFlower(int index, double treeWidth, double treeHeight) {

    // 스케일 계산 (기준 나무 크기 대비)
    final scaleX = treeWidth / _baseTreeWidth;
    final scaleY = treeHeight / _baseTreeHeight;
    // 아이콘 크기: 55x55을 기준으로 너비 스케일에 맞춰 균등 스케일링
    double size = 55.0 * scaleX;
    // 아카시아만 크기를 1.2배로 키움 (이름으로 확인)
    final isAcacia = flowers1?[index].flowerName == 'acacia';
    size = isAcacia ? size * 1.2 : size; // 아카시아만 크기 증가

    final basePos = _baseFlowerPositions[index];
    final left = basePos.dx * scaleX + 47;
    final top = basePos.dy * scaleY + 298;

    return Positioned(
      left: left,
      top: top,
      child: Image.asset(
        flowerMap[flowers1?[index].flowerName]?.imagePath ?? "assets/images/flower/acacia.png", // 실제 카드의 이미지 사용
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }

  // 나무 위 꽃 하나를 그리는 위젯 (적응형 좌표/크기) - 두 번째 나무용
  Widget _buildOverlayFlower2(int index, double treeWidth, double treeHeight) {

    // 스케일 계산 (두 번째 나무 기준 크기 대비)
    final scaleX = treeWidth / _baseTree2Width;
    final scaleY = treeHeight / _baseTree2Height;
    double size = 55.0 * scaleX;
    // 아이콘 크기: 60x60을 기준으로 너비 스케일에 맞춰 균등 스케일링
    // 아카시아만 크기를 1.2배로 키움 (이름으로 확인)
    final isAcacia = flowers1?[index].flowerName == 'acacia';
    size = isAcacia ? size * 1.2 : size; // 아카시아만 크기 증가

    final basePos = _baseFlower2Positions[index];
    final left = basePos.dx * scaleX + 126;
    final top = basePos.dy * scaleY + 287;

    return Positioned(
      left: left,
      top: top,
      child: Image.asset(
        flowerMap[flowers2?[index].flowerName]?.imagePath ?? "assets/images/flower/acacia.png", // 실제 카드의 이미지 사용
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }

  // 나무 위 과일 하나를 그리는 위젯 (적응형 좌표/크기) - 세 번째 나무용
  Widget _buildOverlayFruit1(int index, double treeWidth, double treeHeight) {
    // 스케일 계산 (세 번째 나무 기준 크기 대비)
    final scaleX = treeWidth / _baseTree3Width;
    final scaleY = treeHeight / _baseTree3Height;
    // 아이콘 크기: 60x65 (가로/세로 각각 스케일)
    final width = 60.0 * scaleX;
    final height = 65.0 * scaleY;

    final basePos = _baseFruit1Positions[index];
    final left = basePos.dx * scaleX + 186;
    final top = basePos.dy * scaleY + 323;

    return Positioned(
      left: left,
      top: top,
      child: Image.asset(
        fruitMap[fruits3?[index].fruitName]?.imagePath ?? "assets/images/fruit/spring/cherry.png", // 실제 카드의 이미지 사용
        width: width,
        height: height,
        fit: BoxFit.contain,
      ),
    );
  }

  // 나무 위 과일 하나를 그리는 위젯 (적응형 좌표/크기) - 네 번째 나무용
  Widget _buildOverlayFruit2(int index, double treeWidth, double treeHeight) {

    // 스케일 계산 (네 번째 나무 기준 크기 대비)
    final scaleX = treeWidth / _baseTree4Width;
    final scaleY = treeHeight / _baseTree4Height;
    // 아이콘 크기: 60x65 (가로/세로 각각 스케일)
    final width = 60.0 * scaleX;
    final height = 65.0 * scaleY;

    final basePos = _baseFruit2Positions[index];
    final left = basePos.dx * scaleX;
    final top = basePos.dy * scaleY;

    return Positioned(
      left: left,
      top: top,
      child: Image.asset(
        fruitMap[fruits4?[index].fruitName]?.imagePath ?? "assets/images/fruit/spring/cherry.png", // 실제 카드의 이미지 사용
        width: width,
        height: height,
        fit: BoxFit.contain,
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
                onPageChanged: (index) async {
                  setState(() {
                    _currentPage = index;
                    _showAttachments = false; // 🌙 스와이프 중엔 숨김
                  });
                  // 데이터 로드
                  await _fetchAttachmentsForMonth(_currentMonth, _selectedYear, _currentPage);
                  if (mounted) {
                    setState(() {
                      _showAttachments = true; // 🌞 다시 표시
                    });
                  }
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
          AnimatedOpacity(
            opacity: _showAttachments ? 1.0 : 0.0,
            duration: const Duration(seconds: 3), // 🌸 3초 동안 서서히 나타남
            curve: Curves.easeInOut, // 💫 더 자연스럽게 (시작/끝 부드럽게)
            child: Stack(
              children: [
                // 🌸 첫 번째 나무 (flowers1)
                for (int i = 0; i < min(flowers1?.length ?? 0, 6); i++)
                  _buildOverlayFlower(
                    i,
                    _getTreeLayout('flower-1')['width']!,
                    _getTreeLayout('flower-1')['height']!,
                  ),

                // 🌺 두 번째 나무 (flowers2)
                for (int i = 0; i < min(flowers2?.length ?? 0, 4); i++)
                  _buildOverlayFlower2(
                    i,
                    _getTreeLayout('flower-2')['width']!,
                    _getTreeLayout('flower-2')['height']!,
                  ),

                // 🍎 세 번째 나무 (fruits3)
                for (int i = 0; i < min(fruits3?.length ?? 0, 4); i++)
                  _buildOverlayFruit1(
                    i,
                    _getTreeLayout('fruit-1')['width']!,
                    _getTreeLayout('fruit-1')['height']!,
                  ),

                // 🍇 네 번째 나무 (fruits4)
                for (int i = 0; i < min(fruits4?.length ?? 0, 3); i++)
                  _buildOverlayFruit2(
                    i,
                    _getTreeLayout('fruit-2')['width']!,
                    _getTreeLayout('fruit-2')['height']!,
                  ),
              ],
            ),
          ),
          // if (_showAttachments)
          //   for (int i = 0; i < min(flowers1?.length ?? 0, 6); i++)
          //     _buildOverlayFlower(i, _getTreeLayout('flower-1')['width']!, _getTreeLayout('flower-1')['height']!),
          // for (int i = 0; i < _currentFlowerCards.length && i < 6; i++)
          //   _buildOverlayFlower(i, layout('flower-1')['width']!, layout('flower-1')['height']!),
          // for (int i = 0; i < _currentFlowerCards.length && i < 6; i++)
          //   _buildOverlayFlower(i, layout('flower-1')['width']!, layout('flower-1')['height']!),
          // for (int i = 0; i < _currentFlowerCards.length && i < 6; i++)
          //   _buildOverlayFlower(i, layout('flower-1')['width']!, layout('flower-1')['height']!),

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

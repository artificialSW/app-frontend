import 'dart:ui' as ui;

import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_top_bar.dart';
import 'package:artificialsw_frontend/shared/widgets/common_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:artificialsw_frontend/features/home/widget/progress_bar_with_icon.dart';
import 'package:artificialsw_frontend/features/home/widget/tree_navigation_buttons.dart';
import 'package:artificialsw_frontend/features/home/widget/tree_image_page.dart';
import 'package:artificialsw_frontend/features/home/widget/bottom_progress_bar.dart';
import 'package:artificialsw_frontend/features/home/widget/tree_decorate_sheet.dart';
import 'package:artificialsw_frontend/features/home/widget/message_bubble.dart';
import 'package:artificialsw_frontend/features/home/constants/seasonal_colors.dart';
import 'package:artificialsw_frontend/features/home/models/fruit_card_data.dart';
import 'package:artificialsw_frontend/features/home/models/flower_card_data.dart';

/// 홈 화면의 메인 위젯
/// - 나무 이름 설정 및 트리 이미지 표시
/// - 진행률 바 (메시지, 퍼즐) 표시
/// - 메시지 버블 입력 기능
/// - 트리 페이지 네비게이션 (3개 페이지)
/// - 트리 장식 시트 (과일/꽃 카드) 표시
class HomeRoot extends StatefulWidget {
  const HomeRoot({super.key});
  @override
  State<HomeRoot> createState() => _HomeRootState();
}

class _HomeRootState extends State<HomeRoot> {
  // UI 관련 키 및 컨트롤러
  final GlobalKey _captureKey = GlobalKey(); // 트리 이미지 캡처용
  final TextEditingController _nameController = TextEditingController(); // 나무 이름 입력
  final TextEditingController _bubbleMsgController = TextEditingController(); // 메시지 버블 입력
  final FocusNode _focusNode = FocusNode(); // 포커스 관리
  final PageController _pageController = PageController(); // 트리 페이지 네비게이션

  // 상태 변수
  bool _isTreeNamed = false; // 나무 이름이 설정되었는지 여부
  String _treeName = ''; // 설정된 나무 이름
  String _namingDate = ''; // 나무 이름 설정 날짜
  int _currentTreePage = 0; // 현재 트리 페이지 (0: 첫번째, 1: 두번째, 2: 세번째)
  
  // 선택된 과일/꽃 상태 (order 필드 기반으로 관리)
  List<FruitCardData> _selectedFruits = []; // 선택된 과일 카드들
  List<FlowerCardData> _selectedFlowers = []; // 선택된 꽃 카드들

  /// 트리 이미지를 캡처하여 다이얼로그로 표시하는 함수
  Future<void> _captureImage() async {
    try {
      final boundary =
      _captureKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final ui.Image image =
      await boundary.toImage(pixelRatio: MediaQuery.of(context).devicePixelRatio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();
      showDialog(
        context: context,
        builder: (_) => Dialog(
          insetPadding: const EdgeInsets.all(16),
          child: InteractiveViewer(child: Image.memory(pngBytes, fit: BoxFit.contain)),
        ),
      );
    } catch (e) {
      debugPrint("캡쳐 실패: $e");
    }
  }

  /// 나무 이름 입력 완료 시 호출되는 함수
  /// - 입력된 이름이 있으면 확인 다이얼로그 표시
  /// - 확인 후 나무 이름과 날짜를 상태에 저장
  void _onNameSubmitted() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => CommonDialog(
        title: "나무의 이름이 정해졌어요",
        subtitle: "멋진 이름인데요!",
        buttonText: "확인",
        onButtonPressed: () {
          Navigator.of(dialogContext).pop();
          setState(() {
            _isTreeNamed = true;
            _treeName = name;
            _namingDate = DateTime.now().toString().substring(0, 10).replaceAll('-', '.');
          });
        },
      ),
    );
  }

  /// 3. 선택된 과일 데이터를 반환 (order > 0인 카드들만)
  /// TreeImagePage에서 나무에 표시할 과일들을 필터링
  List<FruitCardData> _getSelectedFruits() {
    return _selectedFruits.where((fruit) => fruit.order > 0).toList();
  }

  /// 3. 선택된 꽃 데이터를 반환 (order > 0인 카드들만)
  /// TreeImagePage에서 나무에 표시할 꽃들을 필터링
  List<FlowerCardData> _getSelectedFlowers() {
    return _selectedFlowers.where((flower) => flower.order > 0).toList();
  }

  /// 2. TreeDecorateSheet에서 선택 상태가 변경되었을 때 호출되는 콜백
  /// 전체 카드 리스트를 받아서 저장하고 화면 갱신
  void _onSelectionChanged(List<FruitCardData> fruitCards, List<FlowerCardData> flowerCards) {
    setState(() {
      _selectedFruits = fruitCards;    // 전체 과일 카드 리스트 저장
      _selectedFlowers = flowerCards;  // 전체 꽃 카드 리스트 저장
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bubbleMsgController.dispose();
    _focusNode.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 진행률 값들 (임시 하드코딩, 추후 실제 데이터로 교체 예정)
    const double chatPercent = 0.3; // 메시지 진행률
    const double puzzlePercent = 0.2; // 퍼즐 진행률
    const double treePercent = 0.9; // 트리 성장 진행률

    return Scaffold(
      appBar: HomeTopBar(),
      body: Stack(
        children: [
          // 배경 그라데이션 (234픽셀 높이로 제한, 맨 밑에 위치)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 234,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,        // ← 수직 시작
                  end: Alignment.topCenter,       // ← 수직 끝
                  colors: SeasonalColors.getBackgroundColors(),
                  stops: const [0.0, 0.55, 1.0],     // 전환 지점 고정(중간색 비율 보장)
                  tileMode: TileMode.clamp,
                ),
              ),
            ),
          ),
          
          // 메인 콘텐츠 영역
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 상단 진행률 바들
                  ProgressBarWithIcon(
                    icon: Image.asset('assets/icons/home_message.png', width: 24, height: 24),
                    score: '0점',
                    progress: chatPercent,
                    showHeart: true,
                  ),
                  const SizedBox(height: 15),
                  ProgressBarWithIcon(
                    icon: Image.asset('assets/icons/home_puzzle.png', width: 24, height: 24),
                    score: '0점',
                    progress: puzzlePercent,
                    showHeart: false,
                  ),
                  const SizedBox(height: 48),

                  // 나무 이름이 설정되지 않은 경우: 새싹 화면
                  if (!_isTreeNamed) ...[
                    Text(
                      "한달동안 키울 나무의 이름을 정해주세요!",
                      style: AppTextStyles.pretendard_medium.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _nameController,
                      focusNode: _focusNode,
                      decoration: const InputDecoration(hintText: "???"),
                      onSubmitted: (_) => _onNameSubmitted(),
                    ),
                    const SizedBox(height: 30),
                    Image.asset(AppAssets.sprout),
                  // 나무 이름이 설정된 경우: 메인 트리 화면
                  ] else ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: MessageBubble(controller: _bubbleMsgController),
                    ),

                    const SizedBox(height: 5),

                    // 트리 이미지 영역 (3개 페이지 네비게이션)
                    SizedBox(
                      width: 350,
                      height: 350,
                      child: RepaintBoundary(
                        key: _captureKey, // 이미지 캡처용 키
                        child: Stack(
                          children: [
                            // 트리 이미지 페이지뷰 (좌우 스와이프 가능)
                            PageView.builder(
                              controller: _pageController,
                              onPageChanged: (index) =>
                                  setState(() => _currentTreePage = index),
                              itemCount: 3, // 3개 페이지
                               itemBuilder: (context, index) {
                                 return TreeImagePage(
                                   treeName: _treeName,
                                   namingDate: _namingDate,
                                   pageIndex: index,
                                   selectedFruits: _getSelectedFruits(),
                                   selectedFlowers: _getSelectedFlowers(),
                                 );
                               },
                            ),
                            // 좌우 네비게이션 버튼
                            TreeNavigationButtons(
                              pageController: _pageController,
                              currentPage: _currentTreePage,
                              totalPages: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 10),
                  BottomProgressBar(
                    progress: treePercent,
                    calendarCircleColor: SeasonalColors.getCalendarColor(),
                    barColors: SeasonalColors.getBarColors(),
                  ),
                ],
              ),
            ),
          ),

           // 트리 장식 시트: 2번째/3번째 페이지에서만 표시 (과일/꽃 카드)
           if (_isTreeNamed && (_currentTreePage == 1 || _currentTreePage == 2))
             TreeDecorateSheet(
               pageIndex: _currentTreePage,
               onSelectionChanged: _onSelectionChanged,
             ),
        ],
      ),
    );
  }
}

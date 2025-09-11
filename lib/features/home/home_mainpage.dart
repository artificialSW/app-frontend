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
    if (name.isNotEmpty) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return CommonDialog(
            title: "나무의 이름이 정해졌어요",
            subtitle: "멋진 이름인데요!",
            buttonText: "확인",
            onButtonPressed: () {
              Navigator.of(dialogContext).pop();
              setState(() {
                _isTreeNamed = true;
                _treeName = name;
                _namingDate =
                    DateTime.now().toString().substring(0, 10).replaceAll('-', '.');
              });
            },
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bubbleMsgController.dispose(); // [추가]
    _focusNode.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 진행률 값들 (임시 하드코딩, 추후 실제 데이터로 교체 예정)
    const double chatPercent = 0.3; // 메시지 진행률
    const double puzzlePercent = 0.2; // 퍼즐 진행률
    const double treePercent = 0.3; // 트리 성장 진행률

    return Scaffold(
      appBar: HomeTopBar(),
      body: Stack(
        children: [
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
                                   namingDate: _namingDate,
                                   treeName: _treeName,
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

                  const SizedBox(height: 20),
                  BottomProgressBar(progress: treePercent),
                ],
              ),
            ),
          ),

           // 트리 장식 시트: 2번째/3번째 페이지에서만 표시 (과일/꽃 카드)
           if (_isTreeNamed && (_currentTreePage == 1 || _currentTreePage == 2))
             TreeDecorateSheet(pageIndex: _currentTreePage),
        ],
      ),
    );
  }
}

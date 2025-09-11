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

class HomeRoot extends StatefulWidget {
  const HomeRoot({super.key});
  @override
  State<HomeRoot> createState() => _HomeRootState();
}

class _HomeRootState extends State<HomeRoot> {
  final GlobalKey _captureKey = GlobalKey();
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final PageController _pageController = PageController();

  bool _isTreeNamed = false;
  String _treeName = '';
  String _namingDate = '';
  int _currentTreePage = 0; // 0,1,2

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
    _focusNode.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double chatPercent = 0.3;
    const double puzzlePercent = 0.2;
    const double treePercent = 0.3;

    return Scaffold(
      appBar: HomeTopBar(),
      //  시트를 화면 전체에 겹치기 위해 Stack 사용
      body: Stack(
        children: [
          // 본문
          Positioned.fill(
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                  const SizedBox(height: 15),

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
                  ] else ...[
                    Stack(
                      children: [
                        const DecoratedBox(
                          decoration: BoxDecoration(color: AppColors.plumu_green_main),
                        ),
                        Text(
                          '간단한 메세지를 남겨봐요!',
                          style: AppTextStyles.pretendard_medium.copyWith(
                            fontSize: 16,
                            color: AppColors.plumu_white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // 트리 영역 (시트는 여기 안에 두지 않음)
                    SizedBox(
                      width: 350,
                      height: 350,
                      child: RepaintBoundary(
                        key: _captureKey,
                        child: Stack(
                          children: [
                            PageView.builder(
                              controller: _pageController,
                              onPageChanged: (index) =>
                                  setState(() => _currentTreePage = index),
                              itemCount: 3,
                               itemBuilder: (context, index) {
                                 return TreeImagePage(
                                   namingDate: _namingDate,
                                   treeName: _treeName,
                                 );
                               },
                            ),
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

           // TreeDecorateSheet: 2번째/3번째 페이지에서만 표시
           if (_isTreeNamed && (_currentTreePage == 1 || _currentTreePage == 2))
             const TreeDecorateSheet(),
        ],
      ),
    );
  }
}

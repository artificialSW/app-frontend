import 'dart:ui' as ui;

import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_top_bar.dart';
import 'package:artificialsw_frontend/shared/widgets/common_dialog.dart'; // CommonDialog 컴포넌트 import 추가
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:artificialsw_frontend/features/home/widget/progress_bar_with_icon.dart';
import 'package:artificialsw_frontend/features/home/widget/tree_navigation_buttons.dart';
import 'package:artificialsw_frontend/features/home/widget/tree_image_page.dart';
import 'package:artificialsw_frontend/features/home/widget/bottom_progress_bar.dart';

class HomeRoot extends StatefulWidget {
  const HomeRoot({super.key});

  @override
  State<HomeRoot> createState() => _HomeRootState();
}

class _HomeRootState extends State<HomeRoot> {
  final GlobalKey _captureKey = GlobalKey();
  final TextEditingController _nameController = TextEditingController(); // 나무 이름 입력을 위한 텍스트 컨트롤러
  final FocusNode _focusNode = FocusNode(); // 입력 필드 포커스 관리
  final PageController _pageController = PageController(); // 트리 이미지 페이지 컨트롤러

  bool _isTreeNamed = false; // 나무 이름이 정해졌는지 여부 - 화면 상태를 결정하는 핵심 변수
  String _treeName = ''; // 입력된 나무 이름
  String _namingDate = ''; // 나무 이름을 지어준 날짜
  int _currentTreePage = 0; // 현재 트리 페이지 (0, 1, 2)

 // 캡쳐 대상 key
  Future<void> _captureImage() async {
    try {
      final boundary = _captureKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(
        pixelRatio: MediaQuery.of(context).devicePixelRatio,
      );
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      // ⬇️ 미리보기 다이얼로그
      showDialog(
        context: context,
        builder: (_) => Dialog(
          insetPadding: const EdgeInsets.all(16),
          child: InteractiveViewer( // 확대/이동 가능하게
            child: Image.memory(pngBytes, fit: BoxFit.contain),
          ),
        ),
      );
    } catch (e) {
      debugPrint("캡쳐 실패: $e");
    }
  }

  /// 이름 입력 완료 시 호출되는 함수
  /// 사용자가 엔터를 누르거나 입력을 완료했을 때 실행
  void _onNameSubmitted() {
    final name = _nameController.text.trim(); // 입력된 이름에서 공백 제거
    if (name.isNotEmpty) { // 이름이 비어있지 않으면
      // CommonDialog 직접 표시 (정적 메서드 대신 직접 showDialog 사용)
      showDialog(
        context: context,
        barrierDismissible: false, // 배경 터치로 닫기 비활성화
        builder: (BuildContext dialogContext) { // 다이얼로그 전용 context 생성
          return CommonDialog(
            title: "나무의 이름이 정해졌어요",
            subtitle: "멋진 이름인데요!",
            buttonText: "확인",
            onButtonPressed: () {
              Navigator.of(dialogContext).pop(); // 다이얼로그 닫기 (dialogContext 사용)
              setState(() {
                _isTreeNamed = true; // 나무 이름이 정해진 상태로 변경 → 화면 전환
                _treeName = name; // 입력된 이름 저장
                _namingDate = DateTime.now().toString().substring(0, 10).replaceAll('-', '.'); // 오늘 날짜 저장 (YYYY.MM.DD)
              });
            },
          );
        },
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose(); // 텍스트 컨트롤러 메모리 해제
    _focusNode.dispose(); // 포커스 노드 메모리 해제
    _pageController.dispose(); // 페이지 컨트롤러 메모리 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double chat_percent = 0.3;
    final double puzzle_percent = 0.2;
    final double tree_percent = 0.3;
    //TODO(서버에 현재 열매랑 꽃 종류와 개수 아마 맵 형태로..? 요청하기
    return Scaffold(
      appBar: HomeTopBar(),
      body: SingleChildScrollView( // 키보드 올라올 때 스크롤 가능하게
        child: Column(
          children: [
          // 메시지 진행바 (하트 포함)
          ProgressBarWithIcon(
            icon: Image.asset(
              'assets/icons/home_message.png', // home_message 아이콘
              width: 24,
              height: 24,
            ),
            score: '0점',
            progress: chat_percent,
            showHeart: true, // 하트 표시
          ),
          SizedBox(height: 15),
          // 퍼즐 진행바 (하트 없음)
          ProgressBarWithIcon(
            icon: Image.asset(
              'assets/icons/home_puzzle.png', // home_puzzle 아이콘
              width: 24,
              height: 24,
            ),
            score: '0점',
            progress: puzzle_percent,
            showHeart: false, // 하트 표시 안함
          ),
          SizedBox(height: 15),

          // 상태에 따라 중간 부분 변경
          if (!_isTreeNamed) ...[
            // 나무 이름 입력 상태
            Text(
              "한달동안 키울 나무의 이름을 정해주세요!",
              style: AppTextStyles.pretendard_medium.copyWith(fontSize: 16),
            ),
            SizedBox(height: 30),
            TextField(
              controller: _nameController,
              focusNode: _focusNode,
              decoration: InputDecoration(hintText: "???"),
              onSubmitted: (_) => _onNameSubmitted(),
            ),
            SizedBox(height: 30),
            Image.asset(AppAssets.sprout),
          ] else ...[
            // 메인 홈 상태 (기존 코드) - 나무 이름 입력 완료 후 표시되는 화면
            //말풍선
            Stack(
              children: [
                DecoratedBox(
                    decoration: BoxDecoration(color: AppColors.plumu_green_main),
                    child: Text(
                      '간단한 메세지를 남겨봐요!',
                      style: AppTextStyles.pretendard_medium.copyWith(
                        fontSize: 16,
                        color: AppColors.plumu_white,
                      ),
                    )
                ),
              ]
            ),
            SizedBox(height: 30),
            // 나무 이미지와 나무 표지판
            SizedBox(
              width: 350, height: 350,
              child: RepaintBoundary( //RepaintBoundary는 캡쳐할 위젯을 감싸는 위젯
                key: _captureKey,
                child: Stack(
                  children: [
                    // PageView로 트리 이미지들 관리
                    PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) => setState(() => _currentTreePage = index),
                      itemCount: 3,
                      itemBuilder: (context, index) => TreeImagePage(
                        namingDate: _namingDate,
                        treeName: _treeName,
                      ),
                    ),
                    // 나무 네비게이션 버튼
                    TreeNavigationButtons(
                      pageController: _pageController,
                      currentPage: _currentTreePage,
                      totalPages: 3,
                    )
                  ],
                ),
              )
            ),
          ],
          const SizedBox(height: 20),
          BottomProgressBar(progress: tree_percent)
        ],
        ),
      ),
    );
  }
}
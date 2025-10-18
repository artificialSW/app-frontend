import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'package:artificialsw_frontend/features/home/single_tree_logic/tree_page.dart';

/// 아카이브 나무 로딩 페이지 위젯
/// 
/// 섬 아카이브나 메인에서 나무를 클릭했을 때 나타나는 로딩 화면임
/// 3초 동안 애니메이션을 보여주고 자동으로 해당 나무 페이지로 이동함
/// 
/// 주요 기능:
/// - 나무 타입에 따라 다른 이미지와 텍스트 표시
/// - 진행률 바 애니메이션 (3초 동안 0%에서 100%까지)
/// - 로딩 중 텍스트와 도착 텍스트 자동 전환
/// - 애니메이션 완료 후 해당 나무 페이지로 자동 이동 (아카이브 모드)
class ArchiveTreeLoadingPage extends StatefulWidget {
  final String treeType; // 'flower-1', 'flower-2', 'fruit-1', 'fruit-2'
  final int year;
  final int month;
  final int period; // 1(~15일), 2(16~말일)
  final int treeIndex; // 1,2,3,4
  
  const ArchiveTreeLoadingPage({
    super.key,
    required this.treeType,
    required this.year,
    required this.month,
    required this.period,
    required this.treeIndex,
  });

  @override
  State<ArchiveTreeLoadingPage> createState() => _ArchiveTreeLoadingPageState();
}

class _ArchiveTreeLoadingPageState extends State<ArchiveTreeLoadingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // 3초 동안 진행되는 애니메이션 컨트롤러 설정
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    // 0.0에서 1.0까지 진행되는 프로그레스 애니메이션 설정
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut, // 부드러운 시작과 끝
    ));
    
    // 애니메이션 시작
    _animationController.forward();
    
    // 애니메이션 완료 시 해당 나무 페이지로 자동 이동
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _navigateToTreePage();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// 로딩 완료 후 해당 나무 페이지로 이동하는 함수
  void _navigateToTreePage() {
    // 현재 로딩 다이얼로그 닫기
    Navigator.of(context).pop();
    
    // 해당 나무 타입에 맞는 나무 페이지로 이동 (아카이브 모드)
    final route = MaterialPageRoute(
      builder: (context) => TreePage(
        treeType: widget.treeType,
        isArchiveMode: true,
        archiveYear: widget.year,
        archiveMonth: widget.month,
        archivePeriod: widget.period,
        archiveTreeIndex: widget.treeIndex,
      ),
    );
    Navigator.push(context, route);
  }

  /// 나무 타입이 꽃나무인지 확인
  bool _isFlowerTree() {
    return widget.treeType == 'flower-1' || widget.treeType == 'flower-2';
  }

  /// 나무 타입에 따른 이미지 경로 반환
  String _getProgressImagePath() {
    return _isFlowerTree() 
        ? AppAssets.progress_flower_tree 
        : AppAssets.progress_fruit_tree;
  }

  /// 나무 타입에 따른 로딩 중 텍스트 반환
  String _getLoadingText() {
    return _isFlowerTree() 
        ? '꽃나무를 보러\n이동 중이에요!' 
        : '열매 나무를 보러\n이동 중이에요!';
  }

  /// 나무 타입에 따른 도착 텍스트 반환
  String _getArrivedText() {
    return _isFlowerTree() 
        ? '꽃나무에\n도착했어요!' 
        : '열매 나무에\n도착했어요!';
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 기준 화면 크기 (412x917)에 대한 비율 계산
    final widthRatio = screenWidth / 412.0;
    final heightRatio = screenHeight / 917.0;

    return Dialog(
      backgroundColor: Colors.transparent, // 투명한 배경
      insetPadding: EdgeInsets.zero, // 여백 제거
      child: Container(
        width: screenWidth, // 전체 화면 너비
        height: screenHeight, // 전체 화면 높이
        color: const Color(0xC41B1B1B), // 반투명한 어두운 배경 (뒤가 비치도록)
        child: Stack(
          children: [
            // 상단 텍스트 (로딩 중/도착 시)
            Positioned(
              left: 37 * widthRatio,
              top: 145 * heightRatio,
              child: AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  // 프로그레스가 90% 이상이면 도착 텍스트 표시
                  final showArrivedText = _progressAnimation.value >= 0.9;
                  
                  return Text(
                    showArrivedText ? _getArrivedText() : _getLoadingText(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32 * widthRatio,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                      height: 1.31,
                      letterSpacing: -0.32 * widthRatio,
                    ),
                  );
                },
              ),
            ),
            
            // 중앙 이미지 (꽃나무/과일나무 진행 이미지)
            Positioned(
              left: (screenWidth - 310 * widthRatio) / 2, // 좌우 중앙 정렬
              top: 430 * heightRatio,
              child: Container(
                width: 310 * widthRatio,
                height: 289 * heightRatio,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(_getProgressImagePath()),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            
            // 프로그레스 바 (위쪽 패딩 744)
            Positioned(
              left: (screenWidth - 348 * widthRatio) / 2, // 좌우 중앙 정렬
              top: 744 * heightRatio, // 위쪽에서 744px 떨어진 위치
              child: AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return Container(
                    width: 348 * widthRatio,
                    height: 8 * heightRatio,
                    decoration: ShapeDecoration(
                      color: Colors.white.withOpacity(0.40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(19.95 * widthRatio),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Color(0x193A0D10),
                          blurRadius: 19.95 * widthRatio,
                          offset: Offset(0, 3.99 * heightRatio),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: Stack(
                      children: [
                        // 프로그레스 바 (흰색 진행 표시)
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: (348 * widthRatio) * _progressAnimation.value,
                            height: 8 * heightRatio,
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(19.95 * widthRatio),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

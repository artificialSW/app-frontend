import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_top_bar.dart';
import 'package:artificialsw_frontend/features/home/widget/progress_bar_with_icon.dart';
import 'package:artificialsw_frontend/features/home/widget/home_bottom_buttons.dart';
import 'package:artificialsw_frontend/features/home/single_tree_logic/tree_loading_page.dart';
import 'package:artificialsw_frontend/features/home/single_tree_logic/archive_tree_loading_page.dart';
import 'package:artificialsw_frontend/features/home/tutorial_logic/help_page.dart';
import 'package:artificialsw_frontend/features/home/widget/island_save_indicator.dart';
import 'package:artificialsw_frontend/services/home/home_service.dart';
import 'package:artificialsw_frontend/services/home/dto/progress_scores/progress_scores_response_dto.dart';
import 'package:flutter/material.dart';

/// 홈 메인 화면 위젯
/// 
/// 사용자가 앱을 처음 실행했을 때 보이는 메인 화면임
/// 시간에 따라 배경이 바뀌고 섬 중앙에 4개의 나무가 배치되어 있음
/// 각 나무를 클릭하면 해당 나무의 상세 페이지로 이동함
/// 
/// 주요 구성요소:
/// - 시간대별 배경 이미지 (새벽/아침/오후/밤)
/// - 섬 중앙의 4개 나무 (꽃나무 2개, 과일나무 2개)
/// - 상단 진행률 바 (꽃과 과일 수확 진행도)
/// - 하단 버튼들 (도감, 섬 보관소)
/// - 도움말 아이콘
class HomeRoot extends StatefulWidget {
  const HomeRoot({super.key});
  @override
  State<HomeRoot> createState() => _HomeRootState();
}

class _HomeRootState extends State<HomeRoot> {
  /// 섬 저장 인디케이터가 이미 표시되었는지 추적하는 정적 변수
  /// 앱 실행 중 한 번만 표시되도록 보장함
  static bool _hasShownSaveIndicator = false;
  
  // API 관련 변수들
  final HomeService _homeService = HomeService();
  ProgressScoresResponseDto? _progressScores;
  bool _isLoadingScores = true;
  
  /// 현재 시간에 따라 배경 이미지를 선택하는 함수
  /// 
  /// 시간대별로 다른 배경 이미지를 보여줌:
  /// - 새벽 (4시~8시): 새벽 배경
  /// - 아침 (8시~16시): 아침 배경  
  /// - 오후 (16시~20시): 오후 배경
  /// - 밤 (20시~4시): 밤 배경
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

  /// 현재 시간에 따라 섬 이미지를 선택하는 함수
  /// 
  /// 아침 시간대(8시~16시)에는 아침 섬 이미지를,
  /// 그 외 시간에는 일반 섬 이미지를 표시함
  String _getTimeBasedIslandImage() {
    final now = DateTime.now();
    final hour = now.hour;
    
    if (hour >= 8 && hour < 16) {
      return 'assets/images/main_island_morning.png';
    } else {
      return 'assets/images/main_island.png';
    }
  }

  /// 나무 클릭 시 아카이브 로딩 페이지로 이동
  void _onTreeTap(int treeIndex) {
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
        year: now.year,
        month: now.month,
        period: period,
        treeIndex: treeIndex,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadProgressScores();
    // 화면이 완전히 로드된 후 섬 저장 완료 인디케이터를 표시함
    // 단, 앱 실행 중 한 번만 표시됨
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasShownSaveIndicator) {
        _hasShownSaveIndicator = true;
        IslandSaveIndicator.show(context: context);
      }
    });
  }

  /// 프로그레스바 점수 조회
  Future<void> _loadProgressScores() async {
    try {
      // TODO: archiveId를 실제 값으로 변경 (현재는 임시값)
      const archiveId = "current"; // 또는 실제 archive ID
      final scores = await _homeService.getProgressScores(archiveId: archiveId);
      setState(() {
        _progressScores = scores;
        _isLoadingScores = false;
      });
    } catch (e) {
      print('❌ 프로그레스바 점수 로드 실패: $e');
      print('🔄 하드코딩된 기본값으로 폴백합니다.');
      
      // API 실패 시 하드코딩된 기본값으로 폴백
      setState(() {
        _progressScores = const ProgressScoresResponseDto(
          puzzleScore: 4,      // 퍼즐 점수 기본값
          communityScore: 7,   // 커뮤니티 점수 기본값
        );
        _isLoadingScores = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // 기준 화면 크기 (412x917)에 대한 비율 계산
    // 다양한 화면 크기에 대응하기 위해 비율로 계산함
    final widthRatio = screenWidth / 412.0;
    final heightRatio = screenHeight / 917.0;
    
    // 섬 컨테이너 크기를 반응형으로 계산
    // 원본 디자인 크기에서 화면 비율만큼 곱해서 크기 조정
    final islandWidth = 338.0 * widthRatio;
    final islandHeight = 302.46 * heightRatio;
    
    // 섬 이미지 패딩을 반응형으로 계산
    final horizontalPadding = 37.0 * widthRatio;
    final topPadding = 276.0 * heightRatio;
    
    // Progress bar 위치를 반응형으로 계산
    final progressBarHorizontalPadding = 16.0 * widthRatio;
    final progressBarTopPadding = 98.0 * heightRatio;
    
    // 하단 버튼 위치를 반응형으로 계산
    final bottomButtonsTopPadding = 717.0 * heightRatio;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: HomeTopBar(),
      body: Stack(
        children: [
          // 시간대별 배경 이미지 (화면 전체를 채움)
          // 새벽/아침/오후/밤에 따라 다른 배경 이미지가 표시됨
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
          
          // 상단 진행률 바 (꽃과 과일 수확 진행도 표시)
          // 꽃 진행률과 과일 진행률을 나란히 배치함
          Positioned(
            left: progressBarHorizontalPadding,
            right: progressBarHorizontalPadding,
            top: progressBarTopPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 꽃 진행률 바 (왼쪽) - 커뮤니티 점수 (10개 세그먼트)
                ProgressBarWithIcon(
                  isFlower: true,
                  progress: _isLoadingScores 
                      ? 0.0 
                      : (_progressScores?.communityScore ?? 0) / 10.0, // 커뮤니티 점수 / 10
                  maxSegments: 10, // 꽃은 10개
                ),
                // 두 진행률 바 사이의 간격
                SizedBox(width: 7.0 * widthRatio),
                // 과일 진행률 바 (오른쪽) - 퍼즐 점수 (8개 세그먼트)
                ProgressBarWithIcon(
                  isFlower: false,
                  progress: _isLoadingScores 
                      ? 0.0 
                      : (_progressScores?.puzzleScore ?? 0) / 8.0, // 퍼즐 점수 / 8
                  maxSegments: 8, // 열매는 8개
                ),
              ],
            ),
          ),
          
          // 하단 버튼들 (도감과 섬 보관소 버튼)
          // 도감 버튼은 꽃/열매 도감으로 이동하고, 섬 보관소는 아직 미구현
          Positioned(
            left: 0,
            right: 0,
            top: bottomButtonsTopPadding,
            child: HomeBottomButtons(),
          ),
          
          // 도움말 아이콘 (섬 왼쪽 하단에 위치)
          // 클릭하면 도움말 페이지가 팝업으로 표시됨
          Positioned(
            left: 32 * widthRatio,
            top: 670 * heightRatio,
            child: GestureDetector(
              onTap: () {
                // 도움말 아이콘 클릭 시 도움말 다이얼로그 표시
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => const HelpPage(),
                );
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
          
          // 섬 이미지 (화면 중앙에 배치)
          // 시간대에 따라 아침 섬 이미지 또는 일반 섬 이미지가 표시됨
          Positioned(
            left: horizontalPadding,
            right: horizontalPadding,
            top: topPadding,
            child: Container(
              width: islandWidth,
              height: islandHeight,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(_getTimeBasedIslandImage()),
                  fit: BoxFit.contain,
                ),
              ),
              child: Stack(
                children: [
                  // 1번째 나무 (맨 왼쪽 꽃나무)
                  // 클릭하면 해당 꽃나무의 상세 페이지로 이동함
                  Positioned(
                    left: islandWidth * 0.15, // 섬 왼쪽에서 15% 지점에 배치
                    top: islandHeight * 0.3,   // 섬 위쪽에서 30% 지점에 배치
                    child: GestureDetector(
                      onTap: () => _onTreeTap(1),
                      child: Container(
                        width: islandWidth * 0.18,   // 나무 클릭 영역 크기
                        height: islandHeight * 0.4,  // 나무 클릭 영역 높이
                        color: Colors.transparent, // 투명하지만 클릭 가능한 영역
                      ),
                    ),
                  ),
                              
                  // 2번째 나무 (왼쪽에서 두 번째 꽃나무)
                  // 클릭하면 해당 꽃나무의 상세 페이지로 이동함
                  Positioned(
                    left: islandWidth * 0.35, // 섬 왼쪽에서 35% 지점에 배치
                    top: islandHeight * 0.25,  // 섬 위쪽에서 25% 지점에 배치
                    child: GestureDetector(
                      onTap: () => _onTreeTap(2),
                      child: Container(
                        width: islandWidth * 0.18,
                        height: islandHeight * 0.4,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  
                  // 3번째 나무 (오른쪽에서 두 번째 과일나무)
                  // 클릭하면 해당 과일나무의 상세 페이지로 이동함
                  Positioned(
                    left: islandWidth * 0.55, // 섬 왼쪽에서 55% 지점에 배치
                    top: islandHeight * 0.3,   // 섬 위쪽에서 30% 지점에 배치
                    child: GestureDetector(
                      onTap: () => _onTreeTap(3),
                      child: Container(
                        width: islandWidth * 0.18,
                        height: islandHeight * 0.4,
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  
                  // 4번째 나무 (맨 오른쪽 과일나무)
                  // 클릭하면 해당 과일나무의 상세 페이지로 이동함
                  Positioned(
                    left: islandWidth * 0.75, // 섬 왼쪽에서 75% 지점에 배치
                    top: islandHeight * 0.25,  // 섬 위쪽에서 25% 지점에 배치
                    child: GestureDetector(
                      onTap: () => _onTreeTap(4),
                      child: Container(
                        width: islandWidth * 0.18,
                        height: islandHeight * 0.4,
                        color: Colors.transparent,
                      ),
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
}

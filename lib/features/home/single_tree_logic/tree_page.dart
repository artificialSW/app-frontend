import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'package:artificialsw_frontend/features/home/widget/tree_decorate_sheet.dart';
import 'package:artificialsw_frontend/features/home/models/flower_card_data.dart';
import 'package:artificialsw_frontend/features/home/models/fruit_card_data.dart';

/// 나무 단독 페이지
/// 
/// 홈에서 나무를 클릭했을 때 보여지는 개별 나무 페이지임
/// 각 나무마다 다른 이미지와 크기를 가지고 있음
/// 
/// 주요 구성요소:
/// - 나무 타입별 배경 이미지 (tree_alone_background)
/// - 나무 타입별 나무 이미지 (flower-1, flower-2, fruit-1, fruit-2)
/// - 나무 장식 시트 (TreeDecorateSheet) - 과일/꽃 선택 기능
/// - 뒤로가기 버튼과 plumu 로고
class TreePage extends StatefulWidget {
  final String treeType; // 'flower-1', 'flower-2', 'fruit-1', 'fruit-2'
  final bool isArchiveMode; // 아카이브 모드 여부
  final int? archiveYear; // 아카이브 연도
  final int? archiveMonth; // 아카이브 월
  final int? archivePeriod; // 아카이브 기간 (1: ~15일, 2: 16~말일)
  final int? archiveTreeIndex; // 아카이브 나무 인덱스 (1,2,3,4)
  
  const TreePage({
    super.key,
    required this.treeType,
    this.isArchiveMode = false,
    this.archiveYear,
    this.archiveMonth,
    this.archivePeriod,
    this.archiveTreeIndex,
  });

  @override
  State<TreePage> createState() => _TreePageState();
}

class _TreePageState extends State<TreePage> {

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

  // 현재 표시할 꽃/열매 카드 데이터 (실제 카드 데이터 사용)
  List<FlowerCardData> _currentFlowerCards = [];
  List<FruitCardData> _currentFruitCards = [];

  /// 나무 타입에 따라 해당하는 나무 이미지 경로를 반환하는 함수
  String _getTreeImagePath() {
    switch (widget.treeType) {
      case 'flower-1':
        return AppAssets.flower_tree_1;
      case 'flower-2':
        return AppAssets.fruit_tree_1; // 2번째 꽃나무 → fruit_tree_1 이미지
      case 'fruit-1':
        return AppAssets.flower_tree_2; // 3번째 열매나무 → flower_tree_2 이미지
      case 'fruit-2':
        return AppAssets.fruit_tree_2;
      default:
        return AppAssets.flower_tree_1;
    }
  }

  /// 나무 타입에 따라 다른 크기와 위치 정보를 반환하는 함수
  /// 
  /// 각 나무마다 다른 크기와 화면에서의 위치를 가지고 있음
  /// 반응형 레이아웃을 위해 화면 비율에 따라 크기가 조정됨
  Map<String, double> _getTreeLayout() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // 기준 화면 크기 (412x917)에 대한 비율 계산
    final widthRatio = screenWidth / 412.0;
    final heightRatio = screenHeight / 917.0;

    switch (widget.treeType) {
      case 'flower-1':
        return {
          'width': 258.0 * widthRatio,
          'height': 453.0 * heightRatio,
          'topPadding': 197.0 * heightRatio,
        };
      case 'flower-2':
        // fruit_tree_1 이미지 사용하므로 fruit-1의 크기/위치 적용
        return {
          'width': 219.0 * widthRatio,
          'height': 441.0 * heightRatio,
          'topPadding': 193.0 * heightRatio,
        };
      case 'fruit-1':
        // flower_tree_2 이미지 사용하므로 flower-2의 크기/위치 적용
        return {
          'width': 252.0 * widthRatio,
          'height': 418.0 * heightRatio,
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final layout = _getTreeLayout();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: SizedBox(
          width: 60,
          height: 24.08,
          child: Text(
            'plumu',
            textAlign: TextAlign.center,
            style: AppTextStyles.plumu.copyWith(color: Colors.white),
          ),
        ),
      ),
      body: Stack(
        children: [
          // 나무 단독 페이지 배경 이미지 (화면 전체를 채움)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppAssets.tree_alone_background),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          
          // 나무 이미지 + 꽃 오버레이 (각 나무별로 다른 크기와 위치에 배치)
          Positioned(
            left: (screenWidth - layout['width']!) / 2, // 화면 중앙에 배치
            top: layout['topPadding']!, // 나무별로 다른 상단 패딩
            child: SizedBox(
              width: layout['width'],
              height: layout['height'],
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // 나무 이미지
                  Positioned.fill(
                    child: Image.asset(
                      _getTreeImagePath(),
                      fit: BoxFit.contain,
                    ),
                  ),
                  // 꽃 오버레이: flower-1 타입일 때 (최대 6개)
                  if (widget.treeType == 'flower-1') ...[
                    for (int i = 0; i < _currentFlowerCards.length && i < 6; i++)
                      _buildOverlayFlower(i, layout['width']!, layout['height']!),
                  ],
                  // 꽃 오버레이: flower-2 타입일 때 (최대 4개)
                  if (widget.treeType == 'flower-2') ...[
                    for (int i = 0; i < _currentFlowerCards.length && i < 4; i++)
                      _buildOverlayFlower2(i, layout['width']!, layout['height']!),
                  ],
                  // 과일 오버레이: fruit-1 타입일 때 (최대 4개)
                  if (widget.treeType == 'fruit-1') ...[
                    for (int i = 0; i < _currentFruitCards.length && i < 4; i++)
                      _buildOverlayFruit1(i, layout['width']!, layout['height']!),
                  ],
                  // 과일 오버레이: fruit-2 타입일 때 (최대 3개)
                  if (widget.treeType == 'fruit-2') ...[
                    for (int i = 0; i < _currentFruitCards.length && i < 3; i++)
                      _buildOverlayFruit2(i, layout['width']!, layout['height']!),
                  ],
                ],
              ),
            ),
          ),
          
          // 나무 장식 시트 (하단에서 화면 높이의 75% 차지)
          // 과일과 꽃을 선택해서 나무에 장식할 수 있는 기능 제공
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: screenHeight * 0.75, // 화면 높이의 75% 차지
            child: TreeDecorateSheet(
              treeType: widget.treeType,
              isArchiveMode: widget.isArchiveMode,
              archiveYear: widget.archiveYear,
              archiveMonth: widget.archiveMonth,
              archivePeriod: widget.archivePeriod,
              archiveTreeIndex: widget.archiveTreeIndex,
              onSelectionChanged: (fruitCards, flowerCards) {
                // 실제 카드 데이터를 저장하여 나무에 표시
                setState(() {
                  _currentFlowerCards = flowerCards;
                  _currentFruitCards = fruitCards;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // 나무 위 꽃 하나를 그리는 위젯 (적응형 좌표/크기) - 첫 번째 나무용
  Widget _buildOverlayFlower(int index, double treeWidth, double treeHeight) {
    // 카드 데이터가 없으면 표시하지 않음
    if (index >= _currentFlowerCards.length) {
      return const SizedBox.shrink();
    }

    // 스케일 계산 (기준 나무 크기 대비)
    final scaleX = treeWidth / _baseTreeWidth;
    final scaleY = treeHeight / _baseTreeHeight;
    // 아이콘 크기: 55x55을 기준으로 너비 스케일에 맞춰 균등 스케일링
    final size = 55.0 * scaleX;

    final basePos = _baseFlowerPositions[index];
    final left = basePos.dx * scaleX;
    final top = basePos.dy * scaleY;

    return Positioned(
      left: left,
      top: top,
      child: Image.asset(
        _currentFlowerCards[index].imagePath, // 실제 카드의 이미지 사용
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }

  // 나무 위 꽃 하나를 그리는 위젯 (적응형 좌표/크기) - 두 번째 나무용
  Widget _buildOverlayFlower2(int index, double treeWidth, double treeHeight) {
    // 카드 데이터가 없으면 표시하지 않음
    if (index >= _currentFlowerCards.length) {
      return const SizedBox.shrink();
    }

    // 스케일 계산 (두 번째 나무 기준 크기 대비)
    final scaleX = treeWidth / _baseTree2Width;
    final scaleY = treeHeight / _baseTree2Height;
    // 아이콘 크기: 60x60을 기준으로 너비 스케일에 맞춰 균등 스케일링
    // 아카시아만 크기를 1.2배로 키움 (이름으로 확인)
    final baseSize = 60.0 * scaleX;
    final isAcacia = _currentFlowerCards[index].name == '아카시아';
    final size = isAcacia ? baseSize * 1.2 : baseSize; // 아카시아만 크기 증가

    final basePos = _baseFlower2Positions[index];
    final left = basePos.dx * scaleX;
    final top = basePos.dy * scaleY;

    return Positioned(
      left: left,
      top: top,
      child: Image.asset(
        _currentFlowerCards[index].imagePath, // 실제 카드의 이미지 사용
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }

  // 나무 위 과일 하나를 그리는 위젯 (적응형 좌표/크기) - 세 번째 나무용
  Widget _buildOverlayFruit1(int index, double treeWidth, double treeHeight) {
    // 카드 데이터가 없으면 표시하지 않음
    if (index >= _currentFruitCards.length) {
      return const SizedBox.shrink();
    }

    // 스케일 계산 (세 번째 나무 기준 크기 대비)
    final scaleX = treeWidth / _baseTree3Width;
    final scaleY = treeHeight / _baseTree3Height;
    // 아이콘 크기: 60x65 (가로/세로 각각 스케일)
    final width = 60.0 * scaleX;
    final height = 65.0 * scaleY;

    final basePos = _baseFruit1Positions[index];
    final left = basePos.dx * scaleX;
    final top = basePos.dy * scaleY;

    return Positioned(
      left: left,
      top: top,
      child: Image.asset(
        _currentFruitCards[index].imagePath, // 실제 카드의 이미지 사용
        width: width,
        height: height,
        fit: BoxFit.contain,
      ),
    );
  }
 
  // 나무 위 과일 하나를 그리는 위젯 (적응형 좌표/크기) - 네 번째 나무용
  Widget _buildOverlayFruit2(int index, double treeWidth, double treeHeight) {
    // 카드 데이터가 없으면 표시하지 않음
    if (index >= _currentFruitCards.length) {
      return const SizedBox.shrink();
    }

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
        _currentFruitCards[index].imagePath, // 실제 카드의 이미지 사용
        width: width,
        height: height,
        fit: BoxFit.contain,
      ),
    );
  }
}

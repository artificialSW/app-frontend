import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'package:artificialsw_frontend/features/home/widget/tree_decorate_sheet.dart';

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
  
  const TreePage({
    super.key,
    required this.treeType,
  });

  @override
  State<TreePage> createState() => _TreePageState();
}

class _TreePageState extends State<TreePage> {

  /// 나무 타입에 따라 해당하는 나무 이미지 경로를 반환하는 함수
  String _getTreeImagePath() {
    switch (widget.treeType) {
      case 'flower-1':
        return AppAssets.flower_tree_1;
      case 'flower-2':
        return AppAssets.flower_tree_2;
      case 'fruit-1':
        return AppAssets.fruit_tree_1;
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
        return {
          'width': 252.0 * widthRatio,
          'height': 418.0 * heightRatio,
          'topPadding': 232.0 * heightRatio,
        };
      case 'fruit-1':
        return {
          'width': 219.0 * widthRatio,
          'height': 441.0 * heightRatio,
          'topPadding': 193.0 * heightRatio,
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
          
          // 나무 이미지 (각 나무별로 다른 크기와 위치에 배치)
          Positioned(
            left: (screenWidth - layout['width']!) / 2, // 화면 중앙에 배치
            top: layout['topPadding']!, // 나무별로 다른 상단 패딩
            child: Container(
              width: layout['width'],
              height: layout['height'],
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(_getTreeImagePath()),
                  fit: BoxFit.contain,
                ),
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
              onSelectionChanged: (fruitCards, flowerCards) {
                // 선택된 과일과 꽃 카드들을 처리하는 로직
                print('선택된 과일: ${fruitCards.where((c) => c.order > 0).length}개');
                print('선택된 꽃: ${flowerCards.where((c) => c.order > 0).length}개');
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/features/home/models/tree.dart';
import 'package:artificialsw_frontend/features/home/models/fruit_card_data.dart';
import 'package:artificialsw_frontend/features/home/models/flower_card_data.dart';

/// 트리 이미지 페이지 위젯
/// - 나무 이미지와 나무 이름 표지판을 표시
/// - 나무 이름 설정 날짜와 이름을 표지판에 표시
/// - 3개 페이지 모두 동일한 구조로 표시
class TreeImagePage extends StatelessWidget {
  final String treeName;
  final String namingDate;
  final int pageIndex;
  final List<FruitCardData>? selectedFruits;
  final List<FlowerCardData>? selectedFlowers;

  const TreeImagePage({
    super.key,
    required this.treeName,
    required this.namingDate,
    required this.pageIndex,
    this.selectedFruits,
    this.selectedFlowers,
  });

  @override
  Widget build(BuildContext context) {
    // 3개의 나무 리스트 (각 페이지별로 다른 나무)
    final List<Tree> treeList = [
      Tree(id: 'tree_1', name: treeName, namingDate: namingDate, fruitCount: 20, flowerCount: 8),
      Tree(id: 'tree_2', name: treeName, namingDate: namingDate, fruitCount: 3, flowerCount: 0),
      Tree(id: 'tree_3', name: treeName, namingDate: namingDate, fruitCount: 0, flowerCount: 3),
    ];

    // 현재 페이지에 해당하는 나무
    final currentTree = treeList[pageIndex];

    // 과일/꽃 배치 위치 (300x300 기준으로 변환된 좌표)
    // 원본: 315x371 기준 → 변환: 300x300 기준
    final List<Offset> decorationPositions = [
      const Offset(78.1, 103.5),  // 첫 번째 위치 (왼쪽 아래)
      const Offset(171.4, 63.9),  // 두 번째 위치 (오른쪽 위)
      const Offset(207.6, 120.5), // 세 번째 위치 (오른쪽 아래)
    ];

    return Stack(
      children: [
        // 나무 이미지
        Positioned(
          top: 40, // 상단 여백
          left: 20, // 좌측 여백
          child: Stack(
            children: [
              // 나무 이미지
              Image.asset(
                AppAssets.tree,
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
              // 선택된 과일/꽃 배치 (순서대로 밀리지 않게)
              ..._buildDecorations(decorationPositions),
            ],
          ),
        ),
        // 나무 이름 표지판
        Positioned(
          top: 240, // 나무 이미지 아래쪽에 배치
          left: 250, // 나무 이미지 오른쪽에 배치
          child: Stack(
            children: [
              // 표지판 배경 이미지
              Image.asset(AppAssets.wooden_sign),
              // 나무 이름 설정 날짜 표시
              Positioned(
                top: 8,
                left: 0,
                right: 0,
                child: Text(
                  currentTree.namingDate,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.pretendard_bold.copyWith(
                    fontSize: 7,
                    color: AppColors.plumu_black,
                  ),
                ),
              ),
              // 나무 이름 표시
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Text(
                  currentTree.name,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.pretendard_bold.copyWith(
                    fontSize: 11,
                    color: AppColors.plumu_black,
                  ),
                ),
              ),
            ],
          )
        ),
      ],
    );
  }

  /// 선택된 과일/꽃을 나무에 배치하는 위젯들을 생성
  /// 순서대로 밀리지 않게 배치 (첫 번째 선택 → 첫 번째 위치, 두 번째 선택 → 두 번째 위치)
  List<Widget> _buildDecorations(List<Offset> positions) {
    List<Widget> decorations = [];

    if (pageIndex == 1 && selectedFruits != null && selectedFruits!.isNotEmpty) {
      // 두 번째 페이지: 과일 배치 (순서대로)
      for (int i = 0; i < selectedFruits!.length && i < 3; i++) {
        final fruit = selectedFruits![i];
        final position = positions[i]; // 순서대로 위치 할당
        
        decorations.add(
          Positioned(
            left: position.dx - 15, // 이미지 중심으로 조정
            top: position.dy - 15,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  fruit.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      }
    } else if (pageIndex == 2 && selectedFlowers != null && selectedFlowers!.isNotEmpty) {
      // 세 번째 페이지: 꽃 배치 (순서대로)
      for (int i = 0; i < selectedFlowers!.length && i < 3; i++) {
        final flower = selectedFlowers![i];
        final position = positions[i]; // 순서대로 위치 할당
        
        decorations.add(
          Positioned(
            left: position.dx - 15, // 이미지 중심으로 조정
            top: position.dy - 15,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  flower.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      }
    }

    return decorations;
  }
}

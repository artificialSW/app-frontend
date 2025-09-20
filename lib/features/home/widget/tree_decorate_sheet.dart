import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/features/home/widget/fruit_card.dart';
import 'package:artificialsw_frontend/features/home/widget/flower_card.dart';
import 'package:artificialsw_frontend/features/home/models/fruit_card_data.dart';
import 'package:artificialsw_frontend/features/home/models/flower_card_data.dart';

class TreeDecorateSheet extends StatefulWidget {
  final int pageIndex;
  final Function(List<FruitCardData>, List<FlowerCardData>)? onSelectionChanged;
  
  const TreeDecorateSheet({
    super.key,
    required this.pageIndex,
    this.onSelectionChanged,
  });

  @override
  State<TreeDecorateSheet> createState() => _TreeDecorateSheetState();
}

class _TreeDecorateSheetState extends State<TreeDecorateSheet> {
  // 실제 카드 데이터들 (서버에서 받아올 예정)
  List<FruitCardData> fruitCards = [];
  List<FlowerCardData> flowerCards = [];

  @override
  void initState() {
    super.initState();
    // 테스트용 데이터 (나중에 서버에서 받아올 예정)
    _loadTestData();
  }

  void _loadTestData() {
    // 테스트용 과일 카드들 (season은 date 기준으로 자동 계산됨)
    final rawFruitCards = [
      FruitCardData(
        id: 'fruit_spring_001',
        name: '딸기',
        imagePath: 'assets/images/fruit/spring/strawberry.png',
        date: '2024-04-15',  // 봄 날짜
        puzzleImagePath: 'assets/images/puzzle/spring_puzzle.png',
        order: 0,  // 기본값: 안달림
      ),
      FruitCardData(
        id: 'fruit_summer_001',
        name: '복숭아',
        imagePath: 'assets/images/fruit/summer/peach.png',
        date: '2024-07-20',  // 여름 날짜
        puzzleImagePath: 'assets/images/puzzle/summer_puzzle.png',
        order: 0,  // 기본값: 안달림
      ),
      FruitCardData(
        id: 'fruit_winter_001',
        name: '사과',
        imagePath: 'assets/images/fruit/winter/apple.png',
        date: '2024-12-15',  // 겨울 날짜
        puzzleImagePath: 'assets/images/puzzle/winter_puzzle.png',
        order: 0,  // 기본값: 안달림
      ),
    ];

    // 테스트용 꽃 카드들 (emotion은 백엔드에서 받아옴)
    final rawFlowerCards = [
      FlowerCardData(
        id: 'flower_love_001',
        name: '장미',
        imagePath: 'assets/images/flower/rose.png',
        emotion: 'love',
        date: '2024-09-13',
        communicationText: '사랑 관련 소통을 통해 획득',
        order: 0,  // 기본값: 안달림
      ),
      FlowerCardData(
        id: 'flower_comfort_001',
        name: '아카시아',
        imagePath: 'assets/images/flower/acacia.png',
        emotion: 'comfort',
        date: '2024-09-12',
        communicationText: '위로 관련 소통을 통해 획득',
        order: 0,  // 기본값: 안달림
      ),
    ];

    // 날짜순으로 정렬 (최신순)
    fruitCards = _sortCardsByDate(rawFruitCards);
    flowerCards = _sortCardsByDate(rawFlowerCards);
  }

  /// 카드들을 날짜순으로 정렬하는 메서드 (최신순)
  List<T> _sortCardsByDate<T>(List<T> cards) {
    if (cards.isEmpty) return cards;
    
    // T가 FruitCardData인지 FlowerCardData인지 확인하고 정렬
    if (cards.first is FruitCardData) {
      final fruitCards = (cards as List<FruitCardData>).toList();
      fruitCards.sort((a, b) => b.date.compareTo(a.date));
      return fruitCards as List<T>;
    } else if (cards.first is FlowerCardData) {
      final flowerCards = (cards as List<FlowerCardData>).toList();
      flowerCards.sort((a, b) => b.date.compareTo(a.date));
      return flowerCards as List<T>;
    }
    
    return cards;
  }

  /// 다음 사용 가능한 order 값을 찾는 메서드 (순서대로 채우기)
  /// 1, 2, 3 중에서 사용되지 않은 첫 번째 값 반환
  int _getNextAvailableOrder(List<dynamic> cards) {
    final usedOrders = cards.map((card) => card.order).toSet();
    for (int i = 1; i <= 3; i++) {
      if (!usedOrders.contains(i)) return i;
    }
    return 4; // 모든 위치가 사용 중 (더 이상 선택 불가)
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      minChildSize: 0.05,
      initialChildSize: 0.08,
      maxChildSize: 0.88,
      snap: true,
      snapSizes: const [0.08, 0.4, 0.88],
      builder: (context, controller) {
        return Container(
          decoration: ShapeDecoration(
            color: Color(0xFFFFFFFF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            shadows: [
              BoxShadow(
                color: Color(0x19000000),
                blurRadius: 30,
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Center(
                child: Container(
                  width: 66,
                  height: 4,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFD9D9D9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  controller: controller,
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 좌우로 3개씩
                    crossAxisSpacing: 12, // 좌우 간격
                    mainAxisSpacing: 12, // 상하 간격
                    childAspectRatio: 1, // 정사각형 비율
                  ),
                  itemCount: widget.pageIndex == 1 ? fruitCards.length : flowerCards.length,
                  itemBuilder: (context, index) {
                    if (widget.pageIndex == 1) {
                      // 2번째 페이지: 과일 카드들
                      if (fruitCards.isEmpty) {
                        // 카드가 없는 경우 빈 상태 표시
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              '아직 획득한 과일이 없습니다',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      }
                      
                      final fruitCard = fruitCards[index];
                      
                      return FruitCard(
                        fruitName: fruitCard.name,
                        fruitImagePath: fruitCard.imagePath,
                        season: fruitCard.season,
                        date: fruitCard.date,
                        order: fruitCard.order, // order 값으로 체크표시 표시 (0: 안달림, 1-3: 위치)
                        onTap: () {
                          setState(() {
                            // 1. 체크표시 클릭 시 상태 변경
                            if (fruitCard.order > 0) {
                              // 해제: order를 0으로 (나무에서 제거)
                              fruitCards[index] = fruitCard.copyWith(order: 0);
                            } else {
                              // 선택: 다음 사용 가능한 order 할당 (나무에 추가)
                              final nextOrder = _getNextAvailableOrder(fruitCards);
                              if (nextOrder <= 3) {
                                fruitCards[index] = fruitCard.copyWith(order: nextOrder);
                              }
                            }
                          });
                          // 2. 부모(HomeMainPage)에게 선택 상태 변경 알림
                          widget.onSelectionChanged?.call(fruitCards, flowerCards);
                        },
                      );
                    } else {
                      // 3번째 페이지: 꽃 카드들
                      if (flowerCards.isEmpty) {
                        // 카드가 없는 경우 빈 상태 표시
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              '아직 획득한 꽃이 없습니다',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        );
                      }
                      
                      final flowerCard = flowerCards[index];
                      
                      return FlowerCard(
                        flowerName: flowerCard.name,
                        flowerImagePath: flowerCard.imagePath,
                        emotion: flowerCard.emotion,
                        date: flowerCard.date,
                        order: flowerCard.order, // order 값으로 체크표시 표시 (0: 안달림, 1-3: 위치)
                        onTap: () {
                          setState(() {
                            // 1. 체크표시 클릭 시 상태 변경
                            if (flowerCard.order > 0) {
                              // 해제: order를 0으로 (나무에서 제거)
                              flowerCards[index] = flowerCard.copyWith(order: 0);
                            } else {
                              // 선택: 다음 사용 가능한 order 할당 (나무에 추가)
                              final nextOrder = _getNextAvailableOrder(flowerCards);
                              if (nextOrder <= 3) {
                                flowerCards[index] = flowerCard.copyWith(order: nextOrder);
                              }
                            }
                          });
                          // 2. 부모(HomeMainPage)에게 선택 상태 변경 알림
                          widget.onSelectionChanged?.call(fruitCards, flowerCards);
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

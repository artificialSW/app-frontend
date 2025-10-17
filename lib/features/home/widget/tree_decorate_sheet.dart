import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/features/home/widget/fruit_card.dart';
import 'package:artificialsw_frontend/features/home/widget/flower_card.dart';
import 'package:artificialsw_frontend/features/home/models/fruit_card_data.dart';
import 'package:artificialsw_frontend/features/home/models/flower_card_data.dart';

class TreeDecorateSheet extends StatefulWidget {
  final String treeType; // 'flower-1', 'flower-2', 'fruit-1', 'fruit-2'
  final Function(List<FruitCardData>, List<FlowerCardData>)? onSelectionChanged;
  
  const TreeDecorateSheet({
    super.key,
    required this.treeType,
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
    // 테스트용 과일 카드들 (16개 과일)
    final rawFruitCards = [
      // 봄 과일들 (4개)
      FruitCardData(id: 'fruit_spring_001', name: '체리', imagePath: 'assets/images/fruit/spring/cherry.png', date: '2024-04-20', puzzleImagePath: 'assets/images/puzzle/spring_puzzle.png', order: 0),
      FruitCardData(id: 'fruit_spring_002', name: '참외', imagePath: 'assets/images/fruit/spring/oriental_melon.png', date: '2024-06-01', puzzleImagePath: 'assets/images/puzzle/spring_puzzle.png', order: 0),
      FruitCardData(id: 'fruit_spring_003', name: '산딸기', imagePath: 'assets/images/fruit/spring/raspberry.png', date: '2024-05-15', puzzleImagePath: 'assets/images/puzzle/spring_puzzle.png', order: 0),
      FruitCardData(id: 'fruit_spring_004', name: '딸기', imagePath: 'assets/images/fruit/spring/strawberry.png', date: '2024-04-15', puzzleImagePath: 'assets/images/puzzle/spring_puzzle.png', order: 0),
      
      // 여름 과일들 (4개)
      FruitCardData(id: 'fruit_summer_001', name: '블루베리', imagePath: 'assets/images/fruit/summer/blueberry.png', date: '2024-07-25', puzzleImagePath: 'assets/images/puzzle/summer_puzzle.png', order: 0),
      FruitCardData(id: 'fruit_summer_002', name: '망고', imagePath: 'assets/images/fruit/summer/mango.png', date: '2024-08-05', puzzleImagePath: 'assets/images/puzzle/summer_puzzle.png', order: 0),
      FruitCardData(id: 'fruit_summer_003', name: '복숭아', imagePath: 'assets/images/fruit/summer/peach.png', date: '2024-07-20', puzzleImagePath: 'assets/images/puzzle/summer_puzzle.png', order: 0),
      FruitCardData(id: 'fruit_summer_004', name: '자두', imagePath: 'assets/images/fruit/summer/plum.png', date: '2024-08-10', puzzleImagePath: 'assets/images/puzzle/summer_puzzle.png', order: 0),
      
      // 가을 과일들 (4개)
      FruitCardData(id: 'fruit_fall_001', name: '무화과', imagePath: 'assets/images/fruit/fall/fig.png', date: '2024-09-20', puzzleImagePath: 'assets/images/puzzle/fall_puzzle.png', order: 0),
      FruitCardData(id: 'fruit_fall_002', name: '포도', imagePath: 'assets/images/fruit/fall/grape.png', date: '2024-09-25', puzzleImagePath: 'assets/images/puzzle/fall_puzzle.png', order: 0),
      FruitCardData(id: 'fruit_fall_003', name: '배', imagePath: 'assets/images/fruit/fall/pear.png', date: '2024-10-10', puzzleImagePath: 'assets/images/puzzle/fall_puzzle.png', order: 0),
      FruitCardData(id: 'fruit_fall_004', name: '감', imagePath: 'assets/images/fruit/fall/persimmon.png', date: '2024-10-15', puzzleImagePath: 'assets/images/puzzle/fall_puzzle.png', order: 0),
      
      // 겨울 과일들 (4개)
      FruitCardData(id: 'fruit_winter_001', name: '사과', imagePath: 'assets/images/fruit/winter/apple.png', date: '2024-12-15', puzzleImagePath: 'assets/images/puzzle/winter_puzzle.png', order: 0),
      FruitCardData(id: 'fruit_winter_002', name: '귤', imagePath: 'assets/images/fruit/winter/mandarin.png', date: '2024-12-25', puzzleImagePath: 'assets/images/puzzle/winter_puzzle.png', order: 0),
      FruitCardData(id: 'fruit_winter_003', name: '석류', imagePath: 'assets/images/fruit/winter/pomegranate.png', date: '2024-01-05', puzzleImagePath: 'assets/images/puzzle/winter_puzzle.png', order: 0),
      FruitCardData(id: 'fruit_winter_004', name: '유자', imagePath: 'assets/images/fruit/winter/yuja.png', date: '2024-01-10', puzzleImagePath: 'assets/images/puzzle/winter_puzzle.png', order: 0),
    ];

    // 테스트용 꽃 카드들 (모든 꽃 추가)
    final rawFlowerCards = [
      FlowerCardData(id: 'flower_001', name: '동백꽃', imagePath: 'assets/images/flower/camellia.png', emotion: 'love', date: '2024-09-13', communicationText: '사랑 관련 소통을 통해 획득', order: 0),
      FlowerCardData(id: 'flower_002', name: '장미', imagePath: 'assets/images/flower/rose.png', emotion: 'love', date: '2024-09-14', communicationText: '사랑 관련 소통을 통해 획득', order: 0),
      FlowerCardData(id: 'flower_003', name: '아카시아', imagePath: 'assets/images/flower/acacia.png', emotion: 'comfort', date: '2024-09-12', communicationText: '위로 관련 소통을 통해 획득', order: 0),
      FlowerCardData(id: 'flower_004', name: '수국', imagePath: 'assets/images/flower/hydrangea.png', emotion: 'comfort', date: '2024-09-15', communicationText: '위로 관련 소통을 통해 획득', order: 0),
      FlowerCardData(id: 'flower_005', name: '매화', imagePath: 'assets/images/flower/plum_blossom.png', emotion: 'special', date: '2024-09-16', communicationText: '특별한 소통을 통해 획득', order: 0),
      FlowerCardData(id: 'flower_006', name: '튤립', imagePath: 'assets/images/flower/tulip.png', emotion: 'special', date: '2024-09-17', communicationText: '특별한 소통을 통해 획득', order: 0),
      FlowerCardData(id: 'flower_007', name: '제비꽃', imagePath: 'assets/images/flower/violet.png', emotion: 'memory', date: '2024-09-18', communicationText: '추억 관련 소통을 통해 획득', order: 0),
      FlowerCardData(id: 'flower_008', name: '목련', imagePath: 'assets/images/flower/magnolia.png', emotion: 'memory', date: '2024-09-19', communicationText: '추억 관련 소통을 통해 획득', order: 0),
      FlowerCardData(id: 'flower_009', name: '벚꽃', imagePath: 'assets/images/flower/cherry_blossom.png', emotion: 'joy', date: '2024-09-20', communicationText: '기쁨 관련 소통을 통해 획득', order: 0),
      FlowerCardData(id: 'flower_010', name: '코스모스', imagePath: 'assets/images/flower/cosmos.png', emotion: 'joy', date: '2024-09-21', communicationText: '기쁨 관련 소통을 통해 획득', order: 0),
      FlowerCardData(id: 'flower_011', name: '해바라기', imagePath: 'assets/images/flower/sunflower.png', emotion: 'hobby', date: '2024-09-22', communicationText: '취미 관련 소통을 통해 획득', order: 0),
      FlowerCardData(id: 'flower_012', name: '팥배꽃', imagePath: 'assets/images/flower/patbae_flower.png', emotion: 'hobby', date: '2024-09-23', communicationText: '취미 관련 소통을 통해 획득', order: 0),
    ];

    // 날짜순으로 정렬 (최신순) 후 상태 업데이트
    final sortedFruit = _sortCardsByDate(rawFruitCards);
    final sortedFlower = _sortCardsByDate(rawFlowerCards);
    setState(() {
      fruitCards = sortedFruit;
      flowerCards = sortedFlower;
    });
    // 초기 로드 시에도 부모에 알림 (시트의 현재 카드 개수 전달)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.onSelectionChanged != null) {
        widget.onSelectionChanged!(fruitCards, flowerCards);
      }
    });
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

  /// 나무 타입이 과일 나무인지 확인
  bool _isFruitTree() {
    return widget.treeType == 'fruit-1' || widget.treeType == 'fruit-2';
  }

  /// 나무 타입에 따라 표시할 카드 리스트 반환
  List<dynamic> _getDisplayCards() {
    if (_isFruitTree()) {
      return fruitCards;
    } else {
      return flowerCards;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      minChildSize: 0.3, // 최소 높이를 30%로 설정
      initialChildSize: 0.4, // 초기 높이를 40%로 설정
      maxChildSize: 0.88,
      snap: true,
      snapSizes: const [0.3, 0.4, 0.88], // 스냅 위치 조정
      expand: true, // 시트가 전체 영역을 차지하도록
      builder: (context, scrollController) {
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
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              // 드래그 핸들 영역 (적응형으로 조정)
              SliverToBoxAdapter(
                child: Container(
                  height: 40 * (MediaQuery.of(context).size.height / 917.0), // 적응형 높이
                  child: Center(
                    child: Container(
                      width: 66 * (MediaQuery.of(context).size.width / 412.0), // 적응형 너비
                      height: 4 * (MediaQuery.of(context).size.height / 917.0), // 적응형 높이
                      decoration: ShapeDecoration(
                        color: const Color(0xFFD9D9D9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2 * (MediaQuery.of(context).size.width / 412.0)), // 적응형 둥근 모서리
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // 카드 그리드 (적응형 패딩과 간격)
              SliverPadding(
                padding: EdgeInsets.all(12 * (MediaQuery.of(context).size.width / 412.0)), // 적응형 패딩
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // 좌우로 3개씩
                    crossAxisSpacing: 12 * (MediaQuery.of(context).size.width / 412.0), // 적응형 좌우 간격
                    mainAxisSpacing: 12 * (MediaQuery.of(context).size.height / 917.0), // 적응형 상하 간격
                    childAspectRatio: 1, // 정사각형 비율
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final displayCards = _getDisplayCards();
                      
                      if (displayCards.isEmpty) {
                        // 카드가 없는 경우 빈 상태 표시 (적응형)
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8 * (MediaQuery.of(context).size.width / 412.0)), // 적응형 둥근 모서리
                          ),
                          child: Center(
                            child: Text(
                              _isFruitTree() ? '아직 획득한 과일이 없습니다' : '아직 획득한 꽃이 없습니다',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14 * (MediaQuery.of(context).size.width / 412.0), // 적응형 폰트 크기
                              ),
                            ),
                          ),
                        );
                      }
                      
                      final card = displayCards[index];
                      
                      if (_isFruitTree()) {
                        final fruitCard = card as FruitCardData;
                        return FruitCard(
                          fruitName: fruitCard.name,
                          fruitImagePath: fruitCard.imagePath,
                          season: fruitCard.season,
                          date: fruitCard.date,
                          order: fruitCard.order,
                          onTap: null,
                        );
                      } else {
                        final flowerCard = card as FlowerCardData;
                        return FlowerCard(
                          flowerName: flowerCard.name,
                          flowerImagePath: flowerCard.imagePath,
                          emotion: flowerCard.emotion,
                          date: flowerCard.date,
                          order: flowerCard.order,
                          onTap: null,
                        );
                      }
                    },
                    childCount: _getDisplayCards().length,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

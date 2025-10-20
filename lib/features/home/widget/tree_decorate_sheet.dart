import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/features/home/widget/fruit_card.dart';
import 'package:artificialsw_frontend/features/home/widget/flower_card.dart';
import 'package:artificialsw_frontend/features/home/models/fruit_card_data.dart';
import 'package:artificialsw_frontend/features/home/models/flower_card_data.dart';
import 'package:artificialsw_frontend/services/home/home_service.dart';
import 'package:artificialsw_frontend/services/home/dto/archive/archive_flower_response_dto.dart';
import 'package:artificialsw_frontend/services/home/dto/archive/archive_fruit_response_dto.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'package:artificialsw_frontend/features/home/widget/fruit_card_dialog.dart';
import 'package:artificialsw_frontend/features/home/widget/flower_card_dialog.dart';

class TreeDecorateSheet extends StatefulWidget {
  final String treeType; // 'flower-1', 'flower-2', 'fruit-1', 'fruit-2'
  final bool isArchiveMode; // 아카이브 모드 여부
  final int? archiveYear; // 아카이브 연도
  final int? archiveMonth; // 아카이브 월
  final int? archivePeriod; // 아카이브 기간 (1: ~15일, 2: 16~말일)
  final int? archiveTreeIndex; // 아카이브 나무 인덱스 (1,2,3,4)
  final Function(List<FruitCardData>, List<FlowerCardData>)? onSelectionChanged;
  
  const TreeDecorateSheet({
    super.key,
    required this.treeType,
    this.isArchiveMode = false,
    this.archiveYear,
    this.archiveMonth,
    this.archivePeriod,
    this.archiveTreeIndex,
    this.onSelectionChanged,
  });

  @override
  State<TreeDecorateSheet> createState() => _TreeDecorateSheetState();
}

class _TreeDecorateSheetState extends State<TreeDecorateSheet> {
  // 실제 카드 데이터들 (서버에서 받아올 예정)
  List<FruitCardData> fruitCards = [];
  List<FlowerCardData> flowerCards = [];
  final HomeService _homeService = HomeService();

  @override
  void initState() {
    super.initState();
    if (widget.isArchiveMode) {
      _loadArchiveData();
    } else {
      // 테스트용 데이터 (나중에 서버에서 받아올 예정)
      _loadTestData();
    }
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
      FlowerCardData(id: 'flower_001', name: '동백꽃', imagePath: 'assets/images/flower/camellia.png', date: '2024-09-13', order: 0),
      FlowerCardData(id: 'flower_002', name: '장미', imagePath: 'assets/images/flower/rose.png', date: '2024-09-14', order: 0),
      FlowerCardData(id: 'flower_003', name: '아카시아', imagePath: 'assets/images/flower/acacia.png', date: '2024-09-12', order: 0),
      FlowerCardData(id: 'flower_004', name: '수국', imagePath: 'assets/images/flower/hydrangea.png', date: '2024-09-15', order: 0),
      FlowerCardData(id: 'flower_005', name: '매화', imagePath: 'assets/images/flower/plum_blossom.png', date: '2024-09-16', order: 0),
      FlowerCardData(id: 'flower_006', name: '튤립', imagePath: 'assets/images/flower/tulip.png', date: '2024-09-17', order: 0),
      FlowerCardData(id: 'flower_007', name: '제비꽃', imagePath: 'assets/images/flower/violet.png', date: '2024-09-18', order: 0),
      FlowerCardData(id: 'flower_008', name: '목련', imagePath: 'assets/images/flower/magnolia.png', date: '2024-09-19', order: 0),
      FlowerCardData(id: 'flower_009', name: '벚꽃', imagePath: 'assets/images/flower/cherry_blossom.png', date: '2024-09-20', order: 0),
      FlowerCardData(id: 'flower_010', name: '코스모스', imagePath: 'assets/images/flower/cosmos.png', date: '2024-09-21', order: 0),
      FlowerCardData(id: 'flower_011', name: '해바라기', imagePath: 'assets/images/flower/sunflower.png', date: '2024-09-22', order: 0),
      FlowerCardData(id: 'flower_012', name: '팥배꽃', imagePath: 'assets/images/flower/patbae_flower.png', date: '2024-09-23', order: 0),
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

  /// 아카이브 데이터를 API에서 로드하는 메서드
  Future<void> _loadArchiveData() async {
    try {
      if (widget.archiveYear == null || 
          widget.archiveMonth == null || 
          widget.archivePeriod == null || 
          widget.archiveTreeIndex == null) {
        print('❌ 아카이브 파라미터가 누락되었습니다.');
        return;
      }

      final List<FruitCardData> archiveFruitCards = [];
      final List<FlowerCardData> archiveFlowerCards = [];

      // 나무 타입에 따라 적절한 API 호출
      if (widget.treeType == 'flower-1' || widget.treeType == 'flower-2') {
        // 꽃 나무
        final flowerData = await _homeService.getArchiveFlowerData(
          year: widget.archiveYear!,
          month: widget.archiveMonth!,
          period: widget.archivePeriod!,
          treeIndex: widget.archiveTreeIndex!,
        );

        for (final data in flowerData) {
          final flowerCard = FlowerCardData(
            id: 'archive_flower_${data.flowerId}',
            name: data.flowerName,
            imagePath: _getFlowerImagePathByName(data.flowerName),
            date: _formatArchiveDate(data.archivedAt),
            order: 0,
          );
          archiveFlowerCards.add(flowerCard);
        }
      } else if (widget.treeType == 'fruit-1' || widget.treeType == 'fruit-2') {
        // 열매 나무
        final fruitData = await _homeService.getArchiveFruitData(
          year: widget.archiveYear!,
          month: widget.archiveMonth!,
          period: widget.archivePeriod!,
          treeIndex: widget.archiveTreeIndex!,
        );

        for (final data in fruitData) {
          final fruitCard = FruitCardData(
            id: 'archive_fruit_${data.fruitId}',
            name: data.fruitName,
            imagePath: _getFruitImagePathByName(data.fruitName),
            date: _formatArchiveDate(data.archivedAt),
            puzzleImagePath: '', // 아카이브에서는 필요없음
            order: 0,
          );
          archiveFruitCards.add(fruitCard);
        }
      }

      // 날짜순으로 정렬 (최신순)
      final sortedFruit = _sortCardsByDate(archiveFruitCards);
      final sortedFlower = _sortCardsByDate(archiveFlowerCards);

      setState(() {
        fruitCards = sortedFruit;
        flowerCards = sortedFlower;
      });

      // 초기 로드 시에도 부모에 알림
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.onSelectionChanged != null) {
          widget.onSelectionChanged!(fruitCards, flowerCards);
        }
      });

    } catch (e) {
      print('❌ 아카이브 데이터 로드 오류: $e');
      // 에러 발생 시 빈 리스트로 설정
      setState(() {
        fruitCards = [];
        flowerCards = [];
      });
    }
  }

  /// 과일 이름으로 이미지 경로를 찾는 메서드
  String _getFruitImagePathByName(String fruitName) {
    // 과일 이름 매핑 (AppAssets와 일치하도록 수정)
    final fruitImageMap = {
      'cherry': AppAssets.fruit_cherry,
      'strawberry': AppAssets.fruit_strawberry,
      'kiwi': AppAssets.fruit_kiwi,
      'raspberry': AppAssets.fruit_raspberry,
      'peach': AppAssets.fruit_peach,
      'plum': AppAssets.fruit_plum,
      'mango': AppAssets.fruit_mango,
      'blueberry': AppAssets.fruit_blueberry,
      'grape': AppAssets.fruit_grape,
      'pear': AppAssets.fruit_pear,
      'persimmon': AppAssets.fruit_persimmon,
      'jujube': AppAssets.fruit_jujube,
      'apple': AppAssets.fruit_apple,
      'mandarin': AppAssets.fruit_mandarin,
      'pomegranate': AppAssets.fruit_pomegranate,
      'yuja': AppAssets.fruit_yuja,
    };
    return fruitImageMap[fruitName] ?? AppAssets.fruit_cherry; // 기본값
  }

  /// 꽃 이름으로 이미지 경로를 찾는 메서드
  String _getFlowerImagePathByName(String flowerName) {
    // 꽃 이름 매핑 (도감에 있는 꽃들만 사용)
    final flowerImageMap = {
      'camellia': AppAssets.flower_camellia,      // 동백꽃
      'acacia': AppAssets.flower_acacia,      // 아카시아
      'plum': AppAssets.flower_plum,          // 매화
      'patbae': AppAssets.flower_patbae,       // 팥배꽃
      'cherry': AppAssets.flower_cherry,        // 벚꽃
      'magnolia': AppAssets.flower_magnolia,      // 목련
      'rose': AppAssets.flower_rose,          // 장미
      'hydrangea': AppAssets.flower_hydrangea,    // 수국
      'tulip': AppAssets.flower_tulip,        // 튤립
      'violet': AppAssets.flower_violet,      // 제비꽃
      'cosmos': AppAssets.flower_cosmos,      // 코스모스
      'sunflower': AppAssets.flower_sunflower,  // 해바라기
    };
    return flowerImageMap[flowerName] ?? AppAssets.flower_camellia; // 기본값
  }

  /// 아카이브 날짜를 포맷하는 메서드
  String _formatArchiveDate(String archivedAt) {
    try {
      // ISO 8601 형식에서 날짜 부분만 추출 (YYYY-MM-DD)
      return archivedAt.split('T')[0];
    } catch (e) {
      print('❌ 날짜 포맷 오류: $e');
      return '2024-01-01'; // 기본값
    }
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

  Future<void> _onFruitCardTapped(int fruitId) async {

    print('함수 _onFruitCardTapped가 호출됨.');

    final fruitCardData = await _homeService.getFruitCardInfo(fruitId.toString());

    await showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6), // 배경색 직접 처리할 거라 투명하게
      barrierDismissible: true,
      builder: (context) => FruitCardDialog(
        imageUrl: fruitCardData?.imageUrl ?? "https://picsum.photos/600/400",
        category: fruitCardData?.category ?? "카테고리 이름",
        message: fruitCardData?.message ?? "메세지",
      ),
    );

    // TextButton(
    //   onPressed: () => Navigator.pop(context),
    //   child: const Text('돌아가기'),
    // ),
  }

  Future<void> _onFlowerCardTapped(int flowerId) async {

    print('함수 _onFlowerCardTapped가 호출됨.');

    final flowerCardData = await _homeService.getFlowerCardInfo(flowerId.toString());

    await showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6), // 배경색 직접 처리할 거라 투명하게
      barrierDismissible: true,
      builder: (context) => FlowerCardDialog(
        flowerCardData: flowerCardData,
      ),
    );
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
                          onTap: (){
                            final numericId = int.tryParse(
                              fruitCard.id.replaceAll(RegExp(r'[^0-9]'), ''),
                            ) ?? 0;
                            _onFruitCardTapped(numericId);
                          },
                        );
                      } else {
                        final flowerCard = card as FlowerCardData;
                        return FlowerCard(
                          flowerName: flowerCard.name,
                          flowerImagePath: flowerCard.imagePath,
                          date: flowerCard.date,
                          order: flowerCard.order,
                          onTap: (){
                            final numericId = int.tryParse(
                              flowerCard.id.replaceAll(RegExp(r'[^0-9]'), ''),
                            ) ?? 0;
                            _onFlowerCardTapped(numericId);
                          },
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

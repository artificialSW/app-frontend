import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/features/home/widget/fruit_card.dart';
import 'package:artificialsw_frontend/features/home/widget/flower_card.dart';

class TreeDecorateSheet extends StatelessWidget {
  final int pageIndex;
  
  const TreeDecorateSheet({
    super.key,
    required this.pageIndex,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      minChildSize: 0.20,
      initialChildSize: 0.22,
      maxChildSize: 0.88,
      snap: true,
      snapSizes: const [0.22, 0.5, 0.88],
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
                  itemCount: pageIndex == 1 ? 20 : 12, // 과일 20개, 꽃 12개
                  itemBuilder: (context, index) {
                    if (pageIndex == 1) {
                      // 2번째 페이지: 모든 과일들
                      final fruits = [
                        // 여름 과일
                        {'name': '블루베리', 'path': 'assets/images/fruit/summer/blueberry.png'},
                        {'name': '복숭아', 'path': 'assets/images/fruit/summer/peach.png'},
                        {'name': '자두', 'path': 'assets/images/fruit/summer/plum.png'},
                        {'name': '망고', 'path': 'assets/images/fruit/summer/mango.png'},
                        {'name': '코코넛', 'path': 'assets/images/fruit/summer/coconut.png'},
                        // 봄 과일
                        {'name': '딸기', 'path': 'assets/images/fruit/spring/strawberry.png'},
                        {'name': '체리', 'path': 'assets/images/fruit/spring/cherry.png'},
                        {'name': '키위', 'path': 'assets/images/fruit/spring/kiwi.png'},
                        {'name': '라즈베리', 'path': 'assets/images/fruit/spring/raspberry.png'},
                        {'name': '참외', 'path': 'assets/images/fruit/spring/oriental_melon.png'},
                        // 가을 과일
                        {'name': '무화과', 'path': 'assets/images/fruit/fall/fig.png'},
                        {'name': '포도', 'path': 'assets/images/fruit/fall/grape.png'},
                        {'name': '대추', 'path': 'assets/images/fruit/fall/jujube.png'},
                        {'name': '배', 'path': 'assets/images/fruit/fall/pear.png'},
                        {'name': '감', 'path': 'assets/images/fruit/fall/persimmon.png'},
                        // 겨울 과일
                        {'name': '사과', 'path': 'assets/images/fruit/winter/apple.png'},
                        {'name': '아보카도', 'path': 'assets/images/fruit/winter/avocado.png'},
                        {'name': '귤', 'path': 'assets/images/fruit/winter/mandarin.png'},
                        {'name': '석류', 'path': 'assets/images/fruit/winter/pomegranate.png'},
                        {'name': '유자', 'path': 'assets/images/fruit/winter/yuja.png'},
                      ];
                      
                      return FruitCard(
                        fruitName: fruits[index]['name']!,
                        fruitImagePath: fruits[index]['path']!,
                        date: '2025.09.11',
                      );
                    } else {
                      // 3번째 페이지: 모든 꽃들
                      final flowers = [
                        {'name': '아카시아', 'path': 'assets/images/flower/acacia.png'},
                        {'name': '동백꽃', 'path': 'assets/images/flower/camellia.png'},
                        {'name': '벚꽃', 'path': 'assets/images/flower/cherry_blossom.png'},
                        {'name': '코스모스', 'path': 'assets/images/flower/cosmos.png'},
                        {'name': '수국', 'path': 'assets/images/flower/hydrangea.png'},
                        {'name': '목련', 'path': 'assets/images/flower/magnolia.png'},
                        {'name': '팥배꽃', 'path': 'assets/images/flower/patbae_flower.png'},
                        {'name': '매화', 'path': 'assets/images/flower/plum_blossom.png'},
                        {'name': '장미', 'path': 'assets/images/flower/rose.png'},
                        {'name': '해바라기', 'path': 'assets/images/flower/sunflower.png'},
                        {'name': '튤립', 'path': 'assets/images/flower/tulip.png'},
                        {'name': '제비꽃', 'path': 'assets/images/flower/violet.png'},
                      ];
                      
                      return FlowerCard(
                        flowerName: flowers[index]['name']!,
                        flowerImagePath: flowers[index]['path']!,
                        date: '2025.09.11',
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

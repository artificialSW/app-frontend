import 'package:flutter/material.dart';

class Fruit {
  final String koreanName;
  final String imagePath;
  final Color textColor;
  final Color backgroundColor1;
  final Color backgroundColor2;
  final Color goFruitColor;

  const Fruit({
    required this.koreanName,
    required this.imagePath,
    required this.textColor,
    required this.backgroundColor1,
    required this.backgroundColor2,
    required this.goFruitColor,
  });
}

final Map<String, Fruit> fruitMap = {
  // 🌸 봄 (0–3)
  "cherry": Fruit(koreanName: "체리", imagePath: "assets/images/fruit/spring/cherry.png", textColor: Color(0xFFE97FA2), backgroundColor1: Color(0xFFFFF5F9), backgroundColor2: Color(0xFFFED4E2), goFruitColor: Color(0xFFE97FA2)),
  "strawberry": Fruit(koreanName: "딸기", imagePath: "assets/images/fruit/spring/strawberry.png", textColor: Color(0xFFE97FA2), backgroundColor1: Color(0xFFFFF5F9), backgroundColor2: Color(0xFFFED4E2), goFruitColor: Color(0xFFE97FA2)),
  "kiwi": Fruit(koreanName: "키위", imagePath: "assets/images/fruit/spring/kiwi.png", textColor: Color(0xFFE97FA2), backgroundColor1: Color(0xFFFFF5F9), backgroundColor2: Color(0xFFFED4E2), goFruitColor: Color(0xFFE97FA2)),
  "raspberry": Fruit(koreanName: "산딸기", imagePath: "assets/images/fruit/spring/raspberry.png", textColor: Color(0xFFE97FA2), backgroundColor1: Color(0xFFFFF5F9), backgroundColor2: Color(0xFFFED4E2), goFruitColor: Color(0xFFE97FA2)),

  // ☀️ 여름 (4–7)
  "peach": Fruit(koreanName: "복숭아", imagePath: "assets/images/fruit/summer/peach.png", textColor: Color(0xFF5CBD56), backgroundColor1: Color(0xFFF4FFEC), backgroundColor2: Color(0xFFAEE77D), goFruitColor: Color(0xFF8DCF53)),
  "plum": Fruit(koreanName: "자두", imagePath: "assets/images/fruit/summer/plum.png", textColor: Color(0xFF5CBD56), backgroundColor1: Color(0xFFF4FFEC), backgroundColor2: Color(0xFFAEE77D), goFruitColor: Color(0xFF8DCF53)),
  "mango": Fruit(koreanName: "망고", imagePath: "assets/images/fruit/summer/mango.png", textColor: Color(0xFF5CBD56), backgroundColor1: Color(0xFFF4FFEC), backgroundColor2: Color(0xFFAEE77D), goFruitColor: Color(0xFF8DCF53)),
  "blueberry": Fruit(koreanName: "블루베리", imagePath: "assets/images/fruit/summer/blueberry.png", textColor: Color(0xFF5CBD56), backgroundColor1: Color(0xFFF4FFEC), backgroundColor2: Color(0xFFAEE77D), goFruitColor: Color(0xFF8DCF53)),

  // 🍂 가을 (8–11)
  "grape": Fruit(koreanName: "포도", imagePath: "assets/images/fruit/fall/grape.png", textColor: Color(0xFFFF9021), backgroundColor1: Color(0xFFFFF6ED), backgroundColor2: Color(0xFFEDA359), goFruitColor: Color(0xFFFF9021)),
  "pear": Fruit(koreanName: "배", imagePath: "assets/images/fruit/fall/pear.png", textColor: Color(0xFFFF9021), backgroundColor1: Color(0xFFFFF6ED), backgroundColor2: Color(0xFFEDA359), goFruitColor: Color(0xFFFF9021)),
  "persimmon": Fruit(koreanName: "감", imagePath: "assets/images/fruit/fall/persimmon.png", textColor: Color(0xFFFF9021), backgroundColor1: Color(0xFFFFF6ED), backgroundColor2: Color(0xFFEDA359), goFruitColor: Color(0xFFFF9021)),
  "jujube": Fruit(koreanName: "대추", imagePath: "assets/images/fruit/fall/jujube.png", textColor: Color(0xFFFF9021), backgroundColor1: Color(0xFFFFF6ED), backgroundColor2: Color(0xFFEDA359), goFruitColor: Color(0xFFFF9021)),

  // ❄️ 겨울 (12–15)
  "apple": Fruit(koreanName: "사과", imagePath: "assets/images/fruit/winter/apple.png", textColor: Color(0xFF58B8CB), backgroundColor1: Color(0xFFE0F9FE), backgroundColor2: Color(0xFF70E9FF), goFruitColor: Color(0xFF58B8CB)),
  "mandarin": Fruit(koreanName: "귤", imagePath: "assets/images/fruit/winter/mandarin.png", textColor: Color(0xFF58B8CB), backgroundColor1: Color(0xFFE0F9FE), backgroundColor2: Color(0xFF70E9FF), goFruitColor: Color(0xFF58B8CB)),
  "pomegranate": Fruit(koreanName: "석류", imagePath: "assets/images/fruit/winter/pomegranate.png", textColor: Color(0xFF58B8CB), backgroundColor1: Color(0xFFE0F9FE), backgroundColor2: Color(0xFF70E9FF), goFruitColor: Color(0xFF58B8CB)),
  "yuja": Fruit(koreanName: "유자", imagePath: "assets/images/fruit/winter/yuja.png", textColor: Color(0xFF58B8CB), backgroundColor1: Color(0xFFE0F9FE), backgroundColor2: Color(0xFF70E9FF), goFruitColor: Color(0xFF58B8CB)),
};

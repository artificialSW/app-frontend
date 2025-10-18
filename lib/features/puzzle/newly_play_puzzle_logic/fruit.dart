class Fruit {
  final String koreanName;
  final String imagePath;

  const Fruit({
    required this.koreanName,
    required this.imagePath,
  });
}

final Map<String, Fruit> fruitMap = {
  // 🌸 봄 (0–3)
  "cherry": Fruit(koreanName: "체리", imagePath: "assets/images/fruit/spring/cherry.png"),
  "strawberry": Fruit(koreanName: "딸기", imagePath: "assets/images/fruit/spring/strawberry.png"),
  "kiwi": Fruit(koreanName: "키위", imagePath: "assets/images/fruit/spring/kiwi.png"),
  "raspberry": Fruit(koreanName: "산딸기", imagePath: "assets/images/fruit/spring/raspberry.png"),

  // ☀️ 여름 (4–7)
  "peach": Fruit(koreanName: "복숭아", imagePath: "assets/images/fruit/summer/peach.png"),
  "plum": Fruit(koreanName: "자두", imagePath: "assets/images/fruit/summer/plum.png"),
  "mango": Fruit(koreanName: "망고", imagePath: "assets/images/fruit/summer/mango.png"),
  "blueberry": Fruit(koreanName: "블루베리", imagePath: "assets/images/fruit/summer/blueberry.png"),

  // 🍂 가을 (8–11)
  "grape": Fruit(koreanName: "포도", imagePath: "assets/images/fruit/autumn/grape.png"),
  "pear": Fruit(koreanName: "배", imagePath: "assets/images/fruit/autumn/pear.png"),
  "persimmon": Fruit(koreanName: "감", imagePath: "assets/images/fruit/autumn/persimmon.png"),
  "jujube": Fruit(koreanName: "대추", imagePath: "assets/images/fruit/autumn/jujube.png"),

  // ❄️ 겨울 (12–15)
  "apple": Fruit(koreanName: "사과", imagePath: "assets/images/fruit/winter/apple.png"),
  "mandarin": Fruit(koreanName: "귤", imagePath: "assets/images/fruit/winter/mandarin.png"),
  "pomegranate": Fruit(koreanName: "석류", imagePath: "assets/images/fruit/winter/pomegranate.png"),
  "yuja": Fruit(koreanName: "유자", imagePath: "assets/images/fruit/winter/yuja.png"),
};

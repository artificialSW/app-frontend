import 'package:flutter/material.dart';

class Flower {
  final String koreanName;
  final String? imagePath;

  const Flower({
    required this.koreanName,
    this.imagePath
  });
}

final Map<String, Flower> flowerMap = {
  // 🌸 봄 (0–3)
  "camellia": Flower(koreanName: "동백꽃", imagePath: "assets/images/flower/camellia.png"),
  "acacia": Flower(koreanName: "아카시아", imagePath: "assets/images/flower/acacia.png"),
  "plum": Flower(koreanName: "매화꽃", imagePath: "assets/images/flower/plum_blossom.png"),
  "patbae": Flower(koreanName: "팥배꽃", imagePath: "assets/images/flower/patbae_flower.png"),

  "cherry": Flower(koreanName: "벚꽃", imagePath: "assets/images/flower/cherry_blossom.png"),
  "mangolia": Flower(koreanName: "목련", imagePath: "assets/images/flower/mangolia.png"),
  "rose": Flower(koreanName: "장미", imagePath: "assets/images/flower/rose.png"),
  "hydrangea": Flower(koreanName: "수국", imagePath: "assets/images/flower/hydrangea.png"),

  "tulip": Flower(koreanName: "튤립", imagePath: "assets/images/flower/tulip.png"),
  "violet": Flower(koreanName: "제비꽃", imagePath: "assets/images/flower/violet.png"),
  "cosmos": Flower(koreanName: "코스모스", imagePath: "assets/images/flower/cosmos"),
  "sunflower": Flower(koreanName: "해바라기", imagePath: "assets/images/flower/sunflower"),
};

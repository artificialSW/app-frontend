import 'package:flutter/material.dart';

class Flower {
  final String koreanName;

  const Flower({
    required this.koreanName,
  });
}

final Map<String, Flower> flowerMap = {
  // 🌸 봄 (0–3)
  "camellia": Flower(koreanName: "동백꽃"),
  "acacia": Flower(koreanName: "아카시아"),
  "plum": Flower(koreanName: "매화꽃"),
  "patbae": Flower(koreanName: "팥배꽃"),

  "cherry": Flower(koreanName: "벚꽃"),
  "mangolia": Flower(koreanName: "목련"),
  "rose": Flower(koreanName: "장미"),
  "hydrangea": Flower(koreanName: "수국"),

  "tulip": Flower(koreanName: "튤립"),
  "violet": Flower(koreanName: "제비꽃"),
  "cosmos": Flower(koreanName: "코스모스"),
  "sunflower": Flower(koreanName: "해바라기"),
};

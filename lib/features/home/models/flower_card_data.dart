/// 꽃 카드의 데이터 모델
/// 서버에서 받아온 꽃 카드 정보를 담는 클래스
class FlowerCardData {
  final String id;                    // 고유 식별자
  final String name;                  // 꽃 이름 (예: "장미", "벚꽃")
  final String imagePath;             // 꽃 이미지 경로
  final String date;                  // 소통한 날짜
  final int order;                    // 나무에 달린 위치 (0: 안달림, 1-3: 위치)

  const FlowerCardData({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.date,
    this.order = 0,                   // 기본값 0 (안달림)
  });

  /// FlowerCardData 복사 메서드
  FlowerCardData copyWith({
    String? id,
    String? name,
    String? imagePath,
    String? date,
    int? order,
  }) {
    return FlowerCardData(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      date: date ?? this.date,
      order: order ?? this.order,
    );
  }

}

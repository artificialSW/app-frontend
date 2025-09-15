/// 나무 정보를 담는 데이터 모델
/// 서버에서 받아온 나무의 기본 정보를 저장하는 클래스
class Tree {
  final String id;              // 나무 고유 식별자 (백엔드 API 통신용)
  final String name;            // 나무 이름 (사용자가 지은 이름)
  final String namingDate;      // 나무 이름을 지은 날짜
  final int fruitCount;         // 현재 달린 과일 개수
  final int flowerCount;        // 현재 달린 꽃 개수

  const Tree({
    required this.id,
    required this.name,
    required this.namingDate,
    required this.fruitCount,
    required this.flowerCount,
  });

  /// Tree 객체 복사 메서드 (불변성 유지)
  /// 특정 필드만 변경하여 새로운 Tree 객체를 생성
  Tree copyWith({
    String? id,
    String? name,
    String? namingDate,
    int? fruitCount,
    int? flowerCount,
  }) {
    return Tree(
      id: id ?? this.id,
      name: name ?? this.name,
      namingDate: namingDate ?? this.namingDate,
      fruitCount: fruitCount ?? this.fruitCount,
      flowerCount: flowerCount ?? this.flowerCount,
    );
  }
}

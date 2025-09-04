// 가족 구성원 모델 (동적 데이터용)
class FamilyMember {
  final String id;    // 서버/DB 고유 ID
  final String name;  // 표시 이름

  const FamilyMember({required this.id, required this.name});
}

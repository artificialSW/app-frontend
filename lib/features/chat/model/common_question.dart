// 앱 전역에서 재사용할 가벼운 데이터 모델
class CommonQuestion {
  final String id;        // 고유키(백엔드 연동 대비)
  final String title;
  final String description;
  final int likes;
  final int comments;

  const CommonQuestion({
    required this.id,
    required this.title,
    required this.description,
    required this.likes,
    required this.comments,
  });
}

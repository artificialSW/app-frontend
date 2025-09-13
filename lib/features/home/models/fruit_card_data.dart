/// 과일 카드의 데이터 모델
/// 서버에서 받아온 과일 카드 정보를 담는 클래스
class FruitCardData {
  final String id;                    // 고유 식별자
  final String name;                  // 과일 이름 (예: "사과", "딸기")
  final String imagePath;             // 과일 이미지 경로
  final String date;                  // 퍼즐을 푼 날짜
  final String puzzleImagePath;       // 퍼즐 이미지 경로 (카드 클릭 시 표시용)
  final bool isSelected;              // 선택 상태 (꾸미기용)

  const FruitCardData({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.date,
    required this.puzzleImagePath,
    required this.isSelected,
  });

  /// 날짜를 기준으로 계절을 계산하는 메서드
  String get season {
    final dateTime = DateTime.parse(date);
    final month = dateTime.month;
    
    if (month >= 3 && month <= 5) {
      return 'spring';
    } else if (month >= 6 && month <= 8) {
      return 'summer';
    } else if (month >= 9 && month <= 11) {
      return 'fall';
    } else {
      return 'winter';
    }
  }

}

/// 꽃 카드의 데이터 모델
/// 서버에서 받아온 꽃 카드 정보를 담는 클래스
class FlowerCardData {
  final String id;                    // 고유 식별자
  final String name;                  // 꽃 이름 (예: "장미", "벚꽃")
  final String imagePath;             // 꽃 이미지 경로
  final String emotion;               // 감정/성격 (love, comfort, joy, hobby, memory, special)
  final String date;                  // 소통한 날짜
  final String communicationText;     // 소통 내용 텍스트 (카드 클릭 시 표시용)
  final bool isSelected;              // 선택 상태 (꾸미기용)

  const FlowerCardData({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.emotion,
    required this.date,
    required this.communicationText,
    required this.isSelected,
  });

}

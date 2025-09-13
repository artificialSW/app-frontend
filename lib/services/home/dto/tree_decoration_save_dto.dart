import 'package:json_annotation/json_annotation.dart';

part 'tree_decoration_save_dto.g.dart';

/// 나무 꾸미기 선택 상태 저장용 DTO
/// 서버에 선택된 카드 ID 목록을 전송할 때 사용
@JsonSerializable()
class TreeDecorationSaveDto {
  final List<String> selectedFruitIds;
  final List<String> selectedFlowerIds;

  const TreeDecorationSaveDto({
    required this.selectedFruitIds,
    required this.selectedFlowerIds,
  });

  /// JSON에서 TreeDecorationSaveDto 생성
  factory TreeDecorationSaveDto.fromJson(Map<String, dynamic> json) =>
      _$TreeDecorationSaveDtoFromJson(json);

  /// TreeDecorationSaveDto를 JSON으로 변환
  Map<String, dynamic> toJson() => _$TreeDecorationSaveDtoToJson(this);
}

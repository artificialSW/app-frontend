import 'package:json_annotation/json_annotation.dart';

part 'tree_id_response_dto.g.dart';

/// 나무 ID 응답용 DTO
/// 서버에서 나무 ID를 받아올 때 사용
@JsonSerializable()
class TreeIdResponseDto {
  final String treeId;
  final String treeName;

  const TreeIdResponseDto({
    required this.treeId,
    required this.treeName,
  });

  /// JSON에서 TreeIdResponseDto 생성
  factory TreeIdResponseDto.fromJson(Map<String, dynamic> json) =>
      _$TreeIdResponseDtoFromJson(json);

  /// TreeIdResponseDto를 JSON으로 변환
  Map<String, dynamic> toJson() => _$TreeIdResponseDtoToJson(this);
}

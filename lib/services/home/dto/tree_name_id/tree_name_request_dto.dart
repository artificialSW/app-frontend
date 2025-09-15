import 'package:json_annotation/json_annotation.dart';

part 'tree_name_request_dto.g.dart';

/// 나무 이름 입력 요청용 DTO
/// 서버에 나무 이름을 전송할 때 사용
@JsonSerializable()
class TreeNameRequestDto {
  final String treeName;

  const TreeNameRequestDto({
    required this.treeName,
  });

  /// JSON에서 TreeNameRequestDto 생성
  factory TreeNameRequestDto.fromJson(Map<String, dynamic> json) =>
      _$TreeNameRequestDtoFromJson(json);

  /// TreeNameRequestDto를 JSON으로 변환
  Map<String, dynamic> toJson() => _$TreeNameRequestDtoToJson(this);
}

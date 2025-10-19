import 'package:json_annotation/json_annotation.dart';

part 'archive_flower_response_dto.g.dart';

/// 아카이브 꽃 데이터 응답 DTO
@JsonSerializable()
class ArchiveFlowerResponseDto {
  /// 꽃 ID
  final int flowerId;
  
  /// 꽃 이름
  final String flowerName;
  
  /// 아카이브된 날짜
  final String archivedAt;

  const ArchiveFlowerResponseDto({
    required this.flowerId,
    required this.flowerName,
    required this.archivedAt,
  });

  factory ArchiveFlowerResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ArchiveFlowerResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ArchiveFlowerResponseDtoToJson(this);

  static List<ArchiveFlowerResponseDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => ArchiveFlowerResponseDto.fromJson(json))
        .toList();
  }
}

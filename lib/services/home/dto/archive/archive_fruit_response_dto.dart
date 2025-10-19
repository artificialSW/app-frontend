import 'package:json_annotation/json_annotation.dart';

part 'archive_fruit_response_dto.g.dart';

/// 아카이브 열매 데이터 응답 DTO
@JsonSerializable()
class ArchiveFruitResponseDto {
  /// 열매 ID
  final int fruitId;
  
  /// 열매 이름
  final String fruitName;
  
  /// 아카이브된 날짜
  final String archivedAt;

  const ArchiveFruitResponseDto({
    required this.fruitId,
    required this.fruitName,
    required this.archivedAt,
  });

  factory ArchiveFruitResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ArchiveFruitResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ArchiveFruitResponseDtoToJson(this);

  static List<ArchiveFruitResponseDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => ArchiveFruitResponseDto.fromJson(json))
        .toList();
  }
}

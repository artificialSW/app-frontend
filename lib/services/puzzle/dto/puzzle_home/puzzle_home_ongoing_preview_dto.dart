import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'puzzle_home_ongoing_preview_dto.g.dart'; // 자동 생성 파일

/// 퍼즐 데이터 모델
@JsonSerializable()
class PuzzleHomeOngoingPreviewDto {
  final int puzzleId;
  final String imageUrl;
  final int size;
  final List<int> completedPiecesId;
  final String lastSavedAt;

  //선언 시점은 꼭 사용자가 '퍼즐 풀기' 버튼을 눌렀을 때로!! 왜냐면 size도 선언할때 같이 적어야한다고 선언했기 때문
  PuzzleHomeOngoingPreviewDto({
    required this.puzzleId,
    required this.imageUrl,
    required this.size, //어쨌든 null 입력한것도 입력한거니까 에러 안 뜨는듯
    required this.completedPiecesId,
    required this.lastSavedAt,
  });

  factory PuzzleHomeOngoingPreviewDto.fromJson(Map<String, dynamic> json) =>
      _$PuzzleHomeOngoingPreviewDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PuzzleHomeOngoingPreviewDtoToJson(this);
}
//다시 풀기 할때 DB에서 가져와서 퍼즐 다시 생성해야할수도 있으니까.
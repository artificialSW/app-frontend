import 'package:artificialsw_frontend/services/puzzle/dto/puzzle_home/puzzle_home_ongoing_preview_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/puzzle_home/puzzle_home_completed_preview_dto.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'puzzle_home_get_dto.g.dart'; // 자동 생성 파일

/// 퍼즐 데이터 모델
@JsonSerializable()
class PuzzleHomeGetDto {
  final List<String> subject;
  final List<PuzzleHomeOngoingPreviewDto?> inProgress;
  final List<PuzzleHomeCompletedPreviewDto?> completedThisWeek;
  final bool isFull; //다음주 퍼즐에 사용될 사진 상한 찼는지 여부 알려줌

  //선언 시점은 꼭 사용자가 '퍼즐 풀기' 버튼을 눌렀을 때로!! 왜냐면 size도 선언할때 같이 적어야한다고 선언했기 때문
  PuzzleHomeGetDto({
    required this.subject,
    required this.inProgress,
    required this.completedThisWeek,
    required this.isFull,
  });

  factory PuzzleHomeGetDto.fromJson(Map<String, dynamic> json) =>
      _$PuzzleHomeGetDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PuzzleHomeGetDtoToJson(this);
}
//다시 풀기 할때 DB에서 가져와서 퍼즐 다시 생성해야할수도 있으니까.
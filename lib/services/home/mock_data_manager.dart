import 'package:artificialsw_frontend/services/home/dto/archive/archive_flower_response_dto.dart';
import 'package:artificialsw_frontend/services/home/dto/archive/archive_fruit_response_dto.dart';

/// 홈용 목데이터 매니저
/// API 호출과 동일한 형식으로 목데이터를 제공
class MockDataManager {
  static final MockDataManager _instance = MockDataManager._internal();
  factory MockDataManager() => _instance;
  MockDataManager._internal();

  /// 2025년 5월부터 10월까지의 꽃 목데이터
  /// API 호출과 동일한 형식으로 반환
  Future<List<ArchiveFlowerResponseDto>> getArchiveFlowerData({
    required int year,
    required int month,
    required int period,
    required int treeIndex,
  }) async {
    // API 호출 시뮬레이션을 위한 지연
    await Future.delayed(const Duration(milliseconds: 500));

    // 2025년 5월부터 10월까지의 데이터만 제공
    if (year != 2025 || month < 5 || month > 10) {
      return [];
    }

    // 꽃 나무별 데이터 매핑 (treeIndex 1, 2)
    switch (treeIndex) {
      case 1: // 첫번째 나무 (꽃)
        return _getFirstTreeData(year, month, period);
      case 2: // 두번째 나무 (꽃)
        return _getSecondTreeData(year, month, period);
      default:
        return [];
    }
  }

  /// 2025년 5월부터 10월까지의 열매 목데이터
  /// API 호출과 동일한 형식으로 반환
  Future<List<ArchiveFruitResponseDto>> getArchiveFruitData({
    required int year,
    required int month,
    required int period,
    required int treeIndex,
  }) async {
    // API 호출 시뮬레이션을 위한 지연
    await Future.delayed(const Duration(milliseconds: 500));

    // 2025년 5월부터 10월까지의 데이터만 제공
    if (year != 2025 || month < 5 || month > 10) {
      return [];
    }

    // 열매 나무별 데이터 매핑 (treeIndex 3, 4)
    switch (treeIndex) {
      case 3: // 세번째 나무 (열매)
        return _getThirdTreeData(year, month, period);
      case 4: // 네번째 나무 (열매)
        return _getFourthTreeData(year, month, period);
      default:
        return [];
    }
  }

  /// 첫번째 나무 데이터 (꽃)
  List<ArchiveFlowerResponseDto> _getFirstTreeData(int year, int month, int period) {
    final data = <ArchiveFlowerResponseDto>[];
    
    // 5월 데이터
    if (month == 5) {
      if (period == 1) {
        data.addAll([
          ArchiveFlowerResponseDto(flowerId: 1, flowerName: '동백꽃', archivedAt: '2025-05-01T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 2, flowerName: '아카시아', archivedAt: '2025-05-03T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 3, flowerName: '매화', archivedAt: '2025-05-05T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 4, flowerName: '팥배꽃', archivedAt: '2025-05-07T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 5, flowerName: '벚꽃', archivedAt: '2025-05-09T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 6, flowerName: '목련', archivedAt: '2025-05-11T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 7, flowerName: '장미', archivedAt: '2025-05-13T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 8, flowerName: '해바라기', archivedAt: '2025-05-15T00:00:00Z'),
        ]);
      } else {
        data.addAll([
          ArchiveFlowerResponseDto(flowerId: 4, flowerName: '팥배꽃', archivedAt: '2025-05-18T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 5, flowerName: '벚꽃', archivedAt: '2025-05-22T00:00:00Z'),
        ]);
      }
    }
    
    // 6월 데이터
    if (month == 6) {
      if (period == 1) {
        data.addAll([
          ArchiveFlowerResponseDto(flowerId: 1, flowerName: '동백꽃', archivedAt: '2025-06-01T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 2, flowerName: '아카시아', archivedAt: '2025-06-03T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 3, flowerName: '매화', archivedAt: '2025-06-05T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 4, flowerName: '팥배꽃', archivedAt: '2025-06-07T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 5, flowerName: '벚꽃', archivedAt: '2025-06-09T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 6, flowerName: '목련', archivedAt: '2025-06-11T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 7, flowerName: '장미', archivedAt: '2025-06-13T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 8, flowerName: '해바라기', archivedAt: '2025-06-15T00:00:00Z'),
        ]);
      } else {
        data.addAll([
          ArchiveFlowerResponseDto(flowerId: 9, flowerName: '수국', archivedAt: '2025-06-17T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 10, flowerName: '코스모스', archivedAt: '2025-06-19T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 11, flowerName: '제비꽃', archivedAt: '2025-06-21T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 12, flowerName: '튤립', archivedAt: '2025-06-23T00:00:00Z'),
        ]);
      }
    }
    
    // 7월 데이터
    if (month == 7) {
      if (period == 1) {
        data.addAll([
          ArchiveFlowerResponseDto(flowerId: 1, flowerName: '동백꽃', archivedAt: '2025-07-01T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 2, flowerName: '아카시아', archivedAt: '2025-07-03T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 3, flowerName: '매화', archivedAt: '2025-07-05T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 4, flowerName: '팥배꽃', archivedAt: '2025-07-07T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 5, flowerName: '벚꽃', archivedAt: '2025-07-09T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 6, flowerName: '목련', archivedAt: '2025-07-11T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 7, flowerName: '장미', archivedAt: '2025-07-13T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 8, flowerName: '해바라기', archivedAt: '2025-07-15T00:00:00Z'),
        ]);
      } else {
        data.addAll([
          ArchiveFlowerResponseDto(flowerId: 9, flowerName: '수국', archivedAt: '2025-07-17T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 10, flowerName: '코스모스', archivedAt: '2025-07-19T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 11, flowerName: '제비꽃', archivedAt: '2025-07-21T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 12, flowerName: '튤립', archivedAt: '2025-07-23T00:00:00Z'),
        ]);
      }
    }
    
    // 8월 데이터
    if (month == 8) {
      if (period == 1) {
        data.addAll([
          ArchiveFlowerResponseDto(flowerId: 1, flowerName: '동백꽃', archivedAt: '2025-08-01T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 2, flowerName: '아카시아', archivedAt: '2025-08-03T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 3, flowerName: '매화', archivedAt: '2025-08-05T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 4, flowerName: '팥배꽃', archivedAt: '2025-08-07T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 5, flowerName: '벚꽃', archivedAt: '2025-08-09T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 6, flowerName: '목련', archivedAt: '2025-08-11T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 7, flowerName: '장미', archivedAt: '2025-08-13T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 8, flowerName: '해바라기', archivedAt: '2025-08-15T00:00:00Z'),
        ]);
      } else {
        data.addAll([
          ArchiveFlowerResponseDto(flowerId: 9, flowerName: '수국', archivedAt: '2025-08-17T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 10, flowerName: '코스모스', archivedAt: '2025-08-19T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 11, flowerName: '제비꽃', archivedAt: '2025-08-21T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 12, flowerName: '튤립', archivedAt: '2025-08-23T00:00:00Z'),
        ]);
      }
    }
    
    // 9월 데이터
    if (month == 9) {
      if (period == 1) {
        data.addAll([
          ArchiveFlowerResponseDto(flowerId: 1, flowerName: '동백꽃', archivedAt: '2025-09-01T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 2, flowerName: '아카시아', archivedAt: '2025-09-03T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 3, flowerName: '매화', archivedAt: '2025-09-05T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 4, flowerName: '팥배꽃', archivedAt: '2025-09-07T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 5, flowerName: '벚꽃', archivedAt: '2025-09-09T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 6, flowerName: '목련', archivedAt: '2025-09-11T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 7, flowerName: '장미', archivedAt: '2025-09-13T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 8, flowerName: '해바라기', archivedAt: '2025-09-15T00:00:00Z'),
        ]);
      } else {
        data.addAll([
          ArchiveFlowerResponseDto(flowerId: 9, flowerName: '수국', archivedAt: '2025-09-17T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 10, flowerName: '코스모스', archivedAt: '2025-09-19T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 11, flowerName: '제비꽃', archivedAt: '2025-09-21T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 12, flowerName: '튤립', archivedAt: '2025-09-23T00:00:00Z'),
        ]);
      }
    }
    
    // 10월 데이터
    if (month == 10) {
      if (period == 1) {
        data.addAll([
          ArchiveFlowerResponseDto(flowerId: 1, flowerName: '동백꽃', archivedAt: '2025-10-01T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 2, flowerName: '아카시아', archivedAt: '2025-10-03T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 3, flowerName: '매화', archivedAt: '2025-10-05T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 4, flowerName: '팥배꽃', archivedAt: '2025-10-07T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 5, flowerName: '벚꽃', archivedAt: '2025-10-09T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 6, flowerName: '목련', archivedAt: '2025-10-11T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 7, flowerName: '장미', archivedAt: '2025-10-13T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 8, flowerName: '해바라기', archivedAt: '2025-10-15T00:00:00Z'),
        ]);
      } else {
        data.addAll([
          ArchiveFlowerResponseDto(flowerId: 9, flowerName: '수국', archivedAt: '2025-10-17T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 10, flowerName: '코스모스', archivedAt: '2025-10-19T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 11, flowerName: '제비꽃', archivedAt: '2025-10-21T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 12, flowerName: '튤립', archivedAt: '2025-10-23T00:00:00Z'),
        ]);
      }
    }
    
    return data;
  }

  /// 두번째 나무 데이터 (꽃)
  List<ArchiveFlowerResponseDto> _getSecondTreeData(int year, int month, int period) {
    final data = <ArchiveFlowerResponseDto>[];
    
    // 5월 데이터
    if (month == 5) {
      if (period == 1) {
        data.addAll([
          ArchiveFlowerResponseDto(flowerId: 1, flowerName: '동백꽃', archivedAt: '2025-05-02T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 2, flowerName: '아카시아', archivedAt: '2025-05-04T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 3, flowerName: '매화', archivedAt: '2025-05-06T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 4, flowerName: '팥배꽃', archivedAt: '2025-05-08T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 5, flowerName: '벚꽃', archivedAt: '2025-05-10T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 6, flowerName: '목련', archivedAt: '2025-05-12T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 7, flowerName: '장미', archivedAt: '2025-05-14T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 8, flowerName: '해바라기', archivedAt: '2025-05-16T00:00:00Z'),
        ]);
      } else {
        data.addAll([
          ArchiveFlowerResponseDto(flowerId: 9, flowerName: '수국', archivedAt: '2025-05-18T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 10, flowerName: '코스모스', archivedAt: '2025-05-20T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 11, flowerName: '제비꽃', archivedAt: '2025-05-22T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 12, flowerName: '튤립', archivedAt: '2025-05-24T00:00:00Z'),
        ]);
      }
    }
    
    // 6월 데이터
    if (month == 6) {
      if (period == 1) {
        data.addAll([
          ArchiveFlowerResponseDto(flowerId: 1, flowerName: '동백꽃', archivedAt: '2025-06-02T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 2, flowerName: '아카시아', archivedAt: '2025-06-04T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 3, flowerName: '매화', archivedAt: '2025-06-06T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 4, flowerName: '팥배꽃', archivedAt: '2025-06-08T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 5, flowerName: '벚꽃', archivedAt: '2025-06-10T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 6, flowerName: '목련', archivedAt: '2025-06-12T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 7, flowerName: '장미', archivedAt: '2025-06-14T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 8, flowerName: '해바라기', archivedAt: '2025-06-16T00:00:00Z'),
        ]);
      } else {
        data.addAll([
          ArchiveFlowerResponseDto(flowerId: 9, flowerName: '수국', archivedAt: '2025-06-18T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 10, flowerName: '코스모스', archivedAt: '2025-06-20T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 11, flowerName: '제비꽃', archivedAt: '2025-06-22T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 12, flowerName: '튤립', archivedAt: '2025-06-24T00:00:00Z'),
        ]);
      }
    }
    
    // 7월 데이터
    if (month == 7) {
      if (period == 1) {
        data.addAll([
          ArchiveFlowerResponseDto(flowerId: 1, flowerName: '동백꽃', archivedAt: '2025-07-02T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 2, flowerName: '아카시아', archivedAt: '2025-07-04T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 3, flowerName: '매화', archivedAt: '2025-07-06T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 4, flowerName: '팥배꽃', archivedAt: '2025-07-08T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 5, flowerName: '벚꽃', archivedAt: '2025-07-10T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 6, flowerName: '목련', archivedAt: '2025-07-12T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 7, flowerName: '장미', archivedAt: '2025-07-14T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 8, flowerName: '해바라기', archivedAt: '2025-07-16T00:00:00Z'),
        ]);
      } else {
        data.addAll([
          ArchiveFlowerResponseDto(flowerId: 9, flowerName: '수국', archivedAt: '2025-07-18T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 10, flowerName: '코스모스', archivedAt: '2025-07-20T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 11, flowerName: '제비꽃', archivedAt: '2025-07-22T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 12, flowerName: '튤립', archivedAt: '2025-07-24T00:00:00Z'),
        ]);
      }
    }
    
    // 8월 데이터
    if (month == 8) {
      if (period == 1) {
        data.addAll([
          ArchiveFlowerResponseDto(flowerId: 1, flowerName: '동백꽃', archivedAt: '2025-08-02T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 2, flowerName: '아카시아', archivedAt: '2025-08-04T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 3, flowerName: '매화', archivedAt: '2025-08-06T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 4, flowerName: '팥배꽃', archivedAt: '2025-08-08T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 5, flowerName: '벚꽃', archivedAt: '2025-08-10T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 6, flowerName: '목련', archivedAt: '2025-08-12T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 7, flowerName: '장미', archivedAt: '2025-08-14T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 8, flowerName: '해바라기', archivedAt: '2025-08-16T00:00:00Z'),
        ]);
      } else {
        data.addAll([
          ArchiveFlowerResponseDto(flowerId: 9, flowerName: '수국', archivedAt: '2025-08-18T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 10, flowerName: '코스모스', archivedAt: '2025-08-20T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 11, flowerName: '제비꽃', archivedAt: '2025-08-22T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 12, flowerName: '튤립', archivedAt: '2025-08-24T00:00:00Z'),
        ]);
      }
    }
    
    // 9월 데이터
    if (month == 9) {
      if (period == 1) {
        data.addAll([
          ArchiveFlowerResponseDto(flowerId: 1, flowerName: '동백꽃', archivedAt: '2025-09-02T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 2, flowerName: '아카시아', archivedAt: '2025-09-04T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 3, flowerName: '매화', archivedAt: '2025-09-06T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 4, flowerName: '팥배꽃', archivedAt: '2025-09-08T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 5, flowerName: '벚꽃', archivedAt: '2025-09-10T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 6, flowerName: '목련', archivedAt: '2025-09-12T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 7, flowerName: '장미', archivedAt: '2025-09-14T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 8, flowerName: '해바라기', archivedAt: '2025-09-16T00:00:00Z'),
        ]);
      } else {
        data.addAll([
          ArchiveFlowerResponseDto(flowerId: 9, flowerName: '수국', archivedAt: '2025-09-18T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 10, flowerName: '코스모스', archivedAt: '2025-09-20T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 11, flowerName: '제비꽃', archivedAt: '2025-09-22T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 12, flowerName: '튤립', archivedAt: '2025-09-24T00:00:00Z'),
        ]);
      }
    }
    
    // 10월 데이터
    if (month == 10) {
      if (period == 1) {
        data.addAll([
          ArchiveFlowerResponseDto(flowerId: 1, flowerName: '동백꽃', archivedAt: '2025-10-02T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 2, flowerName: '아카시아', archivedAt: '2025-10-04T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 3, flowerName: '매화', archivedAt: '2025-10-06T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 4, flowerName: '팥배꽃', archivedAt: '2025-10-08T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 5, flowerName: '벚꽃', archivedAt: '2025-10-10T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 6, flowerName: '목련', archivedAt: '2025-10-12T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 7, flowerName: '장미', archivedAt: '2025-10-14T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 8, flowerName: '해바라기', archivedAt: '2025-10-16T00:00:00Z'),
        ]);
      } else {
        data.addAll([
          ArchiveFlowerResponseDto(flowerId: 9, flowerName: '수국', archivedAt: '2025-10-18T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 10, flowerName: '코스모스', archivedAt: '2025-10-20T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 11, flowerName: '제비꽃', archivedAt: '2025-10-22T00:00:00Z'),
          ArchiveFlowerResponseDto(flowerId: 12, flowerName: '튤립', archivedAt: '2025-10-24T00:00:00Z'),
        ]);
      }
    }
    
    return data;
  }

  /// 세번째 나무 데이터 (열매)
  List<ArchiveFruitResponseDto> _getThirdTreeData(int year, int month, int period) {
    final data = <ArchiveFruitResponseDto>[];
    
    // 5월 데이터
    if (month == 5) {
      if (period == 1) {
        data.addAll([
          ArchiveFruitResponseDto(fruitId: 1, fruitName: '체리', archivedAt: '2025-05-01T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 2, fruitName: '딸기', archivedAt: '2025-05-03T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 3, fruitName: '키위', archivedAt: '2025-05-05T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 4, fruitName: '산딸기', archivedAt: '2025-05-07T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 5, fruitName: '복숭아', archivedAt: '2025-05-09T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 6, fruitName: '자두', archivedAt: '2025-05-11T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 7, fruitName: '망고', archivedAt: '2025-05-13T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 8, fruitName: '블루베리', archivedAt: '2025-05-15T00:00:00Z'),
        ]);
      } else {
        data.addAll([
          ArchiveFruitResponseDto(fruitId: 9, fruitName: '포도', archivedAt: '2025-05-17T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 10, fruitName: '포도', archivedAt: '2025-05-19T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 11, fruitName: '레몬', archivedAt: '2025-05-21T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 12, fruitName: '감', archivedAt: '2025-05-23T00:00:00Z'),
        ]);
      }
    }
    
    // 6월 데이터
    if (month == 6) {
      if (period == 1) {
        data.addAll([
          ArchiveFruitResponseDto(fruitId: 1, fruitName: '체리', archivedAt: '2025-06-01T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 2, fruitName: '딸기', archivedAt: '2025-06-03T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 3, fruitName: '키위', archivedAt: '2025-06-05T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 4, fruitName: '산딸기', archivedAt: '2025-06-07T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 5, fruitName: '복숭아', archivedAt: '2025-06-09T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 6, fruitName: '자두', archivedAt: '2025-06-11T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 7, fruitName: '망고', archivedAt: '2025-06-13T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 8, fruitName: '블루베리', archivedAt: '2025-06-15T00:00:00Z'),
        ]);
      } else {
        data.addAll([
          ArchiveFruitResponseDto(fruitId: 9, fruitName: '포도', archivedAt: '2025-06-17T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 10, fruitName: '포도', archivedAt: '2025-06-19T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 11, fruitName: '레몬', archivedAt: '2025-06-21T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 12, fruitName: '감', archivedAt: '2025-06-23T00:00:00Z'),
        ]);
      }
    }
    
    // 7월 데이터
    if (month == 7) {
      if (period == 1) {
        data.addAll([
          ArchiveFruitResponseDto(fruitId: 1, fruitName: '체리', archivedAt: '2025-07-01T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 2, fruitName: '딸기', archivedAt: '2025-07-03T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 3, fruitName: '키위', archivedAt: '2025-07-05T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 4, fruitName: '산딸기', archivedAt: '2025-07-07T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 5, fruitName: '복숭아', archivedAt: '2025-07-09T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 6, fruitName: '자두', archivedAt: '2025-07-11T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 7, fruitName: '망고', archivedAt: '2025-07-13T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 8, fruitName: '블루베리', archivedAt: '2025-07-15T00:00:00Z'),
        ]);
      } else {
        data.addAll([
          ArchiveFruitResponseDto(fruitId: 9, fruitName: '포도', archivedAt: '2025-07-17T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 10, fruitName: '포도', archivedAt: '2025-07-19T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 11, fruitName: '레몬', archivedAt: '2025-07-21T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 12, fruitName: '감', archivedAt: '2025-07-23T00:00:00Z'),
        ]);
      }
    }
    
    // 8월 데이터
    if (month == 8) {
      if (period == 1) {
        data.addAll([
          ArchiveFruitResponseDto(fruitId: 1, fruitName: '체리', archivedAt: '2025-08-01T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 2, fruitName: '딸기', archivedAt: '2025-08-03T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 3, fruitName: '키위', archivedAt: '2025-08-05T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 4, fruitName: '산딸기', archivedAt: '2025-08-07T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 5, fruitName: '복숭아', archivedAt: '2025-08-09T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 6, fruitName: '자두', archivedAt: '2025-08-11T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 7, fruitName: '망고', archivedAt: '2025-08-13T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 8, fruitName: '블루베리', archivedAt: '2025-08-15T00:00:00Z'),
        ]);
      } else {
        data.addAll([
          ArchiveFruitResponseDto(fruitId: 9, fruitName: '포도', archivedAt: '2025-08-17T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 10, fruitName: '포도', archivedAt: '2025-08-19T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 11, fruitName: '레몬', archivedAt: '2025-08-21T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 12, fruitName: '감', archivedAt: '2025-08-23T00:00:00Z'),
        ]);
      }
    }
    
    // 9월 데이터
    if (month == 9) {
      if (period == 1) {
        data.addAll([
          ArchiveFruitResponseDto(fruitId: 1, fruitName: '체리', archivedAt: '2025-09-01T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 2, fruitName: '딸기', archivedAt: '2025-09-03T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 3, fruitName: '키위', archivedAt: '2025-09-05T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 4, fruitName: '산딸기', archivedAt: '2025-09-07T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 5, fruitName: '복숭아', archivedAt: '2025-09-09T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 6, fruitName: '자두', archivedAt: '2025-09-11T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 7, fruitName: '망고', archivedAt: '2025-09-13T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 8, fruitName: '블루베리', archivedAt: '2025-09-15T00:00:00Z'),
        ]);
      } else {
        data.addAll([
          ArchiveFruitResponseDto(fruitId: 9, fruitName: '포도', archivedAt: '2025-09-17T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 10, fruitName: '포도', archivedAt: '2025-09-19T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 11, fruitName: '레몬', archivedAt: '2025-09-21T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 12, fruitName: '감', archivedAt: '2025-09-23T00:00:00Z'),
        ]);
      }
    }
    
    // 10월 데이터
    if (month == 10) {
      if (period == 1) {
        data.addAll([
          ArchiveFruitResponseDto(fruitId: 1, fruitName: '체리', archivedAt: '2025-10-01T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 2, fruitName: '딸기', archivedAt: '2025-10-03T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 3, fruitName: '키위', archivedAt: '2025-10-05T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 4, fruitName: '산딸기', archivedAt: '2025-10-07T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 5, fruitName: '복숭아', archivedAt: '2025-10-09T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 6, fruitName: '자두', archivedAt: '2025-10-11T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 7, fruitName: '망고', archivedAt: '2025-10-13T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 8, fruitName: '블루베리', archivedAt: '2025-10-15T00:00:00Z'),
        ]);
      } else {
        data.addAll([
          ArchiveFruitResponseDto(fruitId: 9, fruitName: '포도', archivedAt: '2025-10-17T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 10, fruitName: '포도', archivedAt: '2025-10-19T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 11, fruitName: '레몬', archivedAt: '2025-10-21T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 12, fruitName: '감', archivedAt: '2025-10-23T00:00:00Z'),
        ]);
      }
    }
    
    return data;
  }

  /// 네번째 나무 데이터 (열매)
  List<ArchiveFruitResponseDto> _getFourthTreeData(int year, int month, int period) {
    final data = <ArchiveFruitResponseDto>[];
    
    // 5월 데이터
    if (month == 5) {
      if (period == 1) {
        data.addAll([
          ArchiveFruitResponseDto(fruitId: 1, fruitName: '체리', archivedAt: '2025-05-02T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 2, fruitName: '딸기', archivedAt: '2025-05-04T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 3, fruitName: '키위', archivedAt: '2025-05-06T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 4, fruitName: '산딸기', archivedAt: '2025-05-08T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 5, fruitName: '복숭아', archivedAt: '2025-05-10T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 6, fruitName: '자두', archivedAt: '2025-05-12T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 7, fruitName: '망고', archivedAt: '2025-05-14T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 8, fruitName: '블루베리', archivedAt: '2025-05-16T00:00:00Z'),
        ]);
      } else {
        data.addAll([
          ArchiveFruitResponseDto(fruitId: 9, fruitName: '포도', archivedAt: '2025-05-18T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 10, fruitName: '포도', archivedAt: '2025-05-20T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 11, fruitName: '레몬', archivedAt: '2025-05-22T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 12, fruitName: '감', archivedAt: '2025-05-24T00:00:00Z'),
        ]);
      }
    }
    
    // 6월 데이터
    if (month == 6) {
      if (period == 1) {
        data.addAll([
          ArchiveFruitResponseDto(fruitId: 1, fruitName: '체리', archivedAt: '2025-06-02T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 2, fruitName: '딸기', archivedAt: '2025-06-04T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 3, fruitName: '키위', archivedAt: '2025-06-06T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 4, fruitName: '산딸기', archivedAt: '2025-06-08T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 5, fruitName: '복숭아', archivedAt: '2025-06-10T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 6, fruitName: '자두', archivedAt: '2025-06-12T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 7, fruitName: '망고', archivedAt: '2025-06-14T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 8, fruitName: '블루베리', archivedAt: '2025-06-16T00:00:00Z'),
        ]);
      } else {
        data.addAll([
          ArchiveFruitResponseDto(fruitId: 9, fruitName: '포도', archivedAt: '2025-06-18T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 10, fruitName: '포도', archivedAt: '2025-06-20T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 11, fruitName: '레몬', archivedAt: '2025-06-22T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 12, fruitName: '감', archivedAt: '2025-06-24T00:00:00Z'),
        ]);
      }
    }
    
    // 7월 데이터
    if (month == 7) {
      if (period == 1) {
        data.addAll([
          ArchiveFruitResponseDto(fruitId: 1, fruitName: '체리', archivedAt: '2025-07-02T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 2, fruitName: '딸기', archivedAt: '2025-07-04T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 3, fruitName: '키위', archivedAt: '2025-07-06T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 4, fruitName: '산딸기', archivedAt: '2025-07-08T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 5, fruitName: '복숭아', archivedAt: '2025-07-10T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 6, fruitName: '자두', archivedAt: '2025-07-12T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 7, fruitName: '망고', archivedAt: '2025-07-14T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 8, fruitName: '블루베리', archivedAt: '2025-07-16T00:00:00Z'),
        ]);
      } else {
        data.addAll([
          ArchiveFruitResponseDto(fruitId: 9, fruitName: '포도', archivedAt: '2025-07-18T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 10, fruitName: '포도', archivedAt: '2025-07-20T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 11, fruitName: '레몬', archivedAt: '2025-07-22T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 12, fruitName: '감', archivedAt: '2025-07-24T00:00:00Z'),
        ]);
      }
    }
    
    // 8월 데이터
    if (month == 8) {
      if (period == 1) {
        data.addAll([
          ArchiveFruitResponseDto(fruitId: 1, fruitName: '체리', archivedAt: '2025-08-02T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 2, fruitName: '딸기', archivedAt: '2025-08-04T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 3, fruitName: '키위', archivedAt: '2025-08-06T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 4, fruitName: '산딸기', archivedAt: '2025-08-08T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 5, fruitName: '복숭아', archivedAt: '2025-08-10T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 6, fruitName: '자두', archivedAt: '2025-08-12T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 7, fruitName: '망고', archivedAt: '2025-08-14T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 8, fruitName: '블루베리', archivedAt: '2025-08-16T00:00:00Z'),
        ]);
      } else {
        data.addAll([
          ArchiveFruitResponseDto(fruitId: 9, fruitName: '포도', archivedAt: '2025-08-18T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 10, fruitName: '포도', archivedAt: '2025-08-20T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 11, fruitName: '레몬', archivedAt: '2025-08-22T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 12, fruitName: '감', archivedAt: '2025-08-24T00:00:00Z'),
        ]);
      }
    }
    
    // 9월 데이터
    if (month == 9) {
      if (period == 1) {
        data.addAll([
          ArchiveFruitResponseDto(fruitId: 1, fruitName: '체리', archivedAt: '2025-09-02T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 2, fruitName: '딸기', archivedAt: '2025-09-04T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 3, fruitName: '키위', archivedAt: '2025-09-06T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 4, fruitName: '산딸기', archivedAt: '2025-09-08T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 5, fruitName: '복숭아', archivedAt: '2025-09-10T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 6, fruitName: '자두', archivedAt: '2025-09-12T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 7, fruitName: '망고', archivedAt: '2025-09-14T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 8, fruitName: '블루베리', archivedAt: '2025-09-16T00:00:00Z'),
        ]);
      } else {
        data.addAll([
          ArchiveFruitResponseDto(fruitId: 9, fruitName: '포도', archivedAt: '2025-09-18T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 10, fruitName: '포도', archivedAt: '2025-09-20T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 11, fruitName: '레몬', archivedAt: '2025-09-22T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 12, fruitName: '감', archivedAt: '2025-09-24T00:00:00Z'),
        ]);
      }
    }
    
    // 10월 데이터
    if (month == 10) {
      if (period == 1) {
        data.addAll([
          ArchiveFruitResponseDto(fruitId: 1, fruitName: '체리', archivedAt: '2025-10-02T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 2, fruitName: '딸기', archivedAt: '2025-10-04T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 3, fruitName: '키위', archivedAt: '2025-10-06T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 4, fruitName: '산딸기', archivedAt: '2025-10-08T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 5, fruitName: '복숭아', archivedAt: '2025-10-10T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 6, fruitName: '자두', archivedAt: '2025-10-12T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 7, fruitName: '망고', archivedAt: '2025-10-14T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 8, fruitName: '블루베리', archivedAt: '2025-10-16T00:00:00Z'),
        ]);
      } else {
        data.addAll([
          ArchiveFruitResponseDto(fruitId: 9, fruitName: '포도', archivedAt: '2025-10-18T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 10, fruitName: '포도', archivedAt: '2025-10-20T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 11, fruitName: '레몬', archivedAt: '2025-10-22T00:00:00Z'),
          ArchiveFruitResponseDto(fruitId: 12, fruitName: '감', archivedAt: '2025-10-24T00:00:00Z'),
        ]);
      }
    }
    
    return data;
  }
}

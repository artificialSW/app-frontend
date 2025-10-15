import 'package:flutter/material.dart';

/// 섬 아카이브 필터 드롭다운 위젯
/// 연도별 필터링을 위한 드롭다운 메뉴
class IslandArchiveFilterDropdown extends StatelessWidget {
  final int selectedYear;
  final Function(int) onYearSelected;

  const IslandArchiveFilterDropdown({
    super.key,
    required this.selectedYear,
    required this.onYearSelected,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // 기준 화면 크기 (412x917)에 대한 비율 계산
    final widthRatio = screenWidth / 412.0;
    final heightRatio = screenHeight / 917.0;
    
    // 컨테이너 크기 (반응형)
    final containerWidth = 127.0 * widthRatio;
    final containerHeight = 150.0 * heightRatio; // 높이 줄임

    return Container(
      width: containerWidth,
      height: containerHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14 * widthRatio),
        boxShadow: [
          BoxShadow(
            color: const Color(0x05222222),
            blurRadius: 8 * widthRatio,
            offset: Offset(0, 4 * heightRatio),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: const Color(0x05222222),
            blurRadius: 8 * widthRatio,
            offset: Offset(4 * widthRatio, 0),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: const Color(0x05222222),
            blurRadius: 8 * widthRatio,
            offset: Offset(-4 * widthRatio, 0),
            spreadRadius: 0,
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          // ALL 옵션
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 16 * widthRatio,
              vertical: 12 * heightRatio,
            ),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1.20 * widthRatio,
                  color: const Color(0xFFDEDEDE),
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14 * widthRatio),
                  topRight: Radius.circular(14 * widthRatio),
                ),
              ),
            ),
            child: GestureDetector(
              onTap: () => onYearSelected(-1), // -1은 ALL을 의미
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ALL',
                    style: TextStyle(
                      color: selectedYear == -1 
                          ? const Color(0xFFAAAAAA)
                          : const Color(0xFFAAAAAA),
                      fontSize: 16 * widthRatio,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      height: 1.60,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 2025년 옵션
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 16 * widthRatio,
              vertical: 12 * heightRatio,
            ),
            decoration: ShapeDecoration(
              color: selectedYear == 2025 
                  ? const Color(0xFFDEDEDE)
                  : Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1.20 * widthRatio,
                  color: const Color(0xFFDEDEDE),
                ),
              ),
            ),
            child: GestureDetector(
              onTap: () => onYearSelected(2025),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '2025',
                    style: TextStyle(
                      color: selectedYear == 2025 
                          ? Colors.black
                          : const Color(0xFFAAAAAA),
                      fontSize: 16 * widthRatio,
                      fontFamily: 'Pretendard',
                      fontWeight: selectedYear == 2025 
                          ? FontWeight.w500
                          : FontWeight.w400,
                      height: 1.60,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 2024년 옵션
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 16 * widthRatio,
              vertical: 12 * heightRatio,
            ),
            decoration: ShapeDecoration(
              color: selectedYear == 2024 
                  ? const Color(0xFFDEDEDE)
                  : Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1.20 * widthRatio,
                  color: const Color(0xFFDEDEDE),
                ),
              ),
            ),
            child: GestureDetector(
              onTap: () => onYearSelected(2024),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '2024',
                    style: TextStyle(
                      color: selectedYear == 2024 
                          ? Colors.black
                          : const Color(0xFFAAAAAA),
                      fontSize: 16 * widthRatio,
                      fontFamily: 'Pretendard',
                      fontWeight: selectedYear == 2024 
                          ? FontWeight.w500
                          : FontWeight.w400,
                      height: 1.60,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // 2023년 옵션
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 16 * widthRatio,
              vertical: 12 * heightRatio,
            ),
            decoration: ShapeDecoration(
              color: selectedYear == 2023 
                  ? const Color(0xFFDEDEDE)
                  : Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1.20 * widthRatio,
                  color: const Color(0xFFDEDEDE),
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(14 * widthRatio),
                  bottomRight: Radius.circular(14 * widthRatio),
                ),
              ),
            ),
            child: GestureDetector(
              onTap: () => onYearSelected(2023),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '2023',
                    style: TextStyle(
                      color: selectedYear == 2023 
                          ? Colors.black
                          : const Color(0xFFAAAAAA),
                      fontSize: 16 * widthRatio,
                      fontFamily: 'Pretendard',
                      fontWeight: selectedYear == 2023 
                          ? FontWeight.w500
                          : FontWeight.w400,
                      height: 1.60,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }
}

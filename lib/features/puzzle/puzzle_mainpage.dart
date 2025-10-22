import 'package:artificialsw_frontend/services/old_image_store.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/puzzle_home/puzzle_home_completed_preview_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/puzzle_home/puzzle_home_get_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/puzzle_home/puzzle_home_ongoing_preview_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/puzzle_service.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'dart:math';
import 'package:intl/intl.dart';

class PuzzleRoot extends StatefulWidget {
  const PuzzleRoot({super.key});

  @override
  State<PuzzleRoot> createState() => _PuzzleRootState();
}

class _PuzzleRootState extends State<PuzzleRoot> {
  late Future<PuzzleHomeGetDto> _puzzleFuture;

  String formatUtcToDateString(String utcTimeString) {
    // 1. UTC 문자열을 DateTime으로 파싱
    DateTime utcTime = DateTime.parse(utcTimeString);

    // 2. 로컬 시간대로 변환 (원하면 이 단계 생략 가능)
    DateTime localTime = utcTime.toLocal();

    // 3. 원하는 포맷으로 변환
    final formatter = DateFormat('yyyy.MM.dd');
    return formatter.format(localTime);
  }


  @override
  void initState() {
    super.initState();
    _puzzleFuture = _loadPuzzleData();
  }

  // Future<PuzzleHomeGetDto> _loadPuzzleData() async {
  //   try {
  //     return await PuzzleService().getPuzzleHome(); // 실제 서버 호출
  //   } catch (e) {
  //     print('⚠️ 서버 응답 실패, 목데이터 사용: $e');
  //     throw Exception('에러!!${e}');
  //     // // ✅ 목데이터 리턴
  //
  //     return PuzzleHomeGetDto(
  //         category: ["운동하는 모습", "학교 가는 길", "퇴근 후의 모습"],
  //         inProgress: [
  //           PuzzleHomeOngoingPreviewDto(
  //               puzzleId: 171,
  //               imageUrl: 'https://picsum.photos/400/400',
  //               completedPiecesId: [1, 2]
  //           ),
  //           PuzzleHomeOngoingPreviewDto(
  //               puzzleId: 172,
  //               imageUrl: 'https://picsum.photos/400/400',
  //               completedPiecesId: [1, 2, 3]
  //           ),
  //         ],
  //         completedThisWeek: [
  //           PuzzleHomeCompletedPreviewDto(
  //               puzzleId: 173,
  //               imageUrl: 'https://picsum.photos/400/400',
  //               size: 9,
  //               title: '우리 가족이 함께한 추억',
  //               completedAt: "2025-09-28T04:44:00Z"
  //           ),
  //           PuzzleHomeCompletedPreviewDto(
  //               puzzleId: 174,
  //               imageUrl: 'https://picsum.photos/400/400',
  //               size: 9,
  //               title: '좋았던 자연 경관',
  //               completedAt: "2025-09-29T04:44:00Z"
  //           ),
  //           PuzzleHomeCompletedPreviewDto(
  //               puzzleId: 175,
  //               imageUrl: 'https://picsum.photos/400/400',
  //               size: 9,
  //               title: '사랑스러운 사진 자랑',
  //               completedAt: "2025-09-30T04:44:00Z"
  //           ),
  //         ],
  //         empty: false,
  //         full: false,
  //     );
  //   }
  // }

  Future<PuzzleHomeGetDto> _loadPuzzleData() async {
    try {
      final result = await PuzzleService().getPuzzleHome(); // 실제 서버 호출

      if (result == null) {
        print('⚠️ 서버 응답이 비어있음. 목데이터로 대체합니다.');
        return _getMockPuzzleData();
      }

      return result;
    } catch (e, stack) {
      print('⚠️ 서버 응답 실패: $e');
      print(stack); // 디버깅용 (개발 중엔 유용)

      // ✅ 앱이 멈추지 않도록 목데이터 리턴
      return _getMockPuzzleData();
    }
  }

  /// ✅ 서버 실패 시 사용할 목데이터 생성 메서드
  PuzzleHomeGetDto _getMockPuzzleData() {
    return PuzzleHomeGetDto(
      category: ["운동하는 모습", "학교 가는 길", "퇴근 후의 모습"],
      inProgress: [
        PuzzleHomeOngoingPreviewDto(
          puzzleId: 171,
          imageUrl: "http://15.164.94.26/images/1761093145112.png",
          completedPiecesId: [1, 2],
        ),
        PuzzleHomeOngoingPreviewDto(
          puzzleId: 172,
          imageUrl: "http://15.164.94.26/images/1761093145112.png",
          completedPiecesId: [1, 2, 3],
        ),
      ],
      completedThisWeek: [
        PuzzleHomeCompletedPreviewDto(
          puzzleId: 173,
          imageUrl: "http://15.164.94.26/images/1761093145112.png",
          size: 9,
          title: '우리 가족이 함께한 추억',
          completedAt: "2025-09-28T04:44:00Z",
        ),
        PuzzleHomeCompletedPreviewDto(
          puzzleId: 174,
          imageUrl: "http://15.164.94.26/images/1761093145112.png",
          size: 9,
          title: '좋았던 자연 경관',
          completedAt: "2025-09-29T04:44:00Z",
        ),
        PuzzleHomeCompletedPreviewDto(
          puzzleId: 175,
          imageUrl: "http://15.164.94.26/images/1761093145112.png",
          size: 9,
          title: '사랑스러운 사진 자랑',
          completedAt: "2025-09-30T04:44:00Z",
        ),
      ],
      empty: false,
      full: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      // 이 Scaffold를 추가합니다.
      appBar: PuzzlRootTopBar(),
      backgroundColor: AppColors.plumu_white,
      body: FutureBuilder<PuzzleHomeGetDto>(
        future: _puzzleFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('에러 발생: ${snapshot.error}'));
          }
          final puzzle = snapshot.data!;
          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: screenWidth*0.92,
                      decoration: ShapeDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white,                        // 위쪽은 완전 흰색
                            Color(0xFFE5F4E6),                   // 아래는 연초록색 (거의 흰색과 섞임)
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Color(0xFF5CBD56),            // 초록 테두리
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        shadows: [
                          BoxShadow(
                            color: Color(0x26000000),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: screenHeight*0.02, horizontal: screenWidth*0.04),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '이번주의 퍼즐 키워드',
                                style: AppTextStyles.pretendard_bold.copyWith(
                                  fontSize: 16,
                                  color: AppColors.plumu_green_main,
                                ),
                              ),
                              SizedBox(height: screenHeight*0.007),
                              Text(
                                  '키워드에 맞는 사진을 올려보세요! :)',
                                  style: AppTextStyles.pretendard_medium.copyWith(
                                    fontSize: 12,
                                    color: AppColors.plumu_gray_5,
                                  )
                              ),
                              SizedBox(height: screenHeight*0.01,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  EmotionTag(
                                    label: '사진 등록하러 가기',
                                    onclick: puzzle.full
                                        ? null
                                        : () {
                                      Navigator.of(context).pushNamed( '/puzzle/image-upload', arguments: {'category': puzzle.category}, );
                                    },
                                  )
                                ]
                              ),
                            ]
                        ),
                      )
                  ),
                  SizedBox(height: screenHeight*0.01),
                  Row(
                    children: [
                      SizedBox(width: screenWidth*0.05,),
                      Text(
                        "이번 주 풀어진 퍼즐",
                        style: AppTextStyles.pretendard_bold.copyWith(
                          fontSize: 17,
                          color: AppColors.plumu_gray_7,
                        ),
                      ),
                      Spacer(), // 중간 공간 확보
                      Padding(
                        padding: EdgeInsets.only(right: screenWidth * 0.03), // (1 - 0.03 - 0.9 = 0.07)
                        child: IconButton(
                          icon: Image.asset(AppAssets.forward),
                          iconSize: 28,
                          color: AppColors.plumu_gray_7,
                          tooltip: '이번 주 풀어진 퍼즐 목록으로 이동',
                          onPressed: () => Navigator.of(context).pushNamed('/puzzle/completed-list'),
                        ),
                      ),
                    ],
                  ),

                  // PuzzleCardCarousel(
                  //   imageUrls: (puzzle.completedThisWeek.isNotEmpty) ? puzzle.completedThisWeek
                  //       .map((item) => item?.imageUrl ?? 'https://picsum.photos/600/400')
                  //       .toList()
                  //       : ['https://picsum.photos/600/400', 'https://picsum.photos/600/400', 'https://picsum.photos/600/400', 'https://picsum.photos/600/400'], // 기본 이미지 1장
                  //   completedDates: (puzzle.completedThisWeek.isNotEmpty)
                  //       ? puzzle.completedThisWeek
                  //       .map((item) => formatUtcToDateString(item?.completedAt ?? '1111-11-11'))
                  //       .toList()
                  //       : ['1111-11-11', '1111-11-11', '1111-11-11', '1111-11-11'], // puzzle.completedThisWeek.isEmpty 일 때 1111-11-11
                  // ),
                  puzzle.completedThisWeek.isEmpty
                      ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Container(
                      height: max(150, screenHeight*0.2),
                      child: Center(
                        child: Text(
                          '이번 주에 완성된 퍼즐이 없습니다 🧩',
                          style: AppTextStyles.pretendard_medium.copyWith(
                            fontSize: 14,
                            color: AppColors.plumu_gray_5,
                          ),
                        ),
                      ),
                    ),
                  )
                      : PuzzleCardCarousel(
                    imageUrls: puzzle.completedThisWeek
                        .map((item) => item?.imageUrl ?? 'https://picsum.photos/600/400')
                        .toList(),
                    completedDates: puzzle.completedThisWeek
                        .map((item) => formatUtcToDateString(item?.completedAt ?? '1111-11-11'))
                        .toList(),
                  ),
                  Row(
                    children: [
                      SizedBox(width: screenWidth*0.05,),
                      Text(
                        "진행중인 퍼즐",
                        style: AppTextStyles.pretendard_bold.copyWith(
                          fontSize: 17,
                          color: AppColors.plumu_gray_7,
                        ),
                      ),
                      Spacer(), // 중간 공간 확보
                      Padding(
                        padding: EdgeInsets.only(right: screenWidth * 0.03), // (1 - 0.03 - 0.9 = 0.07)
                        child: IconButton(
                          icon: Image.asset(AppAssets.forward),
                          iconSize: 28,
                          color: AppColors.plumu_gray_7,
                          tooltip: '진행중인 퍼즐 목록으로 이동',
                          onPressed: () => Navigator.of(context).pushNamed('/puzzle/ongoing-list'),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: screenWidth*0.06,),
                      PuzzleCardWidget(
                        imageUrl: puzzle.inProgress.isNotEmpty
                            ? puzzle.inProgress[0]?.imageUrl ?? 'https://picsum.photos/600/400'
                            : 'https://picsum.photos/600/400',
                        dateInfo: formatUtcToDateString(puzzle.inProgress.isNotEmpty
                            ? puzzle.inProgress[0]?.lastSavedAt ?? '1111-11-11'
                            : '2000-01-01'
                        ),
                        imageSize: max(screenWidth*0.4, 150),
                        dateFontSize: 10,
                        text: '진행중인 퍼즐',
                        textFontSize: 14,
                        heightOffset: max(screenWidth*0.2, 100),
                      ),
                      SizedBox(width: screenWidth*0.06,),
                      PuzzleCardWidget(
                        imageUrl: puzzle.inProgress.length > 1 //진행중인 데이터 2개 이상 넘어와야.
                          ? puzzle.inProgress[1]?.imageUrl ?? 'https://picsum.photos/600/400'
                          : 'https://picsum.photos/600/400',
                        dateInfo: formatUtcToDateString(puzzle.inProgress.length > 1
                          ? puzzle.inProgress[1]?.lastSavedAt ?? '0000-00-00'
                          : '2000-01-01'
                        ),
                        imageSize: max(screenWidth*0.4, 150),
                        dateFontSize: 10,
                        textFontSize: 14,
                        text: '진행중인 퍼즐',
                        heightOffset: max(screenWidth*0.2, 100),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight*0.02),
                ],
              ),
              PuzzleHomeButtonsPanel(isFull: puzzle.full, category: puzzle.category, isEmpty: puzzle.empty),
            ],
          );
        },
      ),
    );
  }
}



class EmotionTag extends StatelessWidget {
  final String label;
  final VoidCallback? onclick;

  const EmotionTag({
    super.key,
    required this.label,
    required this.onclick,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onclick,
      child: Container(
        width: screenWidth*0.4,
        height: screenHeight*0.03,
        decoration: BoxDecoration(
          color: AppColors.plumu_green_main,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.pretendard_medium.copyWith(
            fontSize: 14,
            color: AppColors.plumu_white,
          ),
        ),
      ),
    );
  }
}

class PuzzleHomeButtonsPanel extends StatefulWidget {
  final bool isFull;
  final bool isEmpty;
  final List<String> category;

  const PuzzleHomeButtonsPanel({
    super.key,
    required this.isFull,
    required this.isEmpty,
    required this.category,
  });

  @override
  State<PuzzleHomeButtonsPanel> createState() =>
      _PuzzleHomeButtonsPanelState();
}

class _PuzzleHomeButtonsPanelState extends State<PuzzleHomeButtonsPanel> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          // 1. 펼쳐졌을 때 전체 터치 감지
          if (isExpanded)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = false;
                  });
                },
                child: Container(color: Colors.transparent),
              ),
            ),

          // 2. 오른쪽 위치에 퍼즐 버튼 + 토글 버튼
          Positioned(
            top: height * 0.7, // 원하는 vertical 위치 조절
            left: 0,
            right: width * 0.05,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // 펼쳐지는 버튼들
                AnimatedSlide(
                  duration: const Duration(milliseconds: 300),
                  offset: isExpanded ? const Offset(0, 0) : const Offset(1.4, 0),
                  child: Row(
                    children: [
                      PuzzleHomeButtons(
                        isFull: widget.isFull,
                        isEmpty: widget.isEmpty,
                        category: widget.category,
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),

                // 펼쳐지지 않았을 때만 보이는 토글 아이콘 버튼
                if (!isExpanded)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = true;
                      });
                    },
                    child: CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.green,
                      child: Image.asset(
                        'assets/icons/filter.png',
                        width: 24,
                        height: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}




class PuzzleHomeButtons extends StatelessWidget {
  final bool isFull;
  final bool isEmpty;
  final List<String> category;

  const PuzzleHomeButtons({
    super.key,
    required this.isFull,
    required this.isEmpty,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 사진 업로드 버튼 (isFull이면 비활성화)
        _RoundIconButton(
          icon: Icons.add,
          label: '사진 업로드',
          isDisabled: isFull,
          disabledMessage: '사진 업로드를 모두 완료했습니다!',
          onTap: isFull
              ? null
              : () {
            Navigator.of(context).pushNamed( '/puzzle/image-upload', arguments: {'category': category}, ); },
        ),
        SizedBox(width: screenWidth * 0.07),

        // 퍼즐 아카이브 버튼
        _RoundIconButton(
          icon: Icons.archive_outlined,
          label: '퍼즐 아카이브',
          onTap: () {
            Navigator.of(context).pushNamed('/puzzle/archive');
          },
        ),
        SizedBox(width: screenWidth * 0.07),

        // 퍼즐 맞추기 버튼
        _RoundIconButton(
          icon: Icons.extension,
          label: '퍼즐 맞추기',
          textColor: Colors.green,
          isDisabled: isEmpty,
          disabledMessage: '더 이상 풀 퍼즐이 없습니다!',
          onTap: () {
            isEmpty
                ? null
                : Navigator.of(context).pushNamed('/puzzle/write-puzzle-info');
          },
        ),
      ],
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? textColor;
  final bool isDisabled;
  final String? disabledMessage;

  const _RoundIconButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.textColor,
    this.isDisabled = false,
    this.disabledMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (isDisabled) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(disabledMessage ?? '버튼을 클릭할 수 없습니다.'),
                  duration: Duration(seconds: 2),
                ),
              );
            } else {
              onTap?.call();
            }
          },

          child: CircleAvatar(
            radius: 28,
            backgroundColor:
            isDisabled ? AppColors.plumu_gray_3 : AppColors.plumu_green_main,
            child: Icon(
              icon,
              color: Colors.white,
              size: 27,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppTextStyles.pretendard_medium.copyWith(
            fontSize: 11,
            color: isDisabled ? AppColors.plumu_gray_3 : AppColors.plumu_green_main,
          ),
        ),
      ],
    );
  }
}


class PuzzleCardWidget extends StatelessWidget {
  final String imageUrl;
  final String dateInfo;
  double? imageSize;
  final double dateFontSize;
  final double textFontSize;
  String? text;
  double? heightOffset;

  PuzzleCardWidget({
    super.key,
    required this.imageUrl,
    required this.dateInfo,
    this.imageSize,
    required this.dateFontSize,
    required this.textFontSize,
    this.text,
    this.heightOffset
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 배경 이미지 (네트워크에서 가져옴)
        SizedBox(
          width: imageSize ?? 250,
          height: imageSize ?? 250,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.network(
              imageUrl, // 백엔드에서 넘겨받은 이미지 URL
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return Center(child: Icon(Icons.broken_image));
              },
            ),
          ),
        ),

        // 아래 텍스트 (날짜 + 퍼즐 제목)
        Positioned(
          bottom: heightOffset ?? 12,
          left: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(dateInfo, style: AppTextStyles.pretendard_medium.copyWith(fontSize: dateFontSize, color: AppColors.plumu_white)),
              Text(text ?? '퍼즐 조각', style: AppTextStyles.pretendard_bold.copyWith(fontSize: textFontSize, color: AppColors.plumu_white)),
            ],
          ),
        ),
      ],
    );
  }
}

class PuzzleCardCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final List<String> completedDates;
  const PuzzleCardCarousel({super.key, required this.imageUrls, required this.completedDates});

  @override
  State<PuzzleCardCarousel> createState() => _PuzzleCardCarouselState();
}

class _PuzzleCardCarouselState extends State<PuzzleCardCarousel> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.6);

    // 🔹 빌드 직후 한 번 강제로 재빌드 (기울기/스케일 초기 적용)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: max(height*0.3, 200), //기기 사이즈에 맞게 적응적으로 가되 최소 이만큼은 차지해야
      child: PageView.builder(
        reverse: true, //카드를 오른쪽에서 왼쪽으로 넘길 수 있게
        controller: _pageController,
        itemCount: widget.imageUrls.length,
        itemBuilder: (context, index) {
          return AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              double value = 0.0;
              if (_pageController.position.haveDimensions) {
                value = _pageController.page! - index;
              }

              // 🔢 1. Scale 계산 (중앙 1.0, 옆 0.8)
              final scale = (1 - value.abs() * 0.2).clamp(0.8, 1.0);

              // 🔄 2. Rotate 계산 (좌우 -5도 ~ +5도)
              final rotation = (- value * 0.1).clamp(-0.1, 0.1); // 라디안

              // 🌫️ 3. Opacity 계산 (중앙 1.0, 옆 0.5)
              final opacity = (1 - value.abs() * 0.5).clamp(0.5, 1.0);

              return Opacity(
                opacity: opacity,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..scale(scale)
                    ..rotateZ(rotation),
                  child: Transform.translate(
                    offset: const Offset(0, 0),
                      child: PuzzleCardWidget(
                        imageUrl: widget.imageUrls[index],
                        dateInfo: widget.completedDates[index],
                        dateFontSize: 14,
                        textFontSize: 17,
                      ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

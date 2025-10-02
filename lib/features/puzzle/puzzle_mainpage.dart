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

  Future<PuzzleHomeGetDto> _loadPuzzleData() async {
    try {
      return await PuzzleService().getPuzzleHome(); // 실제 서버 호출
    } catch (e) {
      print('⚠️ 서버 응답 실패, 목데이터 사용: $e');
      // ✅ 목데이터 리턴
      return PuzzleHomeGetDto(
        subject: ["복숭아 사진 자랑", "아보카도 사진 자랑", "자유주제: 원하는 사진을 올려보세요!"],
        inProgress: [PuzzleHomeOngoingPreviewDto(
          puzzleId: 1,
          imageUrl:
              'https://picsum.photos/400/400',
          size: 4,
          completedPiecesId: [1, 2],
          lastSavedAt: "2025-09-29T04:44:00Z",
        ),
          PuzzleHomeOngoingPreviewDto(
            puzzleId: 1,
            imageUrl:
            'https://picsum.photos/400/400',
            size: 4,
            completedPiecesId: [1, 2],
            lastSavedAt: "2025-09-30T04:44:00Z",
          ),
        ],
        completedThisWeek: [PuzzleHomeCompletedPreviewDto(
          puzzleId: 1,
          imageUrl:
              'https://picsum.photos/400/400',
          size: 9,
          title: "목데이터 title",
          completedAt: "2025-09-29T04:44:00Z",
        ),
          PuzzleHomeCompletedPreviewDto(
            puzzleId: 1,
            imageUrl:
            'https://picsum.photos/400/400',
            size: 9,
            title: "목데이터 title",
            completedAt: "2025-09-28T04:44:00Z",
          ),
        ],
        isFull: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
            return const Center(child: Text('에러 발생'));
          }
          final puzzle = snapshot.data!;
          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: screenWidth*0.92,
                      decoration: BoxDecoration(
                        color: AppColors.plumu_green_30per,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: screenHeight*0.02, horizontal: screenWidth*0.04),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '이번주의 퍼즐 카테고리',
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
                                    color: AppColors.plumu_gray_6,
                                  )
                              ),
                              SizedBox(height: screenHeight*0.01,),
                              EmotionTag(
                                  label: '사진 등록하러 가기',
                                  onclick: puzzle.isFull
                                      ? null
                                      : () {
                                    Navigator.of(context).pushNamed( '/puzzle/image-upload', arguments: {'category': puzzle.subject}, );
                                    },
                              ),
                            ]
                        ),
                      )
                  ),
                  SizedBox(height: screenHeight*0.01),
                  Row(
                    children: [
                      SizedBox(width: screenWidth*0.03,),
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

                  PuzzleCardCarousel(
                    imageUrls: [
                      ...puzzle.completedThisWeek.map((item) => item.imageUrl),
                      'https://picsum.photos/600/400',
                    ],
                    completedDates: [
                      ...puzzle.completedThisWeek.map((item) => formatUtcToDateString(item.completedAt)),
                      '2025.08.23',
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: screenWidth*0.03,),
                      Text(
                        "진행중",
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
                          imageUrl: puzzle.inProgress[0].imageUrl,
                          dateInfo: formatUtcToDateString(puzzle.inProgress[0].lastSavedAt),
                          imageSize: max(screenWidth*0.4, 150),
                          dateFontSize: 10,
                          text: '진행중인 퍼즐',
                          textFontSize: 14,
                          heightOffset: max(screenWidth*0.2, 100),
                      ),
                      SizedBox(width: screenWidth*0.06,),
                      PuzzleCardWidget(
                          imageUrl: puzzle.inProgress[1].imageUrl,
                          dateInfo: formatUtcToDateString(puzzle.inProgress[1].lastSavedAt),
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
              PuzzleHomeButtonsPanel(isFull: puzzle.isFull, category: puzzle.subject),
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
          borderRadius: BorderRadius.circular(8),
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
  final List<String> category;

  const PuzzleHomeButtonsPanel({
    super.key,
    required this.isFull,
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
  final List<String> category;

  const PuzzleHomeButtons({
    super.key,
    required this.isFull,
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
          backgroundColor: Colors.grey.shade300,
          isDisabled: isFull,
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
          backgroundColor: Colors.grey.shade300,
          onTap: () {
            Navigator.of(context).pushNamed('/puzzle/archive');
          },
        ),
        SizedBox(width: screenWidth * 0.07),

        // 퍼즐 맞추기 버튼
        _RoundIconButton(
          icon: Icons.extension,
          label: '퍼즐 맞추기',
          backgroundColor: Colors.green,
          textColor: Colors.green,
          onTap: () {
            Navigator.of(context).pushNamed('/puzzle/write-puzzle-info');
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
  final Color backgroundColor;
  final Color? textColor;
  final bool isDisabled;

  const _RoundIconButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.backgroundColor,
    this.textColor,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: isDisabled ? null : onTap,
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

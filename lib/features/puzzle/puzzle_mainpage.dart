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

class PuzzleRoot extends StatefulWidget {
  const PuzzleRoot({super.key});

  @override
  State<PuzzleRoot> createState() => _PuzzleRootState();
}

class _PuzzleRootState extends State<PuzzleRoot> {
  late Future<PuzzleHomeGetDto> _puzzleFuture;

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
        subject: ["복숭아 사진 자랑", "아보카도 사진 자랑", "딸기 사진 자랑"],
        inProgress: [PuzzleHomeOngoingPreviewDto(
          puzzleId: 1,
          imageUrl:
              'https://picsum.photos/600/400',
          size: 4,
          completedPiecesId: [1, 2],
          lastSavedAt: "03:33",
        ),
          PuzzleHomeOngoingPreviewDto(
            puzzleId: 1,
            imageUrl:
            'https://picsum.photos/600/400',
            size: 4,
            completedPiecesId: [1, 2],
            lastSavedAt: "03:33",
          ),
        ],
        completedThisWeek: [PuzzleHomeCompletedPreviewDto(
          puzzleId: 1,
          imageUrl:
              'https://picsum.photos/600/400',
          size: 9,
          title: "목데이터 title",
          completedAt: "04:44",
        ),
          PuzzleHomeCompletedPreviewDto(
            puzzleId: 1,
            imageUrl:
            'https://picsum.photos/600/400',
            size: 9,
            title: "목데이터 title",
            completedAt: "04:44",
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
                      height: screenHeight*0.22,
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
                                  '키워드에 맞는 사진을 올려보세요! 물론 자유주제도 좋아요 :)',
                                  style: AppTextStyles.pretendard_medium.copyWith(
                                    fontSize: 12,
                                    color: AppColors.plumu_gray_6,
                                  )
                              ),
                              SizedBox(height: screenHeight*0.01,),
                              EmotionTag(label: puzzle.subject[0]),
                              SizedBox(height: screenHeight*0.01,),
                              EmotionTag(label: puzzle.subject[1]),
                              SizedBox(height: screenHeight*0.01,),
                              EmotionTag(label: puzzle.subject[2]),
                            ]
                        ),
                      )
                  ),
                  SizedBox(height: screenHeight*0.01),
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
                      Container(
                        width: screenWidth*0.4,
                        height: screenWidth*0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.network(
                          puzzle.inProgress[0].imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: screenWidth*0.06,),
                      Container(
                        width: screenWidth*0.4,
                        height: screenWidth*0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.network(
                          puzzle.inProgress[1].imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight*0.02),
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
                  Row(
                    children: [
                      SizedBox(width: screenWidth*0.06,),
                      Container(
                        width: screenWidth*0.4,
                        height: screenWidth*0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.network(
                          puzzle.completedThisWeek[0].imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: screenWidth*0.06),
                      Container(
                        width: screenWidth*0.4,
                        height: screenWidth*0.4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.network(
                          puzzle.completedThisWeek[1].imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
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

  const EmotionTag({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth*0.8,
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
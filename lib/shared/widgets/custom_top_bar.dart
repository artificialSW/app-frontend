import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'package:artificialsw_frontend/features/home/guidebook_logic/guidebook_main.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';

AppBar HomeTopBar() => AppBar(
    automaticallyImplyLeading: false,   // 뒤로가기 자동 삽입 방지(중앙 정렬 깨짐 방지)
    centerTitle: true,                  // 로고 중앙
    toolbarHeight: 56,                  // 와이어프레임 높이 맞춤
    titleSpacing: 0,                    // 양옆 여백 제어
    leadingWidth: 56,                   // 좌우 균형(우측 actions 없을 때)
    backgroundColor: Colors.transparent, // 배경 투명하게
    elevation: 0,                       // 그림자 제거
    title: SizedBox(
      width: 60,
      height: 24.08,
      child: Text(
        'plumu',
        textAlign: TextAlign.center,
        style: AppTextStyles.plumu.copyWith(color: Colors.white)
      ),
    ),
    actions: [
      // 기존 book 아이콘 제거 - 도감 기능을 하단 버튼으로 이동
    ],
  );

AppBar PuzzlRootTopBar() => AppBar(
  automaticallyImplyLeading: false,   // 뒤로가기 자동 삽입 방지(중앙 정렬 깨짐 방지)
  centerTitle: true,
  title: const Text(
    'plumu',
    style: AppTextStyles.plumu,
  ),
);

AppBar ProfileRootTopBar() => AppBar(
  backgroundColor: Colors.white,
  automaticallyImplyLeading: false,   // 뒤로가기 자동 삽입 방지(중앙 정렬 깨짐 방지)
  centerTitle: true,
  title: const Text(
    '마이페이지',
    style: TextStyle(
      color: Colors.black,
      fontSize: 17,
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w700,
      height: 1.50,
      letterSpacing: -0.46,
    ),
  ),
);

const chatTopBarStyle = TextStyle(
  color: Colors.black,
  fontSize: 17,
  fontFamily: 'Pretendard',
  fontWeight: FontWeight.w700,
  height: 1.5,
  letterSpacing: -0.46,
);

AppBar ChatRootTopBar() => AppBar(
  elevation: 0,
  backgroundColor: Colors.white,
  centerTitle: true,
  title: const Text('소통방', style: chatTopBarStyle),
  iconTheme: const IconThemeData(color: Colors.black87),
  actions: const [HeaderSendIcon()],
);

AppBar CanGoBackTopBar(String title, context) => AppBar(
  leading: IconButton(
    icon: const Icon(Icons.arrow_back_ios_new, size: 20), //이게 젤 똑같음.
    onPressed: () => Navigator.pop(context),
  ),
  title: Text(
    title,
    textAlign: TextAlign.center,
    style: TextStyle(
      color: const Color(0xFF35353F),
      fontSize: 16,
      fontFamily: 'Pretendard',
      fontWeight: FontWeight.w700,
      height: 1.50,
    ),
  ),
  centerTitle: true,
  backgroundColor: Colors.white,
  elevation: 0,
);
class HeaderSendIcon extends StatelessWidget {
  const HeaderSendIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Image.asset(AppAssets.paperplane),
      tooltip: '답변하기',
      onPressed: () => Navigator.pushNamed(context, '/personal-answer'),
    );
  }
}

AppBar CreateQuestionTopBar(int step) => AppBar(
  elevation: 0,
  backgroundColor: AppColors.plumu_white,
  centerTitle: true,
  iconTheme: const IconThemeData(color: AppColors.plumu_gray_7),
  title: Text(
    '질문생성',
    style: AppTextStyles.pretendard_bold.copyWith(
      fontSize: 17,
      color: AppColors.plumu_gray_7,
    ),
  ),
  bottom: PreferredSize(
    preferredSize: const Size.fromHeight(12),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: SizedBox(
        height: 4,
        child: Row(
          children: [
            Expanded(
              flex: step.clamp(0, 3),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.plumu_green_main,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Expanded(
              flex: (3 - step).clamp(0, 3),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.plumu_gray_2,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ),
);
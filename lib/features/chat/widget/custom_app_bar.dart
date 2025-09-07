import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_top_bar.dart';

// DM 배지가 있는 커스텀 AppBar
class ChatCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int incomingQuestionsCount;

  const ChatCustomAppBar({
    super.key,
    required this.incomingQuestionsCount,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: SizedBox(
        width: 44,
        child: Text(
          '소통방',
          textAlign: TextAlign.center,
          style: chatTopBarStyle,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.black87),
      actions: [
        Stack(
          children: [
            const HeaderSendIcon(),
            if (incomingQuestionsCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.plumu_green_main,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$incomingQuestionsCount',
                      style: AppTextStyles.pretendard_medium.copyWith(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

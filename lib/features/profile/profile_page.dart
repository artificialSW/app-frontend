import 'package:artificialsw_frontend/shared/widgets/custom_top_bar.dart';
import 'package:flutter/material.dart';
import '../../shared/constants/app_colors.dart';
import '../../shared/constants/app_text_styles.dart';
import '../../shared/widgets/custom_bottom_bar.dart';
import 'package:artificialsw_frontend/features/profile/logout_dialog.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';

class ProfileRoot extends StatelessWidget {
  const ProfileRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ProfileRootTopBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(),
            const SizedBox(height: 16),
            _buildActionButtons(),
            const SizedBox(height: 24),
            _buildMenuList(context),
            const SizedBox(height: 24),
            _buildInviteCode(),
            Spacer(),
            Center(
              child: TextButton(
                child: Text(
                  '로그아웃',
                  style: AppTextStyles.pretendard_regular.copyWith(
                    color: AppColors.plumu_gray_5,
                    fontSize: 12,
                    decoration: TextDecoration.underline, // ✅ 밑줄 추가
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => LogoutConfirmDialog(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFEDF9ED),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.plumu_green_main, width: 1.5),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.plumu_green_main,
            child: Icon(Icons.edit, color: Colors.white, size: 30,),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('허준혁님', style: AppTextStyles.pretendard_bold.copyWith(
                        color: AppColors.plumu_black,
                        fontSize: 18
                    )),
                    const SizedBox(width: 8),
                    Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.plumu_green_main,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                          '자녀',
                          style: AppTextStyles.pretendard_regular.copyWith(
                              color: Colors.white, fontSize: 12)
                      ),
                    ),
                  ],
                ),
                Text(
                    '2002.03.25',
                    style: AppTextStyles.pretendard_regular.copyWith(
                        color: AppColors.plumu_gray_5,
                        fontSize: 12)
                ),
              ],
            ),
          ),
          const Icon(
              Icons.arrow_forward_ios,
              size: 16,
            color: AppColors.plumu_gray_5,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: AppColors.plumu_green_main,
            width: 1.5
        ),
        borderRadius: BorderRadius.circular(12),
        color: Color(0xFFEDF9ED),
      ),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _imageTextButton(AppAssets.heart_logo, '좋아요'),
              VerticalDivider(color: Color(0xFFA9E2A5), thickness: 1),
              _imageTextButton(AppAssets.reply_logo, '댓글'),
              VerticalDivider(color: Color(0xFFA9E2A5), thickness: 1),
              _imageTextButton(AppAssets.puzzle_logo, '퍼즐/질문'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageTextButton(String imagePath, String label) {
    return Expanded(
      child: Column(
        children: [
          Image.asset(
              imagePath,
              width: 35,
            height: 35,
          ),
          const SizedBox(height: 4),
          Text(
              label,
              style: AppTextStyles.pretendard_medium.copyWith(
                  color: AppColors.plumu_gray_7,
                  fontSize: 12)
          ),
        ],
      ),
    );
  }


  Widget _buildMenuList(BuildContext context) {
    final menuItems = [
      '환경 설정',
      '가족 설정',
      '약관 및 개인정보 처리방침',
      '개인정보 수정',
    ];


    return Column(
      children: menuItems
          .map(
            (title) => Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                  title,
                  style: AppTextStyles.pretendard_bold.copyWith(
                      color: AppColors.plumu_gray_7,
                      fontSize: 14)
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 15, color: AppColors.plumu_gray_5,),
              onTap: () {},
            ),
            const Divider(height: 1, color: Color(0x4DCECECE)),
          ],
        ),
      )
          .toList(),
    );
  }


  Widget _buildInviteCode() {
    return Row(
      children: [
        Text(
            '가족 초대코드',
            style: AppTextStyles.pretendard_bold.copyWith(
                color: AppColors.plumu_gray_7,
                fontSize: 14
            )
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            '135642',
            style: AppTextStyles.pretendard_regular.copyWith(
              color: AppColors.plumu_gray_5,
              fontSize: 12,
              decoration: TextDecoration.underline, // ✅ 밑줄 추가
            ),
          ),
        ),
        CustomButton(
          text: '복사하기',
          onPressed: (){},
          width: 70,
          height: 30,
          fontSize: 11,
          borderRadius: BorderRadius.circular(30),
        ),
        // ElevatedButton(
        //   onPressed: () {},
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: AppColors.plumu_green_main,
        //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(20),
        //     ),
        //   ),
        //   child: const Text('복사하기'),
        // ),
      ],
    );
  }
}
import 'package:artificialsw_frontend/shared/widgets/custom_top_bar.dart';
import 'package:flutter/material.dart';
import '../../shared/constants/app_colors.dart';
import '../../shared/constants/app_text_styles.dart';
import '../../shared/widgets/custom_bottom_bar.dart';
import 'package:artificialsw_frontend/features/profile/logout.dart';

class ProfileRoot extends StatelessWidget {
  const ProfileRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ProfileRootTopBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
            const SizedBox(height: 32),
            Center(
              child: TextButton(
                child: const Text('로그아웃', style: TextStyle(color: Colors.red)),
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
        color: AppColors.plumu_green_30per,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.plumu_green_main),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey,
            child: Icon(Icons.edit, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('최수민님', style: AppTextStyles.pretendard_bold.copyWith(
                        color: AppColors.plumu_black,
                        fontSize: 20
                    )),
                    const SizedBox(width: 8),
                    Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.plumu_green_main,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text('자녀',
                          style: AppTextStyles.pretendard_regular.copyWith(color: Colors.white, fontSize: 14)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('2004.03.13', style: AppTextStyles.pretendard_regular.copyWith(color: AppColors.plumu_gray_5, fontSize: 14)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.plumu_green_main),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _iconTextButton(Icons.favorite, '좋아요'),
          _iconTextButton(Icons.chat_bubble, '댓글'),
          _iconTextButton(Icons.extension, '퍼즐/질문'),
        ],
      ),
    );
  }

  Widget _iconTextButton(IconData icon, String label) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.plumu_gray_7, size: 30),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.pretendard_medium.copyWith(color: AppColors.plumu_gray_7, fontSize: 14)),
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
              title: Text(title, style: AppTextStyles.pretendard_bold.copyWith(color: AppColors.plumu_gray_7, fontSize: 16)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
            const Divider(height: 1),
          ],
        ),
      )
          .toList(),
    );
  }


  Widget _buildInviteCode() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.plumu_gray_3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text('가족 초대코드', style: AppTextStyles.pretendard_bold.copyWith(color: AppColors.plumu_gray_7, fontSize: 16)),
          const SizedBox(width: 16),
          Expanded(
            child: Text('135642', style: AppTextStyles.pretendard_regular.copyWith(color: AppColors.plumu_gray_7, fontSize: 14)),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.plumu_green_main,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('복사하기'),
          ),
        ],
      ),
    );
  }
}
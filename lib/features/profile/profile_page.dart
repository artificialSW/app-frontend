import 'package:artificialsw_frontend/shared/widgets/custom_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 클립보드 기능을 위한 import
import '../../shared/constants/app_colors.dart';
import '../../shared/constants/app_text_styles.dart';
import '../../shared/widgets/custom_bottom_bar.dart';
import 'package:artificialsw_frontend/features/profile/logout_dialog.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'package:artificialsw_frontend/services/profile/profile_service.dart';
import 'package:artificialsw_frontend/services/profile/dto/profile_response_dto.dart';
import 'profile_edit_page.dart';
import 'settings/settings_page.dart';
import 'password_change_page.dart';

class ProfileRoot extends StatefulWidget {
  const ProfileRoot({super.key});

  @override
  State<ProfileRoot> createState() => _ProfileRootState();
}

class _ProfileRootState extends State<ProfileRoot> {
  final ProfileService _profileService = ProfileService();
  ProfileResponseDto? _profileData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final profileData = await _profileService.getProfile();
      print('✅ 마이페이지 정보 로드 성공:');
      print('   - 이름: ${profileData.name}');
      print('   - 생일: ${profileData.birth}');
      print('   - 구성원: ${profileData.familyType}');
      print('   - 가족코드: ${profileData.familyCode}');
      
      setState(() {
        _profileData = profileData;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ 마이페이지 정보 로드 실패: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ProfileRootTopBar(),
      body: SingleChildScrollView(
        child: Container(
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
              const SizedBox(height: 40),
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => const ProfileEditPage()),
        );
      },
      child: Container(
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
                    Text('${_profileData?.name ?? '로딩중'}님', style: AppTextStyles.pretendard_bold.copyWith(
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
                          _profileData?.familyType ?? '로딩중',
                          style: AppTextStyles.pretendard_regular.copyWith(
                              color: Colors.white, fontSize: 12)
                      ),
                    ),
                  ],
                ),
                Text(
                    _profileData?.birth ?? '로딩중',
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
      {'title': '환경 설정', 'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()))},
      {'title': '가족 설정', 'onTap': () {}},
      {'title': '약관 및 개인정보 처리방침', 'onTap': () {}},
      {'title': '개인정보 수정', 'onTap': () => Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => const PasswordChangePage()))},
    ];


    return Column(
      children: menuItems
          .map(
            (item) => Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                  item['title'] as String,
                  style: AppTextStyles.pretendard_bold.copyWith(
                      color: AppColors.plumu_gray_7,
                      fontSize: 14)
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 15, color: AppColors.plumu_gray_5,),
              onTap: item['onTap'] as VoidCallback,
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
            _profileData?.familyCode ?? '로딩중',
            style: AppTextStyles.pretendard_regular.copyWith(
              color: AppColors.plumu_gray_5,
              fontSize: 12,
              decoration: TextDecoration.underline, // ✅ 밑줄 추가
            ),
          ),
        ),
        CustomButton(
          text: '복사하기',
          onPressed: () {
            if (_profileData?.familyCode != null) {
              Clipboard.setData(ClipboardData(text: _profileData!.familyCode));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('가족코드가 복사되었습니다: ${_profileData!.familyCode}'),
                  duration: Duration(seconds: 2),
                  backgroundColor: AppColors.plumu_green_main,
                ),
              );
            }
          },
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
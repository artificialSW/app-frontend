import 'package:flutter/material.dart';
import '../../../shared/constants/app_colors.dart';
import '../../../shared/constants/app_text_styles.dart';
import 'notification_settings_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final widthRatio = screenWidth / 412.0;
    final heightRatio = screenHeight / 917.0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '환경 설정',
          style: TextStyle(
            color: Colors.black,
            fontSize: 17,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w700,
            height: 1.50,
            letterSpacing: -0.46,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 22 * widthRatio),
        child: Column(
          children: [
            SizedBox(height: 24 * heightRatio),
            _buildSettingsList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    final menuItems = [
      '알림 설정',
      '테마 설정',
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
              onTap: () {
                if (title == '알림 설정') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationSettingsPage()),
                  );
                } else {
                  // TODO: 다른 설정 페이지로 이동
                  print('$title 탭됨');
                }
              },
            ),
            const Divider(height: 1, color: Color(0x4DCECECE)),
          ],
        ),
      )
          .toList(),
    );
  }
}

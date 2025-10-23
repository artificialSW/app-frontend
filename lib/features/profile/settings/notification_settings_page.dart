import 'package:flutter/material.dart';
import '../../../shared/constants/app_colors.dart';
import '../../../shared/constants/app_text_styles.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _chatNotificationsEnabled = true;  // 대화방 알림 (기본값: ON)
  bool _puzzleNotificationsEnabled = false; // 퍼즐 알림 (기본값: OFF)

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
          '알림 설정',
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
            SizedBox(height: 40 * heightRatio),
            _buildNotificationItem(
              '대화방 알림 허용',
              _chatNotificationsEnabled,
              (value) {
                setState(() {
                  _chatNotificationsEnabled = value;
                });
                print('대화방 알림: ${value ? "ON" : "OFF"}');
              },
            ),
            SizedBox(height: 28),
            _buildNotificationItem(
              '퍼즐 알림 허용',
              _puzzleNotificationsEnabled,
              (value) {
                setState(() {
                  _puzzleNotificationsEnabled = value;
                });
                print('퍼즐 알림: ${value ? "ON" : "OFF"}');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(String title, bool isEnabled, ValueChanged<bool> onChanged) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final widthRatio = screenWidth / 412.0;
    final heightRatio = screenHeight / 917.0;

    return Container(
      padding: EdgeInsets.only(left: 32 * widthRatio, right: 32 * widthRatio),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: const Color(0xFF282828),
              fontSize: 16 * widthRatio,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
              height: 1.50,
            ),
          ),
          GestureDetector(
            onTap: () => onChanged(!isEnabled),
            child: Container(
              width: 53 * widthRatio,
              height: 28 * heightRatio,
              child: Stack(
                children: [
                  // OFF 상태일 때: 그림자가 있는 흰색 배경
                  if (!isEnabled)
                    Positioned(
                      left: 4.49 * widthRatio,
                      top: 0,
                      child: Container(
                        width: 48.51 * widthRatio,
                        height: 28 * heightRatio,
                        decoration: ShapeDecoration(
                          color: Colors.white.withValues(alpha: 0.50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16 * widthRatio),
                          ),
                          shadows: [
                            BoxShadow(
                              color: const Color(0x0C42474C),
                              blurRadius: 8 * widthRatio,
                              offset: Offset(0, 4 * heightRatio),
                              spreadRadius: 0,
                            ),
                            BoxShadow(
                              color: const Color(0x5142474C),
                              blurRadius: 0.50 * widthRatio,
                              offset: const Offset(0, 0),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  // ON 상태일 때: 초록색 배경
                  if (isEnabled)
                    Positioned(
                      left: 4.49 * widthRatio,
                      top: 0,
                      child: Container(
                        width: 48.51 * widthRatio,
                        height: 28 * heightRatio,
                        decoration: ShapeDecoration(
                          color: const Color(0xFF5CBD56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16 * widthRatio),
                          ),
                        ),
                      ),
                    ),
                  // 흰색 원 (토글 핸들)
                  Positioned(
                    left: isEnabled ? (53 - 4.49 - 20) * widthRatio : 4.49 * widthRatio, // ON일 때 오른쪽, OFF일 때 왼쪽
                    top: 4 * heightRatio,
                    child: Container(
                      width: 20 * widthRatio,
                      height: 20 * heightRatio,
                      decoration: const ShapeDecoration(
                        color: Colors.white,
                        shape: OvalBorder(),
                        shadows: [
                          BoxShadow(
                            color: Color(0x1A000000),
                            blurRadius: 2,
                            offset: Offset(0, 1),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

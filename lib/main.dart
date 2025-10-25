// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:artificialsw_frontend/services/old_image_store.dart';
import 'package:artificialsw_frontend/features/puzzle/puzzlelist_provider.dart';
import 'package:artificialsw_frontend/shell.dart';
import 'package:artificialsw_frontend/account/login.dart';
import 'package:artificialsw_frontend/account/register.dart';
import 'dart:io' show Platform;
import 'package:firebase_core/firebase_core.dart'; // ✅ Firebase 초기화용
import 'package:firebase_messaging/firebase_messaging.dart'; // ✅ FCM 관련
import 'package:flutter_local_notifications/flutter_local_notifications.dart'; // ✅ 로컬 알림 관련

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('[FCM - Background] Message: ${message.messageId}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Firebase 초기화
  await Firebase.initializeApp();

  // ✅ FCM 인스턴스
  FirebaseMessaging fbMsg = FirebaseMessaging.instance;

  // ✅ FCM 토큰 발급
  String? fcmToken = await fbMsg.getToken(
    vapidKey: "BGRA_GV..........keyvalue", // ← web용 vapidKey, Android에서는 생략 가능
  );
  print("🔥 FCM token: $fcmToken");

  // ✅ 토큰 갱신 시 처리
  fbMsg.onTokenRefresh.listen((newToken) {
    print("🔄 New FCM Token: $newToken");
    // TODO: 서버에 갱신된 토큰 저장
  });

  // ✅ 알림 플러그인 초기화
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  AndroidNotificationChannel? androidChannel;

  if (Platform.isAndroid) {
    androidChannel = const AndroidNotificationChannel(
      'important_channel', // id
      'Important_Notifications', // name
      description: '중요도가 높은 알림을 위한 채널.',
      importance: Importance.high,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }

  // ✅ 백그라운드 메시지 핸들러 등록
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // ✅ 포어그라운드 메시지 처리
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('[FCM - Foreground] Message data: ${message.data}');
    if (message.notification != null) {
      print('📩 Notification: ${message.notification}');
      flutterLocalNotificationsPlugin.show(
        message.hashCode,
        message.notification?.title ?? '알림',
        message.notification?.body ?? '',
        NotificationDetails(
          android: AndroidNotificationDetails(
            androidChannel!.id,
            androidChannel.name,
            channelDescription: androidChannel.description,
            importance: Importance.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  });

  // ✅ 알림 클릭 시 처리 (앱이 꺼져 있던 경우 포함)
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('[FCM - Clicked] ${message.data}');
    // TODO: 클릭 시 페이지 이동 로직 (예: Navigator.pushNamed(...))
  });

  // ✅ 앱 실행
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ImageStore()),
        ChangeNotifierProvider(create: (_) => PuzzleProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/shell': (context) => Shell(),
      },
    );
  }
}

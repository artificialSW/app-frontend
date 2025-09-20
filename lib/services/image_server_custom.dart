import 'dart:io';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

class ImageSaverCustom {
  static Future<void> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      // final sdkInt = (await DeviceInfoPlugin().androidInfo).version.sdkInt;
      final deviceInfo = DeviceInfoPlugin(); // ✅ 여기서 인스턴스 생성
      final sdkInt = (await deviceInfo.androidInfo).version.sdkInt;

      if (sdkInt >= 33) {
        // Android 13 이상은 미디어 권한 따로 요청
        final photosStatus = await Permission.photos.request();
        if (!photosStatus.isGranted) {
          throw PlatformException(
            code: 'PERMISSION_DENIED',
            message: '사진 저장을 위한 권한이 필요합니다.',
          );
        }
      } else {
        // Android 12 이하
        final storageStatus = await Permission.storage.request();
        if (!storageStatus.isGranted) {
          throw PlatformException(
            code: 'PERMISSION_DENIED',
            message: '저장소 접근 권한이 필요합니다.',
          );
        }
      }
    }
  }

  /// ✅ 이미지 저장 함수
  static Future<void> saveImage(String imageUrl, {String? fileName}) async {
    await _requestStoragePermission();

    final response = await Dio().get<Uint8List>(
      imageUrl,
      options: Options(responseType: ResponseType.bytes),
    );

    if (response.statusCode != 200 || response.data == null) {
      throw Exception("이미지 다운로드 실패");
    }

    // ✅ 저장 파일 이름
    final name =
        fileName ?? "puzzle_${DateTime.now().millisecondsSinceEpoch}.jpg";

    // ✅ 저장 경로 확보 (앱 내 저장소)
    final dir =
        await getExternalStorageDirectory(); // /storage/emulated/0/Android/data/your.package.name/files
    final fullPath = "${dir!.path}/$name";

    final file = File(fullPath);
    await file.writeAsBytes(response.data!);

    // ✅ Android 갤러리에 노출되도록 미디어 스캔 요청
    if (Platform.isAndroid) {
      final result = await Process.run('am', [
        'broadcast',
        '-a',
        'android.intent.action.MEDIA_SCANNER_SCAN_FILE',
        '-d',
        'file://$fullPath',
      ]);
      print("갤러리 등록 결과: ${result.stdout}");
    }

    print("이미지 저장 완료: $fullPath");
  }
}

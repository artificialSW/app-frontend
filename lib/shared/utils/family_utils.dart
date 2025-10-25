import 'dart:math';
import 'package:artificialsw_frontend/shared/constants/app_assets.dart';
import 'package:artificialsw_frontend/services/storage_service.dart';

class FamilyUtils {
  FamilyUtils._(); // 인스턴스화 방지

  /// 가족 구성원 역할에 따라 프로필 이미지를 반환
  /// familyType: '아들', '딸', '아빠', '엄마', '할아버지', '할머니'
  static String getProfileImageByFamilyType(String familyType) {
    switch (familyType) {
      case '아들':
        return AppAssets.son;
      case '딸':
        return AppAssets.daughter;
      case '아빠':
        return AppAssets.dad;
      case '엄마':
        return AppAssets.mom;
      case '할아버지':
        return AppAssets.grandfather;
              case '할머니':
                return AppAssets.person_circle;
      default:
        return AppAssets.person_circle; // 기본값
    }
  }

  /// 역할에 따라 프로필 이미지를 반환 (getProfileImageByFamilyType의 별칭)
  static String getProfileImageByRole(String role) {
    return getProfileImageByFamilyType(role);
  }

  /// 현재 사용자와 댓글 작성자의 역할을 비교하여 표시할 이름을 반환
  /// 현재 사용자와 역할이 같으면 "나", 다르면 원래 역할 반환
  static Future<String> getDisplayNameByRole(String writerRole) async {
    final currentUserRole = await StorageService.getUserRole();
    
    // 현재 사용자 역할이 없거나 다르면 원래 역할 반환
    if (currentUserRole == null || currentUserRole != writerRole) {
      return writerRole;
    }
    
    // 현재 사용자와 역할이 같으면 "나" 반환
    return '나';
  }

  /// 가족 구성원 목록
  static const List<String> _familyRoles = [
    '아들', '딸', '아빠', '엄마', '할아버지', '할머니'
  ];

  /// 무작위로 서로 다른 2명의 가족원을 선택하여 반환
  static List<String> getRandomFamilyMembers() {
    final random = Random();
    final shuffled = List<String>.from(_familyRoles)..shuffle(random);
    return shuffled.take(2).toList();
  }
}

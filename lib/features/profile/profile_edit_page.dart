import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../shared/constants/app_colors.dart';
import '../../shared/constants/app_text_styles.dart';
import '../../shared/constants/app_assets.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/custom_top_bar.dart';
import 'package:artificialsw_frontend/features/profile/widgets/profile_type_button.dart';
import '../../services/profile/profile_service.dart';
import '../../services/profile/dto/profile_response_dto.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final ProfileService _profileService = ProfileService();
  ProfileResponseDto? _profileData;
  bool _isLoading = true;
  
  // 텍스트 컨트롤러
  late TextEditingController _nameController;
  late TextEditingController _birthController;
  
  // 선택된 구성원 타입
  String _selectedFamilyType = '자녀';
  
  // 구성원 타입 목록
  final List<String> _familyTypes = ['자녀', '아빠', '엄마', '할아버지', '할머니'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _birthController = TextEditingController();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _birthController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final profileData = await _profileService.getProfile();
      setState(() {
        _profileData = profileData;
        _isLoading = false;
        _nameController.text = profileData.name;
        _birthController.text = profileData.birth;
        _selectedFamilyType = profileData.familyType;
      });
    } catch (e) {
      print('❌ 프로필 정보 로드 실패: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

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
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 32 * widthRatio),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 
                            MediaQuery.of(context).padding.top - 
                            kToolbarHeight,
                ),
                child: Column(
                  children: [
                  SizedBox(height: 50 * heightRatio),
                  
                  // 프로필 사진
                  Stack(
                    children: [
                      Container(
                        width: 133.04 * widthRatio,
                        height: 133.04 * heightRatio,
                        decoration: const ShapeDecoration(
                          color: Color(0xFFF3F3F3),
                          shape: OvalBorder(),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                           child: GestureDetector(
                             onTap: () {
                               // TODO: 프로필 사진 변경 기능
                               print('프로필 사진 변경');
                             },
                             child: Container(
                               width: 48.53 * widthRatio,
                               height: 48.53 * heightRatio,
                               decoration: const ShapeDecoration(
                                 color: Color(0xFFCDCDCD),
                                 shape: OvalBorder(),
                               ),
                               child: Center(
                                 child: Image.asset(
                                   AppAssets.profile_picture_change,
                                   width: 48.53 * widthRatio,
                                   height: 48.53 * heightRatio,
                                 ),
                               ),
                             ),
                           ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 40 * heightRatio),
                  
                  // 이름 라벨
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '이름',
                      style: AppTextStyles.pretendard_medium.copyWith(
                        color: const Color(0xFF282828),
                        fontSize: 16,
                        height: 1.25,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 8 * heightRatio),
                  
                         // 이름 입력 필드
                         Container(
                           width: 348 * widthRatio,
                           height: 52 * heightRatio,
                           decoration: ShapeDecoration(
                             shape: RoundedRectangleBorder(
                               side: const BorderSide(
                                 width: 1,
                                 color: Color(0xFFAAAAAA),
                               ),
                               borderRadius: BorderRadius.circular(8),
                             ),
                           ),
                           child: TextField(
                             controller: _nameController,
                             decoration: const InputDecoration(
                               border: InputBorder.none,
                               contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                             ),
                             style: AppTextStyles.pretendard_regular.copyWith(
                               fontSize: 16,
                               color: Colors.black,
                             ),
                           ),
                         ),
                  
                  SizedBox(height: 24 * heightRatio),
                  
                  // 생년월일 라벨
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '생년월일',
                      style: AppTextStyles.pretendard_medium.copyWith(
                        color: const Color(0xFF282828),
                        fontSize: 16,
                        height: 1.25,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 8 * heightRatio),
                  
                         // 생년월일 입력 필드
                         Container(
                           width: 348 * widthRatio,
                           height: 52 * heightRatio,
                           decoration: ShapeDecoration(
                             shape: RoundedRectangleBorder(
                               side: const BorderSide(
                                 width: 1,
                                 color: Color(0xFFAAAAAA),
                               ),
                               borderRadius: BorderRadius.circular(8),
                             ),
                           ),
                           child: TextField(
                             controller: _birthController,
                             decoration: const InputDecoration(
                               border: InputBorder.none,
                               contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                             ),
                             style: AppTextStyles.pretendard_regular.copyWith(
                               fontSize: 16,
                               color: Colors.black,
                             ),
                           ),
                         ),
                  
                  SizedBox(height: 24 * heightRatio),
                  
                  // 구성원 라벨
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '구성원',
                      style: AppTextStyles.pretendard_medium.copyWith(
                        color: const Color(0xFF282828),
                        fontSize: 16,
                        height: 1.25,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 8 * heightRatio),
                  
                  // 구성원 버튼들
                  Row(
                    children: _familyTypes.map((type) {
                      return Padding(
                        padding: EdgeInsets.only(right: 8 * widthRatio),
                        child: ProfileTypeButton(
                          text: type,
                          isSelected: _selectedFamilyType == type,
                          onTap: () {
                            setState(() {
                              _selectedFamilyType = type;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  
                  // 수정하기 버튼 - profile_type_button들로부터 278px 떨어지게
                  Padding(
                    padding: EdgeInsets.only(top: 278 * heightRatio),
                    child: CustomButton(
                      text: '수정하기',
                      onPressed: _saveProfile,
                      width: 348 * widthRatio,
                      height: 52 * heightRatio,
                    ),
                  ),

                  SizedBox(height: 30 * heightRatio),
                  ],
                ),
              ),
            ),
    );
  }

  void _saveProfile() {
    // TODO: API 호출로 프로필 수정
    print('프로필 수정:');
    print('이름: ${_nameController.text}');
    print('생년월일: ${_birthController.text}');
    print('구성원: $_selectedFamilyType');
    
    // 임시로 이전 화면으로 돌아가기
    Navigator.pop(context);
  }
}

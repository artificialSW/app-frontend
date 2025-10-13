import 'dart:convert';
import 'dart:io';
import 'package:artificialsw_frontend/features/puzzle/model/image_upload_unit.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/image_upload/image_upload_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/image_upload/picture_data_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/puzzle_service.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_button.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:exif/exif.dart';

// 디자인 통일
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/features/puzzle/weekly_upload/image_upload_comment_page.dart';
class ImageUploadPage extends StatefulWidget {
  final List<String> category;

  const ImageUploadPage({super.key, required this.category});

  @override
  State<ImageUploadPage> createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {

  String? exifToIso8601(String? exifDate) {
    if (exifDate == null) return null;

    // "2025:10:10 21:05:47" → "2025-10-10T21:05:47Z"
    final iso = exifDate
        .replaceRange(4, 5, '-')   // 첫 번째 콜론 → '-'
        .replaceRange(7, 8, '-')   // 두 번째 콜론 → '-'
        .replaceFirst(' ', 'T')    // 공백 → 'T'
        + 'Z';                     // UTC 표시

    return iso;
  }

  final List<UploadUnit> _uploads = [];
  File? _currentImage;
  final TextEditingController _commentController = TextEditingController();
  final int maxCount = 3; // 카테고리 3개 기준

  @override
  void initState() {
    super.initState();
    _commentController.addListener(() => setState(() {}));
  }

  // --- 기존 함수 유지: 이미지 픽커 ---
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final fileBytes = await File(picked.path).readAsBytes();
      final tags = await readExifFromBytes(fileBytes);

// 먼저 존재 여부 확인
      print(tags.keys);

// 찍은 날짜 가져오기
      final date = tags['EXIF DateTimeOriginal'] ??
          tags['Image DateTimeOriginal'] ??
          tags['DateTimeOriginal'] ??
          '날짜 정보 없음';

      final isoDate = exifToIso8601(date?.toString());

      print('📸 촬영일자: ${isoDate}');

      setState(() {
        _currentImage = File(picked.path);
      });
    }
  }

  // 카테고리 index로 이미 업로드된 항목 찾기
  UploadUnit? _getUploadForIndex(int idx) {
    final cat = widget.category[idx]; //실제 카테고리
    final foundIdx = _uploads.indexWhere((u) => u.category == cat); //카테고리가 있는지 체크
    if (foundIdx == -1) return null;
    return _uploads[foundIdx];
  }

  void _saveCurrentEntry(int curridx) {
    // curridx 카테고리에 대한 기존 항목
    final existing = _getUploadForIndex(curridx);

    // 새 이미지가 없고, 기존 이미지도 없으면 저장 불가(코멘트만으로는 불가)
    final imageFile = _currentImage ?? existing?.imageFile;
    if (imageFile != null && _commentController.text.isNotEmpty) {
      setState(() {
        final newUnit = UploadUnit(
          imageFile: imageFile,
          comment: _commentController.text,
          category: widget.category[curridx],
        );

        final cat = widget.category[curridx];
        final existIdx = _uploads.indexWhere((u) => u.category == cat);
        if (existIdx >= 0) {
          _uploads[existIdx] = newUnit; // 교체(수정)
        } else {
          _uploads.add(newUnit); // 신규 추가
        }

        _currentImage = null;
        _commentController.clear();
      });
    }
  }

  // 코멘트 입력 팝업
  // Future<void> _showCommentDialog(int idx, {String? initial}) async {
  //   _commentController.text = initial ?? '';
  //
  //   final existing = _getUploadForIndex(idx); // 우리가 만든 헬퍼 (없으면 null)
  //
  //   await showDialog<void>(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (dialogContext) {
  //       return CommentPage(
  //         controller: _commentController,
  //         currentCategory: widget.category[idx],
  //         currentImage: _currentImage,              // 새로 고른 이미지
  //         existingImage: existing?.imageFile,       // 기존 이미지
  //         onCancel: () {
  //           setState(() {
  //             _currentImage = null;
  //             _commentController.clear();
  //           });
  //           Navigator.of(dialogContext).pop();      // ✅ 팝업만 닫기
  //         },
  //         onSave: () {
  //           _saveCurrentEntry(idx);                 // 기존 로직 재사용
  //           Navigator.of(dialogContext).pop();      // ✅ 팝업만 닫기
  //         },
  //       );
  //     },
  //   );
  // }


  // 타일 탭 → 이미지 선택 → 코멘트 팝업
  Future<void> _handleAddOrEdit(int idx) async {
    final existing = _getUploadForIndex(idx);

    // 이미지 먼저 선택(기존 이미지만 수정 원하면 "취소" 후 팝업에서 저장이 되도록 허용)
    await _pickImage();

    // 이미지 선택 취소했더라도, 기존 이미지가 있으면 코멘트만 수정 가능
    //await _showCommentDialog(idx, initial: existing?.comment);
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CommentPage(
          currentCategory: widget.category[idx],
          currentImage: _currentImage,
          existingImage: existing?.imageFile,
          initialText: existing?.comment ?? '',
        ),
      ),
    );

    if (result is Map) {
      final image = result['image'] as File?;
      final comment = result['comment'] as String;

      setState(() {
        final newUnit = UploadUnit(
          imageFile: image!,
          comment: comment,
          category: widget.category[idx],
        );

        final existIdx = _uploads.indexWhere((u) => u.category == widget.category[idx]);
        if (existIdx >= 0) {
          _uploads[existIdx] = newUnit;
        } else {
          _uploads.add(newUnit);
        }

        _currentImage = null;
        _commentController.clear();
      });
    }
  }



    // --- 기존 함수 유지: 업로드 제출 ---
  Future<void> _submitAll() async {
    final List<Map<String, dynamic>> pictureDataList = [];

    for (final item in _uploads) {
      final base64String = base64Encode(await item.imageFile.readAsBytes());

      pictureDataList.add({
        "userId": 123,
        "imageBase64": "${base64String.substring(0, 50)}...",
        "comment": item.comment,
        "category": item.category,
      });

      await PuzzleService().uploadPuzzleImagesWithMetadata(
        ImageUploadDto(
          pictureData: [
            PictureDataDto(
              userId: "123",
              imageBase64: base64String,
              comment: item.comment,
              category: item.category,
            ),
          ],
        ),
      );
    }

    // 디버깅용 로그
    const encoder = JsonEncoder.withIndent('  ');
    // ignore: avoid_print
    print('pictureData: ${encoder.convert(pictureDataList)}');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ 전체 업로드 완료!')),
    );

    // 퍼즐 메인으로 이동 (기존 동작 유지)
    Navigator.of(context).pushNamed('/');
  }

  Widget _buildCategoryTile(int idx) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final uploaded = _getUploadForIndex(idx); ///처음이라면 upload == null,
    ///처음이 아니라면 UploadUnit 타입 저장
    ///   { final File imageFile,
    ///   final String comment,
    ///   final String category }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 초록 라운드 칩: "주제1" 등
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.plumu_green_main,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            widget.category[idx],
            style: AppTextStyles.pretendard_bold.copyWith(
              fontSize: 12,
              color: AppColors.plumu_white,
            ),
          ),
        ),
        const SizedBox(height: 10),
        // + 타일 / 이미지 미리보기
        GestureDetector(
          onTap: () => _handleAddOrEdit(idx),
          child: Container(
            width: screenHeight*0.15,
            height: screenHeight*0.15,
            decoration: BoxDecoration(
              color: AppColors.plumu_gray_2,
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: uploaded == null
                ? //upload가 null일때
            Center(
              child: Icon(
                Icons.add,
                size: 40,
                color: Colors.grey, // 아이콘만 기본색 사용(에러 방지)
              ),
            )
                : //upload가 null이 아닐 때
            Stack(
              fit: StackFit.expand,
              children: [
                Image.file(uploaded.imageFile, fit: BoxFit.cover),
                // 우상단에 살짝 편집 힌트(선택 사항, 디자인 최소 변경)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final isDone = _uploads.length >= maxCount;

    return Scaffold(
      appBar: CanGoBackTopBar('사진 업로드', context),
      backgroundColor: AppColors.plumu_white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 상단 타이틀 영역 (아이콘 + 제목 + 부제)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 퍼즐 아이콘 느낌 (자산 없어서 기본 아이콘 사용)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.extension, // 퍼즐 조각 유사 아이콘
                      color: AppColors.plumu_green_main,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '사진 업로드하기',
                          style: AppTextStyles.pretendard_bold.copyWith(
                            fontSize: 22,
                            color: AppColors.plumu_green_main,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '이번주의 주제별로 사진을 제출해주세요!',
                          style: AppTextStyles.pretendard_regular.copyWith(
                            fontSize: 14,
                            color: AppColors.plumu_gray_7,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // 주제 1~3 섹션 (세로 나열, 모두 한 화면에서 미리보기 가능)
              for (int i = 0; i < maxCount && i < widget.category.length; i++) ...[
                _buildCategoryTile(i),
                SizedBox(height: screenHeight*0.02),
              ],

              // 하단 여백
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      // 하단 "제출하기" 버튼 (기존 업로드 함수 사용)
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: CustomButton(
            text: '제출하기',
            onPressed: isDone ? _submitAll : null,
            width: double.infinity,
            height: 52,
            fontSize: 16,
            textColor: AppColors.plumu_white,
            backgroundColor:
            isDone ? AppColors.plumu_green_main : AppColors.plumu_gray_3,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

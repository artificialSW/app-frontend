import 'dart:typed_data';

import 'package:artificialsw_frontend/features/puzzle/model/puzzlegame.dart';
import 'package:artificialsw_frontend/features/puzzle/puzzlelist_provider.dart';
import 'package:artificialsw_frontend/services/image_server_custom.dart';
import 'package:artificialsw_frontend/services/puzzle/dto/get_archived_puzzle_list/puzzle_get_archived_list_dto.dart';
import 'package:artificialsw_frontend/services/puzzle/puzzle_service.dart';
import 'package:artificialsw_frontend/shared/models/usermodel.dart';
import 'package:artificialsw_frontend/shared/widgets/custom_top_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:artificialsw_frontend/shared/constants/app_text_styles.dart';
import 'package:artificialsw_frontend/shared/constants/app_colors.dart';
import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:typed_data';

class PuzzleArchive extends StatefulWidget {
  const PuzzleArchive({super.key});

  @override
  State<PuzzleArchive> createState() => _PuzzleArchiveState();
}

class _PuzzleArchiveState extends State<PuzzleArchive> {
  final _user = User(name: 'MockUser', id: 123, role: '아빠');

  late Future<List<PuzzleGetArchivedListDto>> _archivedPuzzlesFuture;

  Future<List<PuzzleGetArchivedListDto>> _fetchArchivedPuzzles() async {
    try{
      return await PuzzleService().getArchivedList();
    } catch (e){
      print('⚠️ 서버 응답 실패, 목데이터 사용: $e');
      // ✅ 목데이터 리턴
      throw Exception('err!!!!');
    }
  }

  @override
  void initState() {
    super.initState();
    _archivedPuzzlesFuture = _fetchArchivedPuzzles();
  }

  static Future<void> saveImage(String imageUrl) async {
    try {
      // 1️⃣ 네트워크에서 이미지 다운로드
      final response = await Dio().get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      final Uint8List bytes = Uint8List.fromList(response.data);

      // 2️⃣ 갤러리에 저장
      final result = await ImageGallerySaver.saveImage(
        bytes,
        quality: 100,
        name: "puzzle_${DateTime.now().millisecondsSinceEpoch}",
      );

      if (result['isSuccess'] == false) {
        throw Exception('갤러리 저장 실패');
      }
    } catch (e) {
      throw Exception('이미지 저장 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CanGoBackTopBar('퍼즐 아카이브', context),
      body: FutureBuilder<List<PuzzleGetArchivedListDto>>(
        future: _fetchArchivedPuzzles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('데이터 불러오기 실패'));
          }

          final puzzles = snapshot.data!;

          if (puzzles.isEmpty) {
            return const Center(child: Text('아카이브에 퍼즐이 없습니다.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: puzzles.length,
            itemBuilder: (context, index) {
              final puzzleDto = puzzles[index];
              return PuzzleListItem(
                puzzleDto: puzzleDto,
                // onDelete: () {
                //   PuzzleService().deletePuzzle(puzzleDto.puzzleId.toString());
                // },
                onDelete: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: Colors.white.withValues(alpha: 0.85),
                        insetPadding: const EdgeInsets.symmetric(horizontal: 45),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16, top: 28, bottom: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '아카이브에서 퍼즐을 삭제하시겠습니까?',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.pretendard_bold.copyWith(
                                    fontSize: 15
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '퍼즐 관련 데이터가 모두 삭제됩니다.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.plumu_gray_7,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      style: TextButton.styleFrom(
                                        backgroundColor: AppColors.plumu_white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text(
                                        '아니오',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      style: TextButton.styleFrom(
                                        backgroundColor: AppColors.plumu_white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text(
                                        '예',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );

                  if (confirm == true) {
                    await PuzzleService().deletePuzzleFromArchive(puzzleDto.puzzleId.toString());
                    setState(() {
                      puzzles.removeWhere((p) => p.puzzleId == puzzleDto.puzzleId);
                    });
                  }
                },
                onPressed: () {

                },
                onSave: () async {
                  try {
                    await ImageSaverCustom.saveImage(puzzleDto.imageUrl);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("이미지 저장 완료")),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("저장 실패: ${e.toString()}")),
                    );
                  }
                },

                gameState: GameState.Completed,
                isArchived: true,
              );
            },
          );
        },
      ),
    );
  }
}

import 'dart:io';
import 'package:artificialsw_frontend/shared/widgets/custom_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:artificialsw_frontend/services/image_store.dart';

class ImageUploadPage extends StatefulWidget {
  const ImageUploadPage({Key? key}) : super(key: key);

  @override
  State<ImageUploadPage> createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  final ImagePicker _picker = ImagePicker();
  final List<File> _imageFiles = [];
  //final images = ImageStore().imageWidgetList;

  Future<void> _pickImage() async {
    if (_imageFiles.length >= 3) return; //무조건 3개 넣어야 한다고 강제

    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);

      final imageWidget = Image.file(
        file,
        fit: BoxFit.cover,
      );

      setState(() {
        _imageFiles.add(file);
        ImageStore().addImageWidget(imageWidget); //새로운 인스턴스 생성하긴 하지만, 싱글톤이라 배열 객체는 하나로 관리됨.
        print(ImageStore().widgetCount);
        ImageStore().imageFileList.add(file);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CanGoBackTopBar("이미지 업로드 테스트", context),
      body: Center(
        child: Column(
          children: [
            Text("사진 업로드하기"),
            const SizedBox(height: 10),
            Text("이번주의 주제별로 사진을 제출해주세요!"),
            const SizedBox(height: 20),
            Text("주제1: 맛있었던 과일"),
            const SizedBox(height: 10),
            _imageFiles.isNotEmpty
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _imageFiles.map((file) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Image.file(
                    file,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                );
              }).toList(),
            )
                : const Text("선택된 이미지가 없습니다"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text("+"),
            ),
            const SizedBox(height: 50),
            Text("주제2: 좋았던 풍경"),
            const SizedBox(height: 50),
            Text("주제3: 행복했던 식사"),
            const SizedBox(height: 100),
            Text("일요일 밤 11시 59분까지 제출해주세요!"),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('/puzzle/add-comment'),
                child: const Text("사진 제출하기")
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:artificialsw_frontend/services/image_store.dart';

class ImageUploadTestPage extends StatefulWidget {
  const ImageUploadTestPage({Key? key}) : super(key: key);

  @override
  State<ImageUploadTestPage> createState() => _ImageUploadTestPageState();
}

class _ImageUploadTestPageState extends State<ImageUploadTestPage> {
  final ImagePicker _picker = ImagePicker();
  final List<File> _imageFiles = [];
  final images = ImageStore().imageWidgetList;

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
        ImageStore().imageWidgetList.add(imageWidget); //새로운 인스턴스 생성하긴 하지만, 싱글톤이라 배열 객체는 하나로 관리됨.
        print(ImageStore().imageWidgetList.length);
        ImageStore().imageFileList.add(file);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("이미지 업로드 테스트")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("3개의 이미지를 선택해주세요. 현재 ${_imageFiles.length}개의 이미지가 선택되어 있습니다."),
            const SizedBox(height: 20),
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
              child: const Text("갤러리에서 이미지 선택"),
            ),
            SizedBox(height: 40,),
            // Center(
            //   child: images.length >= 3
            //       ? Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       images[0],
            //       const SizedBox(width: 10),
            //       images[1],
            //       const SizedBox(width: 10),
            //       images[2],
            //     ],
            //   )
            //       : const Text("ui용 이미지 아직 없다"),
            // ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:nimc_card_scanner/nimc_card_scanner/crop_image.dart';
// import 'package:nimc_card_scanner/nimc_card_scanner/result.dart';

class PassportTestExample extends StatefulWidget {
  const PassportTestExample({super.key});

  @override
  State<PassportTestExample> createState() => _PassportTestExampleState();
}

class _PassportTestExampleState extends State<PassportTestExample> {
  String imgPath = '';
  // MaskForCameraViewResult? _res;

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() async {
        imgPath = image.path;
        // _res = await cropImage(
          // 'passport', image.path, , cropWeight, screenHeight, screenWidth, insideLine)
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Passport Test Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: pickImage,
              child: const Text('Pick Image from Gallery'),
            ),
            const SizedBox(height: 20),
            imgPath.isNotEmpty
                ? Image.file(File(imgPath), width: 300, height: 300)
                : const Text('No image selected.'),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:nimc_card_scanner/src/main_crop.dart';
import 'package:nimc_card_scanner/src/mask_camera.dart';
import 'package:nimc_card_scanner/src/result.dart';
// import 'package:nimc_card_scanner/src/screens/analyzer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'src/enum/card_types.dart';
import 'src/model/result.dart';
export 'src/model/result.dart';

class NimcCardScanner<T extends ScanResult> {
  final Function(T scanResult)? onCapture;

  NimcCardScanner({this.onCapture});

  Future<T?> startScan(BuildContext context) async {
    // print(T);

    await MaskForCameraView.initialize();
    // Implementation for starting the scan based on cardType
    // This is a placeholder for actual scanning logic
    // After scanning, create an instance of T and call onCapture with it
    if (T == PassportResult) {
      // Handle passport scan result
      return _navigatePage(CardType.passport, context);
    }

    if (T == DriverLicenseResult) {
      // Handle driver's license scan result
      return _navigatePage(CardType.driverLicense, context);
    }

    if (T == NationalIdResult) {
      //handle national id scan result
      return _navigatePage(CardType.nationalId, context);
    }

    return null;
  }

  Future<T?> _navigatePage(CardType ocrType, BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute<MaskForCameraViewResult>(
        builder: (context) => MaskOCRCam(
          ocrType: ocrType.name,
          // ocrSubType: _ocrSubType,
          showPopBack: false,

          // onCapture: (val, img) {
          //   final Map data = {
          //     'kycType': ocrType.name,
          //     'data': val,
          //     'kycImg': img,
          //   };
          //   print(data);
        ),
      ),
    );
    // print("result $result");
    if (result != null) {
      return analyzeCard(result);
    } else {
      return null;
    }
  }

  static Future<String> performOcrOnImage(Uint8List imageBytes) async {
    final tempDir = await getTemporaryDirectory();
    File file = await File(
      '${tempDir.path}/image${DateTime.now().millisecondsSinceEpoch}.png',
    ).create();
    file.writeAsBytesSync(imageBytes);
    // print('image path');
    // print(file.path);

    final inputImage = InputImage.fromFilePath(file.path);

    // result = '';
    final textDetector = TextRecognizer();
    final RecognizedText recognisedText = await textDetector.processImage(
      inputImage,
    );

    return recognisedText.text;
  }

  Future<T> analyzeCard(MaskForCameraViewResult res) async {
    ScanResult? scanResult;
    // print(T);
    if (T == PassportResult) {
      scanResult = PassportResult(kycImg: res.croppedImage) as T?;

      img.Image? image = img.decodeImage(res.croppedImage!);
      //extract kycImg
      res.sixPartImage = extractImage(
        scanResult!.sixthCroppedImage(image!),
        image,
      );

      scanResult.kycImg = res.sixPartImage;

      res.firstPartImage = extractImage(
        scanResult.firstCroppedImage(image),
        image,
      );

      (scanResult as PassportResult).passportNumber = await performOcr(
        res.firstPartImage!,
      );

      (scanResult).passportNumber = (scanResult).passportNumber
          ?.replaceAll("\n", ' ')
          .split(' ')
          .last
          .trim();

      res.secondPartImage = extractImage(
        scanResult.secondCroppedImage(image),
        image,
      );

      (scanResult).givenNames = await performOcr(res.secondPartImage!);

      (scanResult).cleanGivenNames();
    }

    if (T == DriverLicenseResult) {
      scanResult = DriverLicenseResult(kycImg: res.croppedImage) as T?;

      img.Image? image = img.decodeImage(res.croppedImage!);

      res.firstPartImage = extractImage(
        scanResult!.firstCroppedImage(image!),
        image,
      );

      await performOcr(res.firstPartImage!).then((value) {
        (scanResult as DriverLicenseResult).extractNameAndDob(value ?? "");
      });

      res.secondPartImage = extractImage(
        scanResult.secondCroppedImage(image),
        image,
      );

      await performOcr(res.secondPartImage!).then((value) {
        (scanResult as DriverLicenseResult).licenseNumber = value
            ?.split(' ')
            .last
            .trim();
      });

      //kyc img
      res.sixPartImage = extractImage(
        scanResult.sixthCroppedImage(image),
        image,
      );
      scanResult.kycImg = res.sixPartImage;
    }

    if (T == NationalIdResult) {
      scanResult = NationalIdResult(kycImg: res.croppedImage) as T?;

      img.Image? image = img.decodeImage(res.croppedImage!);

      res.firstPartImage = extractImage(
        scanResult!.firstCroppedImage(image!),
        image,
      );

      await performOcr(res.firstPartImage!).then((value) {
        //split by comma
        (scanResult as NationalIdResult).idNumber = (value?.split(' ') ?? [])
            .last
            .trim();
      });

      res.sixPartImage = extractImage(
        scanResult.sixthCroppedImage(image),
        image,
      );

      //kyc img
      res.sixPartImage = extractImage(
        scanResult.sixthCroppedImage(image),
        image,
      );

      scanResult.kycImg = res.sixPartImage;
    }

    return scanResult as T;
  }

  Uint8List? extractImage(SnipeData snipeData, img.Image image) {
    // if (res?.croppedImage == null) return null;

    final cropped = img.copyCrop(
      image,
      x: snipeData.xOffset.toInt(),
      y: snipeData.yOffset.toInt(),
      width: snipeData.width.toInt(),
      height: snipeData.height.toInt(),
    );
    final croppedList = img.encodeJpg(cropped);
    final croppedBytes = Uint8List.fromList(croppedList);

    return croppedBytes;
  }

  Future<String?> performOcr(Uint8List imageBytes) async {
    String ocrText = await NimcCardScanner.performOcrOnImage(imageBytes);
    return ocrText;
  }
}

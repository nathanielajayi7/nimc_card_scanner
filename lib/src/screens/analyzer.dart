import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nimc_card_scanner/nimc_card_scanner.dart';
import 'package:nimc_card_scanner/src/result.dart';
import 'package:image/image.dart' as img;
import '../mask_camera.dart';

class CardAnalyzer<T extends ScanResult> extends StatefulWidget {
  final MaskForCameraViewResult res;
  const CardAnalyzer({super.key, required this.res});

  @override
  State<CardAnalyzer> createState() => _CardAnalyzerState<T>();
}

class _CardAnalyzerState<T extends ScanResult> extends State<CardAnalyzer> {
  MaskForCameraViewResult? res;

  T? scanResult;

  @override
  void initState() {
    super.initState();
    res = widget.res;
    analyzeCard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: (T == PassportResult)
            ? [
                // Text('Cropped Image'),
                // res?.croppedImage != null
                //     ? MyImageView(imageBytes: res!.croppedImage!)
                //     : Container(),
                Text(
                  'Passport Number Image: ${(scanResult as PassportResult).passportNumber ?? ""}',
                ),
                res?.firstPartImage != null
                    ? MyImageView(imageBytes: res!.firstPartImage!)
                    : Container(),

                Text(
                  'Given Names Image: ${(scanResult as PassportResult).givenNames ?? ""}',
                ),
                res?.secondPartImage != null
                    ? MyImageView(imageBytes: res!.secondPartImage!)
                    : Container(),

                //button to re-analyze
                ElevatedButton(
                  onPressed: () {
                    analyzeCard();
                  },
                  child: Text('Re-analyze'),
                ),
              ]
            : ((T == DriverLicenseResult)
                  ? [
                      // Text('Cropped Image'),
                      // res?.croppedImage != null
                      //     ? MyImageView(imageBytes: res!.croppedImage!)
                      //     : Container(),
                      Text(
                        'Name & Dob Image: ${(scanResult as DriverLicenseResult).firstName ?? ""} ${(scanResult as DriverLicenseResult).lastName ?? ""} ${(scanResult as DriverLicenseResult).dob ?? ""}',
                      ),
                      res?.firstPartImage != null
                          ? MyImageView(imageBytes: res!.firstPartImage!)
                          : Container(),

                      Text(
                        'License Number Image: ${(scanResult as DriverLicenseResult).licenseNumber ?? ""}',
                      ),
                      res?.firstPartImage != null
                          ? MyImageView(imageBytes: res!.secondPartImage!)
                          : Container(),

                      //kyc img
                      Text('KYC Image:'),
                      res?.firstPartImage != null
                          ? MyImageView(imageBytes: res!.sixPartImage!)
                          : Container(),

                      // Text(
                      //   'Date of Birth Image: ${(scanResult as DriverLicenseResult).dateOfBirth ?? ""}',
                      // ),
                      // res?.secondPartImage != null
                      //     ? MyImageView(imageBytes: res!.secondPartImage!)
                      //     : Container(),

                      //button to re-analyze
                      ElevatedButton(
                        onPressed: () {
                          analyzeCard();
                        },
                        child: Text('Re-analyze'),
                      ),
                    ]
                  : (T == NationalIdResult
                        ? [
                            // Text('Cropped Image'),
                            // res?.croppedImage != null
                            //     ? MyImageView(imageBytes: res!.croppedImage!)
                            //     : Container(),
                            Text(
                              'NIN Number Image: ${(scanResult as NationalIdResult).idNumber ?? ""}',
                            ),
                            res?.firstPartImage != null
                                ? MyImageView(imageBytes: res!.firstPartImage!)
                                : Container(),

                            //kyc img
                            Text('KYC Image:'),
                            res?.firstPartImage != null
                                ? MyImageView(imageBytes: res!.sixPartImage!)
                                : Container(),

                            //button to re-analyze
                            ElevatedButton(
                              onPressed: () {
                                analyzeCard();
                              },
                              child: Text('Re-analyze'),
                            ),
                          ]
                        :
        [

        ])),
      ),
    );
  }

  void analyzeCard() async {
    // print(T);
    if (T == PassportResult) {
      scanResult = PassportResult(kycImg: res!.croppedImage) as T?;

      img.Image? image = img.decodeImage(res!.croppedImage!);
      //extract kycImg
      setState(() {
        res!.sixPartImage = extractImage(
          scanResult!.sixthCroppedImage(image!),
          image,
        );
      });

      scanResult!.kycImg = res!.sixPartImage;

      //extract passport number
      setState(() {
        res!.firstPartImage = extractImage(
          scanResult!.firstCroppedImage(image!),
          image,
        );
      });

      (scanResult as PassportResult).passportNumber = await performOcr(
        res!.firstPartImage!,
      );

      (scanResult as PassportResult).passportNumber =
          (scanResult as PassportResult).passportNumber
              ?.replaceAll("\n", ' ')
              .split(' ')
              .last
              .trim();

      res!.secondPartImage = extractImage(
        scanResult!.secondCroppedImage(image!),
        image,
      );

      (scanResult as PassportResult).givenNames = await performOcr(
        res!.secondPartImage!,
      );

      (scanResult as PassportResult).cleanGivenNames();

      //extract passport names
      setState(() {});
    }

    if (T == DriverLicenseResult) {
      scanResult = DriverLicenseResult(kycImg: res!.croppedImage) as T?;

      img.Image? image = img.decodeImage(res!.croppedImage!);

      res!.firstPartImage = extractImage(
        scanResult!.firstCroppedImage(image!),
        image,
      );

      await performOcr(res!.firstPartImage!).then((value) {
        (scanResult as DriverLicenseResult).extractNameAndDob(value ?? "");
      });

      res!.secondPartImage = extractImage(
        scanResult!.secondCroppedImage(image),
        image,
      );

      await performOcr(res!.secondPartImage!).then((value) {
        (scanResult as DriverLicenseResult).licenseNumber = value
            ?.split(' ')
            .last
            .trim();
      });

      //kyc img
      setState(() {
        res!.sixPartImage = extractImage(
          scanResult!.sixthCroppedImage(image),
          image,
        );
        scanResult!.kycImg = res!.sixPartImage;
      });
    }

    if (T == NationalIdResult) {
      scanResult = NationalIdResult(kycImg: res!.croppedImage) as T?;

      img.Image? image = img.decodeImage(res!.croppedImage!);

      res!.firstPartImage = extractImage(
        scanResult!.firstCroppedImage(image!),
        image,
      );

      await performOcr(res!.firstPartImage!).then((value) {
        //split by comma
        (scanResult as NationalIdResult).idNumber = (value?.split(' ') ?? [])
            .last
            .trim();
      });

      res!.sixPartImage = extractImage(
        scanResult!.sixthCroppedImage(image),
        image,
      );

      //kyc img
      setState(() {
        res!.sixPartImage = extractImage(
          scanResult!.sixthCroppedImage(image),
          image,
        );
        scanResult!.kycImg = res!.sixPartImage;
      });
    }
  }

  Uint8List? extractImage(SnipeData snipeData, img.Image image) {
    if (res?.croppedImage == null) return null;

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

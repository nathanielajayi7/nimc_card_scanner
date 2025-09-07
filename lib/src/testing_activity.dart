import 'dart:typed_data';

import 'package:flutter/material.dart' hide Image;
import 'package:image/image.dart';
import 'package:nimc_card_scanner/src/inside_line.dart';
import 'package:nimc_card_scanner/src/inside_line_position.dart';
// import 'package:nimc_card_scanner/nimc_card_scanner/main_crop.dart';
import 'package:nimc_card_scanner/src/mask_camera.dart';
import 'package:nimc_card_scanner/src/result.dart';

// ignore: must_be_immutable
class TestingPassportParameters extends StatefulWidget {
  MaskForCameraViewResult res;

  TestingPassportParameters({super.key, required this.res});

  @override
  State<TestingPassportParameters> createState() =>
      _TestingPassportParametersState();
}

class _TestingPassportParametersState extends State<TestingPassportParameters> {
  late MaskForCameraViewResult res;

  int xOffset = 0;
  int yOffset = 0;
  double width = 0;
  double height = 0;

  @override
  void initState() {
    res = widget.res;
    super.initState();
  }

  _TestingPassportParametersState();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Passport')),

      body: Container(
        margin: EdgeInsets.only(top: 80),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(26.0),
            topRight: Radius.circular(26.0),
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.of(context)
                  ..pop()
                  ..pop();
              },
              icon: Icon(Icons.close),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            centerTitle: true,
            title: Text(
              "OCR Results",
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12.0),
                  Row(
                    children: [
                      res.sixPartImage != null
                          ? SizedBox(
                              height: 100,
                              width: 80,
                              child: MyImageView(imageBytes: res.sixPartImage!),
                            )
                          : Container(),
                      const SizedBox(width: 8.0),
                      res.croppedImage != null
                          ? Expanded(
                              child: MyImageView(imageBytes: res.croppedImage!),
                            )
                          : Container(),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      res.firstPartImage != null
                          ? Expanded(
                              child: Wrap(
                                children: [
                                  Text("Id Num"),
                                  MyImageView(imageBytes: res.firstPartImage!),
                                ],
                              ),
                            )
                          : Container(),
                      res.firstPartImage != null && res.secondPartImage != null
                          ? const SizedBox(width: 8.0)
                          : Container(),
                      res.secondPartImage != null
                          ? Expanded(
                              child: Wrap(
                                children: [
                                  Text("Image 2"),
                                  MyImageView(imageBytes: res.secondPartImage!),
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  Row(
                    children: [
                      res.thirdPartImage != null
                          ? Expanded(
                              child: MyImageView(
                                imageBytes: res.thirdPartImage!,
                              ),
                            )
                          : Container(),
                      res.thirdPartImage != null && res.fourPartImage != null
                          ? const SizedBox(width: 8.0)
                          : Container(),
                      res.fourPartImage != null
                          ? Expanded(
                              child: MyImageView(
                                imageBytes: res.fourPartImage!,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  Row(
                    children: [
                      res.fivePartImage != null
                          ? Expanded(
                              child: MyImageView(
                                imageBytes: res.fivePartImage!,
                              ),
                            )
                          : Container(),
                      res.fivePartImage != null && res.sixPartImage != null
                          ? const SizedBox(width: 8.0)
                          : Container(),
                      res.sixPartImage != null
                          ? Expanded(
                              child: MyImageView(imageBytes: res.sixPartImage!),
                            )
                          : Container(),
                    ],
                  ),

                  //add x and y sliders for firstPartImage
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('X Position'),
                            Slider(
                              value: xOffset.toDouble(),
                              min: 0,
                              max: 500,
                              divisions: 100,
                              label: '$xOffset',
                              onChanged: (value) async {
                                xOffset = value.toInt();
                                res = await _cropHalfImage(
                                  "passport",
                                  decodeImage(res.croppedImage!)!,
                                  MaskForCameraViewInsideLine(
                                    position:
                                        MaskForCameraViewInsideLinePosition
                                            .center,
                                  ),
                                  xOffset,
                                  yOffset,
                                  res,
                                );
                                setState(() {
                                  xOffset = value.toInt();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Y Position'),
                            Slider(
                              value: yOffset.toDouble(),
                              min: 0,
                              max: 250,
                              divisions: 100,
                              label: '$yOffset',
                              onChanged: (value) async {
                                yOffset = value.toInt();
                                res = await _cropHalfImage(
                                  "passport",
                                  decodeImage(res.croppedImage!)!,
                                  MaskForCameraViewInsideLine(
                                    position:
                                        MaskForCameraViewInsideLinePosition
                                            .center,
                                  ),
                                  xOffset,
                                  yOffset,
                                  res,
                                );
                                setState(() {
                                  yOffset = value.toInt();
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // listResult.isNotEmpty
                  //     ? _buildListResult(res.croppedImage!)
                  //     : Container(),
                  // const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Width'),
                            Slider(
                              value: width,
                              min: 0,
                              max:
                                  decodeImage(
                                    res.croppedImage!,
                                  )?.width.toDouble() ??
                                  500,
                              divisions: 100,
                              label: '${width.toInt()}',
                              onChanged: (value) async {
                                width = value;
                                res = await _cropHalfImage(
                                  "passport",
                                  decodeImage(res.croppedImage!)!,
                                  MaskForCameraViewInsideLine(
                                    position:
                                        MaskForCameraViewInsideLinePosition
                                            .center,
                                  ),
                                  xOffset,
                                  yOffset,
                                  res,
                                );
                                setState(() {
                                  width = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Height'),
                            Slider(
                              value: height,
                              min: 0,
                              max:
                                  decodeImage(
                                    res.croppedImage!,
                                  )?.height.toDouble() ??
                                  500,
                              divisions: 100,
                              label: '${height.toInt()}',
                              onChanged: (value) async {
                                height = value;
                                res = await _cropHalfImage(
                                  "passport",
                                  decodeImage(res.croppedImage!)!,
                                  MaskForCameraViewInsideLine(
                                    position:
                                        MaskForCameraViewInsideLinePosition
                                            .center,
                                  ),
                                  xOffset,
                                  yOffset,
                                  res,
                                );
                                setState(() {
                                  height = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<MaskForCameraViewResult> _cropHalfImage(
    String ocrType,
    Image image,
    MaskForCameraViewInsideLine insideLine,
    int xOffset,
    int yOffset,
    MaskForCameraViewResult previousResult,
  ) async {
    double x;
    double y;
    double w;
    double h;

    // y = (45 + yOffset).toDouble();
    // x = (365 - xOffset).toDouble();
    // w = (image.width).toDouble() - 350;
    // h = 35;

    y = (yOffset).toDouble();
    x = (xOffset).toDouble();
    w = width;
    h = height;
    debugPrint('x = $x');
    debugPrint('y = $y');
    debugPrint('w = $w');
    debugPrint('h = $h');

    // Image firstCroppedImage = copyCrop(
    //   image,
    //   x: x.toInt(),
    //   y: y.toInt(),
    //   width: w.toInt(),
    //   height: h.toInt(),
    // );

    // List<int> firstCroppedList = encodeJpg(firstCroppedImage);
    // Uint8List firstCroppedBytes = Uint8List.fromList(firstCroppedList);

    // return previousResult..firstPartImage = firstCroppedBytes;

    Image secondCroppedImage = copyCrop(
      image,
      x: x.toInt(),
      y: y.toInt(),
      width: w.toInt(),
      height: h.toInt(),
    );
    List<int> secondCroppedList = encodeJpg(secondCroppedImage);
    Uint8List secondCroppedBytes = Uint8List.fromList(secondCroppedList);

    return previousResult..secondPartImage = secondCroppedBytes;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'camera_description.dart';
import 'inside_line.dart';
import 'inside_line_direction.dart';
import 'inside_line_position.dart';
import 'main_crop.dart';
import 'result.dart';

class MaskOCRCam extends StatefulWidget {
  const MaskOCRCam({
    super.key,
    required this.ocrType,
    this.ocrSubType,
    this.onCapture,
    this.showRetakeBtn = true,
    this.txtSubmit = 'Submit',
    this.btnSubmit,
    this.showPopBack = false,
  });

  final String ocrType;
  final String? ocrSubType;
  final Function? onCapture;
  final bool showRetakeBtn;
  final Function? btnSubmit;
  final String txtSubmit;
  final bool showPopBack;

  @override
  State<MaskOCRCam> createState() => _MaskOCRCamState();
}

class _MaskOCRCamState extends State<MaskOCRCam> {
  @override
  Widget build(BuildContext context) {
    return widget.ocrType == 'driverLicense'
        ? _buildShowResultList("whiteIdCard")
        : widget.ocrType == 'passport'
        ? _buildShowResultList(widget.ocrType)
        : (widget.ocrType == 'nationalId'
              ? _buildShowResultList("greenIdCard")
              : Scaffold(
                  appBar: AppBar(title: Text('OCR')),
                  body: Text(
                    'Selected OCR Type = ${widget.ocrType}',
                    style: TextStyle(fontSize: 24),
                  ),
                ));
  }

  Widget _buildShowResultList(String ocrType) {
    // print("_orcType ${ocrType}");
    return MaskForCameraView(
      ocrType: ocrType,
      boxHeight: (ocrType == "whiteIdCard"
          ? 165.0
          : ocrType == "greenIdCard"
          ? 165.0
          : 210),
      boxWidth: ocrType == "whiteIdCard"
          ? 300.0
          : ocrType == "greenIdCard"
          ? 300.0
          : 300,
      visiblePopButton: widget.showPopBack,
      insideLine: MaskForCameraViewInsideLine(
        position: MaskForCameraViewInsideLinePosition.partOne,
        direction: MaskForCameraViewInsideLineDirection.horizontal,
      ),
      boxBorderWidth: 1.5,
      boxBorderRadius: 10,
      cameraDescription: MaskForCameraViewCameraDescription.rear,
      onTake: (MaskForCameraViewResult res) =>  Navigator.pop(context, res)
    );
  }


  late String result;
  List listResult = [];
  String passportAllTextExtract = '';
  }

class MyImageView extends StatelessWidget {
  const MyImageView({super.key, required this.imageBytes});
  final Uint8List imageBytes;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      clipBehavior: Clip.hardEdge,
      child: SizedBox(width: double.infinity, child: Image.memory(imageBytes)),
    );
  }
}

// // library nimc_card_scanner;

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'nimc_card_scanner/main_crop.dart';
// import 'nimc_card_scanner/mask_camera.dart';

// class NimcOCRScan extends StatefulWidget {
//   const NimcOCRScan({
//     super.key,
//     this.title = 'NimcOCR',
//     this.subTitle = 'Select NimcOCR Type',
//     required this.onCapture,
//     // this.doFaceReg = false,
//     // this.onFaceReg,
//     this.showRetakeBtn = true,
//     this.txtSubmit = 'Submit',
//     // this.txtSubmitOnFace = 'Done',
//     this.btnSubmit,
//     // this.btnSubmitOnFace,
//     this.showSubmitBtn = false,
//     this.showFaceSubmitBtn = false,
//     this.showPopBack = false,
//   });

//   final String title;
//   final String subTitle;
//   final Function onCapture;
//   // final bool doFaceReg;
//   // final Function? onFaceReg;
//   final bool showRetakeBtn;
//   final Function? btnSubmit;
//   // final Function? btnSubmitOnFace;
//   final String txtSubmit;
//   // final String txtSubmitOnFace;
//   final bool showSubmitBtn;
//   final bool showFaceSubmitBtn;
//   final bool showPopBack;

//   @override
//   State<NimcOCRScan> createState() => _NimcOCRScanState();
// }

// class _NimcOCRScanState extends State<NimcOCRScan> {
//   final _formKey = GlobalKey<FormState>();

//   @override
//   initState() {
//     WidgetsFlutterBinding.ensureInitialized();
//     initPlatform();
//     super.initState();
//   }

//   Future<void> initPlatform() async {
//     await MaskForCameraView.initialize();
//   }

//   //ocr type
//   final List<Map<String, Object>> _rdoOcrType = [
//     {'id': 'idCard', 'name': 'ID Card'},
//     {'id': 'passport', 'name': 'Passport'},
//     // {'id': 'familyBook', 'name': 'Family Book'},
//   ];
//   int? _rdoStartindex;
//   String _onSelectRdo = '';

//   //sub ocr type
//   final List<Map<String, Object>> _rdoOcrSubType = [
//     {'id': 'whiteIdCard', 'name': 'White ID Card'},
//     {'id': 'greenIdCard', 'name': 'Green ID Card'},
//   ];
//   int? _rdoSubStartindex;
//   String _onSelectSubRdo = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.title), centerTitle: true),
//       body: Form(
//         key: _formKey,
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(widget.subTitle, style: const TextStyle(fontSize: 24)),
//             for (int i = 0; i < _rdoOcrType.length; i++)
//               RadioListTile(
//                 title: Text(_rdoOcrType[i]['name'].toString()),
//                 value: i,
//                 groupValue: _rdoStartindex,
//                 onChanged: (int? value) {
//                   setState(() {
//                     _rdoStartindex = value;
//                     _onSelectRdo = _rdoOcrType[i]['id'].toString();
//                   });
//                   // print(_onSelectRdo);
//                 },
//               ),
//             const Divider(),
//             _rdoStartindex != null && _rdoStartindex == 0
//                 ? Column(
//                     children: [
//                       for (int i = 0; i < _rdoOcrSubType.length; i++)
//                         RadioListTile(
//                           title: Text(_rdoOcrSubType[i]['name'].toString()),
//                           value: i,
//                           groupValue: _rdoSubStartindex,
//                           onChanged: (int? value) {
//                             setState(() {
//                               _rdoSubStartindex = value;
//                               _onSelectSubRdo = _rdoOcrSubType[i]['id']
//                                   .toString();
//                             });
//                             // print(_onSelectSubRdo);
//                           },
//                         ),
//                     ],
//                   )
//                 : Container(),
//             Container(
//               padding: const EdgeInsets.only(left: 32, right: 32),
//               height: 50,
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: _onSubmit,
//                 icon: const Icon(Icons.navigate_next_outlined),
//                 label: Text(widget.txtSubmit),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   _onSubmit() {
//     if (_onSelectRdo.isEmpty) {
//       _alertBox('Error!', 'No selected OCR option!');
//       return;
//     }

//     if (_rdoStartindex == 0) {
//       if (_onSelectSubRdo.isNotEmpty) {
//         _navigatePage(_onSelectRdo, _onSelectSubRdo);
//       } else {
//         _alertBox('Error!', 'No selected SUB OCR option!');
//       }
//     } else {
//       _navigatePage(_onSelectRdo);
//     }
//   }

//   void _navigatePage(_ocrType, [String? _ocrSubType]) {
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(
//         builder: (context) => MaskOCRCam(
//           ocrType: _ocrType,
//           ocrSubType: _ocrSubType,
//           showPopBack: widget.showPopBack,
//           onCapture: (val, img) {
//             final Map data = {
//               'kycType': _ocrType == 'idCard' ? _ocrSubType : _ocrType,
//               'data': val,
//               'kycImg': img,
//             };
//             widget.onCapture(data);
//           },
//           showRetakeBtn: widget.showRetakeBtn,
//           txtSubmit: widget.txtSubmit,
//           btnSubmit: widget.showSubmitBtn
//               ? () {
//                   if (widget.btnSubmit != null) widget.btnSubmit!();
//                 }
//               : null,
//         ),
//       ),
//       (route) => true,
//     );
//   }

//   _alertBox(title, msg) {
//     showCupertinoModalPopup(
//       context: context,
//       builder: (context) => AlertDialog(
//         actions: [
//           IconButton(
//             onPressed: () => Navigator.pop(context),
//             icon: Icon(Icons.close),
//           ),
//         ],
//         title: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Icon(Icons.error_outline, size: 54, color: Colors.red),
//             Text('$title'),
//           ],
//         ),
//         content: Text('$msg', textAlign: TextAlign.center),
//       ),
//     );
//   }
// }

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:nimc_card_scanner/src/main_crop.dart';
import 'package:nimc_card_scanner/src/mask_camera.dart';
import 'package:nimc_card_scanner/src/result.dart';
import 'package:nimc_card_scanner/src/screens/analyzer.dart';
import 'package:path_provider/path_provider.dart';

import 'src/enum/card_types.dart';
import 'src/model/result.dart';
export 'src/model/result.dart';

class NimcCardScanner<T extends ScanResult> {
  final Function(T scanResult)? onCapture;

  NimcCardScanner({this.onCapture});

  void startScan(BuildContext context) async {
    // print(T);

    await MaskForCameraView.initialize();
    // Implementation for starting the scan based on cardType
    // This is a placeholder for actual scanning logic
    // After scanning, create an instance of T and call onCapture with it
    if (T == PassportResult) {
      // Handle passport scan result
      _navigatePage(CardType.passport, context);
    }

    if (T == DriverLicenseResult) {
      // Handle driver's license scan result
      _navigatePage(CardType.idCard, context);
    }
  }

  void _navigatePage(CardType ocrType, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<MaskForCameraViewResult>(
        builder: (context) => MaskOCRCam(
          ocrType: ocrType.name,
          // ocrSubType: _ocrSubType,
          showPopBack: true,

          // onCapture: (val, img) {
          //   final Map data = {
          //     'kycType': ocrType.name,
          //     'data': val,
          //     'kycImg': img,
          //   };
          //   print(data);
        ),
      ),
    ).then((result) {
      print(result);

      if (result != null) {
        if (T == PassportResult) {
          //go to card analyzer screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CardAnalyzer<PassportResult>(res: result),
            ),
          );
        }
      }
    });
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

    final textDetector = GoogleMlKit.vision.textRecognizer();
    final RecognizedText recognisedText = await textDetector.processImage(
      inputImage,
    );

    return recognisedText.text;
  }
}

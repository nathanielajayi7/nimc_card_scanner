import 'dart:typed_data';

import 'package:image/image.dart';

// import 'package:flutter/material.dart';

sealed class ScanResult {
  Uint8List? kycImg, croppedImage;

  ScanResult({this.kycImg, this.croppedImage});

  SnipeData firstCroppedImage(Image image);
  SnipeData secondCroppedImage(Image image);
  //six cropped image
  SnipeData sixthCroppedImage(Image image);
}

class PassportResult extends ScanResult {
  String? passportNumber;
  // String? surname;
  String? givenNames;

  PassportResult({
    this.passportNumber,
    // this.surname,
    this.givenNames,
    super.kycImg,
  });

  //contains passport number
  @override
  SnipeData firstCroppedImage(Image image) {
    return SnipeData(xOffset: 285.0, yOffset: 46.0, width: 175.0, height: 55.0);
  }

  String get surname {
    if (givenNames == null || givenNames!.isEmpty) {
      return '';
    }
    List<String> parts = givenNames!.split(' ');
    return parts.first;
  }

  String get firstName {
    if (givenNames == null || givenNames!.isEmpty) {
      return '';
    }
    List<String> parts = givenNames!.split(' ');
    return parts[1];
  }

  @override
  SnipeData secondCroppedImage(Image image) {
    return SnipeData(
      xOffset: 130.0,
      yOffset: 74.0,
      width: image.width - 20 - 325,
      height: image.height - 250 - 46,
    );
  }

  @override
  SnipeData sixthCroppedImage(Image image) {
    return SnipeData(xOffset: 8, yOffset: 80, width: 150, height: 175);
  }

  void cleanGivenNames() {
    List<String> result = [];
    //split string into list by space and remove empty strings
    if (givenNames != null) {
      //remove \n
      givenNames = givenNames!.replaceAll('\n', ' ');
      //replace funny symbols like / or \ with empty space
      givenNames = givenNames!.replaceAll(RegExp(r'[\/\\]'), ' ');
      List<String> names = givenNames!.split(' ');
      names = names..removeWhere((name) => name.trim().isEmpty);

      //remove any text after the text that contains 'nation'
      int endIndex = names.indexWhere(
        (name) => name.toLowerCase().contains('nation'),
      );

      if (endIndex != -1) {
        //check for nigerian
        // int endIndex = names.indexWhere(
        //   (name) => name.toLowerCase().contains('nigeria'),
        // );
        // if (endIndex != -1) {
        names = names.sublist(0, endIndex + 1).toList();
        // }
      }

      // print(names);

      // print(names.length);;
      // ignore: avoid_function_literals_in_foreach_calls
      names.forEach((name) {
        // print(name);
        if (name == name.toUpperCase() &&
            name.trim().isNotEmpty &&
            !name.trim().toLowerCase().startsWith('nigeria')) {
          result.add(name);
        }
      });
      for (int i = 0; i < names.length; i++) {
        // print(i);
        // print(names[i]);

        if (names[i] != names[i].toUpperCase()) {
          // print(names[i]);
          names.removeAt(i);
          continue;
        }

        // if (names[i].trim() != names[i].toUpperCase().trim()) {
        //   names.removeAt(i);
        // }
      }

      print(result);
      givenNames = result.join(' ');
      //remove text not entirely made of capital letters
    }
  }

  //override to string
  @override
  String toString() {
    return 'PassportResult{passportNumber: $passportNumber, surname: $surname, firstname: $firstName,  givenNames: $givenNames}';
  }
}

class DriverLicenseResult extends ScanResult {
  String? idNumber;
  String? firstName;
  String? lastName;
  String? dob;
  String? licenseNumber;

  DriverLicenseResult({
    this.idNumber,
    this.firstName,
    this.lastName,
    this.dob,
    this.licenseNumber,
    super.kycImg,
  });

  @override
  SnipeData firstCroppedImage(Image image) {
    return SnipeData(xOffset: 170, yOffset: 90, width: 206, height: 50);
  }

  //license no
  @override
  SnipeData secondCroppedImage(Image image) {
    return SnipeData(xOffset: 0, yOffset: 50.0, width: 230, height: 35);
  }

  //kyc image
  @override
  SnipeData sixthCroppedImage(Image image) {
    return SnipeData(xOffset: 17, yOffset: 80, width: 168, height: 200);
  }

  void extractNameAndDob(String s) {
    // print(s);
    //split by comma
    List<String> parts = s.split(',');
    // print(parts[1]);
    lastName = parts.last.split("\n").first.trim();
    firstName = parts.first.split("\n").last.trim();
    dob = parts.first.split(" ")[1].trim();
    //only accept numbers and dashes in dob
    dob = dob?.replaceAll(RegExp(r'[^0-9\-]'), '');
  }

  @override
  String toString() {
    return 'DriverLicenseResult{idNumber: $idNumber, firstName: $firstName, lastName: $lastName, dob: $dob, licenseNumber: $licenseNumber}';
  }
}

class NationalIdResult extends ScanResult {
  String? idNumber;
  String? firstName;
  String? lastName;
  String? dob;

  NationalIdResult({
    this.idNumber,
    this.firstName,
    this.lastName,
    this.dob,
    super.kycImg,
  });

  //nin number
  @override
  SnipeData firstCroppedImage(Image image) {
    return SnipeData(xOffset: 17, yOffset: 102, width: 120, height: 40);
  }

  @override
  SnipeData secondCroppedImage(Image image) {
    throw UnimplementedError();
  }

  //kyc image
  @override
  SnipeData sixthCroppedImage(Image image) {
    return SnipeData(xOffset: 420, yOffset: 57, width: 299, height: 141);
  }

  @override
  String toString() {
    return 'NationalIdResult{idNumber: $idNumber, firstName: $firstName, lastName: $lastName, dob: $dob}';
  }
}

class SnipeData {
  final num xOffset;
  final num yOffset;
  final num width;
  final num height;
  SnipeData({
    required this.xOffset,
    required this.yOffset,
    required this.width,
    required this.height,
  });
}

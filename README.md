# NIMC Card Scanner

This is a flutter OCR implementation to scan Nigerian National IDs, Passports 7 Drivers License and extract data from them.

This package from flutter:
[LaoOCR](https://pub.dev/packages/laoocr) was forked, and extended for NIMC, Ecowas Passports and Drivers License.

The refactoring was proposed to also make it extendable for other more use-cases.



[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://choosealicense.com/licenses/mit/)

## Installation

Install via Flutter Pub

```bash
  flutter pub add nimc_card_scanner
```
    
## Usage/Examples

```dart
 ElevatedButton(
              onPressed: () {
                NimcCardScanner<DriverLicenseResult>()
                .startScan(context)
                .then(
                (value) {
                    print(value.toString());
            }
        );
    },
    child: const Text('Scan Driver\'s License'),
),
```


## Authors

- [@nathanielajayi7](https://www.github.com/nathanielajayi7)

Please, feel free to contribute. Thank you.
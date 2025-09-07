import 'package:flutter/material.dart';
import 'package:nimc_card_scanner/nimc_card_scanner.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  // String text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NIMC Card Scanner Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                NimcCardScanner<DriverLicenseResult>().startScan(context).then((
                  value,
                ) {
                  print(value.toString());
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(value.toString())));
                });
              },
              child: const Text('Scan Driver\'s License'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // print('hello');
                NimcCardScanner<PassportResult>().startScan(context).then((
                  value,
                ) {
                  print(value.toString());
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(value.toString())));
                });
              },
              child: const Text('Scan Passport'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                NimcCardScanner<NationalIdResult>().startScan(context).then((
                  value,
                ) {
                  print(value.toString());
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(value.toString())));
                });
              },
              child: const Text('Scan NIN Slip'),
            ),
          ],
        ),
      ),
    );
  }
}

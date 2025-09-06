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
                // TODO: Implement scan driver's license
                 
                NimcCardScanner<DriverLicenseResult>().startScan(context);
              },
              child: const Text('Scan Driver\'s License'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                print('hello');
                NimcCardScanner<PassportResult>().startScan(context);
              },
              child: const Text('Scan Passport'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement scan NIN slip
              },
              child: const Text('Scan NIN Slip'),
            ),
          ],
        ),
      ),
    );
  }
}

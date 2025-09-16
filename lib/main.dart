import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/ble/presentation/pages/scan_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'BLE Chat', theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true), home: const ScanPage());
  }
}

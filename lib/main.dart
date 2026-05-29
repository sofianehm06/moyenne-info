import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'data/storage.dart';
import 'screens/home_screen.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR');

  final storage = StorageService();
  await storage.init();

  runApp(MoyenneApp(storage: storage));
}

class MoyenneApp extends StatelessWidget {
  final StorageService storage;

  const MoyenneApp({super.key, required this.storage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moyenne — Informatique',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: HomeScreen(storage: storage),
    );
  }
}

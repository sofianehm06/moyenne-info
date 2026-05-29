import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  const seed = Color(0xFF3949AB); // Indigo profond
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: seed),
    appBarTheme: const AppBarTheme(centerTitle: false),
    cardTheme: CardThemeData(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
      isDense: true,
    ),
  );
}

/// Couleur sémantique en fonction d'une note /20.
Color couleurNote(double? note, BuildContext context) {
  if (note == null) return Theme.of(context).colorScheme.outline;
  if (note < 8) return Colors.red.shade700;
  if (note < 10) return Colors.orange.shade800;
  if (note < 12) return Colors.amber.shade800;
  if (note < 14) return Colors.lightGreen.shade700;
  if (note < 16) return Colors.green.shade700;
  return Colors.teal.shade700;
}

String formatNote(double? n) {
  if (n == null) return '—';
  return n.toStringAsFixed(2);
}

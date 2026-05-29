import 'package:flutter/material.dart';

import '../theme.dart';

/// Petit badge coloré affichant une note /20.
class NoteChip extends StatelessWidget {
  final double? valeur;
  final String suffix;
  final double fontSize;

  const NoteChip({
    super.key,
    required this.valeur,
    this.suffix = '/20',
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    final color = couleurNote(valeur, context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        '${formatNote(valeur)}$suffix',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: fontSize,
        ),
      ),
    );
  }
}

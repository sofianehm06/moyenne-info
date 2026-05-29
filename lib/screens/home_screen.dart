import 'package:flutter/material.dart';

import '../data/curricula.dart';
import '../data/storage.dart';
import '../models/cursus.dart';
import '../services/calcul.dart';
import '../widgets/note_chip.dart';
import 'cursus_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  final StorageService storage;

  const HomeScreen({super.key, required this.storage});

  Map<TypeCursus, List<Cursus>> _grouper() {
    final m = <TypeCursus, List<Cursus>>{};
    for (final c in kCursus) {
      m.putIfAbsent(c.type, () => []).add(c);
    }
    return m;
  }

  String _libelleType(TypeCursus t) {
    switch (t) {
      case TypeCursus.licence:
        return 'Licence';
      case TypeCursus.master:
        return 'Master';
      case TypeCursus.ingenieur:
        return 'Cycle Ingénieur';
    }
  }

  IconData _iconeType(TypeCursus t) {
    switch (t) {
      case TypeCursus.licence:
        return Icons.school_outlined;
      case TypeCursus.master:
        return Icons.workspace_premium_outlined;
      case TypeCursus.ingenieur:
        return Icons.engineering_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moyenne — Informatique'),
        actions: [
          IconButton(
            tooltip: 'Paramètres',
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => SettingsScreen(storage: storage),
            )),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: storage,
        builder: (context, _) {
          final groupes = _grouper();
          return ListView(
            padding: const EdgeInsets.only(top: 8, bottom: 24),
            children: [
              for (final entry in groupes.entries) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 16, 8),
                  child: Row(
                    children: [
                      Icon(_iconeType(entry.key),
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        _libelleType(entry.key),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                for (final c in entry.value) _carteCursus(context, c),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _carteCursus(BuildContext context, Cursus cursus) {
    final ecueIds = <String>[
      for (final s in cursus.semestres)
        for (final ue in s.unites)
          for (final ecue in ue.ecues) ecue.id,
    ];
    final notes = storage.notesForCursus(cursus.id, ecueIds);
    final res = moyenneCursus(cursus, notes);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => CursusScreen(cursus: cursus, storage: storage),
        )),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor:
                    Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  cursus.libelleCourt,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontSize: cursus.libelleCourt.length > 4 ? 10 : 12,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cursus.nom,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(
                      '${cursus.semestres.length} semestre(s) · '
                      'mention : ${res.mention}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              NoteChip(valeur: res.moyenneAnnuelle),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

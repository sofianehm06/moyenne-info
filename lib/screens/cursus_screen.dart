import 'package:flutter/material.dart';

import '../data/storage.dart';
import '../models/cursus.dart';
import '../services/calcul.dart';
import '../services/personnalisation.dart';
import '../widgets/note_chip.dart';
import 'semestre_screen.dart';

class CursusScreen extends StatelessWidget {
  final Cursus cursus;
  final StorageService storage;

  const CursusScreen({super.key, required this.cursus, required this.storage});

  Future<void> _confirmerReset(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Réinitialiser ce cursus'),
        content: Text(
            'Toutes les notes saisies pour « ${cursus.nom} » seront supprimées.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Annuler')),
          FilledButton.tonal(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Réinitialiser')),
        ],
      ),
    );
    if (ok == true) {
      await storage.resetCursus(cursus.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cursus.libelleCourt),
        actions: [
          IconButton(
            tooltip: 'Réinitialiser',
            icon: const Icon(Icons.refresh),
            onPressed: () => _confirmerReset(context),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: storage,
        builder: (context, _) {
          final c = appliquerPersonnalisation(cursus, storage);
          final ecueIds = [
            for (final s in c.semestres)
              for (final ue in s.unites)
                for (final ecue in ue.ecues) ecue.id,
          ];
          final notes = storage.notesForCursus(c.id, ecueIds);
          final res = moyenneCursus(c, notes);

          return ListView(
            children: [
              _enTete(context, cursus, res),
              const SizedBox(height: 8),
              for (var i = 0; i < c.semestres.length; i++)
                _carteSemestre(context, cursus, res.semestres[i]),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  Widget _enTete(BuildContext context, Cursus cursus, ResultatCursus res) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [cs.primary, cs.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(cursus.nom,
              style: TextStyle(
                  color: cs.onPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _stat(
                  context,
                  'Moyenne générale',
                  res.moyenneAnnuelle == null
                      ? '—'
                      : res.moyenneAnnuelle!.toStringAsFixed(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _stat(context, 'Mention', res.mention),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(BuildContext context, String label, String valeur) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cs.surface.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(fontSize: 11, color: cs.onSurfaceVariant)),
          const SizedBox(height: 4),
          Text(valeur,
              style: TextStyle(
                  fontSize: 22,
                  color: cs.primary,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _carteSemestre(
      BuildContext context, Cursus cursus, ResultatSemestre s) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text('S${s.semestre.numero}'),
        ),
        title: Text(s.semestre.nom,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          '${s.semestre.unites.length} UE · '
          '${s.creditsValides}/${s.creditsTotal} crédits validés',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            NoteChip(valeur: s.moyenne),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => SemestreScreen(
            cursus: cursus,
            semestreId: s.semestre.id,
            storage: storage,
          ),
        )),
      ),
    );
  }
}

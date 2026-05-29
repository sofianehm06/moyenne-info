import 'package:flutter/material.dart';

import '../data/storage.dart';
import '../models/cursus.dart';
import '../services/calcul.dart';
import '../theme.dart';
import '../widgets/note_chip.dart';

/// Permet d'estimer la note d'examen à obtenir pour atteindre la moyenne
/// (10/20 par défaut), pour chaque matière du semestre dont le CC est saisi.
class SimulationScreen extends StatefulWidget {
  final Cursus cursus;
  final Semestre semestre;
  final StorageService storage;

  const SimulationScreen({
    super.key,
    required this.cursus,
    required this.semestre,
    required this.storage,
  });

  @override
  State<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen> {
  double _objectif = 10.0;

  List<String> get _ecueIds => [
        for (final ue in widget.semestre.unites)
          for (final ecue in ue.ecues) ecue.id,
      ];

  @override
  Widget build(BuildContext context) {
    final notes = widget.storage.notesForCursus(widget.cursus.id, _ecueIds);

    return Scaffold(
      appBar: AppBar(
        title: Text('Simulation · ${widget.semestre.nom}'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text(
              'Objectif : ${_objectif.toStringAsFixed(1)} / 20',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          Slider(
            value: _objectif,
            min: 8,
            max: 18,
            divisions: 20,
            label: _objectif.toStringAsFixed(1),
            onChanged: (v) => setState(() => _objectif = v),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Pour chaque matière, voici la note minimale à obtenir à '
              'l\'examen final pour atteindre l\'objectif. Les matières sans '
              'CC saisi sont ignorées.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 8),
          for (final ue in widget.semestre.unites) _carteUE(context, ue, notes),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _carteUE(BuildContext context, UE ue, Map<String, dynamic> notes) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
              child: Text(
                '${ue.code} — ${ue.nom}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            for (final ecue in ue.ecues)
              _ligneMatiere(context, ecue, notes[ecue.id]),
          ],
        ),
      ),
    );
  }

  Widget _ligneMatiere(BuildContext context, ECUE ecue, dynamic note) {
    final actuelle = moyenneECUE(ecue, note);
    final requise = noteExamenRequise(
        ecue: ecue, note: note, objectif: _objectif);

    String message;
    Color? couleur;
    if (!ecue.aExamen) {
      message = 'Pas d\'examen final';
    } else if (requise == null) {
      message = 'Saisissez d\'abord les notes de contrôle continu';
    } else if (requise <= 0) {
      message = 'Objectif déjà atteint avec le CC actuel';
      couleur = Colors.green.shade700;
    } else if (requise > 20) {
      message =
          'Impossible (il faudrait ${requise.toStringAsFixed(1)}/20 à l\'examen)';
      couleur = Colors.red.shade700;
    } else {
      message = 'Note examen requise : ${requise.toStringAsFixed(2)} / 20';
      couleur = couleurNote(requise, context);
    }

    return ListTile(
      dense: true,
      title: Text(ecue.nom),
      subtitle: Text(
        '${ecue.code} · coef ${ecue.coefficient.toStringAsFixed(0)} · $message',
        style: TextStyle(color: couleur),
      ),
      trailing: NoteChip(valeur: actuelle, fontSize: 11),
    );
  }
}

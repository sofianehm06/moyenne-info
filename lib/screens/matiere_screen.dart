import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/storage.dart';
import '../models/cursus.dart';
import '../models/note.dart';
import '../services/calcul.dart';
import '../theme.dart';
import '../widgets/note_chip.dart';

class MatiereScreen extends StatefulWidget {
  final Cursus cursus;
  final UE ue;
  final ECUE ecue;
  final StorageService storage;

  const MatiereScreen({
    super.key,
    required this.cursus,
    required this.ue,
    required this.ecue,
    required this.storage,
  });

  @override
  State<MatiereScreen> createState() => _MatiereScreenState();
}

class _MatiereScreenState extends State<MatiereScreen> {
  late final Map<String, TextEditingController> _ctrls;

  @override
  void initState() {
    super.initState();
    final n = widget.storage.getNote(widget.cursus.id, widget.ecue.id);
    _ctrls = {
      'tp': TextEditingController(text: _toText(n.tp)),
      'td': TextEditingController(text: _toText(n.td)),
      'exam': TextEditingController(text: _toText(n.examen)),
    };
  }

  @override
  void dispose() {
    for (final c in _ctrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  String _toText(double? v) => v == null ? '' : v.toString().replaceAll('.', ',');

  double? _parse(String v) {
    final t = v.trim().replaceAll(',', '.');
    if (t.isEmpty) return null;
    final n = double.tryParse(t);
    if (n == null || n < 0 || n > 20) return null;
    return n;
  }

  Future<void> _save(String comp, String value) async {
    await widget.storage.setComposante(
      widget.cursus.id,
      widget.ecue.id,
      comp,
      _parse(value),
    );
    setState(() {});
  }

  NoteECUE _noteActuelle() => NoteECUE(
        ecueId: widget.ecue.id,
        tp: _parse(_ctrls['tp']!.text),
        td: _parse(_ctrls['td']!.text),
        examen: _parse(_ctrls['exam']!.text),
      );

  @override
  Widget build(BuildContext context) {
    final ecue = widget.ecue;
    final moy = moyenneECUE(ecue, _noteActuelle());
    final examRequis = noteExamenRequise(ecue: ecue, note: _noteActuelle());

    return Scaffold(
      appBar: AppBar(
        title: Text(ecue.code),
        actions: [
          IconButton(
            tooltip: 'Effacer les notes',
            icon: const Icon(Icons.clear_all),
            onPressed: () async {
              for (final c in _ctrls.values) {
                c.clear();
              }
              for (final comp in _ctrls.keys) {
                await widget.storage.setComposante(
                    widget.cursus.id, widget.ecue.id, comp, null);
              }
              setState(() {});
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ecue.nom,
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text('${widget.ue.code} — ${widget.ue.nom}',
                      style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _info('Coefficient', ecue.coefficient.toStringAsFixed(0)),
                      _info('Crédits UE', '${widget.ue.credits}'),
                      _info('Part CC', '${(ecue.partCC * 100).round()} %'),
                      _info('Part Examen', '${(ecue.partExamen * 100).round()} %'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Notes saisies (/20)',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (ecue.aTP)
            _champ('Note de TP', 'tp', Icons.science_outlined),
          if (ecue.aTD)
            _champ('Note de TD', 'td', Icons.menu_book_outlined),
          if (ecue.aExamen)
            _champ('Examen final', 'exam', Icons.assignment_outlined),
          const SizedBox(height: 24),
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Moyenne de la matière',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer)),
                        const SizedBox(height: 4),
                        Text(
                          formatNote(moy),
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                  NoteChip(valeur: moy, fontSize: 16),
                ],
              ),
            ),
          ),
          if (examRequis != null && ecue.aExamen) ...[
            const SizedBox(height: 12),
            Card(
              margin: EdgeInsets.zero,
              child: ListTile(
                leading: const Icon(Icons.flag_outlined),
                title: const Text('Pour valider cette matière (10/20)'),
                subtitle: Text(
                  examRequis <= 0
                      ? 'Vous êtes déjà au-dessus de 10 avec votre CC actuel.'
                      : examRequis > 20
                          ? 'Impossible : il faudrait plus de 20/20 à l\'examen.'
                          : 'Il faut au moins ${examRequis.toStringAsFixed(2)} / 20 à l\'examen final.',
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _info(String label, String valeur) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text('$label : $valeur',
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
    );
  }

  Widget _champ(String label, String comp, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: _ctrls[comp],
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
        ],
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          suffixText: '/20',
        ),
        onChanged: (v) => _save(comp, v),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/storage.dart';
import '../models/cursus.dart';
import '../services/calcul.dart';
import '../services/personnalisation.dart';
import '../widgets/note_chip.dart';
import 'matiere_screen.dart';
import 'simulation_screen.dart';

class SemestreScreen extends StatelessWidget {
  final Cursus cursus; // cursus de base (non personnalisé)
  final String semestreId;
  final StorageService storage;

  const SemestreScreen({
    super.key,
    required this.cursus,
    required this.semestreId,
    required this.storage,
  });

  Semestre _baseSemestre() =>
      cursus.semestres.firstWhere((s) => s.id == semestreId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${cursus.libelleCourt} · ${_baseSemestre().nom}'),
        actions: [
          IconButton(
            tooltip: 'Simuler une note',
            icon: const Icon(Icons.psychology_alt_outlined),
            onPressed: () {
              final c = appliquerPersonnalisation(cursus, storage);
              final sem = c.semestres.firstWhere((s) => s.id == semestreId);
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => SimulationScreen(
                  cursus: c,
                  semestre: sem,
                  storage: storage,
                ),
              ));
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: storage,
        builder: (context, _) {
          final c = appliquerPersonnalisation(cursus, storage);
          final semestre = c.semestres.firstWhere((s) => s.id == semestreId);
          final ecueIds = [
            for (final ue in semestre.unites)
              for (final ecue in ue.ecues) ecue.id,
          ];
          final notes = storage.notesForCursus(c.id, ecueIds);
          final res = moyenneSemestre(semestre, notes);

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _bandeau(context, res)),
              SliverList.builder(
                itemCount: res.resultatsUE.length,
                itemBuilder: (context, i) =>
                    _carteUE(context, res.resultatsUE[i]),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          );
        },
      ),
    );
  }

  Widget _bandeau(BuildContext context, ResultatSemestre res) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Moyenne du semestre',
                    style: TextStyle(color: cs.onPrimaryContainer)),
                const SizedBox(height: 4),
                Text(
                  res.moyenne == null ? '—' : res.moyenne!.toStringAsFixed(2),
                  style: TextStyle(
                    color: cs.onPrimaryContainer,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${res.creditsValides} / ${res.creditsTotal} crédits validés',
                  style: TextStyle(color: cs.onPrimaryContainer, fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(
            res.valide ? Icons.check_circle : Icons.info_outline,
            size: 56,
            color: res.valide ? Colors.green.shade700 : cs.onPrimaryContainer,
          ),
        ],
      ),
    );
  }

  Widget _carteUE(BuildContext context, ResultatUE r) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Bandeau UE.
          Container(
            color:
                r.valide ? Colors.green.shade50 : cs.surfaceContainerHighest,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: r.valide
                      ? Colors.green.shade100
                      : cs.surfaceContainerHigh,
                  child: Text(
                    '${r.ue.credits}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: r.valide
                          ? Colors.green.shade900
                          : cs.onSurfaceVariant,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r.ue.nom,
                          style:
                              const TextStyle(fontWeight: FontWeight.w600)),
                      Text(
                        '${r.ue.code} · ${r.ue.ecues.length} matière(s) · ${r.ue.credits} crédits',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                NoteChip(valeur: r.moyenne),
              ],
            ),
          ),
          // Matières.
          for (final ecue in r.ue.ecues)
            ListTile(
              dense: true,
              title: Row(
                children: [
                  Flexible(child: Text(ecue.nom)),
                  if (ecue.personnalise) ...[
                    const SizedBox(width: 6),
                    Icon(Icons.star, size: 13, color: cs.primary),
                  ],
                ],
              ),
              subtitle: Text(
                '${ecue.code} · coef ${_fmtCoef(ecue.coefficient)}'
                ' · CC ${(ecue.partCC * 100).round()}%'
                ' / Exam ${(ecue.partExamen * 100).round()}%',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  NoteChip(valeur: r.notesParEcue[ecue.id], fontSize: 12),
                  IconButton(
                    tooltip: 'Modifier le module',
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    onPressed: () =>
                        _dialogModule(context, r.ue, ecue: ecue),
                  ),
                ],
              ),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => MatiereScreen(
                  cursus: cursus,
                  ue: r.ue,
                  ecue: ecue,
                  storage: storage,
                ),
              )),
            ),
          // Ajouter un module.
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Ajouter un module'),
              onPressed: () => _dialogModule(context, r.ue),
            ),
          ),
        ],
      ),
    );
  }

  String _fmtCoef(double c) =>
      c == c.roundToDouble() ? c.toStringAsFixed(0) : c.toString();

  /// Dialogue unique : si `ecue` est null → ajout d'un module ; sinon →
  /// modification (et suppression si module personnalisé).
  Future<void> _dialogModule(BuildContext context, UE ue,
      {ECUE? ecue}) async {
    final ajout = ecue == null;
    final estPerso = ecue?.personnalise ?? false;
    // Champs modifiables seulement à l'ajout ou pour un module perso.
    final editable = ajout || estPerso;

    final nomCtrl = TextEditingController(text: ecue?.nom ?? '');
    final coefCtrl = TextEditingController(
        text: ecue == null ? '' : _fmtCoef(ecue.coefficient));
    final ccCtrl = TextEditingController(
        text: ecue == null ? '40' : (ecue.partCC * 100).round().toString());
    bool aTP = ecue?.aTP ?? false;
    bool aTD = ecue?.aTD ?? true;
    bool aExam = ecue?.aExamen ?? true;

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text(ajout
              ? 'Ajouter un module'
              : (estPerso ? 'Modifier le module' : 'Ajuster le module')),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!editable)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      'Module officiel : tu peux ajuster son coefficient et '
                      'sa pondération. Le nom n\'est pas modifiable.',
                      style: Theme.of(ctx).textTheme.bodySmall,
                    ),
                  ),
                TextField(
                  controller: nomCtrl,
                  enabled: editable,
                  decoration: const InputDecoration(labelText: 'Nom du module'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: coefCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  decoration: const InputDecoration(labelText: 'Coefficient'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: ccCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Part contrôle continu',
                    suffixText: '%  (le reste = examen)',
                  ),
                ),
                if (editable) ...[
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: const Text('A une note de TD'),
                    value: aTD,
                    onChanged: (v) => setLocal(() => aTD = v ?? false),
                  ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: const Text('A une note de TP'),
                    value: aTP,
                    onChanged: (v) => setLocal(() => aTP = v ?? false),
                  ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: const Text('A un examen final'),
                    value: aExam,
                    onChanged: (v) => setLocal(() => aExam = v ?? false),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            if (!ajout && estPerso)
              TextButton(
                onPressed: () async {
                  await storage.supprimerModuleAjoute(ue.id, ecue.id);
                  await storage.setComposante(
                      cursus.id, ecue.id, 'tp', null);
                  await storage.setComposante(
                      cursus.id, ecue.id, 'td', null);
                  await storage.setComposante(
                      cursus.id, ecue.id, 'exam', null);
                  if (ctx.mounted) Navigator.pop(ctx);
                },
                child: Text('Supprimer',
                    style: TextStyle(color: Theme.of(ctx).colorScheme.error)),
              ),
            if (!ajout && !estPerso)
              TextButton(
                onPressed: () async {
                  await storage.clearOverrideModule(ecue.id);
                  if (ctx.mounted) Navigator.pop(ctx);
                },
                child: const Text('Réinitialiser'),
              ),
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Annuler')),
            FilledButton(
              onPressed: () async {
                final coef =
                    double.tryParse(coefCtrl.text.replaceAll(',', '.'));
                final cc = int.tryParse(ccCtrl.text);
                if (coef == null || coef <= 0) {
                  _toast(ctx, 'Coefficient invalide');
                  return;
                }
                final partCC =
                    ((cc ?? 40).clamp(0, 100)).toDouble() / 100.0;

                if (ajout) {
                  final nom = nomCtrl.text.trim();
                  if (nom.isEmpty) {
                    _toast(ctx, 'Donne un nom au module');
                    return;
                  }
                  final id =
                      '${ue.id}_x${DateTime.now().millisecondsSinceEpoch}';
                  await storage.ajouterModule(ue.id, {
                    'id': id,
                    'code': _codeAuto(nom),
                    'nom': nom,
                    'coef': coef,
                    'partCC': partCC,
                    'tp': aTP,
                    'td': aTD,
                    'exam': aExam,
                  });
                } else if (estPerso) {
                  await storage.modifierModuleAjoute(ue.id, ecue.id, {
                    'id': ecue.id,
                    'code': _codeAuto(nomCtrl.text.trim()),
                    'nom': nomCtrl.text.trim(),
                    'coef': coef,
                    'partCC': partCC,
                    'tp': aTP,
                    'td': aTD,
                    'exam': aExam,
                  });
                } else {
                  // Module officiel : on stocke un override coef/partCC.
                  await storage.setOverrideModule(ecue.id, coef, partCC);
                }
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: Text(ajout ? 'Ajouter' : 'Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }

  String _codeAuto(String nom) {
    final mots = nom.trim().split(RegExp(r'\s+'));
    if (mots.isEmpty || mots.first.isEmpty) return 'MOD';
    if (mots.length == 1) {
      return mots.first.substring(0, mots.first.length.clamp(0, 4)).toUpperCase();
    }
    return mots.take(3).map((m) => m[0].toUpperCase()).join();
  }

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }
}

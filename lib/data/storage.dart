import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/note.dart';

/// Stockage local des notes via Hive.
///
/// On utilise une `Box<double>` unique (`notes`) dont les clés sont
/// `{cursusId}|{ecueId}|{composant}` où `composant` ∈ {tp, td, exam}.
/// Cette approche évite la génération de TypeAdapters et reste lisible.
///
/// Une seconde box `prefs` retient l'état UI léger (nom de l'étudiant…).
class StorageService extends ChangeNotifier {
  static const _notesBoxName = 'notes';
  static const _prefsBoxName = 'prefs';
  static const _customBoxName = 'custom';

  late final Box<double> _notes;
  late final Box _prefs;
  late final Box _custom;

  Future<void> init() async {
    await Hive.initFlutter();
    _notes = await Hive.openBox<double>(_notesBoxName);
    _prefs = await Hive.openBox(_prefsBoxName);
    _custom = await Hive.openBox(_customBoxName);
  }

  // ─── Notes ────────────────────────────────────────────────────────────

  String _key(String cursusId, String ecueId, String comp) =>
      '$cursusId|$ecueId|$comp';

  NoteECUE getNote(String cursusId, String ecueId) {
    return NoteECUE(
      ecueId: ecueId,
      tp: _notes.get(_key(cursusId, ecueId, 'tp')),
      td: _notes.get(_key(cursusId, ecueId, 'td')),
      examen: _notes.get(_key(cursusId, ecueId, 'exam')),
    );
  }

  Map<String, NoteECUE> notesForCursus(String cursusId, Iterable<String> ecueIds) {
    final out = <String, NoteECUE>{};
    for (final id in ecueIds) {
      out[id] = getNote(cursusId, id);
    }
    return out;
  }

  Future<void> setComposante(
      String cursusId, String ecueId, String comp, double? valeur) async {
    final k = _key(cursusId, ecueId, comp);
    if (valeur == null) {
      await _notes.delete(k);
    } else {
      await _notes.put(k, valeur);
    }
    notifyListeners();
  }

  Future<void> resetCursus(String cursusId) async {
    final keys = _notes.keys
        .whereType<String>()
        .where((k) => k.startsWith('$cursusId|'))
        .toList();
    await _notes.deleteAll(keys);
    notifyListeners();
  }

  Future<void> resetTout() async {
    await _notes.clear();
    await _custom.clear();
    notifyListeners();
  }

  // ─── Préférences ─────────────────────────────────────────────────────

  String get nomEtudiant => (_prefs.get('nom_etudiant') as String?) ?? '';

  Future<void> setNomEtudiant(String v) async {
    await _prefs.put('nom_etudiant', v);
    notifyListeners();
  }

  // ─── Personnalisation des modules ──────────────────────────────────────
  //
  // Deux types de personnalisation, stockés dans la box `custom` :
  //  • override d'un module existant  → clé `ov|{ecueId}`  (Map JSON)
  //  • modules ajoutés à une UE       → clé `add|{ueId}`   (List JSON)

  /// Override (coef / partCC) saisi par l'utilisateur pour un module officiel.
  /// Retourne `null` si le module n'a pas été personnalisé.
  Map<String, dynamic>? overrideModule(String ecueId) {
    final raw = _custom.get('ov|$ecueId') as String?;
    if (raw == null) return null;
    return (jsonDecode(raw) as Map).cast<String, dynamic>();
  }

  Future<void> setOverrideModule(
      String ecueId, double coef, double partCC) async {
    await _custom.put('ov|$ecueId',
        jsonEncode({'coef': coef, 'partCC': partCC}));
    notifyListeners();
  }

  Future<void> clearOverrideModule(String ecueId) async {
    await _custom.delete('ov|$ecueId');
    notifyListeners();
  }

  /// Modules ajoutés manuellement à une UE.
  List<Map<String, dynamic>> modulesAjoutes(String ueId) {
    final raw = _custom.get('add|$ueId') as String?;
    if (raw == null) return [];
    return (jsonDecode(raw) as List)
        .map((e) => (e as Map).cast<String, dynamic>())
        .toList();
  }

  Future<void> ajouterModule(String ueId, Map<String, dynamic> module) async {
    final liste = modulesAjoutes(ueId)..add(module);
    await _custom.put('add|$ueId', jsonEncode(liste));
    notifyListeners();
  }

  Future<void> modifierModuleAjoute(
      String ueId, String moduleId, Map<String, dynamic> nouveau) async {
    final liste = modulesAjoutes(ueId);
    final i = liste.indexWhere((m) => m['id'] == moduleId);
    if (i >= 0) {
      liste[i] = nouveau;
      await _custom.put('add|$ueId', jsonEncode(liste));
      notifyListeners();
    }
  }

  Future<void> supprimerModuleAjoute(String ueId, String moduleId) async {
    final liste = modulesAjoutes(ueId)
      ..removeWhere((m) => m['id'] == moduleId);
    if (liste.isEmpty) {
      await _custom.delete('add|$ueId');
    } else {
      await _custom.put('add|$ueId', jsonEncode(liste));
    }
    notifyListeners();
  }
}

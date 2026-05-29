import '../models/cursus.dart';
import '../models/note.dart';

/// Moteur de calcul : matière → UE → semestre.
///
/// Règles appliquées :
///  - Note matière = moyenne(TP, TD) × partCC + Examen × (1 - partCC).
///    Les composantes absentes ou nulles sont ignorées dans la moyenne CC.
///  - Note UE     = Σ(note_matière × coef) / Σ(coef)
///  - Note semestre = Σ(note_UE × crédits) / Σ(crédits)
///
/// `null` signifie « impossible à calculer faute de notes saisies ».

double? moyenneECUE(ECUE ecue, NoteECUE? note) {
  if (note == null || note.estVide) return null;

  // Moyenne contrôle continu (moyenne des composantes saisies).
  final composantesCC = <double>[];
  if (ecue.aTP && note.tp != null) composantesCC.add(note.tp!);
  if (ecue.aTD && note.td != null) composantesCC.add(note.td!);

  final ccDispo = composantesCC.isNotEmpty;
  final exDispo = ecue.aExamen && note.examen != null;

  if (!ccDispo && !exDispo) return null;

  // Cas 1 : matière 100 % CC (projet, stage…).
  if (!ecue.aExamen) {
    if (!ccDispo) return null;
    return composantesCC.reduce((a, b) => a + b) / composantesCC.length;
  }

  // Cas 2 : matière 100 % examen (pas de CC déclaré).
  if (!ecue.aTP && !ecue.aTD) {
    return note.examen;
  }

  // Cas 3 : pondération CC / Examen.
  final moyCC = ccDispo
      ? composantesCC.reduce((a, b) => a + b) / composantesCC.length
      : null;

  if (moyCC == null) return note.examen; // pas de CC → on prend l'examen seul
  if (!exDispo) return moyCC;            // pas d'examen → on prend le CC seul

  return moyCC * ecue.partCC + note.examen! * ecue.partExamen;
}

class ResultatUE {
  final UE ue;
  final double? moyenne;
  final double coefTotal;
  final Map<String, double?> notesParEcue;

  const ResultatUE({
    required this.ue,
    required this.moyenne,
    required this.coefTotal,
    required this.notesParEcue,
  });

  bool get valide => moyenne != null && moyenne! >= 10.0;
}

ResultatUE moyenneUE(UE ue, Map<String, NoteECUE> notes) {
  double sommePond = 0;
  double sommeCoef = 0;
  final detail = <String, double?>{};

  for (final ecue in ue.ecues) {
    final m = moyenneECUE(ecue, notes[ecue.id]);
    detail[ecue.id] = m;
    if (m != null) {
      sommePond += m * ecue.coefficient;
      sommeCoef += ecue.coefficient;
    }
  }

  final moy = sommeCoef > 0 ? sommePond / sommeCoef : null;
  final coefTotal =
      ue.ecues.fold<double>(0, (acc, e) => acc + e.coefficient);

  return ResultatUE(
    ue: ue,
    moyenne: moy,
    coefTotal: coefTotal,
    notesParEcue: detail,
  );
}

class ResultatSemestre {
  final Semestre semestre;
  final double? moyenne;
  final int creditsValides;
  final int creditsTotal;
  final List<ResultatUE> resultatsUE;

  const ResultatSemestre({
    required this.semestre,
    required this.moyenne,
    required this.creditsValides,
    required this.creditsTotal,
    required this.resultatsUE,
  });

  bool get valide => moyenne != null && moyenne! >= 10.0;
}

ResultatSemestre moyenneSemestre(
    Semestre semestre, Map<String, NoteECUE> notes) {
  final resultats = <ResultatUE>[];
  int creditsTotal = 0;

  // Moyenne semestre = Σ(note_ECUE × coef_ECUE) / Σ(coef_ECUE) sur toutes
  // les matières du semestre — c'est la formule LMD standard, qui matche
  // exactement le bulletin officiel.
  double sommePondCoef = 0;
  double sommeCoef = 0;

  for (final ue in semestre.unites) {
    final r = moyenneUE(ue, notes);
    resultats.add(r);
    creditsTotal += ue.credits;
    for (final ecue in ue.ecues) {
      final m = r.notesParEcue[ecue.id];
      if (m != null) {
        sommePondCoef += m * ecue.coefficient;
        sommeCoef += ecue.coefficient;
      }
    }
  }

  final moy = sommeCoef > 0 ? sommePondCoef / sommeCoef : null;

  // Règle de compensation LMD : si la moyenne semestre ≥ 10, TOUS les
  // crédits du semestre sont validés. Sinon, on compte les crédits des UE
  // individuellement acquises (moy UE ≥ 10).
  int creditsValides;
  if (moy != null && moy >= 10.0) {
    creditsValides = creditsTotal;
  } else {
    creditsValides = 0;
    for (final r in resultats) {
      if (r.moyenne != null && r.moyenne! >= 10.0) {
        creditsValides += r.ue.credits;
      }
    }
  }

  return ResultatSemestre(
    semestre: semestre,
    moyenne: moy,
    creditsValides: creditsValides,
    creditsTotal: creditsTotal,
    resultatsUE: resultats,
  );
}

class ResultatCursus {
  final Cursus cursus;
  final List<ResultatSemestre> semestres;
  final double? moyenneAnnuelle;

  const ResultatCursus({
    required this.cursus,
    required this.semestres,
    required this.moyenneAnnuelle,
  });

  String get mention {
    final m = moyenneAnnuelle;
    if (m == null) return '—';
    if (m < 10) return 'Ajourné';
    if (m < 12) return 'Passable';
    if (m < 14) return 'Assez bien';
    if (m < 16) return 'Bien';
    return 'Très bien';
  }
}

ResultatCursus moyenneCursus(Cursus cursus, Map<String, NoteECUE> notes) {
  final resultats =
      cursus.semestres.map((s) => moyenneSemestre(s, notes)).toList();

  // Moyenne annuelle pondérée par les crédits du semestre (= 30 normalement,
  // mais on suit les crédits réels pour rester correct si la maquette diffère).
  double sommePond = 0;
  double sommeCred = 0;
  for (final r in resultats) {
    if (r.moyenne != null) {
      sommePond += r.moyenne! * r.creditsTotal;
      sommeCred += r.creditsTotal;
    }
  }
  final moy = sommeCred > 0 ? sommePond / sommeCred : null;

  return ResultatCursus(
    cursus: cursus,
    semestres: resultats,
    moyenneAnnuelle: moy,
  );
}

// ─── Simulation : note d'examen nécessaire ──────────────────────────────

/// Calcule la note d'examen requise sur une matière pour atteindre
/// `objectif` (par défaut 10/20). Retourne `null` si le CC est absent ou si
/// la matière n'a pas d'examen distinct.
double? noteExamenRequise({
  required ECUE ecue,
  required NoteECUE? note,
  double objectif = 10.0,
}) {
  if (!ecue.aExamen || ecue.partExamen <= 0) return null;
  if (note == null) return null;

  final composantesCC = <double>[];
  if (ecue.aTP && note.tp != null) composantesCC.add(note.tp!);
  if (ecue.aTD && note.td != null) composantesCC.add(note.td!);

  // S'il n'y a pas du tout de CC dans la matière → la note examen = objectif.
  if (!ecue.aTP && !ecue.aTD) return objectif;

  if (composantesCC.isEmpty) return null;
  final moyCC = composantesCC.reduce((a, b) => a + b) / composantesCC.length;

  return (objectif - moyCC * ecue.partCC) / ecue.partExamen;
}

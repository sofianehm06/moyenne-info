/// Représente la saisie utilisateur pour une matière donnée.
///
/// Chaque composante est optionnelle : si une matière n'a pas de TP, le
/// champ reste `null`. La valeur attendue est sur 20.
class NoteECUE {
  final String ecueId;
  final double? tp;
  final double? td;
  final double? examen;

  const NoteECUE({
    required this.ecueId,
    this.tp,
    this.td,
    this.examen,
  });

  NoteECUE copyWith({
    double? tp,
    double? td,
    double? examen,
    bool clearTp = false,
    bool clearTd = false,
    bool clearExamen = false,
  }) {
    return NoteECUE(
      ecueId: ecueId,
      tp: clearTp ? null : (tp ?? this.tp),
      td: clearTd ? null : (td ?? this.td),
      examen: clearExamen ? null : (examen ?? this.examen),
    );
  }

  bool get estVide => tp == null && td == null && examen == null;
}

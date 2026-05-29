/// Modèles de données décrivant un cursus universitaire (Licence, Master,
/// cycle Ingénieur) et la structure interne d'un semestre :
///
///   Cursus ─► Semestre ─► UE (Unité d'enseignement) ─► ECUE (matière)
///
/// Les données utilisateur (notes saisies) sont stockées séparément via le
/// `StorageService` et indexées par cursusId / ecueId / composante.
library;

enum TypeCursus { licence, master, ingenieur }

class ECUE {
  final String id;
  final String code;
  final String nom;
  final double coefficient;

  /// Pondération contrôle continu (TP/TD) dans la note finale de la
  /// matière. Compris entre 0 et 1. La part examen = 1 - partCC.
  final double partCC;

  final bool aTP;
  final bool aTD;
  final bool aExamen;

  /// `true` si la matière a été ajoutée par l'utilisateur (modifiable et
  /// supprimable). Les modules officiels ne sont pas supprimables.
  final bool personnalise;

  const ECUE({
    required this.id,
    required this.code,
    required this.nom,
    required this.coefficient,
    this.partCC = 0.4,
    this.aTP = false,
    this.aTD = false,
    this.aExamen = true,
    this.personnalise = false,
  });

  double get partExamen => 1.0 - partCC;

  ECUE copyWith({
    String? nom,
    double? coefficient,
    double? partCC,
    bool? aTP,
    bool? aTD,
    bool? aExamen,
  }) {
    return ECUE(
      id: id,
      code: code,
      nom: nom ?? this.nom,
      coefficient: coefficient ?? this.coefficient,
      partCC: partCC ?? this.partCC,
      aTP: aTP ?? this.aTP,
      aTD: aTD ?? this.aTD,
      aExamen: aExamen ?? this.aExamen,
      personnalise: personnalise,
    );
  }
}

class UE {
  final String id;
  final String code;
  final String nom;
  final int credits;
  final List<ECUE> ecues;

  const UE({
    required this.id,
    required this.code,
    required this.nom,
    required this.credits,
    required this.ecues,
  });
}

class Semestre {
  final String id;
  final String nom;
  final int numero;
  final List<UE> unites;

  const Semestre({
    required this.id,
    required this.nom,
    required this.numero,
    required this.unites,
  });
}

class Cursus {
  final String id;
  final String nom;
  final String niveau;
  final String? specialite;
  final TypeCursus type;
  final List<Semestre> semestres;

  const Cursus({
    required this.id,
    required this.nom,
    required this.niveau,
    required this.type,
    required this.semestres,
    this.specialite,
  });

  String get libelleCourt {
    if (specialite != null) return '$niveau $specialite';
    return niveau;
  }
}

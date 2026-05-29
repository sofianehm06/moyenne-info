import '../data/storage.dart';
import '../models/cursus.dart';

/// Applique les personnalisations utilisateur (overrides de coef/partCC et
/// modules ajoutés) sur un cursus de base, et renvoie une copie « effective »
/// utilisée pour l'affichage et le calcul.
Cursus appliquerPersonnalisation(Cursus base, StorageService storage) {
  return Cursus(
    id: base.id,
    nom: base.nom,
    niveau: base.niveau,
    specialite: base.specialite,
    type: base.type,
    semestres: [
      for (final sem in base.semestres)
        Semestre(
          id: sem.id,
          nom: sem.nom,
          numero: sem.numero,
          unites: [
            for (final ue in sem.unites) _ueEffective(ue, storage),
          ],
        ),
    ],
  );
}

UE _ueEffective(UE ue, StorageService storage) {
  final ecues = <ECUE>[];

  // 1. Modules officiels, avec override éventuel.
  for (final e in ue.ecues) {
    final ov = storage.overrideModule(e.id);
    if (ov != null) {
      ecues.add(e.copyWith(
        coefficient: (ov['coef'] as num?)?.toDouble(),
        partCC: (ov['partCC'] as num?)?.toDouble(),
      ));
    } else {
      ecues.add(e);
    }
  }

  // 2. Modules ajoutés par l'utilisateur.
  for (final m in storage.modulesAjoutes(ue.id)) {
    ecues.add(ECUE(
      id: m['id'] as String,
      code: (m['code'] as String?) ?? '',
      nom: (m['nom'] as String?) ?? 'Module',
      coefficient: (m['coef'] as num?)?.toDouble() ?? 1,
      partCC: (m['partCC'] as num?)?.toDouble() ?? 0.4,
      aTP: (m['tp'] as bool?) ?? false,
      aTD: (m['td'] as bool?) ?? true,
      aExamen: (m['exam'] as bool?) ?? true,
      personnalise: true,
    ));
  }

  return UE(
    id: ue.id,
    code: ue.code,
    nom: ue.nom,
    credits: ue.credits,
    ecues: ecues,
  );
}

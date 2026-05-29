import '../models/cursus.dart';

/// Cursus du département informatique.
///
/// IMPORTANT : ces structures sont un point de départ représentatif des
/// programmes de Licence / Master / cycle Ingénieur en informatique.
/// Adaptez les modules, coefficients et crédits aux maquettes officielles
/// de votre université.

// ─── Helpers ────────────────────────────────────────────────────────────

ECUE _ec(
  String id,
  String code,
  String nom, {
  double coef = 1,
  double partCC = 0.4,
  bool tp = false,
  bool td = true,
  bool exam = true,
}) {
  return ECUE(
    id: id,
    code: code,
    nom: nom,
    coefficient: coef,
    partCC: partCC,
    aTP: tp,
    aTD: td,
    aExamen: exam,
  );
}

UE _ue(String id, String code, String nom, int credits, List<ECUE> ecues) {
  return UE(id: id, code: code, nom: nom, credits: credits, ecues: ecues);
}

Semestre _sem(String id, String nom, int numero, List<UE> unites) {
  return Semestre(id: id, nom: nom, numero: numero, unites: unites);
}

// ─── Licence Informatique ───────────────────────────────────────────────

// Licence 1 : S1 a 5 UE (UEF1 + UEF2 + UEM + UED + UET), S2 a 3 UE.
// Crédits confirmés par bulletin S1 ; crédits ECUE S2 estimés.
final Cursus _l1 = Cursus(
  id: 'lic_l1',
  nom: 'Licence Informatique — L1',
  niveau: 'L1',
  type: TypeCursus.licence,
  semestres: [
    _sem('lic_l1_s1', 'Semestre 1', 1, [
      _ue('l1s1_uef1', 'U.E.F1', 'Unité d\'Enseignement Fondamentale 1', 12, [
        _ec('l1s1_sm1', 'SM1', 'Structure Machine 1',
            coef: 3, td: true),
        _ec('l1s1_asd1', 'ASD1',
            'Algorithmique et Structure de Données 1',
            coef: 5, tp: true, td: true),
      ]),
      _ue('l1s1_uef2', 'U.E.F2', 'Unité d\'Enseignement Fondamentale 2', 10, [
        _ec('l1s1_ana1', 'ANA1', 'Analyse 1', coef: 4, td: true),
        _ec('l1s1_alg1', 'ALG1', 'Algèbre 1', coef: 2, td: true),
      ]),
      _ue('l1s1_uem', 'U.E.M', 'Unité d\'Enseignement Méthodologique', 2, [
        _ec('l1s1_open', 'OS', 'Logiciels Libres (Open Source)',
            coef: 1, td: false, tp: false),
      ]),
      _ue('l1s1_ued', 'U.E.D', 'Unité d\'Enseignement Découverte', 4, [
        _ec('l1s1_elec', 'EG', 'Electricité Générale', coef: 2, td: true),
      ]),
      _ue('l1s1_uet', 'U.E.T', 'Unité d\'Enseignement Transversale', 2, [
        _ec('l1s1_lang', 'LE',
            'Langue Etrangère',
            coef: 1, td: false, tp: false),
      ]),
    ]),
    _sem('lic_l1_s2', 'Semestre 2', 2, [
      _ue('l1s2_uef1', 'U.E.F1', 'Unité d\'Enseignement Fondamentale 1', 10, [
        _ec('l1s2_ana2', 'ANA2', 'Analyse 2', coef: 4, td: true),
        _ec('l1s2_alg2', 'ALG2', 'Algèbre 2', coef: 2, td: true),
      ]),
      _ue('l1s2_uef2', 'U.E.F2', 'Unité d\'Enseignement Fondamentale 2', 12, [
        _ec('l1s2_asd2', 'ASD2',
            'Algorithmique et Structure de Données 2',
            coef: 5, tp: true, td: true),
        _ec('l1s2_sm2', 'SM2', 'Structure Machine 2',
            coef: 3, td: true),
      ]),
      _ue('l1s2_uem', 'U.E.M', 'Unité d\'Enseignement Méthodologique', 4, [
        _ec('l1s2_logmath', 'LM', 'Logique Mathématique',
            coef: 1, tp: true, td: false),
        _ec('l1s2_iia', 'IIA', 'Introduction à l\'Intelligence Artificielle',
            coef: 1, tp: true, td: false),
      ]),
      _ue('l1s2_ued', 'U.E.D', 'Unité d\'Enseignement Découverte', 4, [
        _ec('l1s2_elecf', 'EF', 'Electronique Fondamentale',
            coef: 2, td: true),
      ]),
    ]),
  ],
);

// Licence 2 : structure officielle (UEF1 + UEF2 + UEM + UET par semestre).
// Crédits UE confirmés par le bulletin.
final Cursus _l2 = Cursus(
  id: 'lic_l2',
  nom: 'Licence Informatique — L2',
  niveau: 'L2',
  type: TypeCursus.licence,
  semestres: [
    _sem('lic_l2_s3', 'Semestre 3', 3, [
      _ue('l2s3_uef1', 'U.E.F1', 'Unité d\'Enseignement Fondamentale 1', 11, [
        _ec('l2s3_asd3', 'ASD3', 'Algorithmique et Structure de Données 3',
            coef: 3, tp: true, td: true),
        _ec('l2s3_archi', 'ARCH', 'Architectures des Ordinateurs',
            coef: 3, tp: true, td: true),
      ]),
      _ue('l2s3_uef2', 'U.E.F2', 'Unité d\'Enseignement Fondamentale 2', 9, [
        _ec('l2s3_si', 'SI', 'Système d\'Information',
            coef: 3, td: true),
        _ec('l2s3_graphes', 'GR', 'Théorie des Graphes',
            coef: 2, td: true),
      ]),
      _ue('l2s3_uem', 'U.E.M', 'Unité d\'Enseignement Méthodologique', 8, [
        _ec('l2s3_methnum', 'MN', 'Méthodes Numériques',
            coef: 2, tp: true, td: false),
        _ec('l2s3_logmath', 'LM', 'Logique Mathématique',
            coef: 2, td: true),
      ]),
      _ue('l2s3_uet', 'U.E.T', 'Unité d\'Enseignement Transversale', 2, [
        _ec('l2s3_lang', 'LE2', 'Langue Etrangère 2',
            coef: 1, td: true),
      ]),
    ]),
    _sem('lic_l2_s4', 'Semestre 4', 4, [
      _ue('l2s4_uef1', 'U.E.F1', 'Unité d\'Enseignement Fondamentale 1', 10, [
        _ec('l2s4_se1', 'SE1', 'Système d\'Exploitation 1',
            coef: 3, tp: true, td: true),
        _ec('l2s4_tl', 'TL', 'Théorie des Langages',
            coef: 2, td: true),
      ]),
      _ue('l2s4_uef2', 'U.E.F2', 'Unité d\'Enseignement Fondamentale 2', 10, [
        _ec('l2s4_bd', 'BD', 'Bases de Données',
            coef: 3, tp: true, td: true),
        _ec('l2s4_rx', 'RX', 'Réseaux',
            coef: 3, tp: true, td: true),
      ]),
      _ue('l2s4_uem', 'U.E.M', 'Unité d\'Enseignement Méthodologique', 8, [
        _ec('l2s4_poo', 'POO', 'Programmation Orientée Objet',
            coef: 2, tp: true, td: false),
        _ec('l2s4_web', 'WEB', 'Développement d\'Applications Web',
            coef: 2, tp: true, td: false),
      ]),
      _ue('l2s4_uet', 'U.E.T', 'Unité d\'Enseignement Transversale', 2, [
        _ec('l2s4_lang3', 'LE3', 'Langue Etrangère 3',
            coef: 1, td: true),
      ]),
    ]),
  ],
);

// Licence 3 : 4 UE par semestre (U.E.F1 + U.E.F2 + U.E.M + U.E.T).
// Pondération par défaut : CC 40% / Examen 60%.
final Cursus _l3 = Cursus(
  id: 'lic_l3',
  nom: 'Licence Informatique — L3',
  niveau: 'L3',
  type: TypeCursus.licence,
  semestres: [
    _sem('lic_l3_s5', 'Semestre 5', 5, [
      _ue('l3s5_uef1', 'U.E.F1', 'Unité d\'Enseignement Fondamentale 1', 10, [
        _ec('l3s5_ihm', 'IHM', 'Interface Homme Machine',
            coef: 3, tp: true, td: true),
        _ec('l3s5_gl', 'GL', 'Génie Logiciel',
            coef: 3, tp: true, td: true),
      ]),
      _ue('l3s5_uef2', 'U.E.F2', 'Unité d\'Enseignement Fondamentale 2', 10, [
        _ec('l3s5_compil', 'COMP', 'Compilation',
            coef: 3, tp: true, td: true),
        _ec('l3s5_se2', 'SE2', 'Système d\'exploitation 2',
            coef: 3, tp: true, td: true),
      ]),
      _ue('l3s5_uem', 'U.E.M', 'Unité d\'Enseignement Méthodologique', 8, [
        _ec('l3s5_proba', 'PROB', 'Probabilités et Statistiques',
            coef: 2, td: true),
        _ec('l3s5_pl', 'PL', 'Programmation Linéaire',
            coef: 2, td: true),
      ]),
      _ue('l3s5_uet', 'U.E.T', 'Unité d\'Enseignement Transversale', 2, [
        _ec('l3s5_eco', 'ECO', 'Economie Numérique et Veille Stratégique',
            coef: 1, td: true),
      ]),
    ]),
    _sem('lic_l3_s6', 'Semestre 6', 6, [
      _ue('l3s6_uef1', 'U.E.F1', 'Unité d\'Enseignement Fondamentale 1', 10, [
        _ec('l3s6_sec', 'SEC', 'Sécurité Informatique',
            coef: 3, tp: true, td: true),
        _ec('l3s6_mob', 'MOB', 'Applications Mobiles',
            coef: 3, tp: true, td: true),
      ]),
      _ue('l3s6_uef2', 'U.E.F2', 'Unité d\'Enseignement Fondamentale 2', 10, [
        _ec('l3s6_dss', 'DSS', 'Données Semi-structurées',
            coef: 3, tp: true, td: true),
        _ec('l3s6_ia', 'IA', 'Intelligence Artificielle',
            coef: 3, tp: true, td: true),
      ]),
      _ue('l3s6_uem', 'U.E.M', 'Unité d\'Enseignement Méthodologique', 8, [
        _ec('l3s6_prj', 'PRJ', 'Projet',
            coef: 3, tp: true, td: false, exam: false,
            partCC: 1.0),
        _ec('l3s6_rs', 'RS', 'Rédaction Scientifique',
            coef: 1, td: true),
      ]),
      _ue('l3s6_uet', 'U.E.T', 'Unité d\'Enseignement Transversale', 2, [
        _ec('l3s6_startup', 'STR', 'Créer et Développer une Start-up',
            coef: 1, td: true),
      ]),
    ]),
  ],
);

// ─── Master Informatique (3 spécialités) ────────────────────────────────

// Master 1 GL : structure officielle (UEF / UEM / UED par semestre).
// Pondération par défaut : CC 40% / Examen 60%.
final Cursus _m1GL = Cursus(
  id: 'm1_gl',
  nom: 'Master 1 — Génie Logiciel',
  niveau: 'M1',
  specialite: 'GL',
  type: TypeCursus.master,
  semestres: [
    _sem('m1gl_s1', 'Semestre 1', 1, [
      _ue('m1gl_s1_uef', 'U.E.F', 'Unité d\'Enseignement Fondamentale', 18, [
        _ec('m1gl_s1_idm', 'IDM', 'Ingénierie Dirigée par les Modèles',
            coef: 4, tp: true, td: true),
        _ec('m1gl_s1_bda', 'BDA', 'Bases de Données Avancées',
            coef: 4, tp: true, td: true),
        _ec('m1gl_s1_pa', 'PA', 'Programmation Avancée',
            coef: 3, tp: true, td: true),
      ]),
      _ue('m1gl_s1_uem', 'U.E.M', 'Unité d\'Enseignement Méthodologique', 9, [
        _ec('m1gl_s1_rx', 'RX', 'Réseaux',
            coef: 2, tp: true, td: true),
        _ec('m1gl_s1_secl', 'SECL', 'Sécurité des Logiciels',
            coef: 2, td: true),
      ]),
      _ue('m1gl_s1_ued', 'U.E.D', 'Unité d\'Enseignement Découverte', 3, [
        _ec('m1gl_s1_dmml', 'DM', 'Data Mining et Machine Learning',
            coef: 2, tp: true, td: false),
        _ec('m1gl_s1_ang', 'ANG', 'Anglais',
            coef: 1, td: true),
      ]),
    ]),
    _sem('m1gl_s2', 'Semestre 2', 2, [
      _ue('m1gl_s2_uef', 'U.E.F', 'Unité d\'Enseignement Fondamentale', 18, [
        _ec('m1gl_s2_mc', 'MC', 'Méthodes de Conception',
            coef: 4, tp: true, td: true),
        _ec('m1gl_s2_bdnsq', 'BDNSQ', 'Big Data et Bases de Données NoSQL',
            coef: 4, tp: true, td: true),
        _ec('m1gl_s2_psys', 'PSYS', 'Programmation Système',
            coef: 4, tp: true, td: true),
      ]),
      _ue('m1gl_s2_uem', 'U.E.M', 'Unité d\'Enseignement Méthodologique', 9, [
        _ec('m1gl_s2_aie', 'AIE', 'Application Informatique Encadrée',
            coef: 2, tp: true, td: true),
        _ec('m1gl_s2_to', 'TO', 'Techniques d\'Optimisation',
            coef: 2, td: true),
      ]),
      _ue('m1gl_s2_ued', 'U.E.D', 'Unité d\'Enseignement Découverte', 3, [
        _ec('m1gl_s2_imp', 'IMP', 'Insertion en Milieu Professionnel',
            coef: 1, td: true),
        _ec('m1gl_s2_ang', 'ANG', 'Anglais',
            coef: 1, td: true),
      ]),
    ]),
  ],
);

// Master 1 ASR : structure officielle (3 UE par semestre : UEF / UEM / UED).
// Crédits S1 confirmés par bulletin ; S2 mirroring S1 (à ajuster si différent).
// Pondération par défaut : CC 40% / Examen 60%.
final Cursus _m1ASR = Cursus(
  id: 'm1_asr',
  nom: 'Master 1 — Administration Systèmes & Réseaux',
  niveau: 'M1',
  specialite: 'ASR',
  type: TypeCursus.master,
  semestres: [
    _sem('m1asr_s1', 'Semestre 1', 1, [
      _ue('m1asr_s1_uef', 'U.E.F', 'Unité d\'Enseignement Fondamentale', 18, [
        _ec('m1asr_s1_lan', 'LAN', 'Installation et Configuration LAN',
            coef: 3, tp: true, td: true),
        _ec('m1asr_s1_rx2', 'RX2', 'Réseaux 2',
            coef: 3, tp: true, td: true),
        _ec('m1asr_s1_bda', 'BDA', 'Bases de Données Avancées',
            coef: 3, tp: true, td: true),
      ]),
      _ue('m1asr_s1_uem', 'U.E.M', 'Unité d\'Enseignement Méthodologique', 9, [
        _ec('m1asr_s1_pa', 'PA', 'Programmation Avancée',
            coef: 3, tp: true, td: true),
        _ec('m1asr_s1_sec2', 'SEC2', 'Sécurité 2',
            coef: 3, tp: true, td: true),
      ]),
      _ue('m1asr_s1_ued', 'U.E.D', 'Unité d\'Enseignement Découverte', 3, [
        _ec('m1asr_s1_ml', 'ML',
            'Apprentissage automatique pour les réseaux',
            coef: 2, tp: true, td: false),
        _ec('m1asr_s1_ang', 'ANG', 'Anglais',
            coef: 1, td: true),
      ]),
    ]),
    _sem('m1asr_s2', 'Semestre 2', 2, [
      _ue('m1asr_s2_uef', 'U.E.F', 'Unité d\'Enseignement Fondamentale', 18, [
        _ec('m1asr_s2_prx', 'PRX', 'Programmation Réseaux',
            coef: 3, tp: true, td: true),
        _ec('m1asr_s2_psys', 'PSYS', 'Programmation Système',
            coef: 3, tp: true, td: true),
        _ec('m1asr_s2_tip', 'TIP', 'Technologie IP',
            coef: 3, tp: true, td: true),
      ]),
      _ue('m1asr_s2_uem', 'U.E.M', 'Unité d\'Enseignement Méthodologique', 9, [
        _ec('m1asr_s2_aie', 'AIE', 'Application Informatique Encadrée',
            coef: 3, tp: true, td: true),
        _ec('m1asr_s2_to', 'TO', 'Techniques d\'Optimisation',
            coef: 2, td: true),
        _ec('m1asr_s2_se', 'SE', 'Systèmes Embarqués',
            coef: 2, tp: true, td: false),
      ]),
      _ue('m1asr_s2_ued', 'U.E.D', 'Unité d\'Enseignement Découverte', 3, [
        _ec('m1asr_s2_imp', 'IMP', 'Insertion en Milieu Professionnel',
            coef: 1, td: true),
        _ec('m1asr_s2_ang', 'ANG', 'Anglais',
            coef: 1, td: true),
      ]),
    ]),
  ],
);

// Master 1 IA : structure officielle (UEF1 + UEF2 + UEM + UED + UET en S1,
// puis UEF + UEM + UED en S2). Pondération CC 40% / Examen 60%.
final Cursus _m1AI = Cursus(
  id: 'm1_ai',
  nom: 'Master 1 — Intelligence Artificielle',
  niveau: 'M1',
  specialite: 'AI',
  type: TypeCursus.master,
  semestres: [
    _sem('m1ai_s1', 'Semestre 1', 1, [
      _ue('m1ai_s1_uef1', 'U.E.F1', 'Unité d\'Enseignement Fondamentale 1', 10,
          [
        _ec('m1ai_s1_aac', 'AAC', 'Algorithmique Avancée et Complexité',
            coef: 3, tp: true, td: true),
        _ec('m1ai_s1_bda', 'BDA', 'Bases de Données Avancées',
            coef: 3, tp: true, td: true),
      ]),
      _ue('m1ai_s1_uef2', 'U.E.F2', 'Unité d\'Enseignement Fondamentale 2', 8, [
        _ec('m1ai_s1_rcr', 'RCR',
            'Représentation des Connaissances et Raisonnement',
            coef: 3, tp: true, td: false),
        _ec('m1ai_s1_ml', 'ML', 'Machine Learning',
            coef: 3, td: true),
      ]),
      _ue('m1ai_s1_uem', 'U.E.M', 'Unité d\'Enseignement Méthodologique', 9, [
        _ec('m1ai_s1_ad', 'AD', 'Analyse de Données',
            coef: 2, td: true),
        _ec('m1ai_s1_mo', 'MO', 'Méthodes d\'Optimisation',
            coef: 2, td: true),
      ]),
      _ue('m1ai_s1_ued', 'U.E.D', 'Unité d\'Enseignement Découverte', 1, [
        _ec('m1ai_s1_dn', 'DN',
            'Droit du Numérique et Protection des Données',
            coef: 1, td: false, tp: false),
      ]),
      _ue('m1ai_s1_uet', 'U.E.T', 'Unité d\'Enseignement Transversale', 2, [
        _ec('m1ai_s1_rxav', 'RXA', 'Réseaux Avancés',
            coef: 1, td: true),
      ]),
    ]),
    _sem('m1ai_s2', 'Semestre 2', 2, [
      _ue('m1ai_s2_uef', 'U.E.F', 'Unité d\'Enseignement Fondamentale', 18, [
        _ec('m1ai_s2_gi', 'GI', 'Gestion de l\'Incertain',
            coef: 3, td: true),
        _ec('m1ai_s2_vo', 'VO', 'Vision par Ordinateur',
            coef: 3, tp: true, td: true),
        _ec('m1ai_s2_dl', 'DL', 'Deep Learning',
            coef: 3, tp: true, td: true),
        _ec('m1ai_s2_sma', 'SMA', 'Systèmes Multi-Agents',
            coef: 3, tp: true, td: false),
      ]),
      _ue('m1ai_s2_uem', 'U.E.M', 'Unité d\'Enseignement Méthodologique', 9, [
        _ec('m1ai_s2_ms', 'MS', 'Modélisation et Simulation',
            coef: 2, tp: true, td: true),
        _ec('m1ai_s2_vc', 'VC', 'Virtualisation et Cloud',
            coef: 2, tp: true, td: false),
      ]),
      _ue('m1ai_s2_ued', 'U.E.D', 'Unité d\'Enseignement Découverte', 3, [
        _ec('m1ai_s2_gpi', 'GPI', 'Gestion de Projets Informatiques',
            coef: 1, tp: true, td: false),
        _ec('m1ai_s2_siot', 'SIOT', 'Sécurité de l\'IoT',
            coef: 1, td: true),
      ]),
    ]),
  ],
);

// Master 2 GL : structure issue de la maquette officielle 2016-2017
// (Univ. A.Mira Béjaia). UEF + UEM + UED en S3, PFC en S4.
final Cursus _m2GL = Cursus(
  id: 'm2_gl',
  nom: 'Master 2 — Génie Logiciel',
  niveau: 'M2',
  specialite: 'GL',
  type: TypeCursus.master,
  semestres: [
    _sem('m2gl_s3', 'Semestre 3', 3, [
      _ue('m2gl_s3_uef', 'U.E.F', 'Unité d\'Enseignement Fondamentale', 18, [
        _ec('m2gl_s3_bdd', 'BDD', 'Base de Données Distribuées',
            coef: 3, td: true),
        _ec('m2gl_s3_agl', 'AGL', 'Atelier de Génie Logiciel',
            coef: 3, tp: true, td: true),
        _ec('m2gl_s3_web', 'WEB', 'Technologie Web',
            coef: 3, tp: true, td: false),
      ]),
      _ue('m2gl_s3_uem', 'U.E.M', 'Unité d\'Enseignement Méthodologique', 10, [
        _ec('m2gl_s3_sw', 'SW', 'Services Web',
            coef: 2, tp: true, td: false),
        _ec('m2gl_s3_ti', 'TI', 'Technologie d\'Internet',
            coef: 3, tp: true, td: false),
      ]),
      _ue('m2gl_s3_ued', 'U.E.D', 'Unité d\'Enseignement Découverte', 2, [
        _ec('m2gl_s3_ent', 'ENT',
            'Découverte de l\'Entreprise et du Monde du Travail',
            coef: 2, td: true),
      ]),
    ]),
    _sem('m2gl_s4', 'Semestre 4 (PFC)', 4, [
      _ue('m2gl_s4_pfc', 'U.E.T', 'Projet de Fin de Cycle', 30, [
        _ec('m2gl_s4_pfc', 'PFC', 'Projet de Fin de Cycle (Stage en entreprise)',
            coef: 30, tp: true, td: false, exam: false,
            partCC: 1.0),
      ]),
    ]),
  ],
);

// Master 2 ASR : structure issue de la maquette officielle 2016-2017
// (Univ. A.Mira Béjaia). UEF + UEM + UED en S3, PFC en S4.
final Cursus _m2ASR = Cursus(
  id: 'm2_asr',
  nom: 'Master 2 — Administration Systèmes & Réseaux',
  niveau: 'M2',
  specialite: 'ASR',
  type: TypeCursus.master,
  semestres: [
    _sem('m2asr_s3', 'Semestre 3', 3, [
      _ue('m2asr_s3_uef', 'U.E.F', 'Unité d\'Enseignement Fondamentale', 18, [
        _ec('m2asr_s3_secs', 'SECS', 'Systèmes de Sécurité',
            coef: 3, tp: true, td: true),
        _ec('m2asr_s3_admrx', 'ADM', 'Administration des Réseaux',
            coef: 3, tp: true, td: false),
        _ec('m2asr_s3_rxmob', 'RXM', 'Réseaux Mobiles',
            coef: 3, tp: true, td: true),
      ]),
      _ue('m2asr_s3_uem', 'U.E.M', 'Unité d\'Enseignement Méthodologique', 10, [
        _ec('m2asr_s3_voip', 'VOIP', 'Téléphonie sur IP',
            coef: 2, tp: true, td: false),
        _ec('m2asr_s3_ti', 'TI', 'Technologie de l\'Internet',
            coef: 3, tp: true, td: false),
      ]),
      _ue('m2asr_s3_ued', 'U.E.D', 'Unité d\'Enseignement Découverte', 2, [
        _ec('m2asr_s3_ent', 'ENT',
            'Découverte de l\'Entreprise et du Monde du Travail',
            coef: 2, td: true),
      ]),
    ]),
    _sem('m2asr_s4', 'Semestre 4 (PFC)', 4, [
      _ue('m2asr_s4_pfc', 'U.E.T', 'Projet de Fin de Cycle', 30, [
        _ec('m2asr_s4_pfc', 'PFC', 'Projet de Fin de Cycle (Stage en entreprise)',
            coef: 30, tp: true, td: false, exam: false,
            partCC: 1.0),
      ]),
    ]),
  ],
);

// Master 2 IA : structure officielle (UEF / UEM / UED / UET en S3, PFC en S4).
// Chaque module a sa propre pondération CC / Examen.
final Cursus _m2AI = Cursus(
  id: 'm2_ai',
  nom: 'Master 2 — Intelligence Artificielle',
  niveau: 'M2',
  specialite: 'AI',
  type: TypeCursus.master,
  semestres: [
    _sem('m2ai_s3', 'Semestre 3', 3, [
      _ue('m2ai_s3_uef', 'U.E.F', 'Unité d\'Enseignement Fondamentale', 18, [
        _ec('m2ai_s3_aa', 'AA', 'Apprentissage Avancé',
            coef: 3, td: true, partCC: 0.5),
        _ec('m2ai_s3_va', 'VA', 'Vision Artificielle',
            coef: 3, td: true, partCC: 0.4),
        _ec('m2ai_s3_rc2', 'RC2', 'Représentation des Connaissances 2',
            coef: 3, td: true, partCC: 0.4),
      ]),
      _ue('m2ai_s3_uem', 'U.E.M', 'Unité d\'Enseignement Méthodologique', 9, [
        _ec('m2ai_s3_sed', 'SED', 'Simulation à Événements Discrets',
            coef: 2, td: true, partCC: 0.4),
        _ec('m2ai_s3_petri', 'PETRI',
            'Modélisation des Systèmes à Événements Discrets par les Réseaux de Petri',
            coef: 2, tp: true, td: true, partCC: 0.5),
      ]),
      _ue('m2ai_s3_ued', 'U.E.D', 'Unité d\'Enseignement Découverte', 2, [
        _ec('m2ai_s3_bd', 'BD', 'Big Data',
            coef: 2, td: true, partCC: 0.4),
        _ec('m2ai_s3_sem', 'SEM', 'Séminaires',
            coef: 1, td: true, exam: false, partCC: 1.0),
      ]),
      _ue('m2ai_s3_uet', 'U.E.T', 'Unité d\'Enseignement Transversale', 1, [
        _ec('m2ai_s3_ir', 'IR', 'Initiation à la Recherche',
            coef: 1, td: true, exam: false, partCC: 1.0),
      ]),
    ]),
    _sem('m2ai_s4', 'Semestre 4 (PFC)', 4, [
      _ue('m2ai_s4_pfc', 'U.E.T', 'Projet de Fin de Cycle', 30, [
        _ec('m2ai_s4_pfc', 'PFC', 'Projet de Fin de Cycle',
            coef: 17, tp: true, td: false, exam: false,
            partCC: 1.0),
      ]),
    ]),
  ],
);

// ─── Cycle Ingénieur (5 ans) ────────────────────────────────────────────

// Ingéniorat 1 — Tronc Commun : structure officielle.
// Pondérations variables : 40/60 par défaut, sauf Intro SE 1 (60/40),
// Tech. expression écrite (50/50), Electronique et Tech. expression orale
// (100% CC).
final Cursus _ing1 = Cursus(
  id: 'ing_1',
  nom: 'Ingéniorat 1 — Tronc Commun',
  niveau: 'Ing1',
  type: TypeCursus.ingenieur,
  semestres: [
    _sem('ing1_s1', 'Semestre 1', 1, [
      _ue('ing1_s1_uef1', 'U.E.F1.1', 'Unité Fondamentale 1', 16, [
        _ec('ing1_s1_asd1', 'ASD1', 'Algorithmique et Structure de Données 1',
            coef: 5, tp: true, td: true),
        _ec('ing1_s1_sm', 'SM', 'Structure Machine',
            coef: 4, td: true),
        _ec('ing1_s1_se1', 'SE1', 'Introduction aux Systèmes d\'Exploitation 1',
            coef: 3, tp: true, td: false, partCC: 0.6),
      ]),
      _ue('ing1_s1_uef2', 'U.E.F1.2', 'Unité Fondamentale 2', 9, [
        _ec('ing1_s1_ana1', 'ANA1', 'Analyse Mathématique 1',
            coef: 3, td: true),
        _ec('ing1_s1_alg1', 'ALG1', 'Algèbre 1',
            coef: 3, td: true),
      ]),
      _ue('ing1_s1_ued', 'U.E.D1.1', 'Unité Découverte', 3, [
        _ec('ing1_s1_elec', 'EF', 'Electronique Fondamentale',
            coef: 1, td: false, tp: false, partCC: 0),
      ]),
      _ue('ing1_s1_uet', 'U.E.T1.1', 'Unité Transversale', 2, [
        _ec('ing1_s1_teeb', 'TEEB',
            'Techniques d\'Expression Écrite et Bureautique',
            coef: 1, tp: true, td: false, partCC: 0.5),
      ]),
    ]),
    _sem('ing1_s2', 'Semestre 2', 2, [
      _ue('ing1_s2_uef1', 'U.E.F2.1', 'Unité Fondamentale 1', 12, [
        _ec('ing1_s2_asd2', 'ASD2', 'Algorithmique et Structure de Données 2',
            coef: 4, tp: true, td: true),
        _ec('ing1_s2_archi', 'ARCH', 'Architecture des Ordinateurs',
            coef: 4, tp: true, td: true),
      ]),
      _ue('ing1_s2_uef2', 'U.E.F2.2', 'Unité Fondamentale 2', 12, [
        _ec('ing1_s2_ana2', 'ANA2', 'Analyse Mathématique 2',
            coef: 3, td: true),
        _ec('ing1_s2_alg2', 'ALG2', 'Algèbre 2',
            coef: 3, td: true),
        _ec('ing1_s2_logmath', 'LM', 'Logique Mathématique',
            coef: 3, td: true),
      ]),
      _ue('ing1_s2_uem', 'U.E.M2.1', 'Unité Méthodologique', 4, [
        _ec('ing1_s2_probas1', 'PS1', 'Probabilités et Statistique 1',
            coef: 2, td: true),
      ]),
      _ue('ing1_s2_uet', 'U.E.T2.1', 'Unité Transversale', 2, [
        _ec('ing1_s2_teo', 'TEO', 'Techniques d\'Expression Orale',
            coef: 1, td: false, tp: false, partCC: 0),
      ]),
    ]),
  ],
);

// Ingéniorat 2 — Tronc Commun : structure officielle.
// Pondérations 40/60 par défaut. Entreprenariat et Déontologie : 100% Examen.
final Cursus _ing2 = Cursus(
  id: 'ing_2',
  nom: 'Ingéniorat 2 — Tronc Commun',
  niveau: 'Ing2',
  type: TypeCursus.ingenieur,
  semestres: [
    _sem('ing2_s3', 'Semestre 3', 3, [
      _ue('ing2_s3_uef1', 'U.E.F3.1', 'Unité Fondamentale 1', 15, [
        _ec('ing2_s3_asd3', 'ASD3', 'Algorithmique et Structure de Données 3',
            coef: 4, tp: true, td: true),
        _ec('ing2_s3_poo1', 'POO1', 'Programmation Orientée Objet 1',
            coef: 4, tp: true, td: false),
        _ec('ing2_s3_si', 'SI', 'Introduction aux Systèmes d\'Information',
            coef: 3, td: true),
      ]),
      _ue('ing2_s3_uef2', 'U.E.F3.2', 'Unité Fondamentale 2', 9, [
        _ec('ing2_s3_alg3', 'ALG3', 'Algèbre 3',
            coef: 3, td: true),
        _ec('ing2_s3_ana3', 'ANA3', 'Analyse Mathématique 3',
            coef: 3, td: true),
      ]),
      _ue('ing2_s3_uem', 'U.E.M3.1', 'Unité Méthodologique', 4, [
        _ec('ing2_s3_ps2', 'PS2', 'Probabilités et Statistiques 2',
            coef: 2, td: true),
      ]),
      _ue('ing2_s3_uet', 'U.E.T3.1', 'Unité Transversale', 2, [
        _ec('ing2_s3_ent', 'ENT', 'Entreprenariat',
            coef: 1, td: false, tp: false, partCC: 0),
      ]),
    ]),
    _sem('ing2_s4', 'Semestre 4', 4, [
      _ue('ing2_s4_uef1', 'U.E.F4.1', 'Unité Fondamentale 1', 12, [
        _ec('ing2_s4_poo2', 'POO2', 'Programmation Orientée Objet 2',
            coef: 4, tp: true, td: false),
        _ec('ing2_s4_se2', 'SE2', 'Introduction aux Systèmes d\'Exploitation 2',
            coef: 4, tp: true, td: true),
      ]),
      _ue('ing2_s4_uef2', 'U.E.F4.2', 'Unité Fondamentale 2', 12, [
        _ec('ing2_s4_rx', 'RX', 'Introduction aux Réseaux Informatiques',
            coef: 3, tp: true, td: true),
        _ec('ing2_s4_bd', 'BD', 'Introduction aux Bases de Données',
            coef: 3, tp: true, td: true),
        _ec('ing2_s4_tl', 'TL', 'Théorie des Langages',
            coef: 3, td: true),
      ]),
      _ue('ing2_s4_uem', 'U.E.M4.1', 'Unité Méthodologique', 4, [
        _ec('ing2_s4_tg', 'TG', 'Théorie des Graphes',
            coef: 2, td: true),
      ]),
      _ue('ing2_s4_uet', 'U.E.T4.1', 'Unité Transversale', 2, [
        _ec('ing2_s4_deo', 'DEO', 'Déontologie de l\'Informatique',
            coef: 1, td: false, tp: false, partCC: 0),
      ]),
    ]),
  ],
);

// Ingéniorat 3 — Génie Logiciel : structure officielle (S5 + S6).
// Pondération 40/60 partout.
final Cursus _ing3 = Cursus(
  id: 'ing_3',
  nom: 'Ingéniorat 3 — Génie Logiciel',
  niveau: 'Ing3',
  type: TypeCursus.ingenieur,
  semestres: [
    _sem('ing3_s5', 'Semestre 5', 5, [
      _ue('ing3_s5_uef1', 'U.E.F1', 'Unité Fondamentale 1', 12, [
        _ec('ing3_s5_aca', 'ACA', 'Algorithmique et Complexité Avancées',
            coef: 4, tp: true, td: true),
        _ec('ing3_s5_gl', 'GL', 'Génie Logiciel (GL)',
            coef: 4, tp: true, td: true),
      ]),
      _ue('ing3_s5_uef2', 'U.E.F2', 'Unité Fondamentale 2', 10, [
        _ec('ing3_s5_bdd', 'BDD', 'BDD : Administration et Architecture',
            coef: 4, tp: true, td: false),
        _ec('ing3_s5_sys2', 'SYS2',
            'Système d\'Exploitation : Synchronisation et Communication',
            coef: 3, tp: true, td: true),
      ]),
      _ue('ing3_s5_uem', 'U.E.M1', 'Unité Méthodologique', 5, [
        _ec('ing3_s5_top', 'TOP', 'Techniques d\'Optimisation',
            coef: 3, td: true),
      ]),
      _ue('ing3_s5_ued', 'U.E.D1', 'Unité Découverte', 3, [
        _ec('ing3_s5_fia', 'FIA', 'Fondements de l\'IA',
            coef: 2, tp: true, td: false),
      ]),
    ]),
    _sem('ing3_s6', 'Semestre 6', 6, [
      _ue('ing3_s6_uef1', 'U.E.F1', 'Unité Fondamentale 1', 10, [
        _ec('ing3_s6_concl', 'CONCL', 'Conception de Logiciels',
            coef: 4, tp: true, td: true),
        _ec('ing3_s6_pweb', 'PWEB', 'Programmation WEB',
            coef: 3, tp: true, td: false),
      ]),
      _ue('ing3_s6_uef2', 'U.E.F2', 'Unité Fondamentale 2', 11, [
        _ec('ing3_s6_bdo', 'BDO',
            'BDD : Optimisation et Gestion des Accès Concurrents',
            coef: 3, tp: true, td: true),
        _ec('ing3_s6_compil1', 'COMPIL1', 'Compilation 1',
            coef: 4, tp: true, td: true),
      ]),
      _ue('ing3_s6_uem', 'U.E.M1', 'Unité Méthodologique', 5, [
        _ec('ing3_s6_anum', 'ANUM', 'Analyse Numérique',
            coef: 4, tp: true, td: true),
      ]),
      _ue('ing3_s6_ued', 'U.E.D1', 'Unité Découverte', 4, [
        _ec('ing3_s6_isec', 'ISEC',
            'Introduction à la Sécurité Informatique',
            coef: 2, tp: true, td: true),
      ]),
    ]),
  ],
);

// Ingéniorat 4 — Génie Logiciel : structure officielle (S7 + S8).
// Pondération 40/60 partout ; Projet Pluridisciplinaire (S8) 100% CC.
final Cursus _ing4 = Cursus(
  id: 'ing_4',
  nom: 'Ingéniorat 4 — Génie Logiciel',
  niveau: 'Ing4',
  type: TypeCursus.ingenieur,
  semestres: [
    _sem('ing4_s7', 'Semestre 7', 7, [
      _ue('ing4_s7_uef1', 'U.E.F1', 'Unité Fondamentale 1', 11, [
        _ec('ing4_s7_cabd', 'CABD', 'Concepts Avancés de BD',
            coef: 3, tp: true, td: true),
        _ec('ing4_s7_gp', 'GP', 'Gestion de Projets',
            coef: 3, tp: true, td: true),
        _ec('ing4_s7_wms', 'WMS', 'Web Avancé et Micro-services',
            coef: 2, tp: true, td: false),
      ]),
      _ue('ing4_s7_uef2', 'U.E.F2', 'Unité Fondamentale 2', 10, [
        _ec('ing4_s7_dm', 'DM', 'Data-Mining',
            coef: 3, tp: true, td: true),
        _ec('ing4_s7_compil2', 'COMPIL2', 'Compilation 2',
            coef: 3, tp: true, td: true),
      ]),
      _ue('ing4_s7_uem', 'U.E.M1', 'Unité Méthodologique', 6, [
        _ec('ing4_s7_agile', 'AGILE', 'Méthodes de Management Agiles',
            coef: 2, tp: true, td: false),
        _ec('ing4_s7_rp', 'RP', 'Réseaux et Protocoles',
            coef: 2, tp: true, td: false),
      ]),
      _ue('ing4_s7_ued', 'U.E.D1', 'Unité Découverte', 3, [
        _ec('ing4_s7_ihm', 'IHM',
            'IHM : Conception et Évaluation des Interfaces',
            coef: 2, tp: true, td: false),
      ]),
    ]),
    _sem('ing4_s8', 'Semestre 8', 8, [
      _ue('ing4_s8_uef1', 'U.E.F1', 'Unité Fondamentale 1', 8, [
        _ec('ing4_s8_agsi', 'AGSI',
            'Architecture et Gestion des Systèmes d\'Information Avancés',
            coef: 3, tp: true, td: true),
        _ec('ing4_s8_bdnosql', 'BDNOSQL', 'Big-Data et Base de Données NoSQL',
            coef: 3, tp: true, td: true),
      ]),
      _ue('ing4_s8_uef2', 'U.E.F2', 'Unité Fondamentale 2', 12, [
        _ec('ing4_s8_archl', 'ARCHL', 'Architectures Logicielles',
            coef: 2, tp: true, td: false),
        _ec('ing4_s8_mgpl', 'MGPL', 'Modèles et Gestion de Procédés Logiciels',
            coef: 3, tp: true, td: true),
        _ec('ing4_s8_test', 'TEST', 'Test Logiciel et Assurance Qualité',
            coef: 2, tp: true, td: false),
      ]),
      _ue('ing4_s8_uem', 'U.E.M1', 'Unité Méthodologique', 6, [
        _ec('ing4_s8_mep', 'MEP', 'Modélisation et Évaluation des Performances',
            coef: 2, td: true),
        _ec('ing4_s8_sem', 'SEM', 'Systèmes d\'Exploitation Mobiles',
            coef: 2, tp: true, td: false),
      ]),
      _ue('ing4_s8_uet', 'U.E.T1', 'Unité Transversale', 4, [
        _ec('ing4_s8_proj', 'PROJ', 'Projet Pluridisciplinaire',
            coef: 3, tp: true, td: false, exam: false, partCC: 1.0),
      ]),
    ]),
  ],
);

// Ingéniorat 5 — Génie Logiciel : structure officielle (S9 + S10 PFE).
// Pondération 40/60 par défaut ; Aspects juridiques 100% Examen ;
// S10 = Projet de Fin d'Études (100% CC, mémoire + soutenance).
final Cursus _ing5 = Cursus(
  id: 'ing_5',
  nom: 'Ingéniorat 5 — Génie Logiciel (PFE)',
  niveau: 'Ing5',
  type: TypeCursus.ingenieur,
  semestres: [
    _sem('ing5_s9', 'Semestre 9', 9, [
      _ue('ing5_s9_uef1', 'U.E.F1', 'Unité Fondamentale 1', 8, [
        _ec('ing5_s9_mfgl', 'MFGL', 'Méthodes Formelles pour le GL',
            coef: 3, tp: true, td: true),
        _ec('ing5_s9_dle', 'DLE', 'Développement de Logiciels Embarqués',
            coef: 3, tp: true, td: false),
      ]),
      _ue('ing5_s9_uef2', 'U.E.F2', 'Unité Fondamentale 2', 9, [
        _ec('ing5_s9_jeux', 'JEUX',
            'Conception de Jeux Vidéo : Théorie et Pratique',
            coef: 3, tp: true, td: false),
        _ec('ing5_s9_iot', 'IOT',
            'Internet of Things (IoT) : Concepts et Développement',
            coef: 4, tp: true, td: true),
      ]),
      _ue('ing5_s9_uem', 'U.E.M1', 'Unité Méthodologique', 11, [
        _ec('ing5_s9_devops', 'DEVOPS', 'DevOps & Cloud Computing',
            coef: 4, tp: true, td: false),
        _ec('ing5_s9_secl', 'SECL', 'Sécurité Logicielle',
            coef: 2, tp: true, td: false),
        _ec('ing5_s9_mob', 'MOB', 'Développement Mobile',
            coef: 2, tp: true, td: false),
      ]),
      _ue('ing5_s9_uet', 'U.E.T1', 'Unité Transversale', 2, [
        _ec('ing5_s9_droit', 'AJ', 'Aspects Juridiques',
            coef: 1, td: false, tp: false, partCC: 0),
      ]),
    ]),
    _sem('ing5_s10', 'Semestre 10 (PFE)', 10, [
      _ue('ing5_s10_pfe', 'U.E.PFE', 'Projet de Fin d\'Études', 30, [
        _ec('ing5_s10_pfe', 'PFE',
            'Stage en Entreprise (Mémoire + Soutenance)',
            coef: 22, tp: true, td: false, exam: false, partCC: 1.0),
      ]),
    ]),
  ],
);

// ─── Export ─────────────────────────────────────────────────────────────

final List<Cursus> kCursus = [
  _l1, _l2, _l3,
  _m1GL, _m1AI, _m1ASR,
  _m2GL, _m2AI, _m2ASR,
  _ing1, _ing2, _ing3, _ing4, _ing5,
];

Cursus? findCursus(String id) {
  for (final c in kCursus) {
    if (c.id == id) return c;
  }
  return null;
}

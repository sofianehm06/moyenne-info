import 'package:flutter_test/flutter_test.dart';

import 'package:moyenne_info/data/curricula.dart';
import 'package:moyenne_info/models/cursus.dart';
import 'package:moyenne_info/models/note.dart';
import 'package:moyenne_info/services/calcul.dart';

void main() {
  group('Calcul de moyenne', () {
    test('Catalogue de cursus chargé', () {
      expect(kCursus, isNotEmpty);
      expect(kCursus.any((c) => c.id == 'lic_l1'), isTrue);
      expect(kCursus.any((c) => c.id == 'm1_gl'), isTrue);
      expect(kCursus.any((c) => c.id == 'ing_4'), isTrue);
    });

    test('Moyenne ECUE pondère CC et examen correctement', () {
      const ecue = ECUE(
        id: 'x',
        code: 'X',
        nom: 'Test',
        coefficient: 1,
        partCC: 0.4,
        aTP: true,
        aTD: true,
        aExamen: true,
      );
      final note = NoteECUE(ecueId: 'x', tp: 16, td: 12, examen: 10);
      // moyCC = (16+12)/2 = 14 ; note = 14*0.4 + 10*0.6 = 5.6 + 6 = 11.6
      expect(moyenneECUE(ecue, note), closeTo(11.6, 0.001));
    });

    test('Note examen requise', () {
      const ecue = ECUE(
        id: 'x',
        code: 'X',
        nom: 'Test',
        coefficient: 1,
        partCC: 0.4,
        aTP: true,
        aTD: true,
      );
      final note = NoteECUE(ecueId: 'x', tp: 12, td: 8); // moyCC = 10
      // 10 = 10*0.4 + ex*0.6 → ex = (10 - 4)/0.6 = 10
      expect(
        noteExamenRequise(ecue: ecue, note: note),
        closeTo(10.0, 0.001),
      );
    });

    test('Matière sans CC : la note = examen', () {
      const ecue = ECUE(
        id: 'x',
        code: 'X',
        nom: 'Test',
        coefficient: 1,
        partCC: 0.4,
        aTP: false,
        aTD: false,
        aExamen: true,
      );
      final note = NoteECUE(ecueId: 'x', examen: 13);
      expect(moyenneECUE(ecue, note), 13);
    });

    test('Matière 100% CC (projet) : la note = moyenne CC', () {
      const ecue = ECUE(
        id: 'x',
        code: 'X',
        nom: 'Projet',
        coefficient: 1,
        partCC: 1.0,
        aTP: true,
        aTD: false,
        aExamen: false,
      );
      final note = NoteECUE(ecueId: 'x', tp: 17);
      expect(moyenneECUE(ecue, note), 17);
    });
  });
}

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class InfoMiseAJour {
  final String version;
  final String url;

  const InfoMiseAJour(this.version, this.url);
}

const _apiRelease =
    'https://api.github.com/repos/sofianehm06/moyenne-info/releases/latest';

/// Retourne les infos de la nouvelle version, ou null s'il n'y en a pas
/// (ou si on n'arrive pas à contacter GitHub).
Future<InfoMiseAJour?> verifierMiseAJour() async {
  try {
    final rep = await http
        .get(Uri.parse(_apiRelease),
            headers: {'Accept': 'application/vnd.github+json'})
        .timeout(const Duration(seconds: 8));
    if (rep.statusCode != 200) return null;

    final data = jsonDecode(rep.body) as Map<String, dynamic>;
    final distante =
        (data['tag_name'] as String).replaceFirst(RegExp(r'^[vV]'), '');
    final locale = (await PackageInfo.fromPlatform()).version;

    if (_estPlusRecente(distante, locale)) {
      return InfoMiseAJour(distante, data['html_url'] as String);
    }
  } catch (_) {
    // Pas d'internet ou erreur : on ne dérange pas l'utilisateur.
  }
  return null;
}

bool _estPlusRecente(String distante, String locale) {
  List<int> morceaux(String v) => v
      .split('+')
      .first
      .split('.')
      .map((e) => int.tryParse(e) ?? 0)
      .toList();

  final a = morceaux(distante);
  final b = morceaux(locale);
  for (var i = 0; i < 3; i++) {
    final x = i < a.length ? a[i] : 0;
    final y = i < b.length ? b[i] : 0;
    if (x != y) return x > y;
  }
  return false;
}

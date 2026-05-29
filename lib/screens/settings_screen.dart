import 'package:flutter/material.dart';

import '../data/storage.dart';

class SettingsScreen extends StatefulWidget {
  final StorageService storage;

  const SettingsScreen({super.key, required this.storage});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> _resetGlobal() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tout réinitialiser'),
        content: const Text(
            'Toutes les notes saisies dans l\'application seront supprimées. '
            'Cette action est irréversible.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Annuler')),
          FilledButton.tonal(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Tout effacer'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await widget.storage.resetTout();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Toutes les notes ont été effacées.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paramètres')),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('À propos',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const ListTile(
            leading: Icon(Icons.school_outlined),
            title: Text('Moyenne Info'),
            subtitle: Text(
              'Calculateur de moyenne du département Informatique : Licence '
              'L1-L3, Master M1/M2 (GL, IA, ASR) et Cycle Ingénieur 1ère à '
              '5ème année.',
            ),
          ),
          const ListTile(
            leading: Icon(Icons.tune_outlined),
            title: Text('Modules personnalisables'),
            subtitle: Text(
              'Tu peux modifier le coefficient et la pondération d\'un module, '
              'ou ajouter un module manquant : ouvre un semestre puis utilise '
              'l\'icône ✎ sur un module ou le bouton « Ajouter un module ».',
            ),
          ),
          const Divider(height: 32),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text('Données',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: Icon(Icons.delete_outline,
                color: Theme.of(context).colorScheme.error),
            title: Text('Tout réinitialiser',
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
            subtitle: const Text(
                'Supprime toutes les notes saisies et les personnalisations'),
            onTap: _resetGlobal,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

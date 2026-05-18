import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../repositories/hymn_state.dart';
import '../widgets/hymn_list_tile.dart';

/// Tela que exibe os últimos hinos visualizados, com seta de voltar para a home.
class RecentHymnsScreen extends StatelessWidget {
  const RecentHymnsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hinos recentes'),
        centerTitle: false,
      ),
      body: Consumer<HymnState>(
        builder: (context, state, _) {
          final recent = state.recentHymns;
          if (recent.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Nenhum hino visualizado ainda.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            itemCount: recent.length,
            itemBuilder: (context, index) {
              final hymn = recent[index];
              return HymnListTile(
                hymn: hymn,
                onTap: () {
                  Navigator.of(context).pop(hymn);
                },
              );
            },
          );
        },
      ),
    );
  }
}


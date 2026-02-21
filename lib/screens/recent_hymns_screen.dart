import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/hymn.dart';
import '../repositories/hymn_state.dart';

/// Tela que exibe os últimos hinos visualizados, com seta de voltar para a home.
class RecentHymnsScreen extends StatelessWidget {
  const RecentHymnsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Últimos hinos'),
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
              return _HymnListTile(
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

class _HymnListTile extends StatelessWidget {
  final Hymn hymn;
  final VoidCallback onTap;

  const _HymnListTile({required this.hymn, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: scheme.brightness == Brightness.dark
                      ? const Color(0xFF2C3A50)
                      : scheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${hymn.number}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: scheme.brightness == Brightness.dark
                        ? scheme.onSurface
                        : const Color(0xFF1976D2),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  hymn.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    color: scheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(Icons.chevron_right, color: scheme.outline),
            ],
          ),
        ),
      ),
    );
  }
}

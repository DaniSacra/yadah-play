import 'package:flutter/material.dart';

import '../models/hymn.dart';

/// Card de hino (número + título) reutilizado na home e na tela de últimos visualizados.
class HymnListTile extends StatelessWidget {
  final Hymn hymn;
  final VoidCallback onTap;

  const HymnListTile({super.key, required this.hymn, required this.onTap});

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

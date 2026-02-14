import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/hymn.dart';
import '../repositories/hymn_state.dart';

class HymnDetailScreen extends StatefulWidget {
  final Hymn hymn;

  const HymnDetailScreen({super.key, required this.hymn});

  @override
  State<HymnDetailScreen> createState() => _HymnDetailScreenState();
}

class _HymnDetailScreenState extends State<HymnDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hymn = widget.hymn;
    final hymnState = context.watch<HymnState>();
    final fontSize = hymnState.lyricsFontSize;

    final hymns = hymnState.hymns;
    final index = hymns.isEmpty ? -1 : hymns.indexWhere((h) => h.id == hymn.id);
    final hasPrevious = index > 0;
    final hasNext = index >= 0 && index < hymns.length - 1;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hino ${hymn.number}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: fontSize <= kLyricsFontSizeMin
                ? null
                : () => hymnState.setLyricsFontSize(fontSize - 2),
            tooltip: 'Diminuir fonte',
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: fontSize >= kLyricsFontSizeMax
                ? null
                : () => hymnState.setLyricsFontSize(fontSize + 2),
            tooltip: 'Aumentar fonte',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hymn.title,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    hymn.lyrics,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      fontSize: fontSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _NavButton(
                    icon: Icons.chevron_left,
                    onPressed: hasPrevious
                        ? () => _goToHymn(context, hymns[index - 1])
                        : null,
                    tooltip: 'Hino anterior',
                  ),
                  _NavButton(
                    icon: Icons.chevron_right,
                    onPressed: hasNext
                        ? () => _goToHymn(context, hymns[index + 1])
                        : null,
                    tooltip: 'Próximo hino',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _goToHymn(BuildContext context, Hymn hymn) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (context) => HymnDetailScreen(hymn: hymn),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String tooltip;

  const _NavButton({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = scheme.brightness == Brightness.dark;
    return Tooltip(
      message: tooltip,
      child: Material(
        color: isDark ? scheme.surfaceContainerHigh : Colors.white,
        shape: const CircleBorder(),
        elevation: 2,
        shadowColor: Colors.black26,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(
              icon,
              size: 28,
              color: isDark
                  ? (onPressed != null ? scheme.onSurface : scheme.onSurface.withOpacity(0.38))
                  : (onPressed != null ? Colors.black87 : Colors.black26),
            ),
          ),
        ),
      ),
    );
  }
}

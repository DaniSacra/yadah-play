import 'package:flutter/material.dart';

import '../models/hymn.dart';

class HymnDetailScreen extends StatefulWidget {
  final Hymn hymn;

  const HymnDetailScreen({super.key, required this.hymn});

  @override
  State<HymnDetailScreen> createState() => _HymnDetailScreenState();
}

class _HymnDetailScreenState extends State<HymnDetailScreen> {
  static const double _minFontSize = 14;
  static const double _maxFontSize = 28;
  static const double _defaultFontSize = 18;

  double _lyricsFontSize = _defaultFontSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hymn = widget.hymn;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hino ${hymn.number}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: _lyricsFontSize <= _minFontSize
                ? null
                : () => setState(() => _lyricsFontSize = (_lyricsFontSize - 2).clamp(_minFontSize, _maxFontSize)),
            tooltip: 'Diminuir fonte',
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: _lyricsFontSize >= _maxFontSize
                ? null
                : () => setState(() => _lyricsFontSize = (_lyricsFontSize + 2).clamp(_minFontSize, _maxFontSize)),
            tooltip: 'Aumentar fonte',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
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
                fontSize: _lyricsFontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
                fontSize: fontSize,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

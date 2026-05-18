import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:upgrader/upgrader.dart';

import '../upgrader/app_upgrader_config.dart';
import '../upgrader/upgrader_debug.dart';

/// Painel temporário na home para diagnosticar o [Upgrader].
class UpgraderDebugPanel extends StatefulWidget {
  final Upgrader upgrader;

  const UpgraderDebugPanel({super.key, required this.upgrader});

  @override
  State<UpgraderDebugPanel> createState() => _UpgraderDebugPanelState();
}

class _UpgraderDebugPanelState extends State<UpgraderDebugPanel> {
  UpgraderDebugSnapshot? _snapshot;
  bool _loading = false;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _refresh());
  }

  Future<void> _refresh() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final snap = await collectUpgraderDebug(widget.upgrader);
      if (!mounted) return;
      setState(() {
        _snapshot = snap;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _copy() async {
    final text = _snapshot?.toReport() ?? _loadError ?? 'Sem dados';
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Debug copiado — cole no chat')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
  return Card(
      margin: EdgeInsets.zero,
      color: scheme.errorContainer.withOpacity(0.35),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.bug_report, color: scheme.error, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Debug atualização (remover depois)',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: LinearProgressIndicator(),
              ),
            if (_loadError != null)
              Text(_loadError!, style: TextStyle(color: scheme.error)),
            if (_snapshot != null)
              Container(
                constraints: const BoxConstraints(maxHeight: 220),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    _snapshot!.toReport(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontFamily: 'monospace',
                          height: 1.35,
                        ),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                FilledButton.tonalIcon(
                  onPressed: _loading ? null : _refresh,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Verificar de novo'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: _snapshot == null && _loadError == null ? null : _copy,
                  icon: const Icon(Icons.copy, size: 18),
                  label: const Text('Copiar'),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              kShowUpgraderDebugPanel
                  ? 'Modo diagnóstico: o popup de atualização aparece sempre. Desligue kShowUpgraderDebugPanel antes do release.'
                  : 'Produção: popup só se a versão da loja for maior que a instalada.',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}

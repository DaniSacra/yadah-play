import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/hymn.dart';
import '../repositories/hymn_state.dart';
import '../widgets/hymn_list_tile.dart';
import '../theme_mode_notifier.dart';
import 'hymn_detail_screen.dart';
import 'recent_hymns_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _query = '';
  bool _searchInLyrics = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HymnState>().loadHymns();
      if (kDebugMode) _showDebugUpdateDialog();
    });
  }

  /// Em debug: mostra diálogo de "atualizar app" após 1,5 s para testar o fluxo.
  void _showDebugUpdateDialog() {
    Future<void>.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Nova versão disponível'),
          content: const Text(
            'Uma nova versão do Hinário está disponível na Play Store. Atualize para acessar as novidades.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Depois'),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final uri = Uri.parse(
                  'https://play.google.com/store/apps/details?id=br.com.d3lab.yadahplay',
                );
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              child: const Text('Atualizar'),
            ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hinário'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _openRecentHymns(context),
            tooltip: 'Últimos hinos visualizados',
          ),
          Consumer<ThemeModeNotifier>(
            builder: (context, themeMode, _) {
              return IconButton(
                icon: Icon(
                  themeMode.mode == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                ),
                onPressed: () => themeMode.toggle(),
                tooltip: themeMode.mode == ThemeMode.dark
                    ? 'Modo claro'
                    : 'Modo escuro',
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Pesquisar por número ou título...',
                    prefixIcon: const Icon(Icons.search, size: 22),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.close, size: 20),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                            tooltip: 'Limpar',
                            style: IconButton.styleFrom(
                              minimumSize: const Size(36, 36),
                              padding: EdgeInsets.zero,
                            ),
                          ),
                  ),
                  onChanged: (value) => setState(() => _query = value),
                ),
                const SizedBox(height: 4),
                CheckboxListTile(
                  value: _searchInLyrics,
                  onChanged: (value) => setState(() => _searchInLyrics = value ?? false),
                  title: const Text('Buscar na letra'),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  dense: true,
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<HymnState>(
              builder: (context, state, _) {
                if (state.status == HymnListStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.status == HymnListStatus.error) {
                  return _ErrorView(
                    message: state.errorMessage ?? 'Não foi possível carregar os hinos.',
                    onRetry: () => state.loadHymns(),
                  );
                }
                final list = state.filterByQuery(_query, includeLyrics: _searchInLyrics);
                if (list.isEmpty) {
                  return Center(
                    child: Text(
                      _query.isEmpty ? 'Nenhum hino carregado.' : 'Nenhum hino encontrado.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final hymn = list[index];
                    return HymnListTile(
                      hymn: hymn,
                      onTap: () => _openDetail(context, hymn),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openRecentHymns(BuildContext context) {
    final navigator = Navigator.of(context);
    final hymnState = context.read<HymnState>();
    navigator
        .push<Hymn?>(
          MaterialPageRoute<Hymn?>(
            builder: (context) => const RecentHymnsScreen(),
          ),
        )
        .then((hymn) {
      if (hymn != null) {
        hymnState.addToRecentHymns(hymn);
        navigator.push(
          MaterialPageRoute<void>(
            builder: (context) => HymnDetailScreen(hymn: hymn),
          ),
        );
      }
    });
  }

  void _openDetail(BuildContext context, Hymn hymn) {
    context.read<HymnState>().addToRecentHymns(hymn);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => HymnDetailScreen(hymn: hymn),
      ),
    ).then((_) {
      // Ao voltar do hino: limpa a busca e remove o foco/teclado.
      // Executamos após a transição da rota para evitar que o Flutter restaure o foco no campo.
      if (!mounted) return;
      _searchController.clear();
      setState(() => _query = '');
      void removeFocus() {
        if (!mounted) return;
        _searchFocusNode.unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      }
      WidgetsBinding.instance.addPostFrameCallback((_) => removeFocus());
      Future<void>.delayed(const Duration(milliseconds: 100), removeFocus);
    });
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}


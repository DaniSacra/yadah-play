import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/hymn.dart';
import 'hymn_repository.dart';

/// Estado da lista de hinos: loading, sucesso ou erro.
enum HymnListStatus { initial, loading, success, error }

/// Chave para persistir o tamanho da fonte das letras.
const String _kLyricsFontSizeKey = 'lyrics_font_size';

/// Chave para persistir os IDs dos últimos hinos visualizados (até 20).
const String _kRecentHymnIdsKey = 'recent_hymn_ids';

const int _kRecentHymnsMax = 20;

/// Tamanho padrão e limites da fonte das letras.
const double kLyricsFontSizeDefault = 18;
const double kLyricsFontSizeMin = 14;
const double kLyricsFontSizeMax = 28;

/// [ChangeNotifier] que mantém a lista de hinos, carregamento e preferência de fonte.
class HymnState extends ChangeNotifier {
  HymnState({HymnRepository? repository})
      : _repository = repository ?? HymnRepository();
  final HymnRepository _repository;

  HymnListStatus _status = HymnListStatus.initial;
  List<Hymn> _hymns = [];
  List<String> _recentHymnIds = [];
  String? _errorMessage;
  double _lyricsFontSize = kLyricsFontSizeDefault;

  HymnListStatus get status => _status;
  List<Hymn> get hymns => List.unmodifiable(_hymns);
  String? get errorMessage => _errorMessage;
  double get lyricsFontSize => _lyricsFontSize;

  /// Lista dos últimos [ _kRecentHymnsMax ] hinos visualizados (mais recente primeiro).
  /// Apenas inclui hinos que ainda existem em [hymns].
  List<Hymn> get recentHymns {
    final idToHymn = {for (final h in _hymns) h.id: h};
    return _recentHymnIds
        .where((id) => idToHymn.containsKey(id))
        .map((id) => idToHymn[id]!)
        .toList();
  }

  /// Filtra hinos por número e título; se [includeLyrics] for true, também pela letra (case-insensitive).
  List<Hymn> filterByQuery(String query, {bool includeLyrics = false}) {
    if (query.trim().isEmpty) return _hymns;
    final q = query.trim().toLowerCase();
    return _hymns.where((h) {
      final matchNumberOrTitle =
          h.number.toString().contains(q) || h.title.toLowerCase().contains(q);
      if (matchNumberOrTitle) return true;
      if (includeLyrics && h.lyrics.toLowerCase().contains(q)) return true;
      return false;
    }).toList();
  }

  /// Carrega os hinos do JSON e a preferência de fonte. Notifica listeners ao terminar.
  Future<void> loadHymns() async {
    _status = HymnListStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _hymns = await _repository.loadHymns();
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getDouble(_kLyricsFontSizeKey);
      if (saved != null) {
        _lyricsFontSize = saved.clamp(kLyricsFontSizeMin, kLyricsFontSizeMax);
      }
      final idsJson = prefs.getString(_kRecentHymnIdsKey);
      if (idsJson != null) {
        try {
          final list = jsonDecode(idsJson) as List<dynamic>?;
          _recentHymnIds = list?.map((e) => e.toString()).toList() ?? [];
        } catch (_) {
          _recentHymnIds = [];
        }
      }
      _status = HymnListStatus.success;
    } catch (e, st) {
      _status = HymnListStatus.error;
      _errorMessage = e.toString();
      debugPrint('HymnState.loadHymns error: $e\n$st');
    }
    notifyListeners();
  }

  /// Registra um hino como visualizado e persiste os últimos [ _kRecentHymnsMax ].
  Future<void> addToRecentHymns(Hymn hymn) async {
    _recentHymnIds.remove(hymn.id);
    _recentHymnIds.insert(0, hymn.id);
    if (_recentHymnIds.length > _kRecentHymnsMax) {
      _recentHymnIds = _recentHymnIds.take(_kRecentHymnsMax).toList();
    }
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_kRecentHymnIdsKey, jsonEncode(_recentHymnIds));
    } catch (e) {
      debugPrint('HymnState.addToRecentHymns error: $e');
    }
  }

  /// Atualiza o tamanho da fonte das letras e persiste (SharedPreferences). Vale para todos os hinos.
  Future<void> setLyricsFontSize(double size) async {
    final clamped = size.clamp(kLyricsFontSizeMin, kLyricsFontSizeMax);
    if (_lyricsFontSize == clamped) return;
    _lyricsFontSize = clamped;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setDouble(_kLyricsFontSizeKey, _lyricsFontSize);
    } catch (e) {
      debugPrint('HymnState.setLyricsFontSize error: $e');
    }
  }
}

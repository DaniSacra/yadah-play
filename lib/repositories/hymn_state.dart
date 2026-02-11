import 'package:flutter/foundation.dart';

import '../models/hymn.dart';
import 'hymn_repository.dart';

/// Estado da lista de hinos: loading, sucesso ou erro.
enum HymnListStatus { initial, loading, success, error }

/// [ChangeNotifier] que mantém a lista de hinos e o estado de carregamento.
class HymnState extends ChangeNotifier {
  final HymnRepository _repository = HymnRepository();

  HymnListStatus _status = HymnListStatus.initial;
  List<Hymn> _hymns = [];
  String? _errorMessage;

  HymnListStatus get status => _status;
  List<Hymn> get hymns => List.unmodifiable(_hymns);
  String? get errorMessage => _errorMessage;

  /// Filtra hinos por número ou título (case-insensitive).
  List<Hymn> filterByQuery(String query) {
    if (query.trim().isEmpty) return _hymns;
    final q = query.trim().toLowerCase();
    return _hymns.where((h) {
      return h.number.toString().contains(q) || h.title.toLowerCase().contains(q);
    }).toList();
  }

  /// Carrega os hinos do JSON. Notifica listeners ao terminar.
  Future<void> loadHymns() async {
    _status = HymnListStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _hymns = await _repository.loadHymns();
      _status = HymnListStatus.success;
    } catch (e, st) {
      _status = HymnListStatus.error;
      _errorMessage = e.toString();
      debugPrint('HymnState.loadHymns error: $e\n$st');
    }
    notifyListeners();
  }
}

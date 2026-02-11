import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/hymn.dart';

/// Carrega a lista de hinos do asset JSON.
class HymnRepository {
  static const String _assetPath = 'assets/data/hymns.json';

  /// Carrega todos os hinos do arquivo JSON.
  /// Lança [Exception] se o arquivo não existir ou o JSON for inválido.
  Future<List<Hymn>> loadHymns() async {
    final String jsonString = await rootBundle.loadString(_assetPath);
    final List<dynamic> list = jsonDecode(jsonString) as List<dynamic>;
    return list.map((e) => Hymn.fromJson(e as Map<String, dynamic>)).toList();
  }
}

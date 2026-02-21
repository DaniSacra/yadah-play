import 'package:yadah_play/models/hymn.dart';
import 'package:yadah_play/repositories/hymn_repository.dart';

/// Hinos de exemplo para testes (DRY).
const sampleHymns = [
  Hymn(id: '1', number: 1, title: 'Noite de Paz', lyrics: 'Noite de paz'),
  Hymn(id: '2', number: 45, title: 'Castelo Forte', lyrics: 'Castelo forte'),
  Hymn(id: '3', number: 114, title: 'Tu És Fiel', lyrics: 'Tu és fiel Senhor'),
];

/// Repositório fake que retorna uma lista fixa para testes.
class FakeHymnRepository extends HymnRepository {
  final List<Hymn> hymns;

  FakeHymnRepository(this.hymns);

  @override
  Future<List<Hymn>> loadHymns() async => hymns;
}

/// Repositório que falha ao carregar (para testes de erro).
class FailingHymnRepository extends HymnRepository {
  @override
  Future<List<Hymn>> loadHymns() async => throw Exception('Falha ao carregar');
}

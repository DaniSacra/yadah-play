import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yadah_play/models/hymn.dart';
import 'package:yadah_play/repositories/hymn_repository.dart';
import 'package:yadah_play/repositories/hymn_state.dart';

/// Repositório fake que retorna uma lista fixa para testes.
class FakeHymnRepository extends HymnRepository {
  final List<Hymn> hymns;

  FakeHymnRepository(this.hymns);

  @override
  Future<List<Hymn>> loadHymns() async => hymns;
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  final sampleHymns = [
    const Hymn(id: '1', number: 1, title: 'Noite de Paz', lyrics: 'Noite de paz'),
    const Hymn(id: '2', number: 45, title: 'Castelo Forte', lyrics: 'Castelo forte'),
    const Hymn(id: '3', number: 114, title: 'Tu És Fiel', lyrics: 'Tu és fiel Senhor'),
  ];

  group('HymnState', () {
    test('filterByQuery vazio retorna todos os hinos', () async {
      final state = HymnState(repository: FakeHymnRepository(sampleHymns));
      await state.loadHymns();
      expect(state.filterByQuery(''), sampleHymns);
      expect(state.filterByQuery('   '), sampleHymns);
    });

    test('filterByQuery por título (case insensitive)', () async {
      final state = HymnState(repository: FakeHymnRepository(sampleHymns));
      await state.loadHymns();
      expect(state.filterByQuery('noite').length, 1);
      expect(state.filterByQuery('noite').first.title, 'Noite de Paz');
      expect(state.filterByQuery('CASTELO').length, 1);
      expect(state.filterByQuery('fiel').length, 1);
    });

    test('filterByQuery por número', () async {
      final state = HymnState(repository: FakeHymnRepository(sampleHymns));
      await state.loadHymns();
      expect(state.filterByQuery('1').length, 2); // 1 e 114 contêm "1"
      expect(state.filterByQuery('45').length, 1);
      expect(state.filterByQuery('45').first.number, 45);
      expect(state.filterByQuery('114').length, 1);
    });

    test('filterByQuery com includeLyrics busca na letra', () async {
      final state = HymnState(repository: FakeHymnRepository(sampleHymns));
      await state.loadHymns();
      expect(state.filterByQuery('Senhor', includeLyrics: false).length, 0);
      expect(state.filterByQuery('Senhor', includeLyrics: true).length, 1);
      expect(state.filterByQuery('senhor', includeLyrics: true).length, 1);
      expect(state.filterByQuery('paz', includeLyrics: true).length, 1);
    });

    test('filterByQuery sem match retorna lista vazia', () async {
      final state = HymnState(repository: FakeHymnRepository(sampleHymns));
      await state.loadHymns();
      expect(state.filterByQuery('xyz'), isEmpty);
    });
  });
}

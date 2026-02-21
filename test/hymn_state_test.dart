import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yadah_play/models/hymn.dart';
import 'package:yadah_play/repositories/hymn_repository.dart';
import 'package:yadah_play/repositories/hymn_state.dart';

import 'helpers.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  HymnState createState({HymnRepository? repository, List<Hymn>? hymns}) {
    return HymnState(
      repository: repository ?? FakeHymnRepository(hymns ?? sampleHymns),
    );
  }

  group('HymnState', () {
    test('filterByQuery vazio retorna todos os hinos', () async {
      final state = createState();
      await state.loadHymns();
      expect(state.filterByQuery(''), sampleHymns);
      expect(state.filterByQuery('   '), sampleHymns);
    });

    test('filterByQuery por título (case insensitive)', () async {
      final state = createState();
      await state.loadHymns();
      expect(state.filterByQuery('noite').length, 1);
      expect(state.filterByQuery('noite').first.title, 'Noite de Paz');
      expect(state.filterByQuery('CASTELO').length, 1);
      expect(state.filterByQuery('fiel').length, 1);
    });

    test('filterByQuery por número', () async {
      final state = createState();
      await state.loadHymns();
      expect(state.filterByQuery('1').length, 2); // 1 e 114 contêm "1"
      expect(state.filterByQuery('45').length, 1);
      expect(state.filterByQuery('45').first.number, 45);
      expect(state.filterByQuery('114').length, 1);
    });

    test('filterByQuery com includeLyrics busca na letra', () async {
      final state = createState();
      await state.loadHymns();
      expect(state.filterByQuery('Senhor', includeLyrics: false).length, 0);
      expect(state.filterByQuery('Senhor', includeLyrics: true).length, 1);
      expect(state.filterByQuery('senhor', includeLyrics: true).length, 1);
      expect(state.filterByQuery('paz', includeLyrics: true).length, 1);
    });

    test('filterByQuery sem match retorna lista vazia', () async {
      final state = createState();
      await state.loadHymns();
      expect(state.filterByQuery('xyz'), isEmpty);
    });

    group('loadHymns', () {
      test('sucesso: status success e carrega hinos', () async {
        final state = createState();
        await state.loadHymns();
        expect(state.status, HymnListStatus.success);
        expect(state.hymns, sampleHymns);
      });

      test('carrega lyricsFontSize do SharedPreferences', () async {
        SharedPreferences.setMockInitialValues({'lyrics_font_size': 22.0});
        final state = createState();
        await state.loadHymns();
        expect(state.lyricsFontSize, 22);
      });

      test('carrega recentHymnIds do SharedPreferences', () async {
        SharedPreferences.setMockInitialValues({
          'recent_hymn_ids': '["2","1","3"]',
        });
        final state = createState();
        await state.loadHymns();
        expect(state.recentHymns.map((h) => h.id).toList(), ['2', '1', '3']);
      });

      test('erro no repositório: status error e errorMessage', () async {
        final state = HymnState(repository: FailingHymnRepository());
        await state.loadHymns();
        expect(state.status, HymnListStatus.error);
        expect(state.errorMessage, isNotNull);
        expect(state.hymns, isEmpty);
      });
    });

    group('setLyricsFontSize', () {
      test('atualiza valor e persiste', () async {
        final state = createState();
        await state.loadHymns();
        await state.setLyricsFontSize(20);
        expect(state.lyricsFontSize, 20);

        final state2 = createState();
        await state2.loadHymns();
        expect(state2.lyricsFontSize, 20);
      });

      test('rejeita valor fora do intervalo', () async {
        final state = createState();
        await state.loadHymns();
        await state.setLyricsFontSize(10);
        expect(state.lyricsFontSize, 14);
        await state.setLyricsFontSize(40);
        expect(state.lyricsFontSize, 28);
      });
    });

    group('addToRecentHymns / recentHymns', () {
      test('adiciona ao início e deduplica', () async {
        final state = createState();
        await state.loadHymns();
        await state.addToRecentHymns(sampleHymns[0]);
        await state.addToRecentHymns(sampleHymns[1]);
        await state.addToRecentHymns(sampleHymns[0]);
        expect(state.recentHymns.map((h) => h.id).toList(), ['1', '2']);
      });

      test('limita a 20 e persiste', () async {
        final many = List.generate(25, (i) => Hymn(id: '$i', number: i, title: 'Hino $i', lyrics: ''));
        final state = HymnState(repository: FakeHymnRepository(many));
        await state.loadHymns();
        for (var i = 0; i < 25; i++) {
          await state.addToRecentHymns(many[i]);
        }
        expect(state.recentHymns.length, 20);
        expect(state.recentHymns.first.id, '24');

        final state2 = HymnState(repository: FakeHymnRepository(many));
        await state2.loadHymns();
        expect(state2.recentHymns.length, 20);
      });

      test('recentHymns exclui ids que não estão em hymns', () async {
        SharedPreferences.setMockInitialValues({'recent_hymn_ids': '["99","1","2"]'});
        final state = createState();
        await state.loadHymns();
        expect(state.recentHymns.map((h) => h.id).toList(), ['1', '2']);
      });
    });
  });
}

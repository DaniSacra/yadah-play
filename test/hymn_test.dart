import 'package:flutter_test/flutter_test.dart';
import 'package:yadah_play/models/hymn.dart';

void main() {
  group('Hymn', () {
    test('fromJson cria modelo com todos os campos', () {
      final json = {
        'id': '1',
        'number': 1,
        'title': 'Estamos aqui',
        'lyrics': 'Estamos aqui pra Te adorar.',
      };
      final hymn = Hymn.fromJson(json);

      expect(hymn.id, '1');
      expect(hymn.number, 1);
      expect(hymn.title, 'Estamos aqui');
      expect(hymn.lyrics, 'Estamos aqui pra Te adorar.');
    });

    test('fromJson aceita number como string e converte para int', () {
      final hymn = Hymn.fromJson({
        'id': '2',
        'number': '2',
        'title': 'Título',
        'lyrics': 'Letra',
      });
      expect(hymn.number, 2);
    });

    test('fromJson usa string vazia para title/lyrics quando null', () {
      final hymn = Hymn.fromJson({
        'id': '3',
        'number': 3,
        'title': null,
        'lyrics': null,
      });
      expect(hymn.title, '');
      expect(hymn.lyrics, '');
    });

    test('toJson retorna mapa com os mesmos dados', () {
      const hymn = Hymn(
        id: '10',
        number: 10,
        title: 'Meu hino',
        lyrics: 'Letra do hino',
      );
      final json = hymn.toJson();

      expect(json['id'], '10');
      expect(json['number'], 10);
      expect(json['title'], 'Meu hino');
      expect(json['lyrics'], 'Letra do hino');
    });
  });
}

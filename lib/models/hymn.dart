/// Remove marcas invisíveis de direção e espaços no início/fim de cada linha.
String normalizeHymnLyrics(String lyrics) {
  const marks = [
    '\u200e', '\u200f', '\u202a', '\u202b', '\u202c', '\u202d', '\u202e', '\ufeff',
  ];
  var text = lyrics;
  for (final mark in marks) {
    text = text.replaceAll(mark, '');
  }
  return text.split('\n').map((line) => line.trim()).join('\n');
}

/// Modelo de um hino do hinário.
class Hymn {
  final String id;
  final int number;
  final String title;
  final String lyrics;

  const Hymn({
    required this.id,
    required this.number,
    required this.title,
    required this.lyrics,
  });

  /// Letra formatada para exibição (sem espaços/marcas que deslocam o texto).
  String get displayLyrics => normalizeHymnLyrics(lyrics);

  factory Hymn.fromJson(Map<String, dynamic> json) {
    return Hymn(
      id: json['id'] as String,
      number: (json['number'] is int) ? json['number'] as int : int.tryParse(json['number'].toString()) ?? 0,
      title: json['title'] as String? ?? '',
      lyrics: json['lyrics'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'number': number,
        'title': title,
        'lyrics': lyrics,
      };
}

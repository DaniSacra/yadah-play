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

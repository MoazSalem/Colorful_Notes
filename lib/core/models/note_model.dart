class Note {
  final String id;
  final String title;
  final String content;
  final String time;
  final int type;
  final int cIndex;
  final int tIndex;
  final int layout;
  final String extra;
  final String edited;
  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.time,
    required this.type,
    required this.cIndex,
    required this.tIndex,
    required this.layout,
    required this.extra,
    required this.edited,
  });

  Note.fromMap(Map<String, dynamic> map)
    : id = map['id'].toString(),
      title = map['title'].toString(),
      content = map['content'].toString(),
      time = map['time'].toString(),
      type = map['type'],
      cIndex = map['cindex'],
      tIndex = map['tindex'],
      layout = map['layout'],
      extra = map['extra'].toString(),
      edited = map['edited'].toString();

  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? time,
    int? type,
    int? cIndex,
    int? tIndex,
    int? layout,
    String? extra,
    String? edited,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      time: time ?? this.time,
      type: type ?? this.type,
      cIndex: cIndex ?? this.cIndex,
      tIndex: tIndex ?? this.tIndex,
      layout: layout ?? this.layout,
      extra: extra ?? this.extra,
      edited: edited ?? this.edited,
    );
  }
}

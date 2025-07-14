import 'package:colorful_notes/features/notes/domain/entities/note.dart';

class NoteModel {
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

  const NoteModel({
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

  /// Convert DB Map to Model
  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'].toString(),
      title: map['title'].toString(),
      content: map['content'].toString(),
      time: map['time'].toString(),
      type: map['type'],
      cIndex: map['cindex'],
      tIndex: map['tindex'],
      layout: map['layout'],
      extra: map['extra'].toString(),
      edited: map['edited'].toString(),
    );
  }

  /// Convert Model to Map for DB
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'time': time,
      'type': type,
      'cindex': cIndex,
      'tindex': tIndex,
      'layout': layout,
      'extra': extra,
      'edited': edited,
    };
  }

  /// Convert to Domain Entity
  Note toEntity() {
    return Note(
      id: id,
      title: title,
      content: content,
      time: time,
      type: type,
      cIndex: cIndex,
      tIndex: tIndex,
      layout: layout,
      extra: extra,
      edited: edited,
    );
  }

  /// Create Model from Entity
  factory NoteModel.fromEntity(Note note) {
    return NoteModel(
      id: note.id,
      title: note.title,
      content: note.content,
      time: note.time,
      type: note.type,
      cIndex: note.cIndex,
      tIndex: note.tIndex,
      layout: note.layout,
      extra: note.extra,
      edited: note.edited,
    );
  }
}

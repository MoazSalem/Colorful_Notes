import 'package:colorful_notes/core/models/note_model.dart';
import 'package:sqflite/sqflite.dart';

class NotesDatabase {
  late Database database;

  Future<void> startDatabase() async {
    database = await openDatabase(
      'notes.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE Notes (
            id INTEGER PRIMARY KEY,
            title TEXT,
            content TEXT,
            time TEXT,
            cindex INTEGER,
            tindex INTEGER,
            type INTEGER,
            edited TEXT,
            layout INTEGER,
            extra TEXT
          )
          ''');
      },
    );
  }

  Future<List<Note>> getAllNotes() async {
    final List<Map<String, Object?>> notes = await database.query('Notes');
    final List<Note> noteList = [];
    for (var element in notes) {
      noteList.add(Note.fromMap(element));
    }
    return noteList;
  }

  Future<void> insertToDatabase({required Note note}) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
            'INSERT INTO Notes(title, content, cindex, tindex, type, time, edited ,layout, extra) VALUES("${note.title}", "${note.content}", "${note.cIndex}", "${note.tIndex}", "${note.type}","${note.time}","${note.edited}","${note.layout}","${note.extra}")',
          )
          .then((value) {});
    });
  }

  Future<void> editDatabaseItem({required Note note}) async {
    await database.rawUpdate(
      'UPDATE Notes SET title = ?, content = ?, time = ?, cindex = ?, tindex = ?, type = ?, edited = ?, layout = ?, extra = ? WHERE id = ?',
      [
        note.title,
        note.content,
        note.time,
        note.cIndex,
        note.tIndex,
        note.type,
        note.edited,
        note.layout,
        note.extra,
        note.id,
      ],
    );
  }

  Future<void> deleteFromDatabase({required int id}) async {
    int count = await database.rawDelete('DELETE FROM Notes WHERE id = ?', [
      '$id',
    ]);
    assert(count == 1);
  }

  Future<void> destroyDatabase() async {
    await deleteDatabase('notes.db');
  }
}

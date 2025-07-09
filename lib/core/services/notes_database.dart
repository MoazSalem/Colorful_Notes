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

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    return await database.query('Notes');
  }

  Future<void> destroyDatabase() async {
    await deleteDatabase('notes.db');
  }

  Future<void> insertToDatabase({
    required String title,
    required String content,
    required int index,
    required String time,
    required int layout,
    required tIndex,
    required String extra,
    int? type = 0,
    String? edited = 'no',
  }) async {
    await database.transaction((txn) async {
      txn
          .rawInsert(
            'INSERT INTO Notes(title, content, cindex, tindex, type, time, edited ,layout, extra) VALUES("$title", "$content", "$index", "$tIndex", "$type","$time","$edited","$layout","$extra")',
          )
          .then((value) {});
    });
  }

  Future<void> editDatabaseItem({
    required int id,
    required String content,
    required String time,
    required int index,
    required int type,
    required String title,
    required int layout,
    required int tIndex,
    required String extra,
    String? edited = 'yes',
  }) async {
    await database.rawUpdate(
      'UPDATE Notes SET title = ?, content = ?, time = ?, cindex = ?, tindex = ?, type = ?, edited = ?, layout = ?, extra = ? WHERE id = ?',
      [title, content, time, index, tIndex, type, edited, layout, extra, id],
    );
  }

  Future<void> deleteFromDatabase({required int id}) async {
    int count = await database.rawDelete('DELETE FROM Notes WHERE id = ?', [
      '$id',
    ]);
    assert(count == 1);
  }
}

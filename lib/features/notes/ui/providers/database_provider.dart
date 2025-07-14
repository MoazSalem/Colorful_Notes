import 'package:colorful_notes/features/notes/data/datasources/notes_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final databaseProvider = FutureProvider<NotesDatabase>((ref) async {
  final db = NotesDatabase();
  await db.startDatabase();
  return db;
});

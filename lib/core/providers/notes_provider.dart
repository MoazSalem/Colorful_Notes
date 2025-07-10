import 'package:colorful_notes/core/models/note_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_provider.dart';

final notesProvider = FutureProvider<List<Note>>((ref) async {
  final database = ref.watch(databaseProvider).value!;
  return database.getAllNotes();
});

import 'package:colorful_notes/features/notes/domain/entities/note.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:colorful_notes/features/notes/ui/providers/database_provider.dart';

final notesProvider = FutureProvider<List<Note>>((ref) async {
  final database = ref.watch(databaseProvider).value!;
  return database.getAllNotes();
});

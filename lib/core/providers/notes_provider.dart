import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'database_provider.dart';

final notesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final database = ref.watch(databaseProvider).value!;
  return database.getAllNotes();
});

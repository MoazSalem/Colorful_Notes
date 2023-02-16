part of 'notes_bloc.dart';

@immutable
abstract class NotesState {}

class NotesInitial extends NotesState {}

class AppInitial extends NotesState {}

class NavigationBarChanged extends NotesState {}

class NoteCreate extends NotesState {}

class PrefsChanged extends NotesState {}

class OnSearched extends NotesState {}

class ViewChanged extends NotesState {}

class ColorsChanged extends NotesState {}

class AudioPlayed extends NotesState {}

class OnDurationChanged extends NotesState {}

class OnPositionChanged extends NotesState {}

class OnRecord extends NotesState {}

class OnChanged extends NotesState {}

class OnDelete extends NotesState {}

class ColorsHarmonized extends NotesState {}

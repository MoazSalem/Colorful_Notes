import 'package:colorful_notes/features/home/ui/home.dart';
import 'package:colorful_notes/features/home/ui/notes.dart';
import 'package:colorful_notes/features/home/ui/voice.dart';
import 'package:colorful_notes/features/settings/ui/settings.dart';
import 'package:colorful_notes/features/about/ui/info.dart';
import 'package:flutter/material.dart';

class AppConsts {
  static const List<Widget> pagesList = [
    HomePage(),
    NotesPage(),
    VoiceNotesPage(),
    SettingsPage(),
    InfoPage(),
  ];
}

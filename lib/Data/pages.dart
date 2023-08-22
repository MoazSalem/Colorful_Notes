import 'package:flutter/material.dart';
import 'package:notes/Screens/SideBar/home.dart';
import 'package:notes/Screens/SideBar/info.dart';
import 'package:notes/Screens/SideBar/notes.dart';
import 'package:notes/Screens/SideBar/settings.dart';
import 'package:notes/Screens/SideBar/voice.dart';

List<Builder> getPages(B) {
  return [
    Builder(
      builder: (context) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: B.isTablet ? 1.5 : 1.0),
            child: const HomePage());
      },
    ),
    Builder(
      builder: (context) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: B.isTablet ? 1.5 : 1.0),
            child: const NotesPage());
      },
    ),
    Builder(
      builder: (context) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: B.isTablet ? 1.5 : 1.0),
            child: const VoiceNotesPage());
      },
    ),
    Builder(
      builder: (context) {
        return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaleFactor: B.isTablet ? 1.5 : 1.0), //child: ColorsTest(),);
            child: const SettingsPage());
      },
    ),
    Builder(
      builder: (context) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: B.isTablet ? 1.5 : 1.0),
            child: const InfoPage());
      },
    ),
  ];
}

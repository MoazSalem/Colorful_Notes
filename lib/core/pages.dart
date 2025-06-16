import 'package:flutter/material.dart';
import 'package:colorful_notes/features/home/ui/home.dart';
import 'package:colorful_notes/features/about/ui/info.dart';
import 'package:colorful_notes/features/home/ui/notes.dart';
import 'package:colorful_notes/features/settings/ui/settings.dart';
import 'package:colorful_notes/features/home/ui/voice.dart';

List<Builder> getPages(B) {
  return [
    Builder(
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(B.isTablet ? 1.5 : 1.0)),
          child: const HomePage(),
        );
      },
    ),
    Builder(
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(B.isTablet ? 1.5 : 1.0)),
          child: const NotesPage(),
        );
      },
    ),
    Builder(
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(B.isTablet ? 1.5 : 1.0)),
          child: const VoiceNotesPage(),
        );
      },
    ),
    Builder(
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(B.isTablet ? 1.5 : 1.0),
          ), //child: ColorsTest(),);
          child: const SettingsPage(),
        );
      },
    ),
    Builder(
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(B.isTablet ? 1.5 : 1.0)),
          child: const InfoPage(),
        );
      },
    ),
  ];
}

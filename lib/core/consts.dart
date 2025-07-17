import 'package:colorful_notes/features/notes/ui/screens/notes_list.dart';
import 'package:colorful_notes/features/settings/ui/settings.dart';
import 'package:flutter/material.dart';

class AppConsts {
  static const String gitHubLink =
      'https://github.com/MoazSalem/Colorful_Notes';
  static const List<Widget> pagesList = [
    NotesList(typeIndex: 0),
    NotesList(typeIndex: 1),
    NotesList(typeIndex: 2),
    SettingsPage(),
  ];

  static List<Color> lightColors = [
    const Color(0xffffc107),
    const Color(0xfff77b85),
    const Color(0xffff8b34),
    const Color(0xff66c6c2),
    const Color(0xfff169a7),
    const Color(0xffd09ce6),
    const Color(0xffc4e228),
    const Color(0xffe8ea25),
    const Color(0xff78c8ed),
    const Color(0xfff6b280),
  ];

  static List<Color> darkerColors = [
    const Color(0xffcc9a05),
    const Color(0xffc36169),
    const Color(0xffcc6f29),
    const Color(0xff4b9390),
    const Color(0xffbe5283),
    const Color(0xffa179b3),
    const Color(0xff97af1e),
    const Color(0xffb5b61c),
    const Color(0xff5e9cba),
    const Color(0xffc38d65),
  ];
}

import 'package:flutter/material.dart';

ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColorDark: const Color(0xfff2f2f2),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.amber).copyWith(secondary: Colors.amber),
    backgroundColor: Colors.white);

ThemeData normalDark = ThemeData(brightness: Brightness.dark, primarySwatch: Colors.amber, primaryColorDark: const Color(0xFF424242), accentColor: Colors.amber, backgroundColor: const Color(0xFF424242));

ThemeData amoled = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.amber,
    primaryColorDark: const Color(0xFF424242),
    accentColor: Colors.amber,
    canvasColor: Colors.black,
    backgroundColor: Colors.black,
    cardColor: const Color(0xFF1b1b1b));

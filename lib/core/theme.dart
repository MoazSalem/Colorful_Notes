import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.amber,
    brightness: Brightness.light,
    primary: Colors.amber,
    surface: const Color(0xfffafafa),
    onSurface: Colors.black,
    onSurfaceVariant: Colors.black,
    primaryContainer: Colors.white,
    onPrimaryContainer: Colors.black,
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.amber,
    brightness: Brightness.dark,
    primary: Colors.amber,
    surface: const Color(0xff000000),
    onSurface: Colors.white,
    onSurfaceVariant: Colors.white,
    primaryContainer: const Color(0xff262626),
    onPrimaryContainer: Colors.white,
  ),
);

ThemeData amoled = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  primaryColorDark: const Color(0xFF424242),
  //accentColor: Colors.amber,
  canvasColor: Colors.black,
  cardColor: const Color(0xFF1b1b1b),
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: Colors.amber,
  ).copyWith(surface: Colors.black),
);

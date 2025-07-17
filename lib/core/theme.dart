import 'package:flutter/material.dart';

class AppTheme {
  static late ThemeData light;
  static late ThemeData dark;
  static final lightThemes = _themesLight;
  static final darkThemes = _themesDark;
}

final List<ThemeData> _themesLight = [
  ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: Colors.amber,
      primary: Colors.amber,
      surface: const Color(0xfffafafa),
      onSurface: Colors.black,
      onSurfaceVariant: Colors.black,
      surfaceContainerHigh: Colors.white,
    ),
  ),
  ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: Colors.blue,
    ),
  ),
  ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: Colors.green,
    ),
  ),
  ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: Colors.red,
    ),
  ),
  ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: Colors.yellow,
    ),
  ),
];

final List<ThemeData> _themesDark = [
  ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: Colors.amber,
      primary: Colors.amber,
      surface: const Color(0xff000000),
      onSurface: Colors.white,
      onSurfaceVariant: Colors.white,
      surfaceContainerHigh: const Color(0xff262626),
    ),
  ),
  ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: Colors.blue,
    ),
  ),
  ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: Colors.green,
    ),
  ),
  ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: Colors.red,
    ),
  ),
  ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: Colors.yellow,
    ),
  ),
];

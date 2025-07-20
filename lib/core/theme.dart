import 'package:flutter/material.dart';

class AppTheme {
  static late ThemeData light;
  static late ThemeData dark;
  static final lightThemes = _themesLight;
  static final darkThemes = _themesDark;
  static final themeColors = _themeColors;
}

final _themeEntries = _themeColors.entries.toList();

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
  ...List.generate(
    _themeEntries.length - 1,
    (index) => ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.light,
        seedColor: _themeEntries[index + 1].value,
      ),
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

  ...List.generate(
    _themeEntries.length - 1,
    (index) => ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: _themeEntries[index + 1].value,
      ),
    ),
  ),
];

final Map<String, Color> _themeColors = {
  'colorful': Color(0xFFFFFFFF),
  'amber': Color(0xFFFFC107),
  'aquaBlue': Color(0xFF00BCD4),
  'bahamaBlue': Color(0xFF005C99),
  'barossa': Color(0xFF44012B),
  'bigStone': Color(0xFF162955),
  'blackWhite': Color(0xFF9E9E9E),
  'blue': Color(0xFF2196F3),
  'blueM3': Color(0xFF2563EB),
  'blueWhale': Color(0xFF042A2B),
  'blumineBlue': Color(0xFF18587A),
  'brandBlue': Color(0xFF0057B8),
  'cyanM3': Color(0xFF00B7C3),
  'damask': Color(0xFFDA614E),
  'deepBlue': Color(0xFF001F3F),
  'deepOrangeM3': Color(0xFFFF5722),
  'deepPurple': Color(0xFF673AB7),
  'dellGenoa': Color(0xFF476A34),
  'ebonyClay': Color(0xFF22313F),
  'espresso': Color(0xFF4B3832),
  'flutterDash': Color(0xFF02569B),
  'gold': Color(0xFFFFD700),
  'green': Color(0xFF4CAF50),
  'greenM3': Color(0xFF52B788),
  'greyLaw': Color(0xFF607D8B),
  'greys': Color(0xFFBDBDBD),
  'hippieBlue': Color(0xFF5893D4),
  'indigo': Color(0xFF3F51B5),
  'indigoM3': Color(0xFF5D5FEF),
  'jungle': Color(0xFF1B5E20),
  'limeM3': Color(0xFFD0F205),
  'mallardGreen': Color(0xFF3A5F0B),
  'mandyRed': Color(0xFFE25454),
  'mango': Color(0xFFFFB74D),
  'materialBaseline': Color(0xFF6750A4),
  'money': Color(0xFF2E7D32),
  'orangeM3': Color(0xFFFF8C00),
  'outerSpace': Color(0xFF2D383A),
  'pinkM3': Color(0xFFFFB1C1),
  'purpleBrown': Color(0xFF5D3A3A),
  'purpleM3': Color(0xFF7D5260),
  'red': Color(0xFFF44336),
  'redM3': Color(0xFFB3261E),
  'redWine': Color(0xFF722F37),
  'rosewood': Color(0xFF65000B),
  'sakura': Color(0xFFFCC9B9),
  'sanJuanBlue': Color(0xFF304B6A),
  'sepia': Color(0xFF704214),
  'shadBlue': Color(0xFF1E40AF),
  'shadGray': Color(0xFF6B7280),
  'shadGreen': Color(0xFF15803D),
  'shadNeutral': Color(0xFF737373),
  'shadOrange': Color(0xFFEA580C),
  'shadRed': Color(0xFFDC2626),
  'shadRose': Color(0xFFE11D48),
  'shadSlate': Color(0xFF334155),
  'shadStone': Color(0xFF78716C),
  'shadViolet': Color(0xFF7C3AED),
  'shadYellow': Color(0xFFCA8A04),
  'shadZinc': Color(0xFF52525B),
  'shark': Color(0xFF1F1F1F),
  'tealM3': Color(0xFF018786),
  'verdunHemlock': Color(0xFF556B2F),
  'vesuviusBurn': Color(0xFFDD6E42),
  'wasabi': Color(0xFFA4C639),
  'yellowM3': Color(0xFFFFD500),
};

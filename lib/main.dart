import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/Data/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/home_screen.dart';
import 'Screens/on_boarding.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
      statusBarBrightness: Brightness.light, // For iOS (dark icons)
    ),
  );
  final prefs = await SharedPreferences.getInstance();
  final bool showHome = prefs.getBool('showHome') ?? false;
  final bool isBlack = prefs.getBool('isBlack') ?? false;
  runApp(EasyLocalization(
      useOnlyLangCode: true,
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MyApp(
        showHome: showHome,
        isBlack: isBlack,
      )));
}

class MyApp extends StatelessWidget {
  final bool showHome;
  final bool isBlack;

  const MyApp({Key? key, required this.showHome, required this.isBlack}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
      return MaterialApp(
          initialRoute: '/',
          debugShowCheckedModeBanner: false,
          title: 'Colorful Notes',
          theme: ThemeData(
            colorScheme: lightColorScheme ?? defaultLightColorScheme,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme ?? defaultDarkColorScheme,
            useMaterial3: true,
          ),
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: showHome ? const Home() : const IntroPage());
    });
  }
}

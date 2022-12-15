import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

//import 'package:huawei_ml_text/huawei_ml_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/home_screen.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'Screens/on_boarding.dart';
import 'Data/theme.dart';
import 'package:easy_localization/easy_localization.dart';
//import 'Private/api_key.properties';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  MobileAds.instance.initialize();
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
  // MLTextApplication app = MLTextApplication();
  // app.setApiKey(apikey);
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: light,
      dark: isBlack ? amoled : normalDark,
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
          initialRoute: '/',
          debugShowCheckedModeBanner: false,
          title: 'Colorful Notes',
          theme: theme,
          darkTheme: darkTheme,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: showHome ? const Home() : const IntroPage()),
    );
  }
}

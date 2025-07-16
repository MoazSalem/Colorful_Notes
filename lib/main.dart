import 'package:colorful_notes/core/services/service_locator.dart';
import 'package:colorful_notes/features/notes/ui/screens/main_screen.dart.';
import 'package:colorful_notes/features/onboarding/ui/onboarding_view.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the Localization services.
  await EasyLocalization.ensureInitialized();
  // Initialize the Hive services.
  await Hive.initFlutter();
  // Initialize get it.
  await setupServiceLocator();
  runApp(
    ProviderScope(
      child: EasyLocalization(
        useOnlyLangCode: true,
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Brightness oppositeBrightness =
        MediaQuery.of(context).platformBrightness == Brightness.dark
        ? Brightness.light
        : Brightness.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: oppositeBrightness,
        statusBarIconBrightness: oppositeBrightness,
      ),
      child: MaterialApp(
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(start: 0, end: 600),
            const Breakpoint(start: 600, end: 800),
            const Breakpoint(start: 800, end: 1000),
            const Breakpoint(start: 1000, end: 1200),
          ],
        ),
        theme: ThemeData(),
        darkTheme: ThemeData.dark(),
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        title: 'Colorful Notes',
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        // Skip on boarding screen if not first time
        home: serviceLocator<Box>().get('showHome') ?? false
            ? const MainScreen()
            : const IntroPage(),
      ),
    );
  }
}

import 'package:colorful_notes/features/notes/ui/screens/main_screen.dart.';
import 'package:colorful_notes/features/onboarding/ui/onboarding_view.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:home_widget/home_widget.dart';
import 'package:workmanager/workmanager.dart';
import 'core/providers/settings_notifier.dart';
import 'core/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the Work manager services, this is for background process to allow for home screen widgets.
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  // Initialize the Localization services.
  await EasyLocalization.ensureInitialized();
  // Initialize the Hive services.
  await Hive.initFlutter();
  // Initialize get it.
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
      child: Consumer(
        builder: (context, ref, child) {
          final settings = ref.watch(settingsNotifierProvider);
          return settings.when(
            data: (settings) => MaterialApp(
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              initialRoute: '/',
              debugShowCheckedModeBanner: false,
              title: 'Colorful Notes',
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              // Skip on boarding screen if not first time
              home: settings.firstLaunch ? const IntroPage() : MainScreen(),
            ),
            error: (error, stackTrace) => const Text('Error'),
            loading: () => const CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

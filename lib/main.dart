import 'package:colorful_notes/core/di/dependency_injection.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:colorful_notes/old_logic/notes_cubit.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'features/home/ui/home_screen.dart';
import 'features/onboarding/ui/onboarding_view.dart';

late NotesCubit C;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the Localization services.
  await EasyLocalization.ensureInitialized();
  // Initialize the Hive services.
  await Hive.initFlutter();
  await setupGetIt();
  runApp(
    EasyLocalization(
      useOnlyLangCode: true,
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotesCubit(getIt<Box>())..startPage(),
      child: BlocConsumer<NotesCubit, NotesState>(
        listener: (context, state) {},
        builder: (context, state) {
          C = NotesCubit.get(context);
          return DynamicColorBuilder(
            builder: (lightColorScheme, darkColorScheme) {
              final isDarkMode =
                  MediaQuery.of(context).platformBrightness == Brightness.dark;
              final oppositeBrightness = isDarkMode
                  ? Brightness.light
                  : Brightness.dark;
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  systemNavigationBarColor: Colors.transparent,
                  systemNavigationBarIconBrightness: oppositeBrightness,
                  statusBarIconBrightness: oppositeBrightness,
                ),
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
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
                    initialRoute: '/',
                    debugShowCheckedModeBanner: false,
                    title: 'Colorful Notes',
                    localizationsDelegates: context.localizationDelegates,
                    supportedLocales: context.supportedLocales,
                    locale: context.locale,
                    // Skip on boarding screen if not first time
                    home: getIt<Box>().get('showHome') ?? false
                        ? const Home()
                        : const IntroPage(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

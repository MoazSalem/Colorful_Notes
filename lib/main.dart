import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/Cubit/notes_cubit.dart';
import 'package:notes/Data/theme.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:notes/Services/flex_colors/theme_controller.dart';
import 'package:notes/Services/flex_colors/theme_service.dart';
import 'package:notes/Services/flex_colors/theme_service_hive.dart';
import 'package:notes/Data/flex_themes.dart';
import 'Screens/home_screen.dart';
import 'Screens/on_boarding.dart';

late NotesCubit C;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the Localization services.
  await EasyLocalization.ensureInitialized();
  // Initialize the Hive services.
  await Hive.initFlutter();
  // open a named hive box to store settings
  Box box = await Hive.openBox("settingsBox");
  // open another box for themes
  final ThemeService themeService = ThemeServiceHive('flexColorsBox');
  // Initialize the theme service.
  await themeService.init();
  // Create a ThemeController that uses the ThemeService.
  final ThemeController themeController = ThemeController(themeService);
  // Load preferred theme settings, this prevents a theme change when the app is first displayed.
  await themeController.loadAll();
  // Skip Starting screen if not first time
  final bool showHome = box.get('showHome') ?? false;
  runApp(EasyLocalization(
      useOnlyLangCode: true,
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MyApp(
        themeController: themeController,
        showHome: showHome,
        box: box,
      )));
}

class MyApp extends StatelessWidget {
  final bool showHome;
  final Box box;
  final ThemeController themeController;

  const MyApp({Key? key, required this.showHome, required this.themeController, required this.box})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotesCubit(box)..startPage(),
      child: BlocConsumer<NotesCubit, NotesState>(
        listener: (context, state) {},
        builder: (context, state) {
          C = NotesCubit.get(context);
          C.themeController = themeController;
          return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
            return MaterialApp(
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
                theme: flexTheme(
                    mode: "light",
                    themeController: themeController,
                    dScheme: lightColorScheme ?? defaultLightColorScheme,
                    isDynamic: box.get("isDynamic") ?? false),
                darkTheme: flexTheme(
                  mode: "dark",
                  themeController: themeController,
                  dScheme: darkColorScheme ?? defaultDarkColorScheme,
                  isDynamic: box.get("isDynamic") ?? false,
                ),
                themeMode: themeController.themeMode,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                home: showHome ? const Home() : const IntroPage());
          });
        },
      ),
    );
  }
}

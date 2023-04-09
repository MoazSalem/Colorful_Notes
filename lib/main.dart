import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/Bloc/notes_bloc.dart';
import 'package:notes/Data/theme.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'Screens/home_screen.dart';
import 'Screens/on_boarding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter();
  Box box = await Hive.openBox("settingsBox");
  final bool showHome = box.get('showHome') ?? false;
  runApp(EasyLocalization(
      useOnlyLangCode: true,
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MyApp(
        showHome: showHome,
        box: box,
      )));
}

class MyApp extends StatelessWidget {
  final bool showHome;
  final Box box;

  const MyApp({Key? key, required this.showHome, required this.box}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotesBloc(gBox: box)..startPage(),
      child: BlocConsumer<NotesBloc, NotesState>(
        listener: (context, state) {},
        builder: (context, state) {
          var B = NotesBloc.get(context);
          return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
            return MaterialApp(
                builder: (context, child) => ResponsiveWrapper.builder(child,
                    maxWidth: 1200,
                    minWidth: 400,
                    defaultScale: true,
                    breakpoints: [
                      const ResponsiveBreakpoint.autoScale(600, scaleFactor: 0.9),
                      const ResponsiveBreakpoint.autoScale(800, scaleFactor: 1.0),
                      const ResponsiveBreakpoint.autoScale(1000, scaleFactor: 1.0),
                      const ResponsiveBreakpoint.autoScale(1200, scaleFactor: 1.0),
                    ],
                    background: Container(color: Colors.black)),
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
                themeMode: B.themeMode,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                home: showHome
                    ? Home(currentTheme: B.currentTheme)
                    : IntroPage(
                        currentTheme: B.currentTheme,
                        box: box,
                      ));
          });
        },
      ),
    );
  }
}

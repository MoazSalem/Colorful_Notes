import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:notes/Bloc/notes_bloc.dart';
import 'package:notes/Screens/SideBar/home.dart';
import 'package:notes/Screens/SideBar/info.dart';
import 'package:notes/Screens/SideBar/notes.dart';
import 'package:notes/Screens/SideBar/settings.dart';
import 'package:notes/Screens/SideBar/voice_notes.dart';
import 'package:notes/Widgets/sidebar.dart';

class Home extends StatefulWidget {
  final String currentTheme;

  const Home({Key? key, required this.currentTheme}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Brightness brightness;
  late bool isDarkMode;
  late ColorScheme theme;
  late NotesBloc B;
  late List<Widget> page;

  @override
  void initState() {
    brightness = SchedulerBinding.instance.window.platformBrightness;
    isDarkMode = brightness == Brightness.dark
        ? widget.currentTheme == "Light"
            ? false
            : true
        : widget.currentTheme == "Dark"
            ? true
            : false;
    B = NotesBloc.get(context);
    page = [
      Builder(
        builder: (context) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: B.isTablet ? 1.5 : 1.0),
              child: const HomePage());
        },
      ),
      Builder(
        builder: (context) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: B.isTablet ? 1.5 : 1.0),
              child: const NotesPage());
        },
      ),
      Builder(
        builder: (context) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: B.isTablet ? 1.5 : 1.0),
              child: const VoiceNotesPage());
        },
      ),
      Builder(
        builder: (context) {
          return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaleFactor: B.isTablet ? 1.5 : 1.0), //child: ColorsTest(),);
              child: const SettingsPage());
        },
      ),
      Builder(
        builder: (context) {
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: B.isTablet ? 1.5 : 1.0),
              child: const InfoPage());
        },
      ),
    ];
    super.initState();
  }

  @override
  void didChangeDependencies() {
    theme = Theme.of(context).colorScheme;
    B.theme = theme;
    B.lang = context.locale.toString();
    B.getScreenWidth(context);
    B.harmonizeColors();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
          // For Android (dark icons)
          statusBarBrightness: isDarkMode ? Brightness.light : Brightness.dark,
          // For iOS (dark icons)
          systemNavigationBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: theme.surfaceVariant,
        ),
        child: BlocConsumer<NotesBloc, NotesState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: B.loading
                  ? Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: isDarkMode ? theme.background : theme.surfaceVariant.withOpacity(0.6),
                      child: Center(
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: Lottie.asset(
                            'assets/animations/loading.json',
                          ),
                        ),
                      ),
                    )
                  : Row(
                      children: B.sbIndex == 2 || B.sbIndex == 3
                          ? [
                              Expanded(
                                flex: 5,
                                child: page[B.currentIndex],
                              ),
                              sideBar(
                                  theme: theme,
                                  inverted: B.sbIndex == 3 ? true : false,
                                  B: B,
                                  sizeBox: B.isTablet ? 60 : 30),
                            ]
                          : [
                              sideBar(
                                  theme: theme,
                                  inverted: B.sbIndex == 1 ? true : false,
                                  B: B,
                                  sizeBox: B.isTablet ? 60 : 30),
                              Expanded(
                                flex: 5,
                                child: page[B.currentIndex],
                              ),
                            ],
                    ),
            );
          },
        ));
  }
}

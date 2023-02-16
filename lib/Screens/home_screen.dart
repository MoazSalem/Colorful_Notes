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
import 'package:notes/Widgets/sideBar.dart';
//import 'package:notes/Test/colors.dart';

class Home extends StatelessWidget {
  final String currentTheme;

  const Home({Key? key, required this.currentTheme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark
        ? currentTheme == "Light"
            ? false
            : true
        : currentTheme == "Dark"
            ? true
            : false;
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
          // For Android (dark icons)
          statusBarBrightness: isDarkMode ? Brightness.light : Brightness.dark,
          // For iOS (dark icons)
          systemNavigationBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: Theme.of(context).colorScheme.surfaceVariant,
        ),
        child: BlocConsumer<NotesBloc, NotesState>(
          listener: (context, state) {},
          builder: (context, state) {
            var B = NotesBloc.get(context);
            B.lang = context.locale.toString();
            B.getScreenWidth(context);
            B.harmonizeColors(context);
            List<Widget> page = [
              Builder(
                builder: (context) {
                  return MediaQuery(
                      data:
                          MediaQuery.of(context).copyWith(textScaleFactor: B.isTablet ? 1.5 : 1.0),
                      child: const HomePage());
                },
              ),
              Builder(
                builder: (context) {
                  return MediaQuery(
                      data:
                          MediaQuery.of(context).copyWith(textScaleFactor: B.isTablet ? 1.5 : 1.0),
                      child: const NotesPage());
                },
              ),
              Builder(
                builder: (context) {
                  return MediaQuery(
                      data:
                          MediaQuery.of(context).copyWith(textScaleFactor: B.isTablet ? 1.5 : 1.0),
                      child: const VoiceNotesPage());
                },
              ),
              Builder(
                builder: (context) {
                  return MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                          textScaleFactor: B.isTablet ? 1.5 : 1.0), //child: ColorsTest(),);
                      child: const SettingsPage());
                },
              ),
              Builder(
                builder: (context) {
                  return MediaQuery(
                      data:
                          MediaQuery.of(context).copyWith(textScaleFactor: B.isTablet ? 1.5 : 1.0),
                      child: const InfoPage());
                },
              ),
            ];
            return Scaffold(
              resizeToAvoidBottomInset: false,
              key: B.scaffoldKey,
              body: B.loading
                  ? Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: isDarkMode
                          ? Theme.of(context).colorScheme.background
                          : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.6),
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
                              // Container(
                              //   height: double.infinity,
                              //   width: 1,
                              //   color:Theme.of(context).colorScheme.outline.withOpacity(0.2), //Theme.of(context).highlightColor.withOpacity(0.15),
                              // ),
                              sideBar(context, B.sbIndex == 3 ? true : false),
                              // Divider
                            ]
                          : [
                              sideBar(context, B.sbIndex == 1 ? true : false),
                              // Container(
                              //   height: double.infinity,
                              //   width: 1,
                              //   color:Theme.of(context).colorScheme.outline.withOpacity(0.2), //Theme.of(context).highlightColor.withOpacity(0.15),
                              // ), // Divider
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

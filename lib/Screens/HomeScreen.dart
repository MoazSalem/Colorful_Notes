import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/Bloc/notes_bloc.dart';
import 'package:notes/Screens/SideBar/Info.dart';
import 'package:notes/Screens/SideBar/Notes.dart';
import 'package:notes/Screens/SideBar/NotesTablet.dart';
import 'package:notes/Screens/SideBar/Settings.dart';
import 'package:notes/Screens/SideBar/VoiceNotes.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              AdaptiveTheme.of(context).brightness == Brightness.light
                  ? Brightness.dark
                  : Brightness.light,
          // For Android (dark icons)
          statusBarBrightness: AdaptiveTheme.of(context).brightness,
          // For iOS (dark icons)
          systemNavigationBarIconBrightness:
              AdaptiveTheme.of(context).brightness == Brightness.light
                  ? Brightness.dark
                  : Brightness.light,
          systemNavigationBarColor: Theme.of(context).cardColor,
        ),
        child: BlocProvider(
  create: (context) => NotesBloc()..startPage(),
  child: BlocConsumer<NotesBloc, NotesState>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, state) {
    var B = NotesBloc.get(context);

    List<Widget> page = [
      Builder(
        builder: (context) {
          return B.isTablet
              ? MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.5),
              child: HomePage())
              : MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: HomePage());
        },
      ),
      Builder(
        builder: (context) {
          return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaleFactor: B.isTablet ? 1.5 : 1.0),
              child: VoiceNotesPage());
        },
      ),
      Builder(
        builder: (context) {
          return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaleFactor: B.isTablet ? 1.5 : 1.0),
              child: SettingsPage());
        },
      ),
      Builder(
        builder: (context) {
          return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaleFactor: B.isTablet ? 1.5 : 1.0),
              child: InfoPage());
        },
      ),
    ];

    Widget SideBar() {
      return Container(
        width: B.isTablet ? 100 : 60,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
        ),
        child: Column(
          children: [
            Expanded(
                flex: 8,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 65,
                    ),
                    IconButton(
                        onPressed: () {
                          B.onIndexChanged(0);
                        },
                        icon: B.currentIndex != 0
                            ? Icon(
                          Icons.text_snippet_outlined,
                          color: Colors.amber,
                          size: B.isTablet ? 36 : 26,
                        )
                            : Icon(
                          Icons.text_snippet,
                          color: Colors.amber,
                          size: B.isTablet ? 40 : 30,
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                    IconButton(
                        onPressed: () {
                          B.onIndexChanged(1);
                        },
                        icon: B.currentIndex != 1
                            ? Icon(
                          Icons.keyboard_voice_outlined,
                          color: Color(0xfff77b85),
                          size: B.isTablet ? 40 : 30,
                        )
                            : Icon(
                          Icons.keyboard_voice,
                          color: Color(0xfff77b85),
                          size: B.isTablet ? 40 : 30,
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                    IconButton(
                        onPressed: () {
                          B.onIndexChanged(2);
                        },
                        icon: B.currentIndex != 2
                            ? Icon(
                          Icons.settings_outlined,
                          color: Color(0xffff8b34),
                          size: B.isTablet ? 40 : 30,
                        )
                            : Icon(
                          Icons.settings,
                          color: Color(0xffff8b34),
                          size: B.isTablet ? 40 : 30,
                        )),
                  ],
                )),
            Expanded(
              child: IconButton(
                  onPressed: () {
                    B.onIndexChanged(3);
                  },
                  icon: B.currentIndex != 3
                      ? Icon(
                    Icons.info_outline,
                    color: Color(0xff66c6c2),
                    size: B.isTablet ? 40 : 30,
                  )
                      : Icon(
                    Icons.info,
                    color: Color(0xff66c6c2),
                    size: B.isTablet ? 40 : 30,
                  )),
            )
          ],
        ),
      );
    }

    return Scaffold(
          key: B.scaffoldKey,
          body: Row(
            children: [
              SideBar(),
              Container(
                height: double.infinity,
                width: 1,
                color: Theme.of(context).highlightColor.withOpacity(0.15),
              ), // Divider
              Expanded(
                  flex: 5,
                  child: page[B.currentIndex],
                        )
            ],
          ),
        );
  },
),
));
  }
}

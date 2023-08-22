import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:notes/Cubit/notes_cubit.dart';
import 'package:notes/Data/pages.dart';
import 'package:notes/Widgets/sidebar.dart';
import 'package:notes/main.dart';

late Color primaryColor;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<Widget> page;

  @override
  void initState() {
    page = getPages(C);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    C.theme = Theme.of(context).colorScheme;
    C.harmonizeColors();
    C.lang = context.locale.toString();
    C.brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    C.isDarkMode = (C.brightness == Brightness.dark && C.themeMode == ThemeMode.system) ||
        C.themeMode == ThemeMode.dark;
    C.getScreenWidth(context);
    primaryColor = C.theme.primary == Colors.black || C.theme.primary == Colors.white
        ? C.colors[0]
        : C.theme.primary;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: C.isDarkMode ? Brightness.light : Brightness.dark,
          // For Android (dark icons)
          statusBarBrightness: C.isDarkMode ? Brightness.light : Brightness.dark,
          // For iOS (dark icons)
          systemNavigationBarIconBrightness: C.isDarkMode ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: C.theme.surfaceVariant,
        ),
        child: BlocConsumer<NotesCubit, NotesState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: C.loading
                  ? Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: C.isDarkMode
                          ? C.theme.background
                          : C.theme.surfaceVariant.withOpacity(0.6),
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
                      children: C.sbIndex == 2 || C.sbIndex == 3
                          ? [
                              Expanded(
                                flex: 5,
                                child: page[C.currentIndex],
                              ),
                              sideBar(
                                  theme: C.theme,
                                  inverted: C.sbIndex == 3 ? true : false,
                                  C: C,
                                  sizeBox: C.isTablet ? 60 : 30),
                            ]
                          : [
                              sideBar(
                                  theme: C.theme,
                                  inverted: C.sbIndex == 1 ? true : false,
                                  C: C,
                                  sizeBox: C.isTablet ? 60 : 30),
                              Expanded(
                                flex: 5,
                                child: page[C.currentIndex],
                              ),
                            ],
                    ),
            );
          },
        ));
  }
}

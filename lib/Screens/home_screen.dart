import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:notes/Bloc/notes_bloc.dart';
import 'package:notes/Data/pages.dart';
import 'package:notes/Widgets/sidebar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late NotesBloc B;
  late List<Widget> page;

  @override
  void initState() {
    B = NotesBloc.get(context);
    page = getPages(B);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    B.theme = Theme.of(context).colorScheme;
    B.harmonizeColors();
    B.lang = context.locale.toString();
    B.brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    B.isDarkMode = (B.brightness == Brightness.dark && B.themeMode == ThemeMode.system) ||
        B.themeMode == ThemeMode.dark;
    B.getScreenWidth(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: B.isDarkMode ? Brightness.light : Brightness.dark,
          // For Android (dark icons)
          statusBarBrightness: B.isDarkMode ? Brightness.light : Brightness.dark,
          // For iOS (dark icons)
          systemNavigationBarIconBrightness: B.isDarkMode ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: B.theme.surfaceVariant,
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
                      color: B.isDarkMode
                          ? B.theme.background
                          : B.theme.surfaceVariant.withOpacity(0.6),
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
                                  theme: B.theme,
                                  inverted: B.sbIndex == 3 ? true : false,
                                  B: B,
                                  sizeBox: B.isTablet ? 60 : 30),
                            ]
                          : [
                              sideBar(
                                  theme: B.theme,
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

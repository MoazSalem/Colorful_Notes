import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:notes/main.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:notes/Screens/home_screen.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final controller = PageController();
  bool isLastPage = false;
  bool lang = false;
  late bool isDarkMode;

  @override
  void didChangeDependencies() {
    C.theme = Theme.of(context).colorScheme;
    C.brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    isDarkMode = C.brightness == Brightness.dark;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: isDarkMode ? C.theme.background : C.theme.surfaceVariant.withOpacity(0.6),
          statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
          // For Android (dark icons)
          statusBarBrightness: isDarkMode ? Brightness.light : Brightness.dark,
          // For iOS (dark icons)
          systemNavigationBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: C.theme.surfaceVariant,
        ),
        child: Scaffold(
          body: SafeArea(
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                PageView(
                  onPageChanged: (index) {
                    setState(() {
                      index == 3 ? isLastPage = true : isLastPage = false;
                    });
                  },
                  controller: controller,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: lang ? 0 : 20),
                      child: Container(
                        color: isDarkMode
                            ? C.theme.background
                            : C.theme.surfaceVariant.withOpacity(0.6),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                width: 400,
                                height: 370,
                                child: Center(
                                  child: Lottie.asset(
                                    lang
                                        ? 'assets/animations/hello2.json'
                                        : 'assets/animations/hello.json',
                                    reverse: true,
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 30),
                              child: Text(
                                textAlign: TextAlign.center,
                                "T1".tr(),
                                style: TextStyle(
                                    color: C.theme.primary,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: Text(
                                textAlign: TextAlign.center,
                                "B1".tr(),
                                style: TextStyle(
                                    color: C.theme.onSurfaceVariant,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      color:
                          isDarkMode ? C.theme.background : C.theme.surfaceVariant.withOpacity(0.6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: SizedBox(
                              width: 300,
                              height: 250,
                              child: Lottie.asset('assets/animations/notes.json', repeat: false),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 100),
                            child: Text(
                              textAlign: TextAlign.center,
                              "T2".tr(),
                              style: TextStyle(
                                  color: C.theme.primary,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              textAlign: TextAlign.center,
                              "B2".tr(),
                              style: TextStyle(
                                  color: C.theme.onSurfaceVariant,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color:
                          isDarkMode ? C.theme.background : C.theme.surfaceVariant.withOpacity(0.6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: SizedBox(
                              width: 300,
                              height: 250,
                              child: Lottie.asset(
                                'assets/animations/voice.json',
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text(
                              textAlign: TextAlign.center,
                              "T3".tr(),
                              style: TextStyle(
                                  color: C.theme.primary,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              textAlign: TextAlign.center,
                              "B3".tr(),
                              style: TextStyle(
                                  color: C.theme.onSurfaceVariant,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color:
                          isDarkMode ? C.theme.background : C.theme.surfaceVariant.withOpacity(0.6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 100),
                            child: SizedBox(
                              width: 300,
                              height: 300,
                              child: Lottie.asset(
                                'assets/animations/start.json',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 100, bottom: 0),
                            child: Text(
                              textAlign: TextAlign.center,
                              "T5".tr(),
                              style: TextStyle(
                                  color: C.theme.primary,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              textAlign: TextAlign.center,
                              "",
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w400),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              child: SizedBox(
                                height: 60,
                                width: 300,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: C.theme.background,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30))),
                                  child: const Text("START"),
                                  onPressed: () async {
                                    C.box.put("showHome", true);
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(builder: (context) => const Home()));
                                  },
                                ),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        lang = !lang;
                        context.setLocale(Locale(lang ? 'ar' : 'en'));
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: C.theme.surfaceVariant,
                      child: lang
                          ? Text(
                              "عر",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 19,
                                  color: C.theme.primary),
                            )
                          : Text("En",
                              style:
                                  TextStyle(fontWeight: FontWeight.bold, color: C.theme.primary)),
                    ),
                  ),
                )
              ],
            ),
          ),
          bottomSheet: isLastPage
              ? null
              : Container(
                  color: C.theme.surfaceVariant,
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      TextButton(
                        child: Text(
                          "Skip".tr(),
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20, color: C.theme.primary),
                        ),
                        onPressed: () => controller.jumpToPage(3),
                      ),
                      Center(
                        child: SmoothPageIndicator(
                          controller: controller,
                          count: 4,
                          effect: WormEffect(
                              activeDotColor: C.theme.primary,
                              dotHeight: 5,
                              dotWidth: 10,
                              spacing: 5),
                        ),
                      ),
                      TextButton(
                        child: Text("Next".tr(),
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 20, color: C.theme.primary)),
                        onPressed: () => controller.nextPage(
                            duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
                      )
                    ]),
                  ),
                ),
        ));
  }
}

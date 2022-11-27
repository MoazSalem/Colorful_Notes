import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'home_screen.dart';
import 'package:lottie/lottie.dart';

bool isLastPage = false;
bool lang = false;

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final controller = PageController();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Theme.of(context).canvasColor,
        ),
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: SafeArea(
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  PageView(
                    onPageChanged: (index) {
                      setState(() {
                        index == 4 ? isLastPage = true : isLastPage = false;
                      });
                    },
                    controller: controller,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: lang ? 0 : 20),
                        child: Container(
                          color: Theme.of(context).canvasColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                  width: 400,
                                  height: 350,
                                  child: Center(
                                    child: Lottie.asset(
                                      lang ? 'assets/animations/hello2.json' : 'assets/animations/hello.json',
                                      reverse: true,
                                    ),
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(top: 30, bottom: 10),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  "T1".tr(),
                                  style: const TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  "B1".tr(),
                                  style: const TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        color: Theme.of(context).canvasColor,
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
                              padding: const EdgeInsets.only(top: 100, bottom: 10),
                              child: Text(
                                textAlign: TextAlign.center,
                                "T2".tr(),
                                style: const TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: Text(
                                textAlign: TextAlign.center,
                                "B2".tr(),
                                style: const TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Theme.of(context).canvasColor,
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
                              padding: const EdgeInsets.only(top: 20, bottom: 10),
                              child: Text(
                                textAlign: TextAlign.center,
                                "T3".tr(),
                                style: const TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: Text(
                                textAlign: TextAlign.center,
                                "B3".tr(),
                                style: const TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Theme.of(context).canvasColor,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: SizedBox(
                                width: 280,
                                height: 350,
                                child: Lottie.asset(
                                  'assets/animations/scan.json',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20, bottom: 10),
                              child: Text(
                                textAlign: TextAlign.center,
                                "T4".tr(),
                                style: const TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30),
                              child: Text(
                                textAlign: TextAlign.center,
                                "B4".tr(),
                                style: const TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: Theme.of(context).canvasColor,
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
                                style: const TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: Text(
                                textAlign: TextAlign.center,
                                "",
                                style: TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w400),
                              ),
                            ),
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
                        backgroundColor: Colors.black.withOpacity(0.6),
                        child: lang
                            ? const Text(
                                "عر",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: Colors.white),
                              )
                            : const Text("En", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          bottomSheet: isLastPage
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: InkWell(
                              onTap: () async {
                                final prefs = await SharedPreferences.getInstance();
                                prefs.setBool("showHome", true);
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Home()));
                              },
                              child: Container(
                                decoration: BoxDecoration(color: const Color(0xfff169a7), borderRadius: BorderRadius.circular(10.0)),
                                child: Center(
                                    child: Text(
                                  "Start".tr(
                                  ).toUpperCase(),
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
                                )),
                              ),
                            )),
                      )))
              : Container(
                  color: Theme.of(context).canvasColor,
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      TextButton(
                        child: Text(
                          "Skip".tr(),
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20, color: Color(0xfff169a7)),
                        ),
                        onPressed: () => controller.jumpToPage(4),
                      ),
                      Center(
                        child: SmoothPageIndicator(
                          controller: controller,
                          count: 5,
                          effect: const WormEffect(activeDotColor: Color(0xff66c6c2), dotHeight: 5, dotWidth: 10, spacing: 5),
                        ),
                      ),
                      TextButton(
                        child: Text("Next".tr(), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Color(0xff66c6c2))),
                        onPressed: () => controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut),
                      )
                    ]),
                  ),
                ),
        ));
  }
}

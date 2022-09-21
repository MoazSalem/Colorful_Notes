import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'HomeScreen.dart';
import 'package:lottie/lottie.dart';

class introPage extends StatefulWidget {
  const introPage({Key? key}) : super(key: key);

  @override
  State<introPage> createState() => _introPageState();
}

class _introPageState extends State<introPage> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Theme.of(context).primaryColor,
        ),
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: Container(
              child: PageView(
                onPageChanged: (index) {
                  setState(() {
                    index == 2 ? isLastPage = true : isLastPage = false;
                  });
                },
                controller: controller,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Container(
                      color: Theme.of(context).canvasColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              width: 350,
                              height: 350,
                              child: Center(
                                child: Lottie.asset(
                                  'assets/animations/hello.json',
                                  reverse: true,
                                ),
                              )),
                          const Padding(
                            padding: EdgeInsets.only(top: 30, bottom: 10),
                            child: Text(
                              textAlign: TextAlign.center,
                              "Welcome To Notes",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Text(
                              textAlign: TextAlign.center,
                              "Take Notes In A Very Elegant Way!",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400),
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
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            width: 400,
                            height: 350,
                            child: Lottie.asset(
                              'assets/animations/notes.json',
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 10),
                          child: Text(
                            textAlign: TextAlign.center,
                            "Colorful",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 28,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            textAlign: TextAlign.center,
                            "Choose The Colors You Like For Your Notes",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
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
                          padding: const EdgeInsets.only(top: 20),
                          child: Container(
                            width: 300,
                            height: 300,
                            child: Lottie.asset(
                              'assets/animations/start.json',
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 60, bottom: 10),
                          child: Text(
                            textAlign: TextAlign.center,
                            "Let's Get Started",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 28,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            textAlign: TextAlign.center,
                            "",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomSheet: isLastPage
              ? Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        child: Text(
                          "Go",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          prefs.setBool("showHome", true);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => Home()));
                        }),
                  ),
                )
              : Container(
                  color: Colors.grey.shade100,
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            child: const Text(
                              "Skip",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                            onPressed: () => controller.jumpToPage(2),
                          ),
                          Center(
                            child: SmoothPageIndicator(
                              controller: controller,
                              count: 3,
                              effect: WormEffect(
                                  activeDotColor:
                                      Theme.of(context).primaryColor,
                                  dotHeight: 5,
                                  dotWidth: 10,
                                  spacing: 5),
                            ),
                          ),
                          TextButton(
                            child: const Text("Next",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16)),
                            onPressed: () => controller.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeInOut),
                          )
                        ]),
                  ),
                ),
        ));
  }
}

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:notes/Bloc/notes_bloc.dart';
import 'package:notes/Screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

final TextEditingController titleC = TextEditingController();
final TextEditingController contentC = TextEditingController();
late String title;
late String content;
late String time;
late int index;
int layout = 0;
int chosenIndex = 0;
bool isLoading = false;
String chLang = 'en';

Widget createNote(BuildContext context, bool isML) {
  return BlocConsumer<NotesBloc, NotesState>(
    listener: (context, state) {},
    builder: (context, state) {
      var B = NotesBloc.get(context);
      double height = MediaQuery.of(context).size.height;
      double width = MediaQuery.of(context).size.width;
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: B.colors[chosenIndex],
        body: SafeArea(
            child: ListView(children: [
          const SizedBox(
            height: 70,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: TextFormField(
                maxLines: 2,
                textDirection: B.lang == 'en' ? TextDirection.ltr : TextDirection.rtl,
                cursorColor: Colors.white,
                autofocus: true,
                textInputAction: TextInputAction.done,
                controller: titleC,
                style: TextStyle(color: Colors.white, fontSize: B.isTablet ? 60 : 36, fontWeight: FontWeight.w500),
                decoration: InputDecoration(border: InputBorder.none, hintText: "Title".tr())),
          ),
          const SizedBox(
            height: 10,
          ),
          isLoading
              ? SizedBox(
                  height: height * 0.573,
                  width: width * 0.2491,
                  child: Center(
                    child: Lottie.asset(
                      'assets/animations/loading2.json',
                    ),
                  ),
                )
              : isML? Container()
                  // ? SizedBox(
                  //     height: height * 0.573,
                  //     child: FittedBox(
                  //       child: Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           FittedBox(
                  //             child: Padding(
                  //               padding: EdgeInsets.only(left: 60, right: 60, bottom: B.lang == 'en' ? 40 : 10),
                  //               child: Row(children: [
                  //                 TextButton(
                  //                     onPressed: () {
                  //                       chLang = 'en';
                  //                       B.onChanged();
                  //                     },
                  //                     child: Text(
                  //                       "English".tr(),
                  //                       style: TextStyle(color: chLang == 'en' ? Colors.white : Colors.black54, fontSize: 30),
                  //                     )),
                  //                 const SizedBox(
                  //                   width: 40,
                  //                 ),
                  //                 TextButton(
                  //                     onPressed: () {
                  //                       chLang = 'ar';
                  //                       B.onChanged();
                  //                     },
                  //                     child: Text(
                  //                       "Arabic".tr(),
                  //                       style: TextStyle(color: chLang == 'ar' ? Colors.white : Colors.black54, fontSize: 30),
                  //                     ))
                  //               ]),
                  //             ),
                  //           ),
                  //           Text(
                  //             "Take Picture".tr(),
                  //             style: TextStyle(color: Colors.black54, fontWeight: B.lang == "en" ? FontWeight.w500 : FontWeight.bold, fontSize: B.lang == "en" ? 30 : 26),
                  //           ),
                  //           IconButton(
                  //               constraints: const BoxConstraints.tightFor(height: 120, width: 120),
                  //               onPressed: () async {
                  //                 await B.checkCamPerms();
                  //                 isLoading = true;
                  //                 B.onChanged();
                  //                 await B.getImageCamera(chLang);
                  //                 await Future.delayed(const Duration(seconds: 2));
                  //                 contentC.text = B.capturedText;
                  //                 isLoading = false;
                  //                 B.capturedText == "" ? isML = true : isML = false;
                  //                 B.capturedText = "";
                  //                 B.onChanged();
                  //               },
                  //               icon: const Icon(
                  //                 Icons.camera_alt_rounded,
                  //                 size: 100,
                  //                 color: Colors.white,
                  //               )),
                  //           Text(
                  //             "Choose From Gallery".tr(),
                  //             style: TextStyle(color: Colors.black54, fontWeight: B.lang == "en" ? FontWeight.w500 : FontWeight.bold, fontSize: B.lang == "en" ? 30 : 26),
                  //           ),
                  //           IconButton(
                  //               constraints: const BoxConstraints.tightFor(height: 120, width: 120),
                  //               onPressed: () async {
                  //                 await B.checkCamPerms();
                  //                 isLoading = true;
                  //                 B.onChanged();
                  //                 await B.getImageGallery(chLang);
                  //                 await Future.delayed(const Duration(seconds: 2));
                  //                 contentC.text = B.capturedText;
                  //                 isLoading = false;
                  //                 B.capturedText == "" ? isML = true : isML = false;
                  //                 B.capturedText = "";
                  //                 B.onChanged();
                  //               },
                  //               icon: const Icon(
                  //                 Icons.image,
                  //                 size: 100,
                  //                 color: Colors.white,
                  //               )),
                  //           const SizedBox(
                  //             height: 50,
                  //           ),
                  //         ],
                  //       ),
                  //     ))
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                          textDirection: B.lang == 'en' ? TextDirection.ltr : TextDirection.rtl,
                          cursorColor: Colors.white,
                          controller: contentC,
                          maxLines: B.isTablet ? 14 : 15,
                          showCursor: true,
                          style: TextStyle(color: Colors.white, fontSize: B.isTablet ? 40 : 24),
                          decoration: InputDecoration(border: InputBorder.none, constraints: BoxConstraints.expand(height: height * 0.573, width: 200), hintText: "Content".tr())),
                    ),
          FittedBox(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: B.isTablet ? 100 : 20.0),
              child: SizedBox(
                height: 60,
                child: Center(
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: B.colors.length,
                    itemBuilder: (BuildContext context, index) => GestureDetector(
                      onTap: () {
                        chosenIndex = index;
                        B.onColorChanged();
                      },
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: chosenIndex == index ? Colors.white : Colors.white54,
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: B.colors[index],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          FittedBox(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: B.isTablet ? 50 : 30),
                    child: TextButton(
                      onPressed: () {
                        titleC.clear();
                        contentC.clear();
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Discard".tr(),
                        style: const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: B.isTablet ? 60 : 40),
                    child: TextButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance(), time = DateTime.now().toString();
                        title = titleC.text;
                        content = contentC.text;
                        titleC.text != "" || contentC.text != ""
                            ? {
                                await B.detectLanguage("$title $content"),
                                await B.insertToDatabase(title: title, time: time, content: content, index: chosenIndex, layout: B.detectedLanguage == 'ar' ? 1 : 0),
                                titleC.text = "",
                                contentC.text = "",
                                B.adCounter++,
                                await prefs.setInt("adCounter", B.adCounter),
                                B.adCounter == 3 ? {interstitialAd.show(), B.adCounter = 0} : null,
                                Navigator.pop(context),
                                B.onCreateNote()
                              }
                            : Navigator.pop(context);
                      },
                      child: Text(
                        "Save".tr(),
                        style: const TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ])),
      );
    },
  );
}

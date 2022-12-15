import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:notes/Data/theme.dart';
import 'package:notes/Bloc/notes_bloc.dart';
import 'package:notes/Screens/home_screen.dart';
import 'package:notes/Widgets/notes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:switcher_button/switcher_button.dart';

late String dropDownTheme;
late String darkTheme;
var lang = ["English", "Arabic"];
var themes = ["Light", "Dark", "System"];
var dark = ["Dark", "Amoled"];
var sb = ["Left", "Left Inv", "Right", "Right Inv"];
var fab = ["Right", "Left"];
var pages = ["Home", "Text", "Voice"];

class SettingsPage extends StatelessWidget {
  final String currentTheme;
  final String black;
  late String sB;
  late String fabLoc;

  SettingsPage({Key? key, required this.currentTheme, required this.black, required this.sB, required this.fabLoc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    banner1.load();
    AdWidget adWidget = AdWidget(ad: banner1);
    return BlocConsumer<NotesBloc, NotesState>(
      listener: (context, state) {},
      builder: (context, state) {
        var B = NotesBloc.get(context);
        double height = B.isTablet
            ? 120
            : 80;
        double title = isTablet ? 26 : 22;
        double subtitle = isTablet ? 16 : 12;
        double switchSize = isTablet ? 100 : 50;
        double iconSize = isTablet ? 40 : 10.0;
        double itemHeight = isTablet ? 80 : 50.0;
        double fontSize = B.isTablet ? 10 : 14;
        double padding = B.isTablet ? 24 : 10;
        return Scaffold(
          bottomNavigationBar: Container(
            alignment: Alignment.center,
            width: banner1.size.width.toDouble(),
            height: banner1.size.height.toDouble(),
            child: adWidget,
          ),
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              B.customAppBar(context, "Settings".tr(), 66),
              SizedBox(
                height: height,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: ListTile(
                      title: Text(
                        "Language".tr(),
                        style: TextStyle(fontSize: title, fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        "sLanguage".tr(),
                        style: TextStyle(fontSize: subtitle, fontWeight: FontWeight.w400),
                      ),
                      trailing: DropdownButton(
                        iconSize: iconSize,
                        itemHeight: itemHeight,
                        borderRadius: BorderRadius.circular(10),
                        alignment: Alignment.center,
                        underline: Container(),
                        style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: fontSize, fontWeight: FontWeight.w400),
                        dropdownColor: Theme.of(context).canvasColor,
                        elevation: 0,
                        isDense: true,
                        iconEnabledColor: Theme.of(context).textTheme.bodyMedium?.color,
                        value: B.lang == 'en' ? "English" : "Arabic",
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: lang.map((String items) {
                          return DropdownMenuItem(
                              value: items,
                              child: MediaQuery(
                                data: MediaQuery.of(context).copyWith(textScaleFactor: isTablet ? 2.0 : 1.0),
                                child: Text(items).tr(),
                              ));
                        }).toList(),
                        onChanged: (String? newValue) async {
                          B.lang = newValue! == 'English' ? 'en' : 'ar';
                          context.setLocale(Locale(B.lang));
                          B.lang = context.locale.toString();
                          B.prefsChanged();
                        },
                      ),
                    ),
                  ),
                ),
              ),
              B.divider(context),
              SizedBox(
                height: height,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: ListTile(
                        title: Text(
                          "Start In".tr(),
                          style: TextStyle(fontSize: title, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          "sStart In".tr(),
                          style: TextStyle(fontSize: subtitle, fontWeight: FontWeight.w400),
                        ),
                        trailing: DropdownButton(
                          iconSize: iconSize,
                          itemHeight: itemHeight,
                          borderRadius: BorderRadius.circular(10),
                          alignment: Alignment.center,
                          underline: Container(),
                          style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: fontSize, fontWeight: FontWeight.w400),
                          dropdownColor: Theme.of(context).canvasColor,
                          elevation: 0,
                          isDense: true,
                          iconEnabledColor: Theme.of(context).textTheme.bodyMedium?.color,
                          value: B.openPage,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: pages.map((String items) {
                            return DropdownMenuItem(
                                value: items,
                                child: MediaQuery(
                                  data: MediaQuery.of(context).copyWith(textScaleFactor: isTablet ? 2.0 : 1.0),
                                  child: Text(items).tr(),
                                ));
                          }).toList(),
                          onChanged: (String? newValue) async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setString(
                                "Pages",
                                newValue! == 'Home'
                                    ? 'Home'
                                    : newValue == 'Text'
                                        ? 'Text'
                                        : 'Voice');
                            B.openPage = newValue;
                            B.prefsChanged();
                          },
                        )),
                  ),
                ),
              ),
              B.divider(context),
              SizedBox(
                height: height,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: ListTile(
                        title: Text(
                          "Side Bar".tr(),
                          style: TextStyle(fontSize: title, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          "sSide Bar".tr(),
                          style: TextStyle(fontSize: subtitle, fontWeight: FontWeight.w400),
                        ),
                        trailing: DropdownButton(
                          iconSize: iconSize,
                          itemHeight: itemHeight,
                          borderRadius: BorderRadius.circular(10),
                          alignment: Alignment.center,
                          underline: Container(),
                          style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: fontSize, fontWeight: FontWeight.w400),
                          dropdownColor: Theme.of(context).canvasColor,
                          elevation: 0,
                          isDense: true,
                          iconEnabledColor: Theme.of(context).textTheme.bodyMedium?.color,
                          value: sB,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: sb.map((String items) {
                            return DropdownMenuItem(
                                value: items,
                                child: MediaQuery(
                                  data: MediaQuery.of(context).copyWith(textScaleFactor: isTablet ? 2.0 : 1.0),
                                  child: Text(items).tr(),
                                ));
                          }).toList(),
                          onChanged: (String? newValue) async {
                            newValue == 'Left'
                                ? B.sbIndex = 0
                                : newValue == 'Left Inv'
                                    ? B.sbIndex = 1
                                    : newValue == 'Right'
                                        ? B.sbIndex = 2
                                        : B.sbIndex = 3;
                            sB = newValue!;
                            banner1.dispose();
                            banner1.load();
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setInt("sbIndex", B.sbIndex);
                            B.prefsChanged();
                          },
                        )),
                  ),
                ),
              ),
              B.divider(context),
              SizedBox(
                height: height,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: ListTile(
                        title: Text(
                          "Create Button".tr(),
                          style: TextStyle(fontSize: title, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          "sCreate Button".tr(),
                          style: TextStyle(fontSize: subtitle, fontWeight: FontWeight.w400),
                        ),
                        trailing: DropdownButton(
                          iconSize: iconSize,
                          itemHeight: itemHeight,
                          borderRadius: BorderRadius.circular(10),
                          alignment: Alignment.center,
                          underline: Container(),
                          style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: fontSize, fontWeight: FontWeight.w400),
                          dropdownColor: Theme.of(context).canvasColor,
                          elevation: 0,
                          isDense: true,
                          iconEnabledColor: Theme.of(context).textTheme.bodyMedium?.color,
                          value: fabLoc,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: fab.map((String items) {
                            return DropdownMenuItem(
                                value: items,
                                child: MediaQuery(
                                  data: MediaQuery.of(context).copyWith(textScaleFactor: isTablet ? 2.0 : 1.0),
                                  child: Text(items).tr(),
                                ));
                          }).toList(),
                          onChanged: (String? newValue) async {
                            newValue == 'Right' ? B.fabIndex = 0 : B.fabIndex = 1;
                            fabLoc = newValue!;
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setInt("fabIndex", B.fabIndex);
                            B.prefsChanged();
                          },
                        )),
                  ),
                ),
              ),
              B.divider(context),
              SizedBox(
                height: height,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: ListTile(
                        title: Text(
                          "App Theme".tr(),
                          style: TextStyle(fontSize: title, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          "sApp Theme".tr(),
                          style: TextStyle(fontSize: subtitle, fontWeight: FontWeight.w400),
                        ),
                        trailing: DropdownButton(
                          iconSize: iconSize,
                          itemHeight: itemHeight,
                          borderRadius: BorderRadius.circular(10),
                          alignment: Alignment.center,
                          underline: Container(),
                          style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color, fontSize: fontSize, fontWeight: FontWeight.w400),
                          dropdownColor: Theme.of(context).canvasColor,
                          elevation: 0,
                          isDense: true,
                          iconEnabledColor: Theme.of(context).textTheme.bodyMedium?.color,
                          value: dropDownTheme = currentTheme,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: themes.map((String items) {
                            return DropdownMenuItem(
                                value: items,
                                child: MediaQuery(
                                  data: MediaQuery.of(context).copyWith(textScaleFactor: isTablet ? 2.0 : 1.0),
                                  child: Text(items).tr(),
                                ));
                          }).toList(),
                          onChanged: (String? newValue) {
                            newValue == 'Light'
                                ? AdaptiveTheme.of(context).setLight()
                                : newValue == 'Dark'
                                    ? AdaptiveTheme.of(context).setDark()
                                    : AdaptiveTheme.of(context).setSystem();
                            dropDownTheme = newValue!;
                            B.prefsChanged();
                          },
                        )),
                  ),
                ),
              ),
              B.divider(context),
              SizedBox(
                height: height,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: ListTile(
                        title: Text(
                          "Amoled Mode".tr(),
                          style: TextStyle(fontSize: title, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          "sAmoled Mode".tr(),
                          style: TextStyle(fontSize: subtitle, fontWeight: FontWeight.w400),
                        ),
                        trailing: Padding(
                          padding: EdgeInsets.only(right: padding),
                          child: SwitcherButton(
                            onColor: B.colors[8],
                            offColor: Theme.of(context).primaryColorDark,
                            size: switchSize,
                            value: B.isBlack,
                            onChange: (bool value) async {
                              value ? {AdaptiveTheme.of(context).setTheme(light: light, dark: amoled)} : {AdaptiveTheme.of(context).setTheme(light: light, dark: normalDark)};
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setBool("isBlack", value);
                              B.isBlack = value;
                              B.prefsChanged();
                            },
                          ),
                        )),
                  ),
                ),
              ),
              B.divider(context),
              SizedBox(
                height: height,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: ListTile(
                        title: Text(
                          "Darker Colors".tr(),
                          style: TextStyle(fontSize: title, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          "sDarker Colors".tr(),
                          style: TextStyle(fontSize: subtitle, fontWeight: FontWeight.w400),
                        ),
                        trailing: Padding(
                          padding: EdgeInsets.only(right: padding),
                          child: SwitcherButton(
                            onColor: B.colors[6],
                            offColor: Theme.of(context).primaryColorDark,
                            size: switchSize,
                            value: B.darkColors,
                            onChange: (bool value) async {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setBool("darkColors", value);
                              B.darkColors = value;
                              B.startDatabase();
                              B.prefsChanged();
                            },
                          ),
                        )),
                  ),
                ),
              ),
              B.divider(context),
              SizedBox(
                height: height,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: ListTile(
                        title: Text(
                          "Show Date".tr(),
                          style: TextStyle(fontSize: title, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          "sShow Date".tr(),
                          style: TextStyle(fontSize: subtitle, fontWeight: FontWeight.w400),
                        ),
                        trailing: Padding(
                          padding: EdgeInsets.only(right: padding),
                          child: SwitcherButton(
                            onColor: B.colors[0],
                            offColor: Theme.of(context).primaryColorDark,
                            size: switchSize,
                            value: B.showDate,
                            onChange: (bool value) async {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setBool("showDate", value);
                              B.showDate = value;
                              B.prefsChanged();
                            },
                          ),
                        )),
                  ),
                ),
              ),
              B.divider(context),
              SizedBox(
                height: height,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: ListTile(
                        title: Text(
                          "Show Shadow".tr(),
                          style: TextStyle(fontSize: title, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          "sShow Shadow".tr(),
                          style: TextStyle(fontSize: subtitle, fontWeight: FontWeight.w400),
                        ),
                        trailing: Padding(
                          padding: EdgeInsets.only(right: padding),
                          child: SwitcherButton(
                            onColor: B.colors[1],
                            offColor: Theme.of(context).primaryColorDark,
                            size: switchSize,
                            value: B.showShadow,
                            onChange: (bool value) async {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setBool("showShadow", value);
                              B.showShadow = value;
                              B.prefsChanged();
                            },
                          ),
                        )),
                  ),
                ),
              ),
              B.divider(context),
              SizedBox(
                height: height,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: ListTile(
                        title: Text(
                          "Show Edited".tr(),
                          style: TextStyle(fontSize: title, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          "sShow Edited".tr(),
                          style: TextStyle(fontSize: subtitle, fontWeight: FontWeight.w400),
                        ),
                        trailing: Padding(
                          padding: EdgeInsets.only(right: padding),
                          child: SwitcherButton(
                            onColor: B.colors[2],
                            offColor: Theme.of(context).primaryColorDark,
                            size: switchSize,
                            value: B.showEdited,
                            onChange: (bool value) async {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setBool("showEdit", value);
                              B.showEdited = value;
                              B.prefsChanged();
                            },
                          ),
                        )),
                  ),
                ),
              ),
              B.divider(context),
              // SizedBox(
              //   height: height,
              //   child: Center(
              //     child: Padding(
              //         padding: EdgeInsets.symmetric(horizontal: padding),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceAround,
              //           children: [
              //             TextButton(
              //               onPressed: () {
              //                 B.bDialog(context);
              //               },
              //               child: Text(
              //                 "Backup".tr(),
              //                 style: TextStyle(fontSize: 24, color: B.colors[3]),
              //               ),
              //             ),
              //             TextButton(onPressed: () {
              //               B.rDialog(context);
              //             }, child: Text("Restore".tr(), style: TextStyle(fontSize: 24, color: B.colors[4]))),
              //           ],
              //         )),
              //   ),
              // ),
              // B.divider(context),
            ],
          ),
        );
      },
    );
  }
}

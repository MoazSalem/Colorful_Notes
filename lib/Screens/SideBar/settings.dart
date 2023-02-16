import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:switcher_button/switcher_button.dart';
import 'package:notes/Bloc/notes_bloc.dart';
import 'package:notes/Widgets/notes.dart';

late String dropDownTheme;
late String darkTheme;
var lang = ["English", "Arabic"];
var themes = ["Light", "Dark", "System"];
var dark = ["Dark", "Amoled"];
var sb = ["Top Left", "Bottom Left", "Top Right", "Bottom Right"];
var fab = ["Right", "Left"];
var pages = ["Home", "Text", "Voice"];

// ignore: must_be_immutable
class SettingsPage extends StatelessWidget {
  final String black;
  late String sB;
  late String fabLoc;

  SettingsPage({Key? key, required this.black, required this.sB, required this.fabLoc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotesBloc, NotesState>(
      listener: (context, state) {},
      builder: (context, state) {
        var B = NotesBloc.get(context);
        double height = B.isTablet ? 120 : 80;
        double title = isTablet ? 26 : 22;
        double subtitle = isTablet ? 16 : 12;
        double switchSize = isTablet ? 100 : 50;
        double iconSize = isTablet ? 40 : 10.0;
        double itemHeight = isTablet ? 80 : 50.0;
        double fontSize = B.isTablet ? 10 : 14;
        double padding = B.isTablet ? 24 : 10;
        Color textColor = Theme.of(context).colorScheme.onSurfaceVariant;
        Color dropDownColor = Theme.of(context).colorScheme.surfaceVariant;
        return Scaffold(
          backgroundColor: B.isDarkMode ? Theme.of(context).colorScheme.background : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.6),
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              B.customAppBar(context, "Settings".tr(), 65),
              SizedBox(
                height: height,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: ListTile(
                      title: Text(
                        "Language".tr(),
                        style: TextStyle(fontSize: title, fontWeight: FontWeight.w500, color: textColor),
                      ),
                      subtitle: Text(
                        "sLanguage".tr(),
                        style: TextStyle(fontSize: subtitle, fontWeight: FontWeight.w400, color: textColor),
                      ),
                      trailing: DropdownButton(
                        iconSize: iconSize,
                        itemHeight: itemHeight,
                        borderRadius: BorderRadius.circular(10),
                        alignment: Alignment.center,
                        underline: Container(),
                        style: TextStyle(color: textColor, fontSize: fontSize, fontWeight: FontWeight.w400),
                        dropdownColor: dropDownColor,
                        elevation: 0,
                        isDense: true,
                        iconEnabledColor: textColor,
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
                          style: TextStyle(fontSize: title, fontWeight: FontWeight.w500, color: textColor),
                        ),
                        subtitle: Text(
                          "sStart In".tr(),
                          style: TextStyle(fontSize: subtitle, fontWeight: FontWeight.w400, color: textColor),
                        ),
                        trailing: DropdownButton(
                          iconSize: iconSize,
                          itemHeight: itemHeight,
                          borderRadius: BorderRadius.circular(10),
                          alignment: Alignment.center,
                          underline: Container(),
                          style: TextStyle(color: textColor, fontSize: fontSize, fontWeight: FontWeight.w400),
                          dropdownColor: dropDownColor,
                          elevation: 0,
                          isDense: true,
                          iconEnabledColor: textColor,
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
                          "App Theme".tr(),
                          style: TextStyle(fontSize: title, fontWeight: FontWeight.w500, color: textColor),
                        ),
                        subtitle: Text(
                          "sApp Theme".tr(),
                          style: TextStyle(fontSize: subtitle, fontWeight: FontWeight.w400, color: textColor),
                        ),
                        trailing: DropdownButton(
                          iconSize: iconSize,
                          itemHeight: itemHeight,
                          borderRadius: BorderRadius.circular(10),
                          alignment: Alignment.center,
                          underline: Container(),
                          style: TextStyle(color: textColor, fontSize: fontSize, fontWeight: FontWeight.w400),
                          dropdownColor: dropDownColor,
                          elevation: 0,
                          isDense: true,
                          iconEnabledColor: textColor,
                          value: B.currentTheme,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: themes.map((String items) {
                            return DropdownMenuItem(
                                value: items,
                                child: MediaQuery(
                                  data: MediaQuery.of(context).copyWith(textScaleFactor: isTablet ? 2.0 : 1.0),
                                  child: Text(items).tr(),
                                ));
                          }).toList(),
                          onChanged: (String? newValue) async {
                            // I need to relearn Bloc and reImplement this :(
                            int c;
                            newValue == 'Light'
                                ? {c = 0, B.themeMode = ThemeMode.light}
                                : newValue == 'Dark'
                                ? {c = 1, B.themeMode = ThemeMode.dark}
                                : c = 2;
                            B.currentTheme = newValue!;
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.setInt("themeMode", c);
                            B.prefsChanged();
                            SnackBar snackBar = const SnackBar(
                              content: Text('Restart App For Changes to Take Effect'),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                          style: TextStyle(fontSize: title, fontWeight: FontWeight.w500, color: textColor),
                        ),
                        subtitle: Text(
                          "sSide Bar".tr(),
                          style: TextStyle(fontSize: subtitle, fontWeight: FontWeight.w400, color: textColor),
                        ),
                        trailing: DropdownButton(
                          iconSize: iconSize,
                          itemHeight: itemHeight,
                          borderRadius: BorderRadius.circular(10),
                          alignment: Alignment.center,
                          underline: Container(),
                          style: TextStyle(color: textColor, fontSize: fontSize, fontWeight: FontWeight.w400),
                          dropdownColor: dropDownColor,
                          elevation: 0,
                          isDense: true,
                          iconEnabledColor: textColor,
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
                            newValue == 'Top Left'
                                ? B.sbIndex = 0
                                : newValue == 'Bottom Left'
                                    ? B.sbIndex = 1
                                    : newValue == 'Top Right'
                                        ? B.sbIndex = 2
                                        : B.sbIndex = 3;
                            sB = newValue!;
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
                          style: TextStyle(fontSize: title, fontWeight: FontWeight.w500, color: textColor),
                        ),
                        subtitle: Text(
                          "sCreate Button".tr(),
                          style: TextStyle(fontSize: subtitle, fontWeight: FontWeight.w400, color: textColor),
                        ),
                        trailing: DropdownButton(
                          iconSize: iconSize,
                          itemHeight: itemHeight,
                          borderRadius: BorderRadius.circular(10),
                          alignment: Alignment.center,
                          underline: Container(),
                          style: TextStyle(color: textColor, fontSize: fontSize, fontWeight: FontWeight.w400),
                          dropdownColor: dropDownColor,
                          elevation: 0,
                          isDense: true,
                          iconEnabledColor: textColor,
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
              // SizedBox(
              //   height: height,
              //   child: Center(
              //     child: Padding(
              //       padding: EdgeInsets.symmetric(horizontal: padding),
              //       child: ListTile(
              //           title: Text(
              //             "Amoled Mode".tr(),
              //             style: TextStyle(fontSize: title, fontWeight: FontWeight.w500),
              //           ),
              //           subtitle: Text(
              //             "sAmoled Mode".tr(),
              //             style: TextStyle(fontSize: subtitle, fontWeight: FontWeight.w400),
              //           ),
              //           trailing: Padding(
              //             padding: EdgeInsets.only(right: padding),
              //             child: SwitcherButton(
              //               onColor: B.colors[8],
              //               offColor: Theme.of(context).primaryColorDark,
              //               size: switchSize,
              //               value: B.isBlack,
              //               onChange: (bool value) async {
              //                 value ? {AdaptiveTheme.of(context).setTheme(light: light, dark: amoled)} : {AdaptiveTheme.of(context).setTheme(light: light, dark: normalDark)};
              //                 final prefs = await SharedPreferences.getInstance();
              //                 await prefs.setBool("isBlack", value);
              //                 B.isBlack = value;
              //                 B.prefsChanged();
              //               },
              //             ),
              //           )),
              //     ),
              //   ),
              // ),
              // B.divider(context),
              SizedBox(
                height: height,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: ListTile(
                        title: Text(
                          "Show Date".tr(),
                          style: TextStyle(fontSize: title, fontWeight: FontWeight.w500, color: textColor),
                        ),
                        subtitle: Text(
                          "sShow Date".tr(),
                          style: TextStyle(fontSize: subtitle, fontWeight: FontWeight.w400, color: textColor),
                        ),
                        trailing: Padding(
                          padding: EdgeInsets.only(right: padding),
                          child: SwitcherButton(
                            onColor: Theme.of(context).colorScheme.primary,
                            offColor: Theme.of(context).colorScheme.primaryContainer,
                            // onColor: B.colors[0],
                            // offColor: Theme.of(context).primaryColorDark,
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
                          "Show Edited".tr(),
                          style: TextStyle(fontSize: title, fontWeight: FontWeight.w500, color: textColor),
                        ),
                        subtitle: Text(
                          "sShow Edited".tr(),
                          style: TextStyle(fontSize: subtitle, fontWeight: FontWeight.w400, color: textColor),
                        ),
                        trailing: Padding(
                          padding: EdgeInsets.only(right: padding),
                          child: SwitcherButton(
                            onColor: Theme.of(context).colorScheme.primary,
                            offColor: Theme.of(context).colorScheme.primaryContainer,
                            // onColor: B.colors[2],
                            // offColor: Theme.of(context).primaryColorDark,
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
              SizedBox(
                height: height,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: padding),
                    child: ListTile(
                        title: Text(
                          "Show Shadow".tr(),
                          style: TextStyle(fontSize: title, fontWeight: FontWeight.w500, color: textColor),
                        ),
                        subtitle: Text(
                          "sShow Shadow".tr(),
                          style: TextStyle(fontSize: subtitle, fontWeight: FontWeight.w400, color: textColor),
                        ),
                        trailing: Padding(
                          padding: EdgeInsets.only(right: padding),
                          child: SwitcherButton(
                            onColor: Theme.of(context).colorScheme.primary,
                            offColor: Theme.of(context).colorScheme.primaryContainer,
                            // onColor: B.colors[1],
                            // offColor: Theme.of(context).primaryColorDark,
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
                          "Darker Colors".tr(),
                          style: TextStyle(fontSize: title, fontWeight: FontWeight.w500, color: textColor),
                        ),
                        subtitle: Text(
                          "sDarker Colors".tr(),
                          style: TextStyle(fontSize: subtitle, fontWeight: FontWeight.w400, color: textColor),
                        ),
                        trailing: Padding(
                          padding: EdgeInsets.only(right: padding),
                          child: SwitcherButton(
                            onColor: Theme.of(context).colorScheme.primary,
                            offColor: Theme.of(context).colorScheme.primaryContainer,
                            //onColor: B.colors[6],
                            //offColor: Theme.of(context).primaryColorDark,
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
                          "harmonized Colors".tr(),
                          style: TextStyle(fontSize: title, fontWeight: FontWeight.w500, color: textColor),
                        ),
                        subtitle: Text(
                          "sHarmonizedColors".tr(),
                          style: TextStyle(fontSize: subtitle, fontWeight: FontWeight.w400, color: textColor),
                        ),
                        trailing: Padding(
                          padding: EdgeInsets.only(right: padding),
                          child: SwitcherButton(
                            onColor: Theme.of(context).colorScheme.primary,
                            offColor: Theme.of(context).colorScheme.primaryContainer,
                            //onColor: B.colors[6],
                            //offColor: Theme.of(context).primaryColorDark,
                            size: switchSize,
                            value: B.harmonizeColor,
                            onChange: (bool value) async {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setBool("harmonizeColor", value);
                              B.harmonizeColor = value;
                              B.startDatabase();
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

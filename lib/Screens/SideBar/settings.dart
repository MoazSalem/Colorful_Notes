import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:notes/Screens/home_screen.dart';
import 'package:notes/Widgets/theme_popup_menu.dart';
import 'package:notes/main.dart';
import 'package:switcher_button/switcher_button.dart';
import 'package:notes/Bloc/notes_bloc.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String dropDownTheme;
  late String darkTheme;
  late double height;
  late double title;
  late double subtitle;
  late double switchSize;
  late double iconSize;
  late double itemHeight;
  late double fontSize;
  late String fabLoc;
  late String sB;
  List<String> lang = ["English", "Arabic"];
  List<String> themes = ["Light", "Dark", "System"];
  List<String> dark = ["Dark", "Amoled"];
  List<String> sb = ["Top Left", "Bottom Left", "Top Right", "Bottom Right"];
  List<String> fab = ["Right", "Left"];
  List<String> pages = ["Home", "Text", "Voice"];

  @override
  void initState() {
    B = NotesBloc.get(context);
    height = B.isTablet ? 120 : 80;
    title = B.isTablet ? 26 : 22;
    subtitle = B.isTablet ? 16 : 12;
    switchSize = B.isTablet ? 100 : 50;
    iconSize = B.isTablet ? 40 : 10.0;
    itemHeight = B.isTablet ? 80 : 50.0;
    fontSize = B.isTablet ? 10 : 14;
    sB = B.sbIndex == 0
        ? "Top Left"
        : B.sbIndex == 1
            ? "Bottom Left"
            : B.sbIndex == 2
                ? "Top Right"
                : "Bottom Right";
    fabLoc = B.fabIndex == 0 ? "Right" : "Left";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotesBloc, NotesState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor:
              B.isDarkMode ? B.theme.background : B.theme.surfaceVariant.withOpacity(0.6),
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              B.customAppBar("Settings".tr(), 65),
              SizedBox(
                height: height,
                child: Center(
                  child: ListTile(
                    title: Text(
                      "Language".tr(),
                      style: TextStyle(
                          fontSize: title,
                          fontWeight: FontWeight.w400,
                          color: B.theme.onSurfaceVariant),
                    ),
                    subtitle: Text(
                      "sLanguage".tr(),
                      style: TextStyle(
                          fontSize: subtitle,
                          fontWeight: FontWeight.w300,
                          color: B.theme.onSurfaceVariant),
                    ),
                    trailing: DropdownButton(
                      iconSize: iconSize,
                      itemHeight: itemHeight,
                      borderRadius: BorderRadius.circular(10),
                      alignment: Alignment.center,
                      underline: Container(),
                      style: TextStyle(
                          color: B.theme.onSurfaceVariant,
                          fontSize: fontSize,
                          fontWeight: FontWeight.w400),
                      dropdownColor: B.theme.surfaceVariant,
                      elevation: 0,
                      isDense: true,
                      iconEnabledColor: B.theme.onSurfaceVariant,
                      value: B.lang == 'en' ? "English" : "Arabic",
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: lang.map((String items) {
                        return DropdownMenuItem(
                            value: items,
                            child: MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(textScaleFactor: B.isTablet ? 2.0 : 1.0),
                              child: Text(items).tr(),
                            ));
                      }).toList(),
                      onChanged: (String? newValue) {
                        B.lang = newValue! == 'English' ? 'en' : 'ar';
                        context.setLocale(Locale(B.lang));
                        B.lang = context.locale.toString();
                        B.prefsChanged();
                      },
                    ),
                  ),
                ),
              ),
              B.divider(),
              SizedBox(
                height: height,
                child: Center(
                  child: ListTile(
                      title: Text(
                        "Start In".tr(),
                        style: TextStyle(
                            fontSize: title,
                            fontWeight: FontWeight.w400,
                            color: B.theme.onSurfaceVariant),
                      ),
                      subtitle: Text(
                        "sStart In".tr(),
                        style: TextStyle(
                            fontSize: subtitle,
                            fontWeight: FontWeight.w300,
                            color: B.theme.onSurfaceVariant),
                      ),
                      trailing: DropdownButton(
                        iconSize: iconSize,
                        itemHeight: itemHeight,
                        borderRadius: BorderRadius.circular(10),
                        alignment: Alignment.center,
                        underline: Container(),
                        style: TextStyle(
                            color: B.theme.onSurfaceVariant,
                            fontSize: fontSize,
                            fontWeight: FontWeight.w400),
                        dropdownColor: B.theme.surfaceVariant,
                        elevation: 0,
                        isDense: true,
                        iconEnabledColor: B.theme.onSurfaceVariant,
                        value: B.openPage,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: pages.map((String items) {
                          return DropdownMenuItem(
                              value: items,
                              child: MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(textScaleFactor: B.isTablet ? 2.0 : 1.0),
                                child: Text(items).tr(),
                              ));
                        }).toList(),
                        onChanged: (String? newValue) {
                          B.box.put(
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
              B.divider(),
              SizedBox(
                height: height,
                child: Center(
                  child: ListTile(
                      title: Text(
                        "Side Bar".tr(),
                        style: TextStyle(
                            fontSize: title,
                            fontWeight: FontWeight.w400,
                            color: B.theme.onSurfaceVariant),
                      ),
                      subtitle: Text(
                        "sSide Bar".tr(),
                        style: TextStyle(
                            fontSize: subtitle,
                            fontWeight: FontWeight.w300,
                            color: B.theme.onSurfaceVariant),
                      ),
                      trailing: DropdownButton(
                        iconSize: iconSize,
                        itemHeight: itemHeight,
                        borderRadius: BorderRadius.circular(10),
                        alignment: Alignment.center,
                        underline: Container(),
                        style: TextStyle(
                            color: B.theme.onSurfaceVariant,
                            fontSize: fontSize,
                            fontWeight: FontWeight.w400),
                        dropdownColor: B.theme.surfaceVariant,
                        elevation: 0,
                        isDense: true,
                        iconEnabledColor: B.theme.onSurfaceVariant,
                        value: sB,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: sb.map((String items) {
                          return DropdownMenuItem(
                              value: items,
                              child: MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(textScaleFactor: B.isTablet ? 2.0 : 1.0),
                                child: Text(items).tr(),
                              ));
                        }).toList(),
                        onChanged: (String? newValue) {
                          newValue == 'Top Left'
                              ? B.sbIndex = 0
                              : newValue == 'Bottom Left'
                                  ? B.sbIndex = 1
                                  : newValue == 'Top Right'
                                      ? B.sbIndex = 2
                                      : B.sbIndex = 3;
                          sB = newValue!;
                          B.box.put("sbIndex", B.sbIndex);
                          B.prefsChanged();
                        },
                      )),
                ),
              ),
              B.divider(),
              SizedBox(
                height: height,
                child: Center(
                  child: ListTile(
                      title: Text(
                        "Create Button".tr(),
                        style: TextStyle(
                            fontSize: title,
                            fontWeight: FontWeight.w400,
                            color: B.theme.onSurfaceVariant),
                      ),
                      subtitle: Text(
                        "sCreate Button".tr(),
                        style: TextStyle(
                            fontSize: subtitle,
                            fontWeight: FontWeight.w300,
                            color: B.theme.onSurfaceVariant),
                      ),
                      trailing: DropdownButton(
                        iconSize: iconSize,
                        itemHeight: itemHeight,
                        borderRadius: BorderRadius.circular(10),
                        alignment: Alignment.center,
                        underline: Container(),
                        style: TextStyle(
                            color: B.theme.onSurfaceVariant,
                            fontSize: fontSize,
                            fontWeight: FontWeight.w400),
                        dropdownColor: B.theme.surfaceVariant,
                        elevation: 0,
                        isDense: true,
                        iconEnabledColor: B.theme.onSurfaceVariant,
                        value: fabLoc,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: fab.map((String items) {
                          return DropdownMenuItem(
                              value: items,
                              child: MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(textScaleFactor: B.isTablet ? 2.0 : 1.0),
                                child: Text(items).tr(),
                              ));
                        }).toList(),
                        onChanged: (String? newValue) {
                          newValue == 'Right' ? B.fabIndex = 0 : B.fabIndex = 1;
                          fabLoc = newValue!;
                          B.box.put("fabIndex", B.fabIndex);
                          B.prefsChanged();
                        },
                      )),
                ),
              ),
              B.divider(),
              SizedBox(
                height: height,
                child: Center(
                  child: ListTile(
                      title: Text(
                        "App Theme".tr(),
                        style: TextStyle(
                            fontSize: title,
                            fontWeight: FontWeight.w400,
                            color: B.theme.onSurfaceVariant),
                      ),
                      subtitle: Text(
                        "sApp Theme".tr(),
                        style: TextStyle(
                            fontSize: subtitle,
                            fontWeight: FontWeight.w300,
                            color: B.theme.onSurfaceVariant),
                      ),
                      trailing: DropdownButton(
                        iconSize: iconSize,
                        itemHeight: itemHeight,
                        borderRadius: BorderRadius.circular(10),
                        alignment: Alignment.center,
                        underline: Container(),
                        style: TextStyle(
                            color: B.theme.onSurfaceVariant,
                            fontSize: fontSize,
                            fontWeight: FontWeight.w400),
                        dropdownColor: B.theme.surfaceVariant,
                        elevation: 0,
                        isDense: true,
                        iconEnabledColor: B.theme.onSurfaceVariant,
                        value: B.currentTheme,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: themes.map((String items) {
                          return DropdownMenuItem(
                              value: items,
                              child: MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(textScaleFactor: B.isTablet ? 2.0 : 1.0),
                                child: Text(items).tr(),
                              ));
                        }).toList(),
                        onChanged: (String? newValue) {
                          // I need to relearn Bloc and reImplement this :(
                          int c;
                          newValue == 'Light'
                              ? {
                                  c = 0,
                                  B.themeController.setThemeMode(ThemeMode.light),
                                  B.themeMode = ThemeMode.light
                                }
                              : newValue == 'Dark'
                                  ? {
                                      c = 1,
                                      B.themeController.setThemeMode(ThemeMode.dark),
                                      B.themeMode = ThemeMode.dark
                                    }
                                  : {
                                      c = 2,
                                      B.themeController.setThemeMode(ThemeMode.system),
                                      B.themeMode = ThemeMode.system
                                    };
                          B.currentTheme = newValue!;
                          B.box.put("themeMode", c);
                          B.prefsChanged();
                        },
                      )),
                ),
              ),
              B.divider(),
              ThemePopupMenu(
                textColor: B.theme.onSurfaceVariant,
                isTablet: B.isTablet,
                schemeIndex: B.themeController.schemeIndex,
                onChanged: (value) {
                  B.themeController.setSchemeIndex(value);
                  B.prefsChanged();
                },
              ),
              B.divider(),
              SizedBox(
                height: height,
                child: Center(
                  child: ListTile(
                      title: Text(
                        "Dynamic Colors".tr(),
                        style: TextStyle(
                            fontSize: title,
                            fontWeight: FontWeight.w400,
                            color: B.theme.onSurfaceVariant),
                      ),
                      subtitle: Text(
                        "DC".tr(),
                        style: TextStyle(
                            fontSize: subtitle,
                            fontWeight: FontWeight.w300,
                            color: B.theme.onSurfaceVariant),
                      ),
                      trailing: SwitcherButton(
                        onColor: B.colorful ? B.colors[8] : primaryColor,
                        offColor: B.theme.primaryContainer,
                        size: switchSize,
                        value: B.box.get("isDynamic") ?? false,
                        onChange: (bool value) {
                          B.box.put("isDynamic", value);
                          B.prefsChanged();
                        },
                      )),
                ),
              ),
              B.divider(),
              SizedBox(
                height: height,
                child: Center(
                  child: ListTile(
                      title: Text(
                        "Darker Colors".tr(),
                        style: TextStyle(
                            fontSize: title,
                            fontWeight: FontWeight.w400,
                            color: B.theme.onSurfaceVariant),
                      ),
                      subtitle: Text(
                        "sDarker Colors".tr(),
                        style: TextStyle(
                            fontSize: subtitle,
                            fontWeight: FontWeight.w300,
                            color: B.theme.onSurfaceVariant),
                      ),
                      trailing: SwitcherButton(
                        onColor: B.colorful ? B.colors[6] : primaryColor,
                        offColor: B.theme.primaryContainer,
                        size: switchSize,
                        value: B.darkColors,
                        onChange: (bool value) {
                          B.box.put("darkColors", value);
                          B.darkColors = value;
                          B.prefsChanged();
                        },
                      )),
                ),
              ),
              B.divider(),
              SizedBox(
                height: height,
                child: Center(
                  child: ListTile(
                      title: Text(
                        "harmonize Colors".tr(),
                        style: TextStyle(
                            fontSize: title,
                            fontWeight: FontWeight.w400,
                            color: B.theme.onSurfaceVariant),
                      ),
                      subtitle: Text(
                        "sHarmonizeColors".tr(),
                        style: TextStyle(
                            fontSize: subtitle,
                            fontWeight: FontWeight.w300,
                            color: B.theme.onSurfaceVariant),
                      ),
                      trailing: SwitcherButton(
                        onColor: B.colorful ? B.colors[4] : primaryColor,
                        offColor: B.theme.primaryContainer,
                        size: switchSize,
                        value: B.harmonizeColor,
                        onChange: (bool value) {
                          B.box.put("harmonizeColor", value);
                          B.harmonizeColor = value;
                          B.harmonizeColors();
                          B.prefsChanged();
                        },
                      )),
                ),
              ),
              B.divider(),
              SizedBox(
                height: height,
                child: Center(
                  child: ListTile(
                      title: Text(
                        "Colorful".tr(),
                        style: TextStyle(
                            fontSize: title,
                            fontWeight: FontWeight.w400,
                            color: B.theme.onSurfaceVariant),
                      ),
                      subtitle: Text(
                        "sColorful".tr(),
                        style: TextStyle(
                            fontSize: subtitle,
                            fontWeight: FontWeight.w300,
                            color: B.theme.onSurfaceVariant),
                      ),
                      trailing: SwitcherButton(
                        onColor: B.colorful ? B.colors[8] : primaryColor,
                        offColor: B.theme.primaryContainer,
                        size: switchSize,
                        value: B.colorful,
                        onChange: (bool value) {
                          B.box.put("colorful", value);
                          B.colorful = value;
                          B.prefsChanged();
                        },
                      )),
                ),
              ),
              B.divider(),
              SizedBox(
                height: height,
                child: Center(
                  child: ListTile(
                      title: Text(
                        "Show Date".tr(),
                        style: TextStyle(
                            fontSize: title,
                            fontWeight: FontWeight.w400,
                            color: B.theme.onSurfaceVariant),
                      ),
                      subtitle: Text(
                        "sShow Date".tr(),
                        style: TextStyle(
                            fontSize: subtitle,
                            fontWeight: FontWeight.w300,
                            color: B.theme.onSurfaceVariant),
                      ),
                      trailing: SwitcherButton(
                        onColor: B.colorful ? B.colors[0] : primaryColor,
                        offColor: B.theme.primaryContainer,
                        // offColor: Theme.of(context).primaryColorDark,
                        size: switchSize,
                        value: B.showDate,
                        onChange: (bool value) {
                          B.box.put("showDate", value);
                          B.showDate = value;
                          B.prefsChanged();
                        },
                      )),
                ),
              ),
              B.divider(),
              SizedBox(
                height: height,
                child: Center(
                  child: ListTile(
                      title: Text(
                        "Show Edited".tr(),
                        style: TextStyle(
                            fontSize: title,
                            fontWeight: FontWeight.w400,
                            color: B.theme.onSurfaceVariant),
                      ),
                      subtitle: Text(
                        "sShow Edited".tr(),
                        style: TextStyle(
                            fontSize: subtitle,
                            fontWeight: FontWeight.w300,
                            color: B.theme.onSurfaceVariant),
                      ),
                      trailing: SwitcherButton(
                        onColor: B.colorful ? B.colors[2] : primaryColor,
                        offColor: B.theme.primaryContainer,
                        size: switchSize,
                        value: B.showEdited,
                        onChange: (bool value) {
                          B.box.put("showEdit", value);
                          B.showEdited = value;
                          B.prefsChanged();
                        },
                      )),
                ),
              ),
              B.divider(),
              SizedBox(
                height: height,
                child: Center(
                  child: ListTile(
                      title: Text(
                        "Show Shadow".tr(),
                        style: TextStyle(
                            fontSize: title,
                            fontWeight: FontWeight.w400,
                            color: B.theme.onSurfaceVariant),
                      ),
                      subtitle: Text(
                        "sShow Shadow".tr(),
                        style: TextStyle(
                            fontSize: subtitle,
                            fontWeight: FontWeight.w300,
                            color: B.theme.onSurfaceVariant),
                      ),
                      trailing: SwitcherButton(
                        onColor: B.colorful ? B.colors[1] : primaryColor,
                        offColor: B.theme.primaryContainer,
                        size: switchSize,
                        value: B.showShadow,
                        onChange: (bool value) {
                          B.box.put("showShadow", value);
                          B.showShadow = value;
                          B.prefsChanged();
                        },
                      )),
                ),
              ),
              B.divider(),
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

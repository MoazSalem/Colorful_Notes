import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:notes/Screens/home_screen.dart';
import 'package:notes/Widgets/theme_popup_menu.dart';
import 'package:notes/main.dart';
import 'package:switcher_button/switcher_button.dart';
import 'package:notes/Cubit/notes_cubit.dart';

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
    height = C.isTablet ? 120 : 80;
    title = C.isTablet ? 26 : 22;
    subtitle = C.isTablet ? 16 : 12;
    switchSize = C.isTablet ? 100 : 50;
    iconSize = C.isTablet ? 40 : 10.0;
    itemHeight = C.isTablet ? 80 : 50.0;
    fontSize = C.isTablet ? 10 : 14;
    sB = C.sbIndex == 0
        ? "Top Left"
        : C.sbIndex == 1
            ? "Bottom Left"
            : C.sbIndex == 2
                ? "Top Right"
                : "Bottom Right";
    fabLoc = C.fabIndex == 0 ? "Right" : "Left";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesCubit, NotesState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor:
              C.isDarkMode ? C.theme.background : C.theme.surfaceVariant.withOpacity(0.6),
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              C.customAppBar("Settings".tr(), 65),
              SizedBox(
                height: height,
                child: Center(
                  child: ListTile(
                    title: Text(
                      "Language".tr(),
                      style: TextStyle(
                          fontSize: title,
                          fontWeight: FontWeight.w400,
                          color: C.theme.onSurfaceVariant),
                    ),
                    subtitle: Text(
                      "sLanguage".tr(),
                      style: TextStyle(
                          fontSize: subtitle,
                          fontWeight: FontWeight.w300,
                          color: C.theme.onSurfaceVariant),
                    ),
                    trailing: DropdownButton(
                      iconSize: iconSize,
                      itemHeight: itemHeight,
                      borderRadius: BorderRadius.circular(10),
                      alignment: Alignment.center,
                      underline: Container(),
                      style: TextStyle(
                          color: C.theme.onSurfaceVariant,
                          fontSize: fontSize,
                          fontWeight: FontWeight.w400),
                      dropdownColor: C.theme.surfaceVariant,
                      elevation: 0,
                      isDense: true,
                      iconEnabledColor: C.theme.onSurfaceVariant,
                      value: C.lang == 'en' ? "English" : "Arabic",
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: lang.map((String items) {
                        return DropdownMenuItem(
                            value: items,
                            child: MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(textScaleFactor: C.isTablet ? 2.0 : 1.0),
                              child: Text(items).tr(),
                            ));
                      }).toList(),
                      onChanged: (String? newValue) {
                        C.lang = newValue! == 'English' ? 'en' : 'ar';
                        context.setLocale(Locale(C.lang));
                        C.lang = context.locale.toString();
                        C.prefsChanged();
                      },
                    ),
                  ),
                ),
              ),
              C.divider(),
              SizedBox(
                height: height,
                child: Center(
                  child: ListTile(
                      title: Text(
                        "Start In".tr(),
                        style: TextStyle(
                            fontSize: title,
                            fontWeight: FontWeight.w400,
                            color: C.theme.onSurfaceVariant),
                      ),
                      subtitle: Text(
                        "sStart In".tr(),
                        style: TextStyle(
                            fontSize: subtitle,
                            fontWeight: FontWeight.w300,
                            color: C.theme.onSurfaceVariant),
                      ),
                      trailing: DropdownButton(
                        iconSize: iconSize,
                        itemHeight: itemHeight,
                        borderRadius: BorderRadius.circular(10),
                        alignment: Alignment.center,
                        underline: Container(),
                        style: TextStyle(
                            color: C.theme.onSurfaceVariant,
                            fontSize: fontSize,
                            fontWeight: FontWeight.w400),
                        dropdownColor: C.theme.surfaceVariant,
                        elevation: 0,
                        isDense: true,
                        iconEnabledColor: C.theme.onSurfaceVariant,
                        value: C.openPage,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: pages.map((String items) {
                          return DropdownMenuItem(
                              value: items,
                              child: MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(textScaleFactor: C.isTablet ? 2.0 : 1.0),
                                child: Text(items).tr(),
                              ));
                        }).toList(),
                        onChanged: (String? newValue) {
                          C.box.put(
                              "Pages",
                              newValue! == 'Home'
                                  ? 'Home'
                                  : newValue == 'Text'
                                      ? 'Text'
                                      : 'Voice');
                          C.openPage = newValue;
                          C.prefsChanged();
                        },
                      )),
                ),
              ),
              C.divider(),
              SizedBox(
                height: height,
                child: Center(
                  child: ListTile(
                      title: Text(
                        "Side Bar".tr(),
                        style: TextStyle(
                            fontSize: title,
                            fontWeight: FontWeight.w400,
                            color: C.theme.onSurfaceVariant),
                      ),
                      subtitle: Text(
                        "sSide Bar".tr(),
                        style: TextStyle(
                            fontSize: subtitle,
                            fontWeight: FontWeight.w300,
                            color: C.theme.onSurfaceVariant),
                      ),
                      trailing: DropdownButton(
                        iconSize: iconSize,
                        itemHeight: itemHeight,
                        borderRadius: BorderRadius.circular(10),
                        alignment: Alignment.center,
                        underline: Container(),
                        style: TextStyle(
                            color: C.theme.onSurfaceVariant,
                            fontSize: fontSize,
                            fontWeight: FontWeight.w400),
                        dropdownColor: C.theme.surfaceVariant,
                        elevation: 0,
                        isDense: true,
                        iconEnabledColor: C.theme.onSurfaceVariant,
                        value: sB,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: sb.map((String items) {
                          return DropdownMenuItem(
                              value: items,
                              child: MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(textScaleFactor: C.isTablet ? 2.0 : 1.0),
                                child: Text(items).tr(),
                              ));
                        }).toList(),
                        onChanged: (String? newValue) {
                          newValue == 'Top Left'
                              ? C.sbIndex = 0
                              : newValue == 'Bottom Left'
                                  ? C.sbIndex = 1
                                  : newValue == 'Top Right'
                                      ? C.sbIndex = 2
                                      : C.sbIndex = 3;
                          sB = newValue!;
                          C.box.put("sbIndex", C.sbIndex);
                          C.prefsChanged();
                        },
                      )),
                ),
              ),
              C.divider(),
              SizedBox(
                height: height,
                child: Center(
                  child: ListTile(
                      title: Text(
                        "Create Button".tr(),
                        style: TextStyle(
                            fontSize: title,
                            fontWeight: FontWeight.w400,
                            color: C.theme.onSurfaceVariant),
                      ),
                      subtitle: Text(
                        "sCreate Button".tr(),
                        style: TextStyle(
                            fontSize: subtitle,
                            fontWeight: FontWeight.w300,
                            color: C.theme.onSurfaceVariant),
                      ),
                      trailing: DropdownButton(
                        iconSize: iconSize,
                        itemHeight: itemHeight,
                        borderRadius: BorderRadius.circular(10),
                        alignment: Alignment.center,
                        underline: Container(),
                        style: TextStyle(
                            color: C.theme.onSurfaceVariant,
                            fontSize: fontSize,
                            fontWeight: FontWeight.w400),
                        dropdownColor: C.theme.surfaceVariant,
                        elevation: 0,
                        isDense: true,
                        iconEnabledColor: C.theme.onSurfaceVariant,
                        value: fabLoc,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: fab.map((String items) {
                          return DropdownMenuItem(
                              value: items,
                              child: MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(textScaleFactor: C.isTablet ? 2.0 : 1.0),
                                child: Text(items).tr(),
                              ));
                        }).toList(),
                        onChanged: (String? newValue) {
                          newValue == 'Right' ? C.fabIndex = 0 : C.fabIndex = 1;
                          fabLoc = newValue!;
                          C.box.put("fabIndex", C.fabIndex);
                          C.prefsChanged();
                        },
                      )),
                ),
              ),
              C.divider(),
              SizedBox(
                height: height,
                child: Center(
                  child: ListTile(
                      title: Text(
                        "App Theme".tr(),
                        style: TextStyle(
                            fontSize: title,
                            fontWeight: FontWeight.w400,
                            color: C.theme.onSurfaceVariant),
                      ),
                      subtitle: Text(
                        "sApp Theme".tr(),
                        style: TextStyle(
                            fontSize: subtitle,
                            fontWeight: FontWeight.w300,
                            color: C.theme.onSurfaceVariant),
                      ),
                      trailing: DropdownButton(
                        iconSize: iconSize,
                        itemHeight: itemHeight,
                        borderRadius: BorderRadius.circular(10),
                        alignment: Alignment.center,
                        underline: Container(),
                        style: TextStyle(
                            color: C.theme.onSurfaceVariant,
                            fontSize: fontSize,
                            fontWeight: FontWeight.w400),
                        dropdownColor: C.theme.surfaceVariant,
                        elevation: 0,
                        isDense: true,
                        iconEnabledColor: C.theme.onSurfaceVariant,
                        value: C.currentTheme,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        items: themes.map((String items) {
                          return DropdownMenuItem(
                              value: items,
                              child: MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(textScaleFactor: C.isTablet ? 2.0 : 1.0),
                                child: Text(items).tr(),
                              ));
                        }).toList(),
                        onChanged: (String? newValue) {
                          // I need to relearn Bloc and reImplement this :(
                          int c;
                          newValue == 'Light'
                              ? {
                                  c = 0,
                                  C.themeController.setThemeMode(ThemeMode.light),
                                  C.themeMode = ThemeMode.light
                                }
                              : newValue == 'Dark'
                                  ? {
                                      c = 1,
                                      C.themeController.setThemeMode(ThemeMode.dark),
                                      C.themeMode = ThemeMode.dark
                                    }
                                  : {
                                      c = 2,
                                      C.themeController.setThemeMode(ThemeMode.system),
                                      C.themeMode = ThemeMode.system
                                    };
                          C.currentTheme = newValue!;
                          C.box.put("themeMode", c);
                          C.prefsChanged();
                        },
                      )),
                ),
              ),
              C.divider(),
              ThemePopupMenu(
                textColor: C.theme.onSurfaceVariant,
                isTablet: C.isTablet,
                schemeIndex: C.themeController.schemeIndex,
                onChanged: (value) {
                  C.themeController.setSchemeIndex(value);
                  C.prefsChanged();
                },
              ),
              C.divider(),
              SizedBox(
                height: height,
                child: Center(
                  child: ListTile(
                      title: Text(
                        "Dynamic Colors".tr(),
                        style: TextStyle(
                            fontSize: title,
                            fontWeight: FontWeight.w400,
                            color: C.theme.onSurfaceVariant),
                      ),
                      subtitle: Text(
                        "DC".tr(),
                        style: TextStyle(
                            fontSize: subtitle,
                            fontWeight: FontWeight.w300,
                            color: C.theme.onSurfaceVariant),
                      ),
                      trailing: SwitcherButton(
                        onColor: C.colorful ? C.colors[8] : primaryColor,
                        offColor: C.theme.primaryContainer,
                        size: switchSize,
                        value: C.box.get("isDynamic") ?? false,
                        onChange: (bool value) {
                          C.box.put("isDynamic", value);
                          C.prefsChanged();
                        },
                      )),
                ),
              ),
              C.divider(),
              SizedBox(
                height: height,
                child: Center(
                  child: ListTile(
                      title: Text(
                        "Darker Colors".tr(),
                        style: TextStyle(
                            fontSize: title,
                            fontWeight: FontWeight.w400,
                            color: C.theme.onSurfaceVariant),
                      ),
                      subtitle: Text(
                        "sDarker Colors".tr(),
                        style: TextStyle(
                            fontSize: subtitle,
                            fontWeight: FontWeight.w300,
                            color: C.theme.onSurfaceVariant),
                      ),
                      trailing: SwitcherButton(
                        onColor: C.colorful ? C.colors[6] : primaryColor,
                        offColor: C.theme.primaryContainer,
                        size: switchSize,
                        value: C.darkColors,
                        onChange: (bool value) {
                          C.box.put("darkColors", value);
                          C.darkColors = value;
                          C.prefsChanged();
                        },
                      )),
                ),
              ),
              C.divider(),
              SizedBox(
                height: C.isTablet ? 140 : 100,
                child: Center(
                  child: ListTile(
                      title: Text(
                        "harmonize Colors".tr(),
                        style: TextStyle(
                            fontSize: title,
                            fontWeight: FontWeight.w400,
                            color: C.theme.onSurfaceVariant),
                      ),
                      subtitle: Text(
                        "sHarmonizeColors".tr(),
                        style: TextStyle(
                            fontSize: subtitle,
                            fontWeight: FontWeight.w300,
                            color: C.theme.onSurfaceVariant),
                      ),
                      trailing: SwitcherButton(
                        onColor: C.colorful ? C.colors[4] : primaryColor,
                        offColor: C.theme.primaryContainer,
                        size: switchSize,
                        value: C.harmonizeColor,
                        onChange: (bool value) {
                          C.box.put("harmonizeColor", value);
                          C.harmonizeColor = value;
                          C.harmonizeColors();
                          C.prefsChanged();
                        },
                      )),
                ),
              ),
              C.divider(),
              SizedBox(
                height: height,
                child: Center(
                  child: ListTile(
                      title: Text(
                        "Colorful".tr(),
                        style: TextStyle(
                            fontSize: title,
                            fontWeight: FontWeight.w400,
                            color: C.theme.onSurfaceVariant),
                      ),
                      subtitle: Text(
                        "sColorful".tr(),
                        style: TextStyle(
                            fontSize: subtitle,
                            fontWeight: FontWeight.w300,
                            color: C.theme.onSurfaceVariant),
                      ),
                      trailing: SwitcherButton(
                        onColor: C.colorful ? C.colors[8] : primaryColor,
                        offColor: C.theme.primaryContainer,
                        size: switchSize,
                        value: C.colorful,
                        onChange: (bool value) {
                          C.box.put("colorful", value);
                          C.colorful = value;
                          C.prefsChanged();
                        },
                      )),
                ),
              ),
              C.divider(),
              SizedBox(
                height: height,
                child: Center(
                  child: ListTile(
                      title: Text(
                        "Show Date".tr(),
                        style: TextStyle(
                            fontSize: title,
                            fontWeight: FontWeight.w400,
                            color: C.theme.onSurfaceVariant),
                      ),
                      subtitle: Text(
                        "sShow Date".tr(),
                        style: TextStyle(
                            fontSize: subtitle,
                            fontWeight: FontWeight.w300,
                            color: C.theme.onSurfaceVariant),
                      ),
                      trailing: SwitcherButton(
                        onColor: C.colorful ? C.colors[0] : primaryColor,
                        offColor: C.theme.primaryContainer,
                        // offColor: Theme.of(context).primaryColorDark,
                        size: switchSize,
                        value: C.showDate,
                        onChange: (bool value) {
                          C.box.put("showDate", value);
                          C.showDate = value;
                          C.prefsChanged();
                        },
                      )),
                ),
              ),
              C.divider(),
              SizedBox(
                height: height,
                child: Center(
                  child: ListTile(
                      title: Text(
                        "Show Edited".tr(),
                        style: TextStyle(
                            fontSize: title,
                            fontWeight: FontWeight.w400,
                            color: C.theme.onSurfaceVariant),
                      ),
                      subtitle: Text(
                        "sShow Edited".tr(),
                        style: TextStyle(
                            fontSize: subtitle,
                            fontWeight: FontWeight.w300,
                            color: C.theme.onSurfaceVariant),
                      ),
                      trailing: SwitcherButton(
                        onColor: C.colorful ? C.colors[2] : primaryColor,
                        offColor: C.theme.primaryContainer,
                        size: switchSize,
                        value: C.showEdited,
                        onChange: (bool value) {
                          C.box.put("showEdit", value);
                          C.showEdited = value;
                          C.prefsChanged();
                        },
                      )),
                ),
              ),
              C.divider(),
              SizedBox(
                height: height,
                child: Center(
                  child: ListTile(
                      title: Text(
                        "Show Shadow".tr(),
                        style: TextStyle(
                            fontSize: title,
                            fontWeight: FontWeight.w400,
                            color: C.theme.onSurfaceVariant),
                      ),
                      subtitle: Text(
                        "sShow Shadow".tr(),
                        style: TextStyle(
                            fontSize: subtitle,
                            fontWeight: FontWeight.w300,
                            color: C.theme.onSurfaceVariant),
                      ),
                      trailing: SwitcherButton(
                        onColor: C.colorful ? C.colors[1] : primaryColor,
                        offColor: C.theme.primaryContainer,
                        size: switchSize,
                        value: C.showShadow,
                        onChange: (bool value) {
                          C.box.put("showShadow", value);
                          C.showShadow = value;
                          C.prefsChanged();
                        },
                      )),
                ),
              ),
              C.divider(),
              SizedBox(
                height: height,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          C.bDialog(context);
                        },
                        child: Text(
                          "Backup".tr(),
                          style: TextStyle(
                              fontSize: 20, color: C.colorful ? C.colors[3] : C.theme.primary),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            C.rDialog(context);
                          },
                          child: Text("Restore".tr(),
                              style: TextStyle(
                                  fontSize: 20,
                                  color: C.colorful ? C.colors[4] : C.theme.secondary))),
                    ],
                  ),
                ),
              ),
              C.divider(),
            ],
          ),
        );
      },
    );
  }
}

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
    sB = C.settings["sbIndex"] == 0
        ? "Top Left"
        : C.settings["sbIndex"] == 1
            ? "Bottom Left"
            : C.settings["sbIndex"] == 2
                ? "Top Right"
                : "Bottom Right";
    fabLoc = C.settings["fabIndex"] == 0 ? "Right" : "Left";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesCubit, NotesState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: C.isDark
              ? C.theme.background
              : C.theme.surfaceVariant.withOpacity(0.6),
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
                      value: C.settings["lang"] == 'en' ? "English" : "Arabic",
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
                        C.settings["lang"] = newValue! == 'English' ? 'en' : 'ar';
                        context.setLocale(Locale(C.settings["lang"]));
                        C.settings["lang"] = context.locale.toString();
                        C.onChanged();
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
                        value: C.settings["openPage"],
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
                        onChanged: (newValue) {
                          C.box.put(
                              "Pages",
                              newValue! == 'Home'
                                  ? 'Home'
                                  : newValue == 'Text'
                                      ? 'Text'
                                      : 'Voice');
                          C.settings["openPage"] = newValue;
                          C.onChanged();
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
                              ? C.settings["sbIndex"] = 0
                              : newValue == 'Bottom Left'
                                  ? C.settings["sbIndex"] = 1
                                  : newValue == 'Top Right'
                                      ? C.settings["sbIndex"] = 2
                                      : C.settings["sbIndex"] = 3;
                          sB = newValue!;
                          C.box.put("sbIndex", C.settings["sbIndex"]);
                          C.onChanged();
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
                          newValue == 'Right'
                              ? C.settings["fabIndex"] = 0
                              : C.settings["fabIndex"] = 1;
                          fabLoc = newValue!;
                          C.box.put("fabIndex", C.settings["fabIndex"]);
                          C.onChanged();
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
                        value: C.settings["currentTheme"] == ThemeMode.light
                            ? "Light"
                            : C.settings["currentTheme"] == ThemeMode.dark
                                ? "Dark"
                                : "System",
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
                        onChanged: (newValue) {
                          newValue == 'Light'
                              ? {
                                  C.themeController.setThemeMode(ThemeMode.light),
                                  C.settings["currentTheme"] = ThemeMode.light
                                }
                              : newValue == 'Dark'
                                  ? {
                                      C.themeController.setThemeMode(ThemeMode.dark),
                                      C.settings["currentTheme"] = ThemeMode.dark
                                    }
                                  : {
                                      C.themeController.setThemeMode(ThemeMode.system),
                                      C.settings["currentTheme"] = ThemeMode.system
                                    };
                          C.onChanged();
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
                  C.onChanged();
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
                        onColor: C.settings["colorful"] ? C.colors[8] : primaryColor,
                        offColor: C.theme.primaryContainer,
                        size: switchSize,
                        value: C.box.get("isDynamic") ?? false,
                        onChange: (bool value) {
                          C.box.put("isDynamic", value);
                          C.onChanged();
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
                        onColor: C.settings["colorful"] ? C.colors[6] : primaryColor,
                        offColor: C.theme.primaryContainer,
                        size: switchSize,
                        value: C.settings["darkColors"],
                        onChange: (bool value) {
                          C.box.put("darkColors", value);
                          C.settings["darkColors"] = value;
                          C.onChanged();
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
                        onColor: C.settings["colorful"] ? C.colors[4] : primaryColor,
                        offColor: C.theme.primaryContainer,
                        size: switchSize,
                        value: C.settings["harmonizeColor"],
                        onChange: (bool value) {
                          C.box.put("harmonizeColor", value);
                          C.settings["harmonizeColor"] = value;
                          C.harmonizeColors();
                          C.onChanged();
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
                        onColor: C.settings["colorful"] ? C.colors[8] : primaryColor,
                        offColor: C.theme.primaryContainer,
                        size: switchSize,
                        value: C.settings["colorful"],
                        onChange: (bool value) {
                          C.box.put("colorful", value);
                          C.settings["colorful"] = value;
                          C.onChanged();
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
                        onColor: C.settings["colorful"] ? C.colors[0] : primaryColor,
                        offColor: C.theme.primaryContainer,
                        // offColor: Theme.of(context).primaryColorDark,
                        size: switchSize,
                        value: C.settings["showDate"],
                        onChange: (bool value) {
                          C.box.put("showDate", value);
                          C.settings["showDate"] = value;
                          C.onChanged();
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
                        onColor: C.settings["colorful"] ? C.colors[2] : primaryColor,
                        offColor: C.theme.primaryContainer,
                        size: switchSize,
                        value: C.settings["showEdited"],
                        onChange: (bool value) {
                          C.box.put("showEdit", value);
                          C.settings["showEdited"] = value;
                          C.onChanged();
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
                        onColor: C.settings["colorful"] ? C.colors[1] : primaryColor,
                        offColor: C.theme.primaryContainer,
                        size: switchSize,
                        value: C.settings["showShadow"],
                        onChange: (bool value) {
                          C.box.put("showShadow", value);
                          C.settings["showShadow"] = value;
                          C.onChanged();
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
                              fontSize: 20,
                              color: C.settings["colorful"] ? C.colors[3] : C.theme.primary),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            C.rDialog(context);
                          },
                          child: Text("Restore".tr(),
                              style: TextStyle(
                                  fontSize: 20,
                                  color:
                                      C.settings["colorful"] ? C.colors[4] : C.theme.secondary))),
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

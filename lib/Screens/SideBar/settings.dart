import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:notes/Bloc/notes_bloc.dart';
import 'package:notes/Screens/home_screen.dart';
import 'package:notes/Widgets/notes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:switcher_button/switcher_button.dart';

late String dropDownTheme;
var lang = ["English", "Arabic"];
var themes = ["Light", "Dark", "System"];
var pages = ["Home", "Text", "Voice"];

class SettingsPage extends StatelessWidget {
  final String currentTheme;

  const SettingsPage({Key? key, required this.currentTheme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    banner1.load();
    AdWidget adWidget = AdWidget(ad: banner1);
    return BlocConsumer<NotesBloc, NotesState>(
      listener: (context, state) {},
      builder: (context, state) {
        var B = NotesBloc.get(context);
        double height = B.isTablet ? 100 : 60;
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
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
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
                                data: MediaQuery.of(context).copyWith(textScaleFactor: isTablet ? 3.0 : 1.0),
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
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
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
                                  data: MediaQuery.of(context).copyWith(textScaleFactor: isTablet ? 3.0 : 1.0),
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
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
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
                                  data: MediaQuery.of(context).copyWith(textScaleFactor: isTablet ? 3.0 : 1.0),
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
                          "Show Date".tr(),
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
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
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
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
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
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
              SizedBox(
                height: height,
                child: Center(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: () {
                              B.backUp();
                            },
                            child: Text(
                              "Backup",
                              style: TextStyle(fontSize: 24, color: B.colors[3]),
                            ),
                          ),
                          TextButton(onPressed: () {}, child: Text("Restore", style: TextStyle(fontSize: 24, color: B.colors[4]))),
                        ],
                      )),
                ),
              ),
              B.divider(context),
            ],
          ),
        );
      },
    );
  }
}

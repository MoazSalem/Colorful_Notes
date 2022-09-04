import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:notes/Screens/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    bool d1 = false;
    bool d2 = false;
    bool s1 = false;
    bool s2 = false;
    bool c1 = false;
    bool c2 = false;
    bool c3 = false;
    return Scaffold(
      body: ListView(
        children: [
          customAppBar("Settings",45),
          Padding(
            padding: const EdgeInsets.only(left: 35, bottom: 10, top: 10),
            child: Text(
              "Notes Date:",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    selected: d1,
                    onSelected: (value) async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool("showDate", true);
                      showDate = true;
                      setState(() {});
                    },
                    label: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Show"),
                    ),
                  ),
                ),
                ChoiceChip(
                  selected: d2,
                  onSelected: (value) async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool("showDate", false);
                    showDate = false;
                    setState(() {});
                  },
                  label: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Hide"),
                  ),
                ),
              ],
            ),
          ),
          divider(),
          Padding(
            padding: const EdgeInsets.only(left: 35, bottom: 10, top: 10),
            child: Text(
              "Drop Shadow:",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    selected: s1,
                    onSelected: (value) {
                      setState(() async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool("showShadow", true);
                        showShadow = true;
                        setState(() {});
                      });
                    },
                    label: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Show"),
                    ),
                  ),
                ),
                ChoiceChip(
                  selected: s2,
                  onSelected: (value) async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool("showShadow", false);
                    showShadow = false;
                    setState(() {});
                  },
                  label: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Hide"),
                  ),
                ),
              ],
            ),
          ),
          divider(),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 35, bottom: 10),
            child: Text(
              "App Theme:",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ChoiceChip(
                  selected: c1,
                  onSelected: (value) {
                    setState(() {
                      AdaptiveTheme.of(context).setLight();
                      c1 = value;
                      c2 = !value;
                      c3 = !value;
                    });
                  },
                  label: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Light Theme"),
                  ),
                ),
              ),
              ChoiceChip(
                selected: c2,
                onSelected: (value) {
                  setState(() {
                    AdaptiveTheme.of(context).setDark();
                    c1 = !value;
                    c2 = value;
                    c3 = !value;
                  });
                },
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Dark Theme"),
                ),
              ),
            ],
          ),
          ChoiceChip(
            selected: c3,
            onSelected: (value) {
              setState(() {
                AdaptiveTheme.of(context).setSystem();
                c1 = !value;
                c2 = !value;
                c3 = value;
              });
            },
            label: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("System Defalut"),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          divider()
        ],
      ),
    );
  }
}

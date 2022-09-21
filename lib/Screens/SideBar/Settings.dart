import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/Bloc/notes_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool d1 = false;
    bool d2 = false;
    bool s1 = false;
    bool s2 = false;
    bool c1 = false;
    bool c2 = false;
    bool c3 = false;
    return BlocConsumer<NotesBloc, NotesState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var B = NotesBloc.get(context);
        return Scaffold(
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              B.customAppBar(context,"Settings", 66),
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
                          B.showDate = true;
                          B.prefsChanged();
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
                        B.showDate = false;
                        B.prefsChanged();
                      },
                      label: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Hide"),
                      ),
                    ),
                  ],
                ),
              ),
              B.divider(context),
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
                        onSelected: (value) async{
                            final prefs = await SharedPreferences
                                .getInstance();
                            await prefs.setBool("showShadow", true);
                            B.showShadow = true;
                            B.prefsChanged();
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
                        B.showShadow = false;
                        B.prefsChanged();
                      },
                      label: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Hide"),
                      ),
                    ),
                  ],
                ),
              ),
              B.divider(context),
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
                          AdaptiveTheme.of(context).setLight();
                          c1 = value;
                          c2 = !value;
                          c3 = !value;
                          B.prefsChanged();
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
                        AdaptiveTheme.of(context).setDark();
                        c1 = !value;
                        c2 = value;
                        c3 = !value;
                        B.prefsChanged();
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
                    AdaptiveTheme.of(context).setSystem();
                    c1 = !value;
                    c2 = !value;
                    c3 = value;
                    B.prefsChanged();
                },
                label: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("System Defalut"),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              B.divider(context)
            ],
          ),
        );
      },
    );
  }
}

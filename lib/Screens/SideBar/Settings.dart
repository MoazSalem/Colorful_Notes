import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override

  Widget build(BuildContext context) {
    bool c1 = false;
    bool c2 = false;
    bool c3 = false;
    return Scaffold(
      body: ListView(children: [Padding(
        padding:
        const EdgeInsets.only(left: 30, bottom: 20, top: 60),
        child: Text(
          "Settings",
          style: TextStyle(
              fontSize: 50, fontWeight: FontWeight.bold),
        ),
      ),
        Padding(
          padding: const EdgeInsets.only(left: 35,bottom: 20),
          child: Text("App Theme:",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w400),),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center,children: [ChoiceChip(selected:c1 ,onSelected: (value){setState(() {
          AdaptiveTheme.of(context).setLight();
          c1 = value;
          c2 = !value;
          c3 = !value;
        });}, label: Text("Light Theme"),),
          SizedBox(width: 20,),ChoiceChip(selected:c2 ,onSelected: (value){setState(() {
            AdaptiveTheme.of(context).setDark();
            c1 = !value;
            c2 = value;
            c3 = !value;
          });}, label: Text("Dark Theme"),),],),
        ChoiceChip(selected:c3 ,onSelected: (value){setState(() {
          AdaptiveTheme.of(context).setSystem();
          c1 = !value;
          c2 = !value;
          c3 = value;
        });}, label: Text("System Defalut"),)],),
    );
  }
}

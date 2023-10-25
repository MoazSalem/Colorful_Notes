import 'dart:ui';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:home_widget/home_widget.dart';

class HomeWidgetConfig {
  static Future<void> update(context,
      {required List<Map<dynamic, dynamic>> notes, required List<Color> color}) async {
    String titles = "";
    String contents = "";
    String colors = "";
    String layouts = "";
    for (int i = 0; i < notes.length; i++) {
      titles += notes[i]['title'];
      contents += notes[i]['content'];
      colors += notes[i]['cindex'] == 99
          ? Color(int.parse(notes[i]['extra'])).hex.toString()
          : color[notes[i]['cindex']].hex.toString();
      layouts += notes[i]['layout'].toString();
      // add separator if not last note
      if (i < notes.length - 1) {
        titles += "||S||";
        contents += "||S||";
        colors += "||S||";
        layouts += "||S||";
      }
    }
    await HomeWidget.saveWidgetData('titles', titles);
    await HomeWidget.saveWidgetData('contents', contents);
    await HomeWidget.saveWidgetData('colors', colors);
    await HomeWidget.saveWidgetData('layouts', layouts);
    await HomeWidget.updateWidget(androidName: "BigNoteWidget");
  }
}

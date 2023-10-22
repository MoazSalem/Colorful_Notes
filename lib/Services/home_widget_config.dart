import 'package:home_widget/home_widget.dart';

class HomeWidgetConfig {
  static Future<void> update(context,
      {required String title, required String content, required String color}) async {
    await HomeWidget.saveWidgetData('title', title);
    await HomeWidget.saveWidgetData('content', content);
    await HomeWidget.saveWidgetData('color', color);
    await HomeWidget.updateWidget(androidName: "BigNoteWidget");
  }
}

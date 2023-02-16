import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:notes/Widgets/sound_player.dart';

bool isTablet = getDeviceType() == 'tablet' ? true : false;

Widget listView({
  required BuildContext context,
  required List<Map> notes,
  required List<Color> colors,
  required int reverseIndex,
  required int dateValue,
  required String date,
  required bool noTitle,
  required bool noContent,
  required bool showDate,
  required bool showShadow,
  required bool showEdited,
}) {
  String lang = context.locale.toString();
  double width = MediaQuery.of(context).size.width;
  return Center(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: showShadow ? width * 0.0051 : 0),
      child: Stack(alignment: Alignment.topRight, children: [
        SizedBox(
          height: isTablet ? width * 0.9 : width * 0.7639,
          child: Card(
            color: colors[notes[reverseIndex]['cindex']],
            elevation: showShadow ? 4 : 0,
            shadowColor: colors[notes[reverseIndex]['cindex']],
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: width * 0.05092, right: width * 0.05092, top: width * 0.07639, bottom: showDate ? width * 0.03819 : width * 0.02546),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                noTitle
                    ? Container()
                    : Expanded(
                        flex: 2,
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(notes[reverseIndex]["title"],
                              maxLines: notes[reverseIndex]["type"] == 0
                                  ? isTablet
                                      ? 2
                                      : 1
                                  : 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              textDirection: notes[reverseIndex]["layout"] == 0 || notes[reverseIndex]["layout"] == 2 ? TextDirection.ltr : TextDirection.rtl,
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 24, color: Colors.white)),
                        ),
                      ),
                notes[reverseIndex]["type"] == 0
                    ? Expanded(
                        flex: 7,
                        child: SizedBox(
                          width: double.infinity,
                          child: Text(
                              noContent
                                  ? notes[reverseIndex]["layout"] == 0
                                      ? "Empty"
                                      : "فارغ"
                                  : notes[reverseIndex]["content"],
                              textAlign: notes[reverseIndex]["layout"] == 1 || notes[reverseIndex]["layout"] == 2 ? TextAlign.right : TextAlign.left,
                              textDirection: notes[reverseIndex]["layout"] == 1 || notes[reverseIndex]["layout"] == 2 ? TextDirection.rtl : TextDirection.ltr,
                              maxLines: showDate
                                  ? isTablet
                                      ? 20
                                      : 8
                                  : isTablet
                                      ? 20
                                      : 9,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: noContent ? Colors.white38 : Colors.white, fontSize: noTitle ? 21 : 16)),
                        ),
                      )
                    : Expanded(
                        flex: noTitle ? 7 : 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: showDate
                                      ? noTitle
                                          ? width * 0.063657
                                          : 0
                                      : 0),
                              child: SoundPlayer(index: reverseIndex, voiceMap: notes, colors: colors, viewMode: 0),
                            ),
                          ],
                        ),
                      ),
                SizedBox(
                  height: width * 0.02546,
                ),
                showDate
                    ? Expanded(
                        child: Stack(
                          alignment: lang == 'en' ? Alignment.centerLeft : Alignment.centerRight,
                          children: [
                            Text(
                              dateValue == 0
                                  ? "Today".tr()
                                  : dateValue == -1
                                      ? "Yesterday".tr()
                                      : date,
                              style: const TextStyle(color: Colors.white),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  showEdited
                                      ? notes[reverseIndex]["edited"] == "yes"
                                          ? "Edited".tr()
                                          : ""
                                      : "",
                                  style: const TextStyle(color: Colors.white38),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    : Container(),
              ]),
            ),
          ),
        ),
      ]),
    ),
  );
}

Widget smallListView({
  required BuildContext context,
  required List<Map> notes,
  required List<Color> colors,
  required int reverseIndex,
  required int dateValue,
  required String date,
  required bool noTitle,
  required bool noContent,
  required bool showDate,
  required bool showShadow,
  required bool showEdited,
}) {
  String lang = context.locale.toString();
  double width = MediaQuery.of(context).size.width;
  return Center(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: showShadow ? width * 0.0051 : 0),
      child: Stack(alignment: Alignment.topCenter, children: [
        SizedBox(
          height: width * 0.2801,
          width: width,
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Card(
                color: colors[notes[reverseIndex]['cindex']],
                elevation: showShadow ? width * 0.01018 : 0,
                shadowColor: colors[notes[reverseIndex]['cindex']],
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                child: SizedBox(
                  width: width,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: notes[reverseIndex]["type"] == 0 ? width * 0.038194 : width * 0.01273,
                        right: noTitle ? width * 0.076388 : width * 0.05092,
                        top: notes[reverseIndex]["type"] == 0
                            ? noTitle
                                ? width * 0.035648
                                : width * 0.030555
                            : 0,
                        bottom: showDate ? 0.02546 : 0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      noTitle
                          ? Container()
                          : notes[reverseIndex]["type"] == 0
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      right: notes[reverseIndex]["layout"] == 0 || notes[reverseIndex]["layout"] == 2 ? width * 0.050926 : 0,
                                      left: notes[reverseIndex]["layout"] == 0 || notes[reverseIndex]["layout"] == 2 ? 0 : width * 0.050926),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: notes[reverseIndex]["layout"] == 0 ? 0 : width * 0.02546,
                                          bottom: notes[reverseIndex]["layout"] == 0
                                              ? 0
                                              : notes[reverseIndex]["layout"] == 2
                                                  ? width * 0.01273
                                                  : width * 0.02037),
                                      child: Text(notes[reverseIndex]["title"],
                                          strutStyle: StrutStyle(
                                            forceStrutHeight: notes[reverseIndex]["layout"] == 0 ? false : true,
                                          ),
                                          textAlign: notes[reverseIndex]["layout"] == 0 || notes[reverseIndex]["layout"] == 2 ? TextAlign.left : TextAlign.right,
                                          textDirection: notes[reverseIndex]["layout"] == 0 || notes[reverseIndex]["layout"] == 2 ? TextDirection.ltr : TextDirection.rtl,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 22, color: Colors.white)),
                                    ),
                                  ),
                                )
                              : Container(),
                      notes[reverseIndex]["type"] == 0
                          ? Expanded(
                              flex: noTitle ? 2 : 1,
                              child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: EdgeInsets.only(top: isTablet ? 8 : 0),
                                  child: Text(
                                      noContent
                                          ? notes[reverseIndex]["layout"] == 0
                                              ? "Empty"
                                              : "فارغ"
                                          : notes[reverseIndex]["content"],
                                      strutStyle: StrutStyle(
                                        forceStrutHeight: notes[reverseIndex]["layout"] == 0 || notes[reverseIndex]["layout"] == 1 ? false : true,
                                      ),
                                      textAlign: notes[reverseIndex]["layout"] == 1 || notes[reverseIndex]["layout"] == 2 ? TextAlign.right : TextAlign.left,
                                      textDirection: notes[reverseIndex]["layout"] == 1 || notes[reverseIndex]["layout"] == 2 ? TextDirection.rtl : TextDirection.ltr,
                                      maxLines: noTitle
                                          ? showDate
                                              ? isTablet
                                                  ? 4
                                                  : 2
                                              : isTablet
                                                  ? 4
                                                  : 3
                                          : showDate
                                              ? isTablet
                                                  ? 3
                                                  : 1
                                              : isTablet
                                                  ? 4
                                                  : 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: noContent ? Colors.white38 : Colors.white,
                                        fontSize: noTitle ? 21 : 16,
                                      )),
                                ),
                              ),
                            )
                          : Expanded(
                              flex: noTitle ? 2 : 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: width * 0.02037),
                                    child: SoundPlayer(index: reverseIndex, voiceMap: notes, colors: colors, viewMode: 1),
                                  ),
                                ],
                              ),
                            ),
                    ]),
                  ),
                ),
              ),
              showDate
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: width * 0.030555, horizontal: width * 0.050926),
                      child: Stack(
                        alignment: lang == 'en' ? Alignment.centerLeft : Alignment.centerRight,
                        children: [
                          Text(
                            dateValue == 0
                                ? "Today".tr()
                                : dateValue == -1
                                    ? "Yesterday".tr()
                                    : date,
                            style: const TextStyle(color: Colors.white),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                showEdited
                                    ? notes[reverseIndex]["edited"] == "yes"
                                        ? "Edited".tr()
                                        : ""
                                    : "",
                                style: const TextStyle(color: Colors.white38),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        noTitle
            ? Container()
            : Padding(
                padding: EdgeInsets.symmetric(vertical: showDate ? width * 0.03564 : width * 0.04074, horizontal: width * 0.203703),
                child: notes[reverseIndex]["type"] == 0
                    ? Container()
                    : Text(
                        notes[reverseIndex]["title"],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
              ),
      ]),
    ),
  );
}

Widget gridView({
  required BuildContext context,
  required List<Map> notes,
  required List<Color> colors,
  required int reverseIndex,
  required int dateValue,
  required String date,
  required bool noTitle,
  required bool noContent,
  required bool showDate,
  required bool showShadow,
  required bool showEdited,
}) {
  String lang = context.locale.toString();
  double width = MediaQuery.of(context).size.width;
  return Center(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: showShadow ? width * 0.0051 : 0),
      child: Stack(alignment: Alignment.topRight, children: [
        SizedBox(
          height: width * 0.4584,
          width: width * 0.4584,
          child: Card(
            color: colors[notes[reverseIndex]['cindex']],
            elevation: showShadow ? width * 0.01018 : 0,
            shadowColor: colors[notes[reverseIndex]['cindex']],
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  left: width * 0.03819,
                  right: width * 0.050926,
                  top: noTitle || notes[reverseIndex]["type"] == 1
                      ? notes[reverseIndex]["type"] == 1
                          ? width * 0.07384
                          : width * 0.03565
                      : width * 0.03565,
                  bottom: width * 0.02546),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                noTitle || notes[reverseIndex]["type"] == 1
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.only(
                            bottom: width * 0.01528,
                            right: notes[reverseIndex]["layout"] == 0 || notes[reverseIndex]["layout"] == 2 ? width * 0.050926 : 0,
                            left: notes[reverseIndex]["layout"] == 0 || notes[reverseIndex]["layout"] == 2 ? 0 : width * 0.050926),
                        child: SizedBox(
                            width: double.infinity,
                            child: Text(notes[reverseIndex]["title"],
                                textAlign: notes[reverseIndex]["layout"] == 0 || notes[reverseIndex]["layout"] == 2 ? TextAlign.left : TextAlign.right,
                                textDirection: notes[reverseIndex]["layout"] == 0 || notes[reverseIndex]["layout"] == 2 ? TextDirection.ltr : TextDirection.rtl,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Colors.white))),
                      ),
                notes[reverseIndex]["type"] == 0
                    ? Expanded(
                        flex: noTitle ? 3 : 2,
                        child: Padding(
                          padding: EdgeInsets.only(right: noTitle ? width * 0.020926 : 0),
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                                noContent
                                    ? notes[reverseIndex]["layout"] == 0
                                        ? "Empty"
                                        : "فارغ"
                                    : notes[reverseIndex]["content"],
                                textAlign: notes[reverseIndex]["layout"] == 1 || notes[reverseIndex]["layout"] == 2 ? TextAlign.right : TextAlign.left,
                                textDirection: notes[reverseIndex]["layout"] == 1 || notes[reverseIndex]["layout"] == 2 ? TextDirection.rtl : TextDirection.ltr,
                                maxLines: noTitle
                                    ? showDate
                                        ? isTablet
                                            ? 9
                                            : 4
                                        : isTablet
                                            ? 10
                                            : 5
                                    : showDate
                                        ? isTablet
                                            ? 9
                                            : 3
                                        : isTablet
                                            ? 10
                                            : 4,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: noContent ? Colors.white38 : Colors.white, fontSize: noTitle ? 18 : 13)),
                          ),
                        ),
                      )
                    : Expanded(
                        flex: noTitle ? 3 : 2,
                        child: SoundPlayer(
                          index: reverseIndex,
                          voiceMap: notes,
                          colors: colors,
                          viewMode: 3,
                        ),
                      ),
                showDate
                    ? Stack(
                        alignment: lang == 'en' ? Alignment.centerLeft : Alignment.centerRight,
                        children: [
                          Text(
                            dateValue == 0
                                ? "Today".tr()
                                : dateValue == -1
                                    ? "Yesterday".tr()
                                    : date,
                            style: TextStyle(color: Colors.white, fontSize: notes[reverseIndex]["type"] == 0 ? 15 : 14),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                showEdited
                                    ? notes[reverseIndex]["edited"] == "yes"
                                        ? "Edited".tr()
                                        : ""
                                    : "",
                                style: const TextStyle(color: Colors.white38),
                              )
                            ],
                          )
                        ],
                      )
                    : Container(),
              ]),
            ),
          ),
        ),
      ]),
    ),
  );
}

String getDeviceType() {
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
  return data.size.shortestSide < 600 ? 'phone' : 'tablet';
}
